import 'dart:async';
import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/src/model/home_screen_arguments.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/TelehealthProviders.dart';
import 'package:myfhb/video_call/model/CallArguments.dart';
import 'package:screen/screen.dart';

import '../utils/settings.dart';

class CallPage extends StatefulWidget {
  /// non-modifiable channel name of the page
  String channelName;

  /// non-modifiable client role of the page
  ClientRole role;
  CallArguments arguments;

  ///check call is made from NS
  bool isAppExists;

  /// Creates a call page with given channel name.
  CallPage({this.channelName, this.role, this.arguments, this.isAppExists});

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  static final _users = <int>[];
  final _infoStrings = <String>[];

  ///create method channel for on going NS for call
  static const platform = const MethodChannel(parameters.ongoing_channel);

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    cancelOnGoingNS();
    super.dispose();
    Screen.keepOn(false);
  }

  @override
  void initState() {
    super.initState();

    if (widget.arguments != null) {
      widget.channelName = widget.arguments.channelName;
      widget.role = widget.arguments.role;
      widget.isAppExists = widget.arguments.isAppExists;
    }

    // initialize agora sdk
    initialize();
    Screen.keepOn(true);
  }

  cancelOnGoingNS() async {
    await platform.invokeMethod(
        parameters.startOnGoingNS, {parameters.mode: parameters.stop});
  }

  Future<void> initialize() async {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          parameters.appid_missing,
        );
        _infoStrings.add(parameters.agora_not_starting);
      });
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await AgoraRtcEngine.enableWebSdkInteroperability(true);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = Size(1920, 1080);
    await AgoraRtcEngine.setVideoEncoderConfiguration(configuration);
    await AgoraRtcEngine.joinChannel(null, widget.channelName, null, 0)
        .then((value) async {
      //todo name has to be change with dynamic

      await platform.invokeMethod(
          parameters.startOnGoingNS, {parameters.mode: parameters.start});
    });
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    await AgoraRtcEngine.create(APP_ID);
    await AgoraRtcEngine.enableVideo();
    await AgoraRtcEngine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await AgoraRtcEngine.setClientRole(widget.role);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    AgoraRtcEngine.onError = (dynamic code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onJoinChannelSuccess = (
      String channel,
      int uid,
      int elapsed,
    ) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onLeaveChannel = () {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
      });
    };

    AgoraRtcEngine.onUserMuteAudio = (int uid, bool muted) {
      setState(() {
        //get the remote user mute status
      });
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
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
      });
    };

    AgoraRtcEngine.onFirstRemoteVideoFrame = (
      int uid,
      int width,
      int height,
      int elapsed,
    ) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onLocalVideoStateChanged =
        (LocalVideoStreamState localVideoStreamState,
            LocalVideoStreamError localVideoStreamError) {
      if (localVideoStreamState == LocalVideoStreamState.Stopped) {
        //FlutterToast().getToast('your video has been stopped', Colors.red);

      } else if (localVideoStreamState == LocalVideoStreamState.Failed) {
        //FlutterToast().getToast('The local video fails to start.', Colors.red);
      } else if (localVideoStreamState == LocalVideoStreamState.Capturing) {
        // FlutterToast().getToast(
        //     'The local video capturer starts successfully.', Colors.green);
      } else if (localVideoStreamState == LocalVideoStreamState.Encoding) {
        // FlutterToast().getToast(
        //     'The first local video frame encodes successfully.', Colors.green);

      }

      if (localVideoStreamError == LocalVideoStreamError.OK) {
        //FlutterToast().getToast('The local video is normal.', Colors.green);
      } else if (localVideoStreamError ==
          LocalVideoStreamError.CaptureFailure) {
        // FlutterToast().getToast(
        //     'The local video capture fails. Check whether the capturer is working properly.',
        //     Colors.red);

      } else if (localVideoStreamError ==
          LocalVideoStreamError.DeviceNoPermission) {
        // FlutterToast().getToast(
        //     'No permission to use the local video device.', Colors.red);

      } else if (localVideoStreamError == LocalVideoStreamError.DeviceBusy) {
        // FlutterToast()
        //     .getToast('The local video capturer is in use.', Colors.red);

      } else if (localVideoStreamError == LocalVideoStreamError.EncodeFailure) {
        //FlutterToast().getToast('The local video encoding fails.', Colors.red);
      } else if (localVideoStreamError == LocalVideoStreamError.Failure) {
        // FlutterToast().getToast(
        //     'No specified reason for the local video failure.', Colors.red);
      }
    };

    AgoraRtcEngine.onRemoteVideoStateChanged = (uid, state, reason, elapsed) {
      // if (state == 'REMOTE_VIDEO_STATE_STARTING') {
      //   FlutterToast().getToast('Remote Video call is started', Colors.green);
      // } else if (state == 'REMOTE_VIDEO_STATE_FAILED') {
      //   FlutterToast().getToast('Remote Video call state Failed', Colors.red);
      // } else if (state == 'REMOTE_VIDEO_STATE_FROZEN') {
      //   FlutterToast().getToast('Remote Video call state is Frozen', Colors.red);
      //   print('Remote Video call state is Frozen');
      // } else if (state == 'REMOTE_VIDEO_STATE_STOPPED') {
      //   FlutterToast().getToast('Remote Video call is Stopped', Colors.red);
      //   print('Remote Video call is Stopped');
      // }

      if (reason == 0) {
        //FlutterToast().getToast('Remote User Went to OFFLINE', Colors.yellow);
      } else if (reason == 6) {
        FlutterToast().getToast('Video is resumed', Colors.green);
      } else if (reason == 5) {
        FlutterToast().getToast('Video is paused', Colors.red);
      }
    };
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final list = <AgoraRenderWidget>[];
    if (widget.role == ClientRole.Broadcaster) {
      list.add(AgoraRenderWidget(0, local: true, preview: true));
    }
    _users.forEach((int uid) => list.add(AgoraRenderWidget(uid)));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return customVideoView(views);
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      default:
    }
    return Container();
  }

  Widget customVideoView(List<Widget> attendees) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(child: attendees[1]),
        SizedBox(
          width: 150,
          height: 200,
          child: Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: attendees[0]),
        ),
      ],
    );
  }

  /// Info panel to show logs
  Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return null;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _viewRows();
  }
}
