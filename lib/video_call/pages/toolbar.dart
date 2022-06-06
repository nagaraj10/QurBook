import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/telehealth/features/chat/viewModel/ChatViewModel.dart';
import 'package:myfhb/video_call/model/videocallStatus.dart';
import 'package:myfhb/video_call/utils/audiocall_provider.dart';
import 'package:myfhb/video_call/utils/hideprovider.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/healthRecord.dart';
import 'package:myfhb/video_call/utils/rtc_engine.dart';
import 'package:myfhb/video_call/utils/videoicon_provider.dart';
import 'package:myfhb/video_call/utils/videorequest_provider.dart';
import 'package:provider/provider.dart';
import '../../src/utils/screenutils/size_extensions.dart';

// ignore: must_be_immutable
class Toolbar extends StatefulWidget {
  final ClientRole role;
  Function(bool, bool) controllerState;
  bool muted;
  bool _isHideMyVideo;
  String patId;
  String patName;
  String appointmentId;
  String patPicUrl;
  String bookId;
  String callStartTime;
  String healthOrganizationId;
  HealthRecord healthRecords;
  bool isFromAppointment;

  Toolbar(
      this.role,
      this.controllerState,
      this.muted,
      this._isHideMyVideo,
      this.patId,
      this.patName,
      this.appointmentId,
      this.patPicUrl,
      this.bookId,
      this.callStartTime,
      this.healthOrganizationId,
      this.healthRecords,
      this.isFromAppointment);

  @override
  _ToolbarState createState() => _ToolbarState();
}

class _ToolbarState extends State<Toolbar> {
  String doctorId = '';
  String doctorName = '';
  String doctorPicUrl = '';
  PreferenceUtil prefs = new PreferenceUtil();

  ChatViewModel chatViewModel = ChatViewModel();
  static const platform = const MethodChannel('ongoing_ns.channel');
  String callStartTime = '';
  String callEndTime = '';
  //ApiResponse _apiResponse = ApiResponse();
  String doctor_id, mtTitle = '', specialityName = '';
  String userIdForNotify = '';

  final audioCallStatus =
      Provider.of<AudioCallProvider>(Get.context, listen: false);
  final videoIconStatus =
      Provider.of<VideoIconProvider>(Get.context, listen: false);
  final videoRequestStatus =
      Provider.of<VideoRequestProvider>(Get.context, listen: false);

  var rtcProvider = Provider.of<RTCEngineProvider>(Get.context, listen: false);

