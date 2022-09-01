import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/asset_image.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/src/ui/SheelaAI/Models/sheela_arguments.dart';

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
  final SheelaArgument arguments;
  SheelaAIMainScreen({this.arguments});
  @override
  State<SheelaAIMainScreen> createState() => _SheelaAIMainScreenState();
}

class _SheelaAIMainScreenState extends State<SheelaAIMainScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  SheelaAIController controller = Get.find();
  AnimationController animationController;
  Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller.arguments = widget.arguments;
    controller.setDefaultValues();
    controller.bleController = null;
    controller.startSheelaConversation();
    controller.isSheelaScreenActive = true;
    animationController = AnimationController(
        duration: const Duration(
          milliseconds: 600,
        ),
        vsync: this,
        value: 0.0);
    _animation =
        Tween<double>(begin: 0.0, end: 15.0).animate(animationController)
          ..addStatusListener(
            (status) {
              if (status == AnimationStatus.completed) {
                animationController.reverse();
              } else if (status == AnimationStatus.dismissed) {
                animationController.forward();
              }
            },
          );
  }

  @override
  void dispose() {
    animationController?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    controller.stopTTS();
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      controller.canSpeak = false;
      if (controller.bleController != null) {
        controller.bleController.stopTTS();
        controller.bleController = null;
      }
      controller.stopTTS();
    } else if (state == AppLifecycleState.resumed) {
      controller.canSpeak = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.isMicListening.isTrue) {
          animationController?.reset();
          animationController?.forward();
        } else {
          animationController?.stop();
        }
        return WillPopScope(
          onWillPop: () async {
            if (controller.isLoading.isFalse) {
              controller.stopTTS();
              controller.canSpeak = false;
              controller.isSheelaScreenActive = false;

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
                        if (controller.isLoading.isFalse) {
                          controller.stopTTS();
                          controller.canSpeak = false;
                          controller.isSheelaScreenActive = false;

                          Get.back();
                        }
                      },
                    ),
                    actions: [
                      Visibility(
                        visible: !Platform.isIOS,
                        child: PopupMenuButton<String>(
                          onSelected: (languageCode) {
                            PreferenceUtil.saveString(
                                SHEELA_LANG,
                                CommonUtil
                                    .langaugeCodes[languageCode ?? 'undef']);
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
                animation: animationController,
                builder: (context, child) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(_animation?.value ?? 0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: controller.isMicListening.value
                            ? Colors.redAccent.shade100
                            : Colors.transparent,
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
                              controller.currentPlayingConversation?.isPlaying
                                  ?.value ??
                          false) {
                        controller.stopTTS();
                      } else {
                        controller.gettingReposnseFromNative();
                      }
                    }
                  },
                  elevation: 10,
                  backgroundColor: controller.isMicListening.value
                      ? Colors.red
                      : controller.isLoading.value
                          ? Colors.black45
                          : PreferenceUtil.getIfQurhomeisAcive()
                              ? Color(CommonUtil().getQurhomeGredientColor())
                              : Color(CommonUtil().getMyPrimaryColor()),
                  child: Icon(
                    (controller.currentPlayingConversation != null &&
                                controller.currentPlayingConversation?.isPlaying
                                    ?.value ??
                            false)
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
      toolbarHeight: CommonUtil().isTablet ? 110.00 : null,
      centerTitle: true,
      elevation: 0,
      title: CommonUtil().isTablet
          ? Row(
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

            Get.back();
          },
          child: CommonUtil().isTablet
              ? IconWidget(
                  icon: Icons.arrow_back_ios,
                  colors: Colors.black,
                  size: CommonUtil().isTablet ? 38.0 : 24.0,
                  onTap: () {
                    controller.canSpeak = false;
                    controller.stopTTS();
                    Get.back();
                  },
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
                ),
        ),
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

  List<PopupMenuItem<String>> getSupportedLanguages() {
    controller.stopTTS();
    controller.isMicListening.value = false;
    final List<PopupMenuItem<String>> languagesMenuList = [];
    final String currentLanguage = '';
    final lan = controller.getCurrentLanCode(splittedCode: true);
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
                  onChanged: (value) {
                    Get.back();
                    PreferenceUtil.saveString(SHEELA_LANG,
                        CommonUtil.langaugeCodes[value ?? 'undef']);
                    controller.getDeviceSelectionValues(
                      preferredLanguage: value,
                    );
                  },
                ),
                Text(
                  toBeginningOfSentenceCase(language),
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
