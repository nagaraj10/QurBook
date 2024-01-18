import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/FlatButton.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/errors_widget.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/router_variable.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/more_menu/screens/terms_and_conditon.dart';
import 'package:myfhb/more_menu/voice_clone_status_controller.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/telehealth/features/Notifications/constants/notification_constants.dart';
import 'package:myfhb/voice_cloning/controller/voice_cloning_controller.dart';
import 'package:myfhb/voice_cloning/model/voice_clone_status_arguments.dart';
import 'package:myfhb/voice_cloning/model/voice_cloning_choose_member_arguments.dart';
import 'package:myfhb/voice_cloning/view/widgets/voice_clone_family_members_list.dart';
import 'package:provider/provider.dart';

import '../../common/common_circular_indicator.dart';

class VoiceCloningStatus extends StatefulWidget {
  final VoiceCloneStatusArguments? arguments;

  const VoiceCloningStatus({
    required this.arguments,
  });

  @override
  _MyFhbWebViewState createState() => _MyFhbWebViewState();
}

class _MyFhbWebViewState extends State<VoiceCloningStatus> {
  bool isLoading = true;
  final controller = Get.put(VoiceCloneStatusController());
  double subtitle = CommonUtil().isTablet! ? tabHeader2 : mobileHeader2;
  late VoiceCloningController _voiceCloningController;

  bool isForceStopPlayer = false;
  @override
  void initState() {
    Provider.of<VoiceCloningController>(context, listen: false)
        .initialiseControllers();
    mInitialTime = DateTime.now();
    controller.onInit();
    //Api to get health organzation id and also the status of voice cloning
    controller.getUserHealthOrganizationId();
    controller.isPlayWidgetClicked = false;
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    _voiceCloningController.disposeRecorder();
    _voiceCloningController.isPlayerLoading = false;
    super.dispose();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': ' Voice Cloning status',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
  }

  disposeVoiceControler() async {
    if (_voiceCloningController.playerVoiceStatusController.playerState !=
        PlayerState.stopped) {
      await _voiceCloningController.playerVoiceStatusController.stopPlayer();
    }
    _voiceCloningController.disposeRecorder();
    _voiceCloningController.isPlayerLoading = false;
    _voiceCloningController.isFirsTymVoiceCloningStatus = true;
  }

