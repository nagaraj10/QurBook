import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_timer/flutter_timer.dart';
import 'package:get/get.dart';
import 'package:myfhb/src/ui/Dashboard.dart';
import 'package:myfhb/video_call/model/CallArguments.dart';
import 'package:myfhb/video_call/utils/callstatus.dart';
import 'package:provider/provider.dart';

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
  bool muted = false;
  bool _isHideMyVideo = false;
  bool _isHideControl = true;
  bool _isTimerRun = true;
  bool _isRemoteAudio = false;
  bool _isFirstTime = true;

  ///create method channel for on going NS for call
  static const platform = const MethodChannel('ongoing_ns.channel');

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    cancelOnGoingNS();
    _isTimerRun = false;
    super.dispose();
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
  }

  cancelOnGoingNS() async {
    await platform.invokeMethod(
        "startOnGoingNS", {'name': 'Dr.Parvathi Krishnan', 'mode': 'stop'});
  }

  Future<void> initialize() async {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
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
          "startOnGoingNS", {'name': 'Dr.Parvathi Krishnan', 'mode': 'start'});
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

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
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
        _expandedVideoRow([attendees[1]]),
        SizedBox(
          width: 150,
          height: 200,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Stack(
              children: [
                _expandedVideoRow([attendees[0]]),
                Align(
                  alignment: Alignment.topCenter,
                  child: IconButton(
                    onPressed: _onSwitchCamera,
                    icon: Icon(
                      Icons.switch_camera,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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

  void _onCallEnd(BuildContext context) async {
    widget.isAppExists ? Navigator.pop(context) : Get.offAll(DashboardScreen());
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

  void _onSwitchCamera() {
    AgoraRtcEngine.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    /// hide/show app bar and controller
//    if (_isFirstTime) {
//      _isFirstTime = false;
//      Future.delayed(const Duration(seconds: 5), () {
//        setState(() {
//          _isHideControl = false;
//        });
//      });
//    }

    ///update call status through provider
    final callStatus = Provider.of<CallStatus>(context, listen: false);
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: Center(
          child: Stack(
            children: <Widget>[
              _viewRows(),
              customAppbar(),
              _toolbar(callStatus: callStatus),
              //_panel(),
//              Visibility(
//                child: customAppbar(),
//                visible: _isHideControl,
//              ),
//              Visibility(
//                child: _toolbar(callStatus: callStatus),
//                visible: _isHideControl,
//              ),
              //_prescription(context, callStatus: callStatus)
            ],
          ),
        ),
      ),
    );
  }

  Widget customAppbar() {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Dr.Parvathi Krishnan',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      //todo this has to be uncomment in future
//                      SizedBox(
//                        width: 10,
//                      ),
//                      Icon(
//                        Icons.mic,
//                        color: Colors.white,
//                        size: 20,
//                      ),
                    ],
                  ),
                  TikTikTimer(
                    backgroundColor: Colors.transparent,
                    initialDate: DateTime.now(),
                    running: _isTimerRun,
                    width: 50,
                    timerTextStyle:
                        TextStyle(color: Colors.white, fontSize: 12),
                    isRaised: false,
                    tracetime: (time) {
                      // print(time.getCurrentSecond);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    return userAlert() ?? false;
  }

  Future userAlert() {
    print('show dialog invoked');
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Center(
              child: Text(
                'warning!',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.8)),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Text(
                    'Do you want exit from call?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withOpacity(0.5)),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FlatButton(
                        child: Text('Yes'),
                        onPressed: () {
                          widget.isAppExists
                              ? Navigator.of(context).pop(true)
                              : Get.offAll(DashboardScreen());
                        }),
                    FlatButton(
                        child: Text('No'),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        }),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
