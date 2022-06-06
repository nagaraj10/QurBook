import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfhb/video_call/utils/audiocall_provider.dart';
import 'package:myfhb/video_call/utils/hideprovider.dart';
import 'package:myfhb/video_call/utils/rtc_engine.dart';
import 'package:provider/provider.dart';
import '../../src/utils/screenutils/size_extensions.dart';

class MakeCallLocalPreview extends StatefulWidget {
  @override
  _MakeCallLocalPreviewState createState() => _MakeCallLocalPreviewState();
}

class _MakeCallLocalPreviewState extends State<MakeCallLocalPreview> {
  @override
  Widget build(BuildContext context) {
    final hideStatus = Provider.of<HideProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(children: [
        InkWell(
          onTap: () {
            try {
              if (hideStatus.isControlStatus) {
                hideStatus.hideMe();
              } else {
                hideStatus.showMe();
                Future.delayed(Duration(seconds: 10), () {
                  hideStatus.hideMe();
                });
              }
            } catch (e) {
              print(e);
            }
          },
          child: Container(),
        ),
        Consumer<AudioCallProvider>(builder: (context, status, child) {
          return Visibility(
            child: Positioned.fill(
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
                      Consumer<RTCEngineProvider>(
                          builder: (context, status, child) {
                        return Visibility(
                          child: RtcLocalView.SurfaceView(),
                          visible: !(status.isVideoPaused),
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
                        );
                      }),
                      Align(
                        alignment: FractionalOffset.topRight,
                        child: IconButton(
                            icon: Icon(Icons.camera_front),
                            iconSize: 30,
                            color: Colors.white,
                            onPressed: () {
                              try {
                                Provider.of<RTCEngineProvider>(Get.context,
                                        listen: false)
                                    ?.rtcEngine
                                    ?.switchCamera();
                              } catch (e) {
                                print(e);
                              }
                            }),
                      )
                    ],
                  ),
                ),
              ),
            ),
            visible: status.isAudioCall ? false : true,
          );
        }),
      ]),
    );
  }
}
