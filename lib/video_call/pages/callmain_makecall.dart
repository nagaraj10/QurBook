import 'dart:convert';
import 'dart:io';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/Prescription/model/fetch_prescription_detail/prescription_detail.dart'
    as pre;
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/common/keysofmodel.dart';
import 'package:myfhb/my_providers/models/User.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/healthRecord.dart';
import 'package:myfhb/video_call/pages/localpreview.dart';
import 'package:myfhb/video_call/pages/make_call.dart';
import 'package:myfhb/video_call/pages/toolbar.dart';
import 'package:myfhb/video_call/Model/videoCallStatus.dart';
import 'package:myfhb/video_call/utils/audiocall_provider.dart';
import 'package:myfhb/video_call/utils/hideprovider.dart';
import 'package:myfhb/video_call/utils/rtc_engine.dart';
import 'package:myfhb/video_call/utils/videoicon_provider.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/video_call/widgets/custom_timer.dart';
import 'package:provider/provider.dart';
import '../../../../constants/fhb_constants.dart' as constants;
import '../../src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Controller/QurhomeRegimenController.dart';

// ignore: must_be_immutable
class CallMainMakeCall extends StatelessWidget {
  /// non-modifiable channel name of the page
  final String channelName;
  pre.PrescriptionDetail existingAdditionalInfo = pre.PrescriptionDetail();

  /// non-modifiable client role of the page
  final ClientRole role;

  final String bookId;
  final String patName;
  final String patId;
  final String patDOB;
  final String patPicUrl;

  final String appointmentId;
  final String healthOrganizationId;
  final String gender;
  final HealthRecord healthRecords;
  final dynamic slotDuration;

  User patienInfo;
  bool isFromAppointment;
  static String nonAppointmentUrl = 'call-log/non-appointment-call';
  String startedTime;
  var isDoctor;
  CallMainMakeCall({
    Key key,
    this.channelName,
    this.role,
    this.bookId,
    this.patName,
    this.patId,
    this.appointmentId,
    this.patDOB,
    this.patPicUrl,
    this.gender,
    this.healthOrganizationId,
    this.existingAdditionalInfo,
    this.slotDuration,
    this.healthRecords,
    this.patienInfo,
    this.isFromAppointment,
    this.startedTime,
    this.isDoctor,
  }) : super(key: key);

  BuildContext globalContext;

  final call_start_time = DateFormat(c_yMd_Hms).format(DateTime.now());

  bool _isFirstTime = true;
  bool _isMute = false;
  bool _isVideoHide = false;
  String doctor_id, mtTitle = '', specialityName = '';
  String userIdForNotify = '';
  PreferenceUtil prefs = new PreferenceUtil();
  var regController = Get.find<QurhomeRegimenController>();
  bool _isTimerRun = true;

