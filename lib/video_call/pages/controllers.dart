import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/model/home_screen_arguments.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/TelehealthProviders.dart';
import 'package:myfhb/telehealth/features/chat/viewModel/ChatViewModel.dart';
import 'package:myfhb/video_call/utils/callstatus.dart';
import 'package:myfhb/video_call/utils/hideprovider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  MyControllers(
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
      this.patientPicUrl);

  @override
  _MyControllersState createState() => _MyControllersState();
}

class _MyControllersState extends State<MyControllers> {
  ChatViewModel chatViewModel = ChatViewModel();
  SharedPreferences prefs;
  String patientId;
  String patientName;
  String patientPicUrl;

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
          color: Color(CommonUtil().getMyPrimaryColor()).withOpacity(0.3),
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
                  // icon: Icon(
                  // widget._isHideMyVideo ? Icons.videocam_off : Icons.videocam,
                  //   color: Colors.white,
                  //   size: 20.0,
                  // ),
                  icon: widget._isHideMyVideo
                      ? Image.asset(
                          'assets/icons/ic_vc_off_white.png') //? video call off icon
                      : Image.asset('assets/icons/ic_vc_white.png'),
                  //color: Colors.white,
                  //iconSize: 15.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: _onToggleMute,
                  icon: widget.muted
                      ? Image.asset(
                          'assets/icons/ic_mic_mute_white.png')
                      : Image.asset(
                          'assets/icons/ic_mic_unmute_white.png'),
                  //color: Colors.white,
                  //iconSize: 13.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () {
                   chatViewModel.storePatientDetailsToFCM(widget.doctorId,
                  widget.doctorName, widget.doctorPicUrl,widget.patientId,widget.patientName,widget.patientPicUrl,context,true);
                  },
                  icon: Image.asset('assets/icons/ic_chat.png'),
                  //iconSize: 33,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                padding: EdgeInsets.only(top: 8, bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(8),bottomRight: Radius.circular(8)),
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
    AgoraRtcEngine.muteLocalAudioStream(widget.muted);
  }

  void _onToggleVideo() {
    setState(() {
      widget._isHideMyVideo = !widget._isHideMyVideo;
    });
    widget.controllerState(widget.muted, widget._isHideMyVideo);
    AgoraRtcEngine.muteLocalVideoStream(widget._isHideMyVideo);
  }
}
