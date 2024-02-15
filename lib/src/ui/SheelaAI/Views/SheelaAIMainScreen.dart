import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/asset_image.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/language/model/Language.dart';
import 'package:myfhb/language/repository/LanguageRepository.dart';
import 'package:myfhb/src/ui/SheelaAI/Models/sheela_arguments.dart';
import 'package:myfhb/src/ui/SheelaAI/Services/SheelaQueueServices.dart';
import 'package:myfhb/src/ui/SheelaAI/Widgets/BLEBlinkingIcon.dart';
import '../../../../common/firebase_analytics_qurbook/firebase_analytics_qurbook.dart';
import '../Widgets/common_bluetooth_widget.dart';

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

  final hubListViewController = CommonUtil().onInitHubListViewController();

  @override
  void initState() {
    super.initState();
    FABService.trackCurrentScreen(FBASheelaScreen);
    WidgetsBinding.instance.addObserver(this);
    controller.conversations = [];
    controller.btnTextLocal = '';
    controller.isRetakeCapture = false;

    ///Surrendered with addPostFrameCallback for widget building issue///
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      CommonUtil().handleCameraAndMic(onlyMic: true);
      controller.arguments = widget.arguments;
      controller.setDefaultValues();
      controller.bleController = null;
      //controller.bleController = CommonUtil().onInitSheelaBLEController();

      controller.startSheelaConversation();
      controller.isSheelaScreenActive = true;
      controller.isDiscardDialogShown.value = false;
      controller.isCallStartFromSheela = false;
      PreferenceUtil.saveIfSheelaAttachmentPreviewisActive(
        qurhomeStatus: false,
      );
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
      controller.getLanguagesFromApi().then((value) {
        controller.getDeviceSelectionValues(savePrefLang: true);
      });
    });
  }

  @override
  void dispose() {
    animationController?.dispose();
    controller.clearTimer();
    controller.clearTimerForSessionExpiry();
    WidgetsBinding.instance!.removeObserver(this);
    controller.stopTTS();
    controller.isSheelaScreenActive = false;
    controller.isDiscardDialogShown.value = false;
    controller.conversations = [];
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
      controller.stopTTS();
      if (controller.bleController != null) {
        controller.bleController!.stopTTS();
        controller.bleController = null;
        Get.back();
      }
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
              if (!controller.isCallStartFromSheela) {
                controller.updateTimer(enable: true);
              }
            }
          }
        }
        return WillPopScope(
          onWillPop: () async {
            if (controller.isLoading.isFalse ||
                (controller.arguments!.audioMessage ?? '').isNotEmpty) {
              if ((CommonUtil.isUSRegion()) &&
                  ((controller.conversations.length ?? 0) > 0) &&
                  !(controller.conversations.last?.endOfConvDiscardDialog ??
                      true)) {
                controller.isDiscardDialogShown.value = true;
                controller.updateTimer(enable: false);
                CommonUtil().alertForSheelaDiscardOnConversation(
                    context, PreferenceUtil.getIfQurhomeisAcive(),
                    pressYes: () {
                  goToBackScreen();
                  Get.back();
                }, pressNo: () {
                  controller.updateTimer(enable: true);
                  Get.back();
                }).then((value) {
                  controller.isDiscardDialogShown.value = false;
                });
              } else {
                goToBackScreen();
                return true;
              }
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
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: getLanguageButton(),
                      )
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
            floatingActionButton: animationController == null
                ? null
                : Visibility(
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
                            padding:
                                EdgeInsets.all(15.0 - (_animation?.value ?? 0)),
                            child: child,
                          ),
                        );
                      },
                      child: FloatingActionButton(
                        onPressed: () {
                          controller.clearTimer();
                          if (controller.isLoading.isFalse) {
                            if (controller.currentPlayingConversation != null &&
                                controller.currentPlayingConversation!.isPlaying
                                    .value) {
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
                                  controller.currentPlayingConversation!
                                      .isPlaying.value)
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
      leadingWidth: CommonUtil.isUSRegion()
          ? (CommonUtil().isTablet ?? false)
              ? 147
              : 106
          : 58.0,
      actions: [
        Row(
          children: [
            if (!CommonUtil.isUSRegion() &&
                (widget.arguments?.takeActiveDeviceReadings ?? false))
              hubListViewController.isUserHasParedDevice.value
                  ? controller.isBLEStatus.value == BLEStatus.Disabled
                      ? CommonBluetoothWidget.getDisabledBluetoothIcon()
                      : MyBlinkingBLEIcon()
                  : SizedBox.shrink(),
            SizedBox(width: 12.w),
            if (CommonUtil.isUSRegion()) _getMuteUnMuteIcon(),
            SizedBox(width: 12.w),
            getLanguageButton(),
            SizedBox(width: 8.w),
          ],
        )
      ],
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
                  flex: 1,
                ),
              ],
            ),
      leading: Container(
        margin: EdgeInsets.only(
          left: 8.h,
        ),
        child: InkWell(
            onTap: () {
              if ((CommonUtil.isUSRegion()) &&
                  ((controller.conversations.length ?? 0) > 0) &&
                  !(controller.conversations.last?.endOfConvDiscardDialog ??
                      true)) {
                controller.isDiscardDialogShown.value = true;
                controller.updateTimer(enable: false);
                CommonUtil().alertForSheelaDiscardOnConversation(
                    context, PreferenceUtil.getIfQurhomeisAcive(),
                    pressYes: () {
                  goToBackScreen();
                  Get.back();
                }, pressNo: () {
                  Get.back();
                  controller.updateTimer(enable: true);
                }).then((value) {
                  controller.isDiscardDialogShown.value = false;
                });
              } else {
                goToBackScreen();
              }
            },
            child:
                /*CommonUtil().isTablet!
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
                :*/
                CommonUtil.isUSRegion()
                    ? Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.h,
                              vertical: 4.h,
                            ),
                            child: Icon(
                              Icons.home,
                              size: 32.sp,
                              color:
                                  Color(CommonUtil().getQurhomePrimaryColor()),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          hubListViewController.isUserHasParedDevice.value &&
                                  (widget.arguments?.takeActiveDeviceReadings ??
                                      false)
                              ? controller.isBLEStatus.value ==
                                      BLEStatus.Disabled
                                  ? CommonBluetoothWidget
                                      .getDisabledBluetoothIcon()
                                  : MyBlinkingBLEIcon()
                              : SizedBox.shrink(),
                        ],
                      )
                    : CommonUtil().qurHomeMainIcon()),
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

  goToBackScreen() {
    controller.stopTTS();
    controller.canSpeak = false;
    controller.isSheelaScreenActive = false;
    controller.getSheelaBadgeCount();
    controller.updateTimer(enable: false);
    controller.clearTimer();
    controller.clearTimerForSessionExpiry();
    Get.back();
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

    controller.langaugeDropdownList.forEach(
      (
        language,
        languageCode,
      ) {
        languagesMenuList.add(
          PopupMenuItem<String>(
            value: languageCode,
            child: Container(
              padding: CommonUtil().isTablet!
                  ? EdgeInsets.all(14)
                  : EdgeInsets.all(0),
              child: Row(
                children: [
                  Radio(
                    value: languageCode,
                    groupValue: currentLanguage,
                    activeColor: Color(CommonUtil().getMyPrimaryColor()),
                    onChanged: (dynamic value) {
                      Get.back();
                      getupdateDeviceSelection(value);
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
          ),
        );
      },
    );
    return languagesMenuList;
  }

  void getupdateDeviceSelection(String value) {
    PreferenceUtil.saveString(
        SHEELA_LANG, CommonUtil.langaugeCodes[value ?? 'undef']!);
    controller
        .getDeviceSelectionValues(
      preferredLanguage: value,
    )
        .then((value1) {
      controller.updateDeviceSelectionModel(preferredLanguage: value);
    });
  }

  Widget getLanguageButton() {
    return PopupMenuButton<String>(
      onSelected: (languageCode) {
        getupdateDeviceSelection(languageCode);
      },
      itemBuilder: (BuildContext context) => getSupportedLanguages(),
      child: Padding(
        padding: EdgeInsets.only(
          right: 10.0.w,
        ),
        child: Image.asset(
          icon_language,
          width: 35.0.sp,
          height: 35.0.sp,
          color: PreferenceUtil.getIfQurhomeisAcive()
              ? Color(CommonUtil().getQurhomePrimaryColor())
              : Colors.white,
        ),
      ),
    );
  }
}
