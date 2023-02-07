
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

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

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget?.videoId!,
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
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
        progressIndicatorColor: Color(new CommonUtil().getMyPrimaryColor()),
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
        appBar: AppBar(
          title: Text(
            _videoMetaData.title,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(
              Icons.close,
              size: 24.0.sp,
            ),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          color: Colors.black,
          child: Center(
            child: player,
          ),
        ),
      ),
    );
  }
}
