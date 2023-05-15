import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/asset_image.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/src/ui/SheelaAI/Models/sheela_arguments.dart';
import 'package:myfhb/src/ui/SheelaAI/Services/SheelaQueueServices.dart';

import '../../../../common/CommonUtil.dart';
import '../../../../common/PreferenceUtil.dart';
import '../../../../constants/fhb_constants.dart';
import '../../../../constants/variable_constant.dart';
import '../../../../widgets/GradientAppBar.dart';
import '../../../utils/screenutils/size_extensions.dart';
import '../Controller/SheelaAIController.dart';
import '../Models/SheelaResponse.dart';
import 'SheelaAIReceiverBubble.dart';
import 'SheelaAISenderBubble.dart';

class SheelaAIMainScreen extends StatefulWidget {
  final SheelaArgument? arguments;

  SheelaAIMainScreen({this.arguments});

  @override
  State<SheelaAIMainScreen> createState() => _SheelaAIMainScreenState();
}

class _SheelaAIMainScreenState extends State<SheelaAIMainScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  SheelaAIController controller = Get.find();
  SheelaQueueServices servicesQueue = SheelaQueueServices();
  AnimationController? animationController;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    CommonUtil().handleCameraAndMic(onlyMic: true);
    controller.arguments = widget.arguments;
    controller.setDefaultValues();
    controller.bleController = null;
    //controller.bleController = CommonUtil().onInitSheelaBLEController();

    controller.startSheelaConversation();
    controller.isSheelaScreenActive = true;
    animationController = AnimationController(
        duration: const Duration(
          milliseconds: 600,
        ),
        vsync: this,
        value: 0.0);
    _animation =
        Tween<double>(begin: 0.0, end: 15.0).animate(animationController!)
          ..addStatusListener(
            (status) {
              if (status == AnimationStatus.completed) {
                animationController!.reverse();
              } else if (status == AnimationStatus.dismissed) {
                animationController!.forward();
              }
            },
          );

    if (CommonUtil.isUSRegion()) {
      controller.isMuted.value = false;
    }
  }

  @override
  void dispose() {
    animationController?.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    controller.stopTTS();
    controller.isSheelaScreenActive = false;
    if (controller.bleController != null) {
      controller.bleController!.stopTTS();
      controller.bleController!.stopScanning();
      controller.bleController!.isFromRegiment = false;
      controller.bleController!.filteredDeviceType = '';
      controller.bleController!.addingDevicesInHublist = false;
      controller.bleController!.isFromVitals = false;
      controller.bleController = null;
    }
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      controller.canSpeak = false;
      if (controller.bleController != null) {
        controller.bleController!.stopTTS();
        controller.bleController = null;
      }
      controller.stopTTS();
      if ((controller.arguments!.audioMessage ?? '').isNotEmpty) {
        controller.isSheelaScreenActive = false;
        Get.back();
      }
    } else if (state == AppLifecycleState.resumed) {
      controller.canSpeak = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.isMicListening.isTrue) {
          // animationController?.reset();
          // animationController?.forward();
          controller.updateTimer(enable: false);
        } else {
          animationController?.stop();
          if (controller.isLoading.isTrue) {
            controller.updateTimer(enable: false);
          } else {
            if (controller.currentPlayingConversation != null &&
                controller.currentPlayingConversation!.isPlaying.isTrue) {
              controller.updateTimer(enable: false);
            } else {
              controller.updateTimer(enable: true);
            }
          }
        }
        return WillPopScope(
          onWillPop: () async {
            if (controller.isLoading.isFalse ||
                (controller.arguments!.audioMessage ?? '').isNotEmpty) {
              controller.stopTTS();
              controller.canSpeak = false;
              controller.isSheelaScreenActive = false;
              controller.getSheelaBadgeCount();
              controller.updateTimer(enable: false);
              Get.back();
              return true;
            }
            return false;
          },
          child: Scaffold(
            appBar: PreferenceUtil.getIfQurhomeisAcive()
                ? getQurhomeAppbar()
                : AppBar(
                    flexibleSpace: GradientAppBar(),
                    title: Text(strMaya),
                    leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 24.0.sp,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        if (controller.isLoading.isFalse ||
                            (controller.arguments!.audioMessage ?? '')
                                .isNotEmpty) {
                          controller.stopTTS();
                          controller.canSpeak = false;
                          controller.isSheelaScreenActive = false;
                          controller.getSheelaBadgeCount();
                          controller.updateTimer(enable: false);
                          Get.back();
                        }
                      },
                    ),
                    actions: [
                      Visibility(
                        visible: !Platform.isIOS,
                        child: PopupMenuButton<String>(
                          onSelected: (languageCode) {
                            PreferenceUtil.saveString(SHEELA_LANG,
                                CommonUtil.langaugeCodes[languageCode]!);
                            controller.getDeviceSelectionValues(
                              preferredLanguage: languageCode,
                            );
                          },
                          itemBuilder: (BuildContext context) =>
                              getSupportedLanguages(),
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: 10.0.w,
                            ),
                            child: Image.asset(
                              icon_language,
                              width: 35.0.sp,
                              height: 35.0.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
            body: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  // padding: const EdgeInsets.only(bottom: 50),
                  color: PreferenceUtil.getIfQurhomeisAcive()
                      ? Colors.white10
                      : Colors.white70,
                  child: ListView.builder(
                    controller: controller.scrollController,
                    itemCount: controller.conversations.length + 1,
                    shrinkWrap: true,
                    itemBuilder: (builderContext, index) {
                      if (index == controller.conversations.length) {
                        return SizedBox(
                          height: 80,
                        );
                      }
                      final SheelaResponse currentConversation =
                          controller.conversations[index];
                      return Padding(
                        padding: const EdgeInsets.only(
                          top: 20.0,
                          bottom: 20.0,
                        ),
                        child: (currentConversation.loading ?? false)
                            ? SheelaAIReceiverBubble(currentConversation)
                            : (currentConversation.recipientId ?? '').isEmpty
                                ? SheelaAISenderBubble(currentConversation)
                                : SheelaAIReceiverBubble(currentConversation),
                      );
                    },
                  ),
                ),
              ],
            ),
            floatingActionButton: Visibility(
              visible: controller.bleController == null,
              child: AnimatedBuilder(
                animation: animationController!,
                builder: (context, child) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(_animation?.value ?? 0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(15.0 - (_animation?.value ?? 0)),
                      child: child,
                    ),
                  );
                },
                child: FloatingActionButton(
                  onPressed: () {
                    if (controller.isLoading.isFalse) {
                      if (controller.currentPlayingConversation != null &&
                          controller
                              .currentPlayingConversation!.isPlaying.value) {
                        controller.stopTTS();
                      } else {
                        controller.gettingReposnseFromNative();
                      }
                    }
                  },
                  elevation: 0,
                  backgroundColor: controller.isLoading.value
                      ? Colors.black45
                      : PreferenceUtil.getIfQurhomeisAcive()
                          ? Color(CommonUtil().getQurhomeGredientColor())
                          : Color(CommonUtil().getMyPrimaryColor()),
                  child: Icon(
                    (controller.currentPlayingConversation != null &&
                            controller
                                .currentPlayingConversation!.isPlaying.value)
                        ? Icons.pause
                        : controller.isLoading.isTrue
                            ? Icons.mic_off
                            : Icons.mic,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
          ),
        );
      },
    );
  }

  AppBar getQurhomeAppbar() {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: CommonUtil().isTablet! ? 110.00 : null,
      centerTitle: true,
      elevation: 0,
      title: CommonUtil().isTablet!
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          icon_mayaMain,
                          height: 32.h,
                          width: 32.h,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          strMaya,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (CommonUtil.isUSRegion()) _getMuteUnMuteIcon(),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Image.asset(
                  icon_mayaMain,
                  height: 30.h,
                  width: 30.h,
                ),
                const SizedBox(
                  width: 4,
                ),
                const Text(
                  strMaya,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                const Spacer(
                  flex: 2,
                ),
                if (CommonUtil.isUSRegion()) _getMuteUnMuteIcon(),
              ],
            ),
      leading: Container(
        margin: EdgeInsets.only(
          left: 8.h,
        ),
        child: InkWell(
            onTap: () {
              controller.stopTTS();
              controller.canSpeak = false;
              controller.isSheelaScreenActive = false;
              controller.getSheelaBadgeCount();
              controller.updateTimer(enable: false);
              Get.back();
            },
            child: CommonUtil().isTablet!
                ? IconWidget(
                    icon: Icons.arrow_back_ios,
                    colors: Colors.black,
                    size: CommonUtil().isTablet! ? 38.0 : 24.0,
                    onTap: () {
                      controller.canSpeak = false;
                      controller.stopTTS();
                      controller.updateTimer(enable: false);
                      Get.back();
                    },
                  )
                : CommonUtil.isUSRegion()
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.h,
                          vertical: 4.h,
                        ),
                        child: Icon(
                          Icons.home,
                          size: 32.sp,
                          color: Color(CommonUtil().getQurhomePrimaryColor()),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.h,
                          vertical: 4.h,
                        ),
                        child: AssetImageWidget(
                          icon: icon_qurhome,
                          height: 30.h,
                          width: 30.h,
                        ),
                      )),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(
          1.0,
        ),
        child: Container(
          color: Color(
            CommonUtil().getQurhomeGredientColor(),
          ),
          height: 1.0,
        ),
      ),
    );
  }

  Widget _getMuteUnMuteIcon() {
    return Container(
      child: Row(
        children: [
          InkWell(
            onTap: () {
              if (controller.isMuted.value) {
                controller.isMuted.value = false;
              } else {
                controller.isMuted.value = true;
                controller.stopTTS();
              }
            },
            child: Icon(
              controller.isMuted.value ? Icons.volume_off : Icons.volume_up,
              size: 32.sp,
              color: controller.isMuted.value
                  ? Colors.grey
                  : Color(CommonUtil().getQurhomePrimaryColor()),
            ),
          )
        ],
      ),
    );
  }

  List<PopupMenuItem<String>> getSupportedLanguages() {
    controller.stopTTS();
    controller.isMicListening.value = false;
    final List<PopupMenuItem<String>> languagesMenuList = [];
    final currentLanguage = controller.getCurrentLanCode(splittedCode: true);
    CommonUtil.supportedLanguages.forEach(
      (
        language,
        languageCode,
      ) {
        languagesMenuList.add(
          PopupMenuItem<String>(
            value: languageCode,
            child: Row(
              children: [
                Radio(
                  value: languageCode,
                  groupValue: currentLanguage,
                  activeColor: Color(CommonUtil().getMyPrimaryColor()),
                  onChanged: (dynamic value) {
                    Get.back();
                    PreferenceUtil.saveString(SHEELA_LANG,
                        CommonUtil.langaugeCodes[value ?? 'undef']!);
                    controller
                        .getDeviceSelectionValues(
                      preferredLanguage: value,
                    )
                        .then((value1) {
                      controller.updateDeviceSelectionModel(
                          preferredLanguage: value);
                    });
                  },
                ),
                Text(
                  toBeginningOfSentenceCase(language)!,
                  style: TextStyle(
                    fontSize: 16.0.sp,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    return languagesMenuList;
  }
}
