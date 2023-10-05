import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:myfhb/Qurhome/Common/GradientAppBarQurhome.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/src/ui/SheelaAI/Controller/SheelaAIController.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String? videoURL;

  VideoPlayerScreen({this.videoURL});

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayerScreen> {
  late VideoPlayerController videoPlayerController;
  SheelaAIController sheelaAIController = Get.find();

  @override
  void initState() {
    try {
      super.initState();
      sheelaAIController.onStopTTSWithDelay();
      videoPlayerController =
          VideoPlayerController.network((widget.videoURL ?? ""))
            ..addListener(() => setState(() {}))
            ..setLooping(false)
            ..initialize().then((_) => videoPlayerController?.play());
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  @override
  void deactivate() {
    try {
      videoPlayerController?.pause();
      super.deactivate();
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  @override
  void dispose() {
    try {
      videoPlayerController?.dispose();
      super.dispose();
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        CommonUtil().onBackVideoPlayerScreen();
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
              flexibleSpace: PreferenceUtil.getIfQurhomeisAcive()
                  ? GradientAppBarQurhome()
                  : GradientAppBar(),
              leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 24.0.sp,
                  ),
                  color: Colors.white,
                  onPressed: () {
                    try {
                      Get.back();
                      CommonUtil().onBackVideoPlayerScreen();
                    } catch (e, stackTrace) {
                      CommonUtil().appLogs(
                          message: e.toString(), stackTrace: stackTrace);
                    }
                  }),
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              title: Text(
                strVideoTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0.sp,
                ),
              )),
          body: ((videoPlayerController != null) &&
                  (videoPlayerController?.value?.isInitialized ?? false))
              ? Center(child: buildVideo())
              : Center(
                  child: CircularProgressIndicator(
                      color: Color(CommonUtil().getMyPrimaryColor())))),
    );
  }

  Widget buildVideo() => OrientationBuilder(
        builder: (context, orientation) {
          final isPortrait = orientation == Orientation.portrait;
          return Stack(
            fit: isPortrait ? StackFit.loose : StackFit.expand,
            children: <Widget>[
              buildVideoPlayer(),
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    sheelaAIController.isPlayPauseView.value =
                        !(sheelaAIController.isPlayPauseView.value);
                  },
                  child: Stack(
                    children: <Widget>[
                      Obx(() => Visibility(
                          visible: (sheelaAIController.isPlayPauseView.value),
                          child: buildPlay())),
                      Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            color: Colors.black26,
                            child: Row(
                              children: [
                                SizedBox(width: 8),
                                Text(
                                  CommonUtil().durationFormatter(
                                    videoPlayerController
                                        .value.position.inMilliseconds,
                                  ),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12.0),
                                ),
                                SizedBox(width: 8),
                                Expanded(child: buildIndicator()),
                                SizedBox(width: 8),
                                Text(
                                  "- ${CommonUtil().durationFormatter(
                                    (videoPlayerController
                                            .value.duration.inMilliseconds) -
                                        (videoPlayerController
                                            .value.position.inMilliseconds),
                                  )}",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12.0),
                                ),
                                SizedBox(width: 8),
                                GestureDetector(
                                  child: Icon(
                                    (sheelaAIController
                                            .isFullScreenVideoPlayer.value)
                                        ? Icons.fullscreen_exit
                                        : Icons.fullscreen,
                                    color: Colors.white,
                                  ),
                                  onTap: () {
                                    try {
                                      sheelaAIController
                                              .isFullScreenVideoPlayer.value =
                                          !(sheelaAIController
                                              .isFullScreenVideoPlayer.value);
                                      if (sheelaAIController
                                          .isFullScreenVideoPlayer.value) {
                                        SystemChrome.setPreferredOrientations([
                                          DeviceOrientation.landscapeLeft,
                                          DeviceOrientation.landscapeRight
                                        ]);
                                      } else {
                                        SystemChrome.setPreferredOrientations(
                                            [DeviceOrientation.portraitUp]);
                                      }
                                    } catch (e, stackTrace) {
                                      CommonUtil().appLogs(
                                          message: e, stackTrace: stackTrace);
                                    }
                                  },
                                ),
                                SizedBox(width: 8),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      );

  Widget buildVideoPlayer() {
    final video = AspectRatio(
      aspectRatio: (videoPlayerController?.value?.aspectRatio ?? 0.0),
      child: VideoPlayer(videoPlayerController),
    );

    return buildFullScreen(child: video);
  }

  Widget buildFullScreen({
    @required Widget? child,
  }) {
    final size = videoPlayerController.value.size;
    final width = size?.width ?? 0;
    final height = size?.height ?? 0;

    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(width: width, height: height, child: child),
    );
  }

  Widget buildPlay() => Container(
        color: Colors.black26,
        child: Center(
          child: InkWell(
            onTap: () {
              if (videoPlayerController.value.isPlaying) {
                videoPlayerController.pause();
              } else {
                videoPlayerController.play();
              }
            },
            child: Icon(
              videoPlayerController.value.isPlaying
                  ? Icons.pause
                  : Icons.play_arrow,
              color: Colors.white,
              size: 70,
            ),
          ),
        ),
      );

  Widget buildIndicator() => Container(
        margin: EdgeInsets.all(8).copyWith(right: 0),
        height: 7,
        child: VideoProgressIndicator(
          videoPlayerController,
          allowScrubbing: true,
          colors: VideoProgressColors(playedColor: Colors.white),
        ),
      );
}
