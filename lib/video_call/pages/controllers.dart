import 'dart:io';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/chat_socket/view/ChatDetail.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/model/home_screen_arguments.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/TelehealthProviders.dart';
import 'package:myfhb/telehealth/features/chat/viewModel/ChatViewModel.dart';
import 'package:myfhb/video_call/model/videocallStatus.dart';
import 'package:myfhb/video_call/utils/audiocall_provider.dart';
import 'package:myfhb/video_call/utils/callstatus.dart';
import 'package:myfhb/video_call/utils/hideprovider.dart';
import 'package:myfhb/video_call/utils/rtc_engine.dart';
import 'package:myfhb/video_call/utils/videoicon_provider.dart';
import 'package:myfhb/video_call/utils/videorequest_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class MyControllers extends StatefulWidget {
  CallStatus callStatus;
  ClientRole role;
  bool isAppExists;
  Function(bool, bool) controllerState;
  bool muted;
  bool _isHideMyVideo;
  String doctorId;
  String doctorName;
  String doctorPicUrl;
  String patientId;
  String patientName;
  String patientPicUrl;
  RtcEngine rtcEngine;
  String channelName;
  bool isWeb;

  MyControllers(
      this.rtcEngine,
      this.callStatus,
      this.role,
      this.isAppExists,
      this.doctorId,
      this.controllerState,
      this.muted,
      this._isHideMyVideo,
      this.doctorName,
      this.doctorPicUrl,
      this.patientId,
      this.patientName,
      this.patientPicUrl,
      this.channelName,
      this.isWeb);

  @override
  _MyControllersState createState() => _MyControllersState();
}

class _MyControllersState extends State<MyControllers> {
  ChatViewModel chatViewModel = ChatViewModel();
  SharedPreferences prefs;
  String patientId;
  String patientName;
  String patientPicUrl;

  final audioCallStatus =
      Provider.of<AudioCallProvider>(Get.context, listen: false);
  final videoIconStatus =
      Provider.of<VideoIconProvider>(Get.context, listen: false);
  final videoRequestStatus =
      Provider.of<VideoRequestProvider>(Get.context, listen: false);

  //final myDB = Firestore.instance;

  @override
  void initState() {
    super.initState();
    //acknowledgeForVideoCallRequest();
  }

  /* acknowledgeForVideoCallRequest() {
    myDB
        .collection('call_log')
        .document('${widget.channelName}') //! call must be updat here
        .snapshots()
        .listen((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> firestoreInfo = documentSnapshot.data;

      if (firestoreInfo['PatientRequestForVideoCall'] == 'request') {
        showDialog(
            context: Get.context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Center(
                  child: Text(
                    'Alert!',
                    style: TextStyle(
                        fontSize: 20.0.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.8)),
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      child: Text(
                        'Do you want Switch to Video call?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20.0.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black.withOpacity(0.5)),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FlatButton(
                            child: Text('Yes'),
                            onPressed: () async {
                              try {
                                await myDB
                                    .collection("call_log")
                                    .document("${widget.channelName}")
                                    .setData({
                                  "PatientRequestForVideoCall": "accept"
                                });
                              } catch (e) {}
                              Provider?.of<HideProvider>(context, listen: false)
                                  ?.swithToVideo();
                              Provider.of<AudioCallProvider>(context,
                                      listen: false)
                                  ?.disableAudioCall();
                              Navigator.of(context).pop(true);
                            }),
                        FlatButton(
                            child: Text('No'),
                            onPressed: () async {
                              try {
                                await myDB
                                    .collection("call_log")
                                    .document("${widget.channelName}")
                                    .setData({
                                  "PatientRequestForVideoCall": "decline"
                                });
                              } catch (e) {}
                              Navigator.of(context).pop(false);
                            }),
                      ],
                    ),
                  ],
                ),
              );
            });
      }
    }).onError((e) {});
  } */

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _toolbar(callStatus: widget.callStatus);

