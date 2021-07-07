import 'dart:ui';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/video_call/utils/hideprovider.dart';
import 'package:myfhb/video_call/utils/rtc_engine.dart';
import 'package:provider/provider.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;

class LocalPreview extends StatefulWidget {
  RtcEngine rtcEngine;
  String channelName;

  LocalPreview({this.rtcEngine, this.channelName});
  @override
  _LocalPreviewState createState() => _LocalPreviewState();
}

class _LocalPreviewState extends State<LocalPreview> {
  @override
  Widget build(BuildContext context) {
    final hideStatus = Provider.of<HideProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(children: [
        InkWell(
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
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              height: 150.0.h,
              width: 125.0.w,
              margin: EdgeInsets.symmetric(vertical: 120, horizontal: 10),
              child: Stack(
                children: [
                  Visibility(
                    child: RtcLocalView.SurfaceView(),
                    visible: !(Provider.of<RTCEngineProvider>(context)
                        ?.isVideoPaused ?? false),
                    replacement: Container(
                      color: Colors.grey.withOpacity(0.2),
                      child: Center(
                        child: Text(
                          'Video Paused',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                      alignment: FractionalOffset.topRight,
                      child: IconButton(
                          icon: Icon(Icons.camera_front),
                          iconSize: 30,
                          color: Colors.white,
                          onPressed: () {
                            widget.rtcEngine.switchCamera();
                          }))
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