  void listenForVideoCallRequest() {
    var rtcProvider =
        Provider.of<RTCEngineProvider>(Get.context, listen: false);
    try {
      VideoCallCommonUtils()
          .myDB
          .collection('call_log')
          .doc(bookId)
          .snapshots()
          .listen(
        (DocumentSnapshot<Map<String, dynamic>> documentSnapshot) async {
          Map<String, dynamic> firestoreInfo = documentSnapshot.data() ?? {};
          var recStatus = VideoCallStatus.fromMap(firestoreInfo);
          if ((recStatus.videoRequestFromMobile == 1 ||
                  recStatus.videoRequestFromWeb == 1) &&
              !CommonUtil.isVideoRequestSent) {
            // need to show video request
            await Get.dialog(
              AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      child: Text(
                        '${regController.onGoingSOSCall.value ? "Emergency Services" : patName} requesting to switch to video call',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.0.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FlatButton(
                          child: Text('Decline'),
                          onPressed: () async {
                            try {
                              Get.back();
                              var newStatus = VideoCallStatus();
                              newStatus.setDefaultValues();
                              newStatus.acceptedByMobile = 0;
                              FirebaseFirestore.instance
                                ..collection("call_log")
                                    .doc("$bookId")
                                    .update(newStatus.toMap());
                            } catch (e) {
                              print(e);
                            }
                          },
                        ),
                        FlatButton(
                          child: Text('Switch'),
                          onPressed: () async {
                            try {
                              var permissionStatus =
                                  await VideoCallCommonUtils()
                                      .getCurrentVideoCallRelatedPermission();
                              if (!permissionStatus) {
                                FlutterToast().getToast(
                                  'Could not switch on video due to permission settings',
                                  Colors.black,
                                );
                                Get.back();
                                var newStatus = VideoCallStatus();
                                newStatus.setDefaultValues();
                                newStatus.acceptedByMobile = 0;
                                FirebaseFirestore.instance
                                  ..collection("call_log")
                                      .doc("$bookId")
                                      .update(newStatus.toMap());
                                return;
                              } else {
                                await rtcProvider?.rtcEngine?.enableVideo();
                                await rtcProvider?.rtcEngine
                                    ?.enableLocalVideo(true);
                                await rtcProvider?.rtcEngine
                                    ?.muteLocalVideoStream(false);
                                Provider?.of<HideProvider>(Get.context,
                                        listen: false)
                                    ?.swithToVideo();
                                Provider.of<AudioCallProvider>(Get.context,
                                        listen: false)
                                    ?.disableAudioCall();
                                Provider?.of<VideoIconProvider>(Get.context,
                                        listen: false)
                                    ?.turnOnVideo();
                                Provider.of<RTCEngineProvider>(Get.context,
                                        listen: false)
                                    ?.changeLocalVideoStatus(false);
                                var newStatus = VideoCallStatus();
                                newStatus.setDefaultValues();
                                newStatus.acceptedByMobile = 1;
                                FirebaseFirestore.instance
                                  ..collection("call_log")
                                      .doc("$bookId")
                                      .update(newStatus.toMap());
                                Get.back();
                              }
                            } catch (e) {
                              print(e);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              barrierDismissible: false,
            );
          } else if (recStatus.videoRequestFromMobile == 0 ||
              recStatus.videoRequestFromWeb == 0) {
            // need to dismiss if the video request pop is shown
            if (Get.isDialogOpen) {
              Get.back();
              Get.rawSnackbar(
                messageText: Center(
                  child: Text(
                    'Request Declined',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                snackPosition: SnackPosition.BOTTOM,
                snackStyle: SnackStyle.GROUNDED,
                duration: Duration(
                  seconds: 1,
                ),
                backgroundColor: Colors.red.shade400,
              );
            }
            final audioStatus =
                Provider.of<AudioCallProvider>(Get.context, listen: false);
            if (!(audioStatus.isAudioCall ?? false)) {
              await rtcProvider?.rtcEngine?.disableVideo();
              await rtcProvider?.rtcEngine?.enableLocalVideo(false);
              await rtcProvider?.rtcEngine?.muteLocalVideoStream(true);
              Provider?.of<HideProvider>(Get.context, listen: false)
                  ?.swithToAudio();
              Provider.of<AudioCallProvider>(Get.context, listen: false)
                  ?.enableAudioCall();
              Provider?.of<VideoIconProvider>(Get.context, listen: false)
                  ?.turnOffVideo();
            }
          } else if (recStatus.acceptedByMobile == 1 ||
              recStatus.acceptedByWeb == 1) {
            // no change is required for this
            if (CommonUtil.isVideoRequestSent) {
              CommonUtil.isVideoRequestSent = false;
              Get.back();
              Provider?.of<HideProvider>(Get.context, listen: false)
                  ?.swithToVideo();
              Provider.of<AudioCallProvider>(Get.context, listen: false)
                  ?.disableAudioCall();
              Provider?.of<VideoIconProvider>(Get.context, listen: false)
                  ?.turnOnVideo();
              Provider.of<RTCEngineProvider>(Get.context, listen: false)
                  ?.changeLocalVideoStatus(false);
            }
          } else if (recStatus.acceptedByMobile == 0 ||
              recStatus.acceptedByWeb == 0) {
            // video call request is reject on patient end
            CommonUtil.isVideoRequestSent = false;
            if (Get.isDialogOpen) {
              Get.back();
              Get.rawSnackbar(
                messageText: Center(
                  child: Text(
                    'Request Declined',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                snackPosition: SnackPosition.BOTTOM,
                snackStyle: SnackStyle.GROUNDED,
                duration: Duration(
                  seconds: 3,
                ),
                backgroundColor: Colors.red.shade400,
              );
              await rtcProvider?.rtcEngine?.disableVideo();
              await rtcProvider?.rtcEngine?.enableLocalVideo(false);
              await rtcProvider?.rtcEngine?.muteLocalVideoStream(true);
            }
          }
        },
      ).onError(
        (e) {
          printError(
            info: e.toString(),
          );
        },
      );
    } catch (e) {
      printError(
        info: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hideStatus = Provider.of<HideProvider>(context, listen: false);
    final videoIconStatus =
        Provider.of<VideoIconProvider>(Get.context, listen: false);
    globalContext = context;

    final audioCallStatus =
        Provider.of<AudioCallProvider>(context, listen: false);
    videoIconStatus?.isVideoOn = audioCallStatus?.isAudioCall ? false : true;

    /// hide controller after 5 secs
    if (audioCallStatus?.isAudioCall) {
      //if audio call do not hide status bar
      hideStatus.showMe();
    } else {
      if (_isFirstTime) {
        _isFirstTime = false;
        Future.delayed(Duration(seconds: 5), () {
          hideStatus.hideMe();
        });
      }
    }
    prepareMyData();
    listenForVideoCallRequest();
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                regController.onGoingSOSCall.value
                    ? "Emergency Services"
                    : patName,
                style: TextStyle(
                  fontSize: 16.0.sp,
                ),
              ),
              /*Text(
                bookId,
                style: TextStyle(
                  fontSize: 13.0.sp,
                  color: Colors.white70,
                ),
              )*/
              CustomTimer(
                backgroundColor: Colors.transparent,
                initialDate: DateTime.now(),
                running: _isTimerRun,
                width: 50.0.w,
                timerTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0.sp,
                ),
                isRaised: false,
                tracetime: (time) {},
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
          actions: [
            /*PopupMenuButton<int>(
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: FlatButton(
                    child: Text(
                      "Health records",
                      style: TextStyle(
                        fontSize: 16.0.sp,
                      ),
                    ),
                    onPressed: () async {
                      CommonUtil().moveToAssociateHealthTabs(
                          (CommonUtil.bookedForId != null &&
                                  CommonUtil.bookedForId != '')
                              ? CommonUtil.bookedForId
                              : patId,
                          context,
                          healthRecords.associatedRecords,
                          patName);
                    },
                  ),
                ),
                PopupMenuItem(
                  value: 1,
                  child: FlatButton(
                    child: Text(
                      "Device Readings",
                      style: TextStyle(
                        fontSize: 16.0.sp,
                      ),
                    ),
                    onPressed: () async {
                      CommonUtil().moveToDeviceReadings(
                          (CommonUtil.bookedForId != null &&
                                  CommonUtil.bookedForId != '')
                              ? CommonUtil.bookedForId
                              : patId,
                          context);
                    },
                  ),
                ),
              ],
            )*/
          ],
        ),
        backgroundColor: Colors.black,
        body: Center(
          child: Stack(
            children: <Widget>[
              MakeCallPage(
                channelName: this.channelName,
                role: ClientRole.Broadcaster,
                bookId: bookId,
                patName: patName,
                appointmentId: appointmentId,
                call_start_time: call_start_time,
                isFromAppointment: isFromAppointment,
                patId: patId,
                startedTime: startedTime,
              ),
              /* InkWell(
                  onTap: () {
                    if (hideStatus.isControlStatus) {
                      hideStatus.hideMe();
                    } else {
                      hideStatus.showMe();
                      Future.delayed(Duration(seconds: 10), () {
                        hideStatus.hideMe();
                      });
                    }
                  },
                  child: Container(),
                ), */
              LocalPreview(),
              Consumer<HideProvider>(
                builder: (context, status, child) {
                  try {
                    if (status.isAudioSwitchToVideo >= 0) {
                      _isVideoHide =
                          status?.isAudioSwitchToVideo == 0 ? true : false;
                      hideStatus.isAudioSwitchToVideo = -1;
                    }
                  } catch (e) {
                    print(e);
                  }

                  return Visibility(
                    visible: status.isControlStatus,
                    child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Toolbar(role, (isMute, isVideoHide) {
                              _isMute = isMute;
                              _isVideoHide = isVideoHide;
                            },
                                _isMute,
                                _isVideoHide,
                                (CommonUtil.bookedForId != null &&
                                        CommonUtil.bookedForId != '')
                                    ? CommonUtil.bookedForId
                                    : patId,
                                patName,
                                appointmentId,
                                patPicUrl,
                                bookId,
                                call_start_time,
                                healthOrganizationId,
                                healthRecords,
                                isFromAppointment),
                            SizedBox(
                              height: 20.0.h,
                            ),
                          ],
                        )),
                  );
                },
              ),
              /*PrescriptionModule(
                appointmentId,
                patName,
                patDOB,
                patId,
                gender,
                slotDuration,
                existingAdditionalInfo,
                patienInfo: patienInfo,
                isDoctor: isDoctor,
              ),*/
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    return userAlert() ?? false;
  }

  void prepareMyData() async {
    /*SharedPrefUtil sharedPref = new SharedPrefUtil();
    try {
      isDoctor = await sharedPref.getBool('isDoctor');
    } catch (e) {}
    try {
      mtTitle = await prefs.getValueBasedOnKey("display_name");
    } catch (e) {}
    try {
      specialityName = await prefs.getValueBasedOnKey("speciality");
    } catch (e) {}
    try {
      doctor_id = await prefs.getValueBasedOnKey("doctor_id");
    } catch (e) {}*/
    try {
      userIdForNotify =
          await PreferenceUtil.getStringValue(constants.KEY_USERID);
      //userIdForNotify = json.decode(userIdForNotify);
    } catch (e) {}
  }

  Future userAlert() {
    return showDialog(
      context: globalContext,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'warning!',
              style: TextStyle(
                fontSize: 20.0.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(0.8),
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: Text(
                  'Do you want exit from call?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FlatButton(
                    child: Text(
                      'Yes',
                      style: TextStyle(
                        fontSize: 16.0.sp,
                      ),
                    ),
                    onPressed: () {
                      prepareMyData();
                      try {
                        if (!isFromAppointment) callApiToUpdateNonAppointment();
                      } catch (e) {}
                      VideoCallCommonUtils().terminate(
                          appsID: appointmentId,
                          bookId: bookId,
                          patName: patName,
                          callStartTime: call_start_time);
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    child: Text(
                      'No',
                      style: TextStyle(
                        fontSize: 16.0.sp,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  callApiToUpdateNonAppointment() async {
    try {
      Map<String, dynamic> body = new Map();
      final now = DateTime.now();
      String endTime =
          '${DateFormat('yyyy-MM-dd HH:mm:ss', 'en_US').format(now)}';
      String userIdForNotify;

      try {
        userIdForNotify =
            await PreferenceUtil.getStringValue(constants.KEY_USERID);
      } catch (e) {}

      body['startTime'] = startedTime;
      body['endTime'] = endTime;
      body['callerUser'] = userIdForNotify;
      body['recipientUser'] = patId;

      //TODO
      /*new ApiResponse()
        .putNonAppointmentCall(CallMainMakeCall.nonAppointmentUrl, body)
        .then((value) {
      if (value['isSuccess'] != null && value['isSuccess']) {
        print('SUCCESSSSSSSSSSSSSSSSSSSSSSSSS NON APPOINTMENT CALL UPDATED');
      }
    });*/
    } catch (e) {
      print(e);
    }
  }
}