  /// Toolbar layout
  Widget _toolbar({CallStatus callStatus, HideProvider hideProvider}) {
    if (widget.role == ClientRole.Audience) return Container();
    /* return Container(
      color: Colors.black.withOpacity(0.5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          IconButton(
            onPressed: _onToggleVideo,
            icon: Icon(
              widget._isHideMyVideo ? Icons.videocam_off : Icons.videocam,
              color: Colors.white,
              size: 20.0,
            ),
          ),
          IconButton(
            onPressed: _onToggleMute,
            icon: Icon(
              widget.muted ? Icons.mic_off : Icons.mic,
              color: Colors.white,
              size: 20.0,
            ),
          ),
          IconButton(
            onPressed: () {
              chatViewModel.storePatientDetailsToFCM(widget.doctorId,
                  widget.doctorName, widget.doctorPicUrl,widget.patientId,widget.patientName,widget.patientPicUrl,context,true);
            },
            icon: Icon(
              Icons.chat_bubble_outline,
              color: Colors.white,
              size: 20.0,
            ),
          ),
          Container(
            color: Colors.redAccent,
            child: IconButton(
              onPressed: () {
                _onCallEnd(context);
              },
              icon: Icon(
                Icons.call_end,
                color: Colors.white,
                size: 30.0,
              ),
              padding: const EdgeInsets.all(15.0),
            ),
          ),
        ],
      ),
    ); */

    return Container(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          color: audioCallStatus?.isAudioCall
              ? Colors.white.withOpacity(0.5)
              : Color(CommonUtil().getMyPrimaryColor()).withOpacity(0.3),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        //color:Colors.red,
        child: Container(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: _onToggleVideo,
                  icon: Consumer<VideoIconProvider>(
                    builder: (context, status, child) {
                      return status.isVideoOn
                          ? Image.asset('assets/icons/ic_vc_white.png')
                          : Image.asset('assets/icons/ic_vc_off_white.png');
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: _onToggleMute,
                  icon: widget.muted
                      ? Image.asset('assets/icons/ic_mic_mute_white.png')
                      : Image.asset('assets/icons/ic_mic_unmute_white.png'),
                  //color: Colors.white,
                  //iconSize: 13.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () {
                    /* chatViewModel.storePatientDetailsToFCM(
                        widget.doctorId,
                        widget.doctorName,
                        widget.doctorPicUrl,
                        widget.patientId,
                        widget.patientName,
                        widget.patientPicUrl,
                        context,
                        true);*/
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatDetail(
                                peerId: widget.doctorId,
                                peerAvatar: widget.doctorPicUrl,
                                peerName: widget.doctorName,
                                patientId: widget.patientId,
                                patientName: widget.patientName,
                                patientPicture: widget.patientPicUrl,
                                isFromVideoCall: true,
                                isCareGiver: false,
                                isForGetUserId: true)));
                  },
                  icon: Image.asset('assets/icons/ic_chat.png'),
                  //iconSize: 33,
                ),
              ),
              SizedBox(
                width: 10.0.w,
              ),
              Container(
                padding: EdgeInsets.only(top: 8, bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8)),
                ),
                //color: Colors.red,
                child: IconButton(
                  onPressed: () {
                    _onCallEnd(context);
                  },
                  icon: Image.asset('assets/icons/ic_hangup.png'),
                  color: Colors.white,
                  iconSize: 33,
                  //padding: const EdgeInsets.only(left: 13,right: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onCallEnd(BuildContext context) async {
    if (Platform.isIOS) {
      Navigator.pop(context);
    } else {
      if (widget.isAppExists) {
        Navigator.pop(context);
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/splashscreen', (Route<dynamic> route) => false);
      }
    }
  }

  void _onToggleMute() {
    setState(() {
      widget.muted = !widget.muted;
    });
    widget.controllerState(widget.muted, widget._isHideMyVideo);
    widget.rtcEngine.muteLocalAudioStream(widget.muted);
  }

  void _onToggleVideo() async {
    //* this need to uncomment and check
    if (audioCallStatus?.isAudioCall) {
      //if it's a audio call want switch to video call, request remote user
      //check for camera permission
      var permissionStatus =
          await CommonUtil.askPermissionForCameraAndMic(isAudioCall: false);
      if (!permissionStatus) {
        FlutterToast().getToast(
            'Could not request video due to permission settings', Colors.black);
        return;
      } else {
        // open request dialog for requesting
        await widget?.rtcEngine?.enableVideo();
        await widget?.rtcEngine?.enableLocalVideo(true);
        await widget?.rtcEngine?.muteLocalVideoStream(false);
        requestingDialog();
        var newStatus = VideoCallStatus();
        newStatus.setDefaultValues();
        newStatus.videoRequestFromMobile = 1;
        FirebaseFirestore.instance
          ..collection("call_log")
              .doc("${widget.channelName}")
              .set(newStatus.toMap());
      }
    } else {
      if (CommonUtil.isRemoteUserOnPause) {
        await widget?.rtcEngine?.disableVideo();
        await widget?.rtcEngine?.enableLocalVideo(false);
        await widget?.rtcEngine?.muteLocalVideoStream(true);

        Provider?.of<HideProvider>(context, listen: false)?.swithToAudio();
        Provider.of<AudioCallProvider>(context, listen: false)
            ?.enableAudioCall();
        Provider?.of<VideoIconProvider>(context, listen: false)?.turnOffVideo();
      } else {
        widget.rtcEngine.muteLocalVideoStream(videoIconStatus?.isVideoOn);
        Provider.of<RTCEngineProvider>(context, listen: false)
            ?.changeLocalVideoStatus(videoIconStatus?.isVideoOn);
        CommonUtil.isLocalUserOnPause = videoIconStatus?.isVideoOn;
        videoIconStatus?.swapVideo();
        widget.controllerState(widget.muted, videoIconStatus?.isVideoOn);
      }
    }
  }

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
                        // if (widget.isWeb != null && widget.isWeb) {
                        var newStatus = VideoCallStatus();
                        newStatus.setDefaultValues();
                        newStatus.videoRequestFromMobile = 0;
                        FirebaseFirestore.instance
                          ..collection("call_log")
                              .doc("${widget.channelName}")
                              .update(newStatus.toMap());
                        // }
                        CommonUtil.isVideoRequestSent = false;
                        await widget?.rtcEngine?.disableVideo();
                        await widget?.rtcEngine?.enableLocalVideo(false);
                        await widget?.rtcEngine?.muteLocalVideoStream(true);
                        Get.back();
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