  @override
  Widget build(BuildContext context) {
    _voiceCloningController = Provider.of<VoiceCloningController>(context);
    if (_voiceCloningController.isFirsTymVoiceCloningStatus) {
      _voiceCloningController.recordedPath = "";
      _voiceCloningController.playerVoiceStatusController = PlayerController();
    }

    return Obx(
      () => WillPopScope(
        onWillPop: () {
          disposeVoiceControler();
          controller.setBackButton(
              context, widget.arguments?.fromMenu ?? false);
          //  Get.off(
          //  MoreMenuScreen(),
          //);
          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: 24.0.sp,
              ),
              onPressed: () {
                disposeVoiceControler();
                controller.setBackButton(
                    context, widget.arguments?.fromMenu ?? false);
              },
            ),
            title: AppBarForVoiceCloning().getVoiceCloningAppBar(),
            centerTitle: false,
          ),
          body: controller.loadingData.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : controller.voiceCloneStatusModel?.result != null
                  ? ListView(
                      children: [
                        Visibility(
                            visible: controller
                                    .voiceCloneStatusModel?.result?.status !=
                                strApproved,
                            child: SizedBox(height: 50.0.sp)),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            controller.voiceCloneStatusModel?.result
                                    ?.description ??
                                strDescStatus,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: mobileFontTitle),
                          ),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                strDOS,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: subtitle,
                                    color: Colors.grey[600]),
                              ),
                              Text(
                                  changeDateFormat(
                                      CommonUtil().validString(controller
                                              .voiceCloneStatusModel
                                              ?.result
                                              ?.createdOn ??
                                          ''),
                                      isFromAppointment: false),
                                  style: TextStyle(
                                    fontSize: subtitle,
                                  )),
                            ]),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                strStatus,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: subtitle,
                                    color: Colors.grey[600]),
                              ),
                              Text(
                                  controller.voiceCloneStatusModel?.result
                                          ?.status ??
                                      '',
                                  style: AppBarForVoiceCloning().getTextStyle(
                                      controller.voiceCloneStatusModel?.result
                                              ?.status ??
                                          '')),
                            ]),
                        Visibility(
                          visible: controller
                                      .voiceCloneStatusModel?.result?.status ==
                                  strApproved &&
                              controller.listOfFamilyMembers.length > 0,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                            child: VoiceCloneFamilyMembersList(
                              isShowcaseExisting: true,
                              familyMembers: controller.listOfFamilyMembers,
                              onValueSelected: (value) {},
                              isScrollParent: true,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: controller
                                  .voiceCloneStatusModel?.result?.status ==
                              strDecline,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 17.0.sp,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: strReason,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: mobileFontTitle,
                                        color: Colors.grey[600]),
                                  ),
                                  TextSpan(
                                      text: controller
                                              .voiceCloneStatusModel
                                              ?.result
                                              ?.additionalInfo
                                              ?.reason ??
                                          '',
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: mobileFontTitle)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1.3,
                                )),
                            padding: EdgeInsets.all(
                              15.0.sp,
                            ),
                            margin: EdgeInsets.all(10.0.sp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        controller.voiceCloneStatusModel?.result
                                                    ?.status ==
                                                strApproved
                                            ? strProVoice
                                            : strSubVoice,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: mobileFontTitle,
                                            color: Colors.grey[600]),
                                      ),
                                    ),
                                    InkWell(
                                        child: Icon(
                                          controller.isPlayWidgetClicked
                                              ? Icons
                                                  .keyboard_arrow_down_rounded
                                              : Icons.keyboard_arrow_right,
                                          size: CommonUtil().isTablet!
                                              ? 20.0.sp
                                              : 30.0.sp,
                                        ),
                                        onTap: () async {
                                          if (_voiceCloningController
                                                  .isFirsTymVoiceCloningStatus ||
                                              isForceStopPlayer) {
                                            _voiceCloningController
                                                    .isFirsTymVoiceCloningStatus =
                                                false;
                                            isForceStopPlayer = false;
                                            await _voiceCloningController
                                                .startVoiceStatusPlayer();
                                          }
                                          setState(() {
                                            controller.isPlayWidgetClicked =
                                                !controller.isPlayWidgetClicked;
                                          });

                                          if (!controller.isPlayWidgetClicked) {
                                            isForceStopPlayer = true;
                                            await _voiceCloningController
                                                .playerVoiceStatusController
                                                .stopPlayer();
                                          }
                                        })
                                  ],
                                ),
                                controller.isPlayWidgetClicked
                                    ? SizedBox(height: 20)
                                    : Container(),
                                Visibility(
                                    visible: controller.isPlayWidgetClicked,
                                    child: controller.audioURL != ""
                                        ? (_voiceCloningController
                                                    ?.recordedPath !=
                                                "")
                                            ? _playerControllerWidget()
                                            : getFutureAudioURL()
                                        : SizedBox())
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            //Pop the current page and should go back to recording page
                            stopAudioPlayer();
                            Navigator.pushNamed(context, rt_record_submission);
                          },
                          child: Visibility(
                              visible: controller
                                      .voiceCloneStatusModel?.result?.status ==
                                  strApproved,
                              child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    strChangeVoice,
                                    style: TextStyle(
                                      color: Colors.red,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.red, // optional
                                      decorationThickness: 2, // optional
                                      decorationStyle:
                                          TextDecorationStyle.solid, // optional
                                    ),
                                    textAlign: TextAlign.center,
                                  ))),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: InkWell(
                            onTap: _onButtonPressed,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                border: Border.all(color: getColors()),
                                borderRadius: BorderRadius.circular(20),
                                color: getBackGroundColor(),
                              ),
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 30.sp,
                                      right: 30.sp,
                                      top: 10,
                                      bottom: 10),
                                  child: Text(
                                    getTextBasedOnStatus(),
                                    style: TextStyle(color: getColors()),
                                  )),
                            ),
                          ),
                        ),
                      ],
                    )
                  : ErrorsWidget(),
        ),
      ),
    );
  }

  /**
   * Set text button based on the status fof voice cloning
   */
  String getTextBasedOnStatus() {
    String? status = controller.voiceCloneStatusModel?.result?.status;
    switch (status) {
      case 'Under Review':
        return 'Revoke Submission';

      case 'Being Processed':
        return 'Revoke Submission';

      case strApproved:
        return 'Assign voice to members';

      case strDeclined:
        return 'Record Again';

      default:
        return 'Revoke Submission';
    }
  }

  /**
   * Get text color based on status of voice cloning text
   */
  getColors() {
    return (controller.voiceCloneStatusModel?.result?.status == strApproved)
        ? Colors.white
        : Color(CommonUtil().getMyPrimaryColor());
  }

  /**
   * Get the background color based on tatus of voice cloning text
   */
  getBackGroundColor() {
    return (controller.voiceCloneStatusModel?.result?.status == strApproved)
        ? Color(CommonUtil().getMyPrimaryColor())
        : Colors.white;
  }

  /**
   * Button click based on the staus of the voice cloning status
   */
  _onButtonPressed() async {
    String statusBtn = getTextBasedOnStatus();
    if (statusBtn == 'Revoke Submission') {
      stopAudioPlayer();
      //revoke the submission of voice clone and navigate to more menu screen
      await controller.revokeSubmission(widget.arguments?.fromMenu ?? false);
    } else if (statusBtn == 'Record Again') {
      stopAudioPlayer();
      //Pop the current page and should go back to recording page
      Navigator.pushNamed(context, rt_record_submission);
    } else {
      //Navigate to assign to members
      final selectedFamilyMembers = controller.listOfFamilyMembers.value
          .map((e) => e.child?.id ?? '')
          .toList();

      stopAudioPlayer();
      Navigator.pushNamed(context, rt_VoiceCloningChooseMemberSubmit,
          arguments: VoiceCloningChooseMemberArguments(
            fromMenu: widget.arguments?.fromMenu ?? false,
            voiceCloneId: controller.voiceCloneId.value,
            selectedFamilyMembers: controller.selectedFamilyMembers,
          ));
    }
  }

  Container _playerControllerWidget() => Container(
        width: double.infinity,
        color: const Color(0xFF333232),
        padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
        child: _voiceCloningController.isPlayerLoading
            ? Container(
                alignment: Alignment.center,
                height: 150,
                width: double.infinity,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AudioFileWaveforms(
                    size: Size(MediaQuery.of(context).size.width, 100),
                    playerController:
                        _voiceCloningController.playerVoiceStatusController,
                    enableSeekGesture: false,
                    waveformData:
                        _voiceCloningController.audioWaveVoiceStatusData,
                    playerWaveStyle: PlayerWaveStyle(
                      fixedWaveColor: Colors.white,
                      liveWaveColor: Color(CommonUtil().getMyPrimaryColor()),
                      spacing: 6,
                    ),
                  ),
                  Slider(
                    activeColor: Color(CommonUtil().getMyPrimaryColor())
                        .withOpacity(0.5),
                    inactiveColor: Colors.white,
                    value: _voiceCloningController.playVoiceStatusPosition,
                    max: _voiceCloningController.maxPlayerVoiceStatusDuration >
                            0
                        ? _voiceCloningController.maxPlayerVoiceStatusDuration
                        : 1.0,
                    onChanged: (value) {
                      _voiceCloningController.playerVoiceStatusController
                          .seekTo(value.round());
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _voiceCloningController.formatPlayerDuration(
                                _voiceCloningController
                                    .playVoiceStatusPosition),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              _voiceCloningController
                                  .playVoiceStatusPausePlayer();
                            },
                            child: SvgPicture.asset(
                              _voiceCloningController
                                      .playerVoiceStatusController
                                      .playerState
                                      .isPlaying
                                  ? icVoicePause
                                  : icVoicePlay,
                              color: Colors.white,
                              height: 45,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            _voiceCloningController.formatPlayerDuration(
                                _voiceCloningController
                                    .maxPlayerVoiceStatusDuration),
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
      );

  Widget getFutureAudioURL() {
    return FutureBuilder<String>(
      future: _voiceCloningController.downloadAudioFile(controller.audioURL),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CommonCircularIndicator();
        } else if (snapshot.hasError) {
          return FlatButtonWidget(
            bgColor: Colors.transparent,
            isSelected: true,
            title: 'Retry',
            onPress: () {
              setState(() {});
            },
          );
        } else if (snapshot.hasData &&
            snapshot.data != '' &&
            snapshot.data != null) {
          return _playerControllerWidget();
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  //Allow to forcefully stop the audio player
  void stopAudioPlayer() async {
    controller.isPlayWidgetClicked = false;
    isForceStopPlayer = true;
    if (_voiceCloningController.playerVoiceStatusController.playerState !=
        PlayerState.stopped) {
      await _voiceCloningController.playerVoiceStatusController.stopPlayer();
    }
  }
}