  @override
  void initState() {
    try {
      super.initState();
      prepareMyData();
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    try {
      super.dispose();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.role == ClientRole.Audience) return Container();
    return Container(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          color: audioCallStatus?.isAudioCall
              ? Colors.white.withOpacity(0.5)
              : Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.all(
            Radius.circular(
              8.0.sp,
            ),
          ),
        ),
        //color:Colors.red,
        child: Container(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(
                  8.0.sp,
                ),
                child: IconButton(
                  onPressed: _onToggleVideo,
                  // icon: Icon(
                  // widget._isHideMyVideo ? Icons.videocam_off : Icons.videocam,
                  //   color: Colors.white,
                  //   size: 20.0,
                  // ),
                  icon: Consumer<VideoIconProvider>(
                    builder: (context, status, child) {
                      return status.isVideoOn
                          ? Image.asset('assets/icons/ic_vc_white.png')
                          : Image.asset('assets/icons/ic_vc_off_white.png');
                    },
                  ),
                  iconSize: 24.0.sp,
                  //color: Colors.white,
                  //iconSize: 15.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(
                  8.0.sp,
                ),
                child: IconButton(
                  onPressed: _onToggleMute,
                  icon: widget.muted
                      ? Image.asset('assets/icons/ic_mic_mute_white.png')
                      : Image.asset('assets/icons/ic_mic_unmute_white.png'),
                  iconSize: 24.0.sp,
                  //color: Colors.white,
                  //iconSize: 13.0,
                ),
              ),
              /*Padding(
                padding: EdgeInsets.all(
                  8.0.sp,
                ),
                child: IconButton(
                  onPressed: () {
                    */ /*chatViewModel.goToChatSocket(widget.patId, widget.patName,
                        widget.patPicUrl, context, true, null,
                        healthRecord: widget.healthRecords,
                        dailyListAppointmentModel: null,
                        patientInfo: null);*/ /*
                  },
                  icon: Image.asset('assets/icons/ic_chat.png'),
                  iconSize: 24.0.sp,
                  //iconSize: 33,
                ),
              ),*/
              Padding(
                padding: EdgeInsets.all(
                  8.0.sp,
                ),
                child: Visibility(
                  visible: (widget.appointmentId != null &&
                          widget.appointmentId != '')
                      ? true
                      : false,
                  child: IconButton(
                    onPressed: () {
                      //_displayPopUpDialog(context);
                    },
                    icon: Image.asset('assets/icons/ic_followup.png'),
                    iconSize: 8.0.sp,
                  ),
                ),
              ),
              SizedBox(
                width: 10.0.w,
              ),
              Container(
                padding: EdgeInsets.only(
                  top: 8.0.h,
                  bottom: 8.0.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(
                      8.0.sp,
                    ),
                    bottomRight: Radius.circular(
                      8.0.sp,
                    ),
                  ),
                ),
                //color: Colors.red,
                child: IconButton(
                  onPressed: () {
                    _onCallEnd(context);
                  },
                  icon: Image.asset('assets/icons/ic_hangup.png'),
                  color: Colors.white,
                  iconSize: 33.0.sp,
                  //padding: const EdgeInsets.only(left: 13,right: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*_displayPopUpDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: 8.0.w,
          ),
          backgroundColor: Colors.transparent,
          content: (widget.appointmentId != null && widget.appointmentId != '')
              ? FollowUpMain(
                  appointmentId: widget.appointmentId,
                  healthOrganizationId: widget.healthOrganizationId,
                )
              : SizedBox(),
        );
      },
    );
  }*/

  void _onCallEnd(BuildContext context) {
    prepareMyData();
    try {
      if (!widget.isFromAppointment) {
        callApiToUpdateNonAppointment();
      }
    } catch (e) {}
    VideoCallCommonUtils().terminate(
        appsID: widget.appointmentId,
        bookId: widget.bookId,
        patName: widget.patName,
        callStartTime: widget.callStartTime);
    Navigator.pop(context);
  }

  void _onToggleMute() {
    try {
      setState(() {
        widget.muted = !widget.muted;
      });
      widget.controllerState(widget.muted, widget._isHideMyVideo);
      Provider.of<RTCEngineProvider>(Get.context, listen: false)
          ?.rtcEngine
          ?.muteLocalAudioStream(widget.muted);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onToggleVideo() async {
    try {
      /// switch to audio call if remote user also in audio call
      if (audioCallStatus?.isAudioCall) {
        //if it's a audio call want switch to video call, request remote user
        //check for camera permission
        var permissionStatus =
            await VideoCallCommonUtils().getCurrentVideoCallRelatedPermission();
        if (!permissionStatus) {
          FlutterToast().getToast(
              'Could not request video due to permission settings',
              Colors.black);
          return;
        } else {
          // open request dialog for requesting
          await rtcProvider?.rtcEngine?.enableVideo();
          await rtcProvider?.rtcEngine?.enableLocalVideo(true);
          await rtcProvider?.rtcEngine?.muteLocalVideoStream(false);
          Provider.of<RTCEngineProvider>(context, listen: false)
              ?.changeLocalVideoStatus(false);
          requestingDialog();
          var newStatus = VideoCallStatus();
          newStatus.setDefaultValues();
          newStatus.videoRequestFromMobile = 1;

          VideoCallCommonUtils().myDB
            ..collection("call_log")
                .doc("${widget.bookId}")
                .update(newStatus.toMap());
        }
      } else {
        if (CommonUtil.isRemoteUserOnPause) {
          await rtcProvider?.rtcEngine?.disableVideo();
          await rtcProvider?.rtcEngine?.enableLocalVideo(false);
          await rtcProvider?.rtcEngine?.muteLocalVideoStream(true);

          Provider?.of<HideProvider>(context, listen: false)?.swithToAudio();
          Provider.of<AudioCallProvider>(context, listen: false)
              ?.enableAudioCall();
          Provider?.of<VideoIconProvider>(context, listen: false)
              ?.turnOffVideo();
        } else {
          await rtcProvider?.rtcEngine
              ?.muteLocalVideoStream(videoIconStatus?.isVideoOn);
          Provider.of<RTCEngineProvider>(context, listen: false)
              ?.changeLocalVideoStatus(videoIconStatus?.isVideoOn);
          CommonUtil.isLocalUserOnPause = videoIconStatus?.isVideoOn;
          videoIconStatus?.swapVideo();
          widget.controllerState(widget.muted, videoIconStatus?.isVideoOn);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void prepareMyData() async {
    /*try {
      mtTitle = await prefs.getValueBasedOnKey("display_name");
    } catch (e) {}
    try {
      specialityName = await prefs.getValueBasedOnKey("speciality");
    } catch (e) {}
    try {
      doctor_id = await prefs.getValueBasedOnKey("doctor_id");
    } catch (e) {}
    try {
      final SharedPreferences sharedPrefs =
          await SharedPreferences.getInstance();
      userIdForNotify = await sharedPrefs.getString('userID');
      userIdForNotify = json.decode(userIdForNotify);
    } catch (e) {}*/
  }

  void callApiToUpdateNonAppointment() {
    try {
      String nonAppointmentUrl = 'call-log/non-appointment-call';
      Map<String, dynamic> body = new Map();
      final now = DateTime.now();
      String endTime =
          '${DateFormat('yyyy-MM-dd HH:mm:ss', 'en_US').format(now)}';
      //String userIdForNotify;
      //PreferenceUtil prefs = new PreferenceUtil();

      /* try {
      prefs.getValueBasedOnKey(struserID).then((value) {
        userIdForNotify = value;
      });
    } catch (e) {}
*/
      body['startTime'] = widget.callStartTime;
      body['endTime'] = endTime;
      body['callerUser'] = userIdForNotify;
      body['recipientUser'] = widget.patId;

      /*new ApiResponse()
        .putNonAppointmentCall(nonAppointmentUrl, body)
        .then((value) {
      if (value['isSuccess'] != null && value['isSuccess']) {
        print('SUCCESSSSSSSSSSSSSSSSSSSSSSSSS NON APPOINTMENT CALL UPDATED');
      }
    });*/
    } catch (e) {
      print(e);
    }
  }

// Future<void> terminate() async {
//   AgoraRtcEngine.leaveChannel();
//   AgoraRtcEngine.destroy();
//   cancelOnGoingNS();
//   CommonUtil.isCallStarted = false;

//   ///invoke call log api before end the call
//   callEndTime = DateFormat(c_yMd_Hms).format(DateTime.now());
//   UpdatedInfo _updateInfo = UpdatedInfo(
//       actualEndDateTime: callEndTime,
//       actualStartDateTime: callStartTime,
//       bookingId: widget.bookId);
//   CallLogRequestModel _request = CallLogRequestModel(
//       updationType: "appointmentEnds", updatedInfo: _updateInfo);

//   //clear the call_log from firebase db
//   FirebaseFirestore.instance
//       .collection('call_log')
//       .doc('${widget.bookId}')
//       .delete();

//   var callLogResponse =
//       await _apiResponse.recordCallLogData(request: _request);
// }

// cancelOnGoingNS() async {
//   await platform.invokeMethod(
//       "startOnGoingNS", {'name': '${widget.patName}', 'mode': 'stop'});
// }

  Future<void> requestingDialog() async {
    CommonUtil.isVideoRequestSent = true;
    try {
      await Get.dialog(
        AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 40.0.w,
                ),
                child: LinearProgressIndicator(
                  backgroundColor: Color(CommonUtil.secondaryGrey),
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Color(CommonUtil().getMyPrimaryColor())),
                  //value: progressValue[currentProgressValue],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Text(
                  'Requesting to switch to video call',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20.0.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withOpacity(0.5)),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                      child: Text('Cancel'),
                      onPressed: () async {
                        try {
                          CommonUtil.isVideoRequestSent = false;
                          await rtcProvider?.rtcEngine?.disableVideo();
                          await rtcProvider?.rtcEngine?.enableLocalVideo(false);
                          await rtcProvider?.rtcEngine
                              ?.muteLocalVideoStream(true);
                          Provider.of<RTCEngineProvider>(Get.context,
                                  listen: false)
                              ?.changeLocalVideoStatus(true);
                          var newStatus = VideoCallStatus();
                          newStatus.setDefaultValues();
                          newStatus.videoRequestFromMobile = 0;
                          VideoCallCommonUtils().myDB
                            ..collection("call_log")
                                .doc("${widget.bookId}")
                                .update(newStatus.toMap());
                          Get.back();
                        } catch (e) {
                          print(e);
                        }
                      }),
                ],
              ),
            ],
          ),
        ),
        barrierDismissible: false,
      );
    } catch (e) {}
  }
}
