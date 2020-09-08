import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  MyControllers(
      this.callStatus,
      this.role,
      this.isAppExists,
      this.doctorId,
      this.controllerState,
      this.muted,
      this._isHideMyVideo,
      this.doctorName,
      this.doctorPicUrl);

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
    return Container(
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
                  widget.doctorName, widget.doctorPicUrl, context);
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
    );
  }

  void _onCallEnd(BuildContext context) async {
    if (Platform.isIOS) {
      Navigator.pop(context);
    } else {
      Get.offAll(TelehealthProviders(
        arguments: HomeScreenArguments(selectedIndex: 0),
      ));
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
