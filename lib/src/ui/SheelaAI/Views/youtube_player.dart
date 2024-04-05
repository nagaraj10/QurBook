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
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../main.dart';

class MyYoutubePlayer extends StatefulWidget {
  final String? videoId;

  MyYoutubePlayer({this.videoId});

  @override
  _YoutubePlayerState createState() => _YoutubePlayerState();
}

class _YoutubePlayerState extends State<MyYoutubePlayer> {
  YoutubePlayerController? _controller;

  PlayerState? _playerState;

  late YoutubeMetaData _videoMetaData;

  double _volume = 100;

  bool _muted = false;

  bool _isPlayerReady = false;
  SheelaAIController sheelaAIController = Get.find();

  @override
  void initState() {
    super.initState();
    sheelaAIController.onStopTTSWithDelay();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId!,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: true,
        enableCaption: true,
      ),
    )..addListener(listener);

    _videoMetaData = const YoutubeMetaData();

    _playerState = PlayerState.unknown;
  }

  @override
  void deactivate() {
    _controller!.pause();

    super.deactivate();
  }

  @override
  void dispose() {
    _controller!.dispose();

    super.dispose();
  }

  void listener() {
    //!_controller.value.isFullScreen

    if (_isPlayerReady && mounted) {
      setState(() {
        _playerState = _controller!.value.playerState;

        _videoMetaData = _controller!.metadata;
      });
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
                      CommonUtil()
                          .appLogs(message: e.toString(), stackTrace: stackTrace);
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
          body: YoutubePlayerBuilder(
            onExitFullScreen: () {
              SystemChrome.setPreferredOrientations(
                  [DeviceOrientation.portraitUp]);

              _controller!.play();
            },
            onEnterFullScreen: () {
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.landscapeRight
              ]);

              if (!_controller!.value.isPlaying) {
                _controller!.play();
              }
            },
            player: YoutubePlayer(
              controller: _controller!,
              showVideoProgressIndicator: false,
              progressIndicatorColor: mAppThemeProvider.primaryColor,
              topActions: <Widget>[
                SizedBox(width: 8.0.w),

                // Expanded(

                //   child: Text(

                //     _controller.metadata.title,

                //     style: const TextStyle(

                //       color: Colors.white,

                //       fontSize: 18.0.sp,

                //     ),

                //     overflow: TextOverflow.ellipsis,

                //     maxLines: 1,

                //   ),

                // ),
              ],
              bottomActions: [
                CurrentPosition(),
                ProgressBar(isExpanded: true),
                RemainingDuration(),
                FullScreenButton(
                  controller: _controller,
                )
              ],
              onReady: () {
                _isPlayerReady = true;
              },
              onEnded: (data) {
                //* logics when video ends
              },
            ),
            builder: (context, player) => Scaffold(
              body: Container(
                color: Colors.black,
                child: Center(
                  child: player,
                ),
              ),
            ),
          )),
    );
  }
}
