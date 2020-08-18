import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfhb/src/ui/Dashboard.dart';
import 'package:myfhb/video_call/utils/callstatus.dart';

class MyControllers extends StatefulWidget {
  CallStatus callStatus;
  ClientRole role;
  bool isAppExists;

  MyControllers(this.callStatus, this.role, this.isAppExists);

  @override
  _MyControllersState createState() => _MyControllersState();
}

class _MyControllersState extends State<MyControllers> {
  bool muted = false;
  bool _isHideMyVideo = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _toolbar(callStatus: widget.callStatus),
      ],
    );
  }

  /// Toolbar layout
  Widget _toolbar({CallStatus callStatus}) {
    if (widget.role == ClientRole.Audience) return Container();
    return Container(
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            IconButton(
              onPressed: _onToggleVideo,
              icon: Icon(
                _isHideMyVideo ? Icons.videocam_off : Icons.videocam,
                color: Colors.white,
                size: 20.0,
              ),
            ),
            IconButton(
              onPressed: _onToggleMute,
              icon: Icon(
                muted ? Icons.mic_off : Icons.mic,
                color: Colors.white,
                size: 20.0,
              ),
            ),
            IconButton(
              onPressed: null,
              icon: Icon(
                Icons.chat_bubble_outline,
                color: Colors.white,
                size: 20.0,
              ),
            ),
            IconButton(
              onPressed: null,
              icon: Icon(
                Icons.attach_file,
                color: Colors.white,
                size: 20.0,
              ),
            ),
            Container(
              color: Colors.redAccent,
              child: IconButton(
                onPressed: () {
//                  callStatus.enCall();
//                  iCallStatus.callNotAlive();
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
      ),
    );
  }

  void _onCallEnd(BuildContext context) async {
    if (Platform.isIOS) {
      Navigator.pop(context);
    } else {
      widget.isAppExists
          ? Navigator.pop(context)
          : Get.offAll(DashboardScreen());
    }
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    AgoraRtcEngine.muteLocalAudioStream(muted);
  }

  void _onToggleVideo() {
    setState(() {
      _isHideMyVideo = !_isHideMyVideo;
    });
    AgoraRtcEngine.muteLocalVideoStream(_isHideMyVideo);
  }
}
