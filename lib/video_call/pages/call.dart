import 'dart:async';
import 'dart:io';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/common/common_circular_indicator.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/src/model/home_screen_arguments.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/TelehealthProviders.dart';
import 'package:myfhb/video_call/model/CallArguments.dart';
import 'package:screen/screen.dart';
import 'package:myfhb/constants/router_variable.dart' as router;
import '../utils/settings.dart';
import 'package:myfhb/src/utils/PageNavigator.dart';

class CallPage extends StatefulWidget {
  /// non-modifiable channel name of the page
  String channelName;

  /// non-modifiable client role of the page
  ClientRole role;
  CallArguments arguments;

  ///check call is made from NS
  bool isAppExists;
  RtcEngine rtcEngine;

  /// Creates a call page with given channel name.
  CallPage({
    this.channelName,
    this.role,
    this.arguments,
    this.isAppExists,
    this.rtcEngine,
  });

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  static final _users = <int>[];
  final _infoStrings = <String>[];

  ///create method channel for on going NS for call
  static const platform = const MethodChannel(parameters.ongoing_channel);
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _internetconnection = false;
  bool isCustomViewShown = false;
  int videoPauseResumeState = 0;
  RtcEngineEventHandler rtcEngineEventHandler = RtcEngineEventHandler();

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    // widget.rtcEngine.leaveChannel();
    // widget.rtcEngine.destroy();
    cancelOnGoingNS();
    super.dispose();
    Screen.keepOn(false);
    videoPauseResumeState = 0;
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'TeleHealth Call Screen',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
  }

  @override
  void initState() {
    mInitialTime = DateTime.now();
    super.initState();

    if (widget.arguments != null) {
      widget.channelName = widget.arguments.channelName;
      widget.role = widget.arguments.role;
      widget.isAppExists = widget.arguments.isAppExists;
    }

    // initialize agora sdk
    initialize();
    Screen.keepOn(true);
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        setState(() {
          _internetconnection = true;
          isCustomViewShown = false;
        });
        break;
      case ConnectivityResult.mobile:
        setState(() {
          _internetconnection = true;
          //toast.getToast(data_connected, Colors.green);
          isCustomViewShown = false;
        });
        break;
      case ConnectivityResult.none:
        setState(() {
          _internetconnection = false;
          //toast.getToast(no_internet_conn, Colors.red);
          Future.delayed(Duration(seconds: 20), () {
            if (_internetconnection) {
              //do nothing
            } else {
              noResponseDialog(
                  context, 'Disconnected due to your Network Drop!');
            }
          });
          isCustomViewShown = true;
        });
        break;
      default:
        setState(() {
          _internetconnection = false;
          //toast.getToast(failed_get_connectivity, Colors.red);
        });
        break;
    }
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

    //todo name has to be change with dynamic
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    widget?.rtcEngine?.setEventHandler(rtcEngineEventHandler);
    await widget?.rtcEngine?.joinChannel(null, widget.channelName, null, 0);
    await platform.invokeMethod(
        parameters.startOnGoingNS, {parameters.mode: parameters.start});
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    await widget.rtcEngine.enableWebSdkInteroperability(true);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = VideoDimensions(width: 1920, height: 1080);
    await widget?.rtcEngine?.setVideoEncoderConfiguration(configuration);
    await widget?.rtcEngine?.enableVideo();
    await widget?.rtcEngine?.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await widget?.rtcEngine?.setClientRole(widget.role);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    var user_id;
    rtcEngineEventHandler.error = (dynamic code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    };

    rtcEngineEventHandler.joinChannelSuccess = (
      String channel,
      int uid,
      int elapsed,
    ) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);
      });
    };

    rtcEngineEventHandler.leaveChannel = (RtcStats rtcStats) {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
        //FlutterToast().getToast('Call Ended', Colors.red);
      });
    };

    rtcEngineEventHandler.userJoined = (int uid, int elapsed) {
      setState(() {
        user_id = uid;
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
      });
    };

    rtcEngineEventHandler.remoteAudioStateChanged = (int uid,
        AudioRemoteState audioRemoteState,
        AudioRemoteStateReason audioRemoteStateReason,
        int) {
      setState(() {
        //get the remote user mute status
      });
    };

    // AgoraRtcEngine.onUserOffline = (int uid, int reason) {
    //   setState(() {
    //     final info = 'userOffline: $uid';
    //     _infoStrings.add(info);
    //     _users.remove(uid);
    //     if (Platform.isIOS) {
    //       Navigator.pop(context);
    //     } else {
    //       if (widget.isAppExists) {
    //         Navigator.pop(context);
    //       } else {
    //         Navigator.of(context).pushNamedAndRemoveUntil(
    //             '/splashscreen', (Route<dynamic> route) => false);
    //       }
    //     }
    //   });
    // };

    rtcEngineEventHandler.userOffline = (int uid, UserOfflineReason reason) {
      setState(() {
        if (reason == UserOfflineReason.Dropped) {
          noResponseDialog(context, 'Disconnected due to Network Failure!');
          //print('user is OFFLINE');
        } else {
          if (Platform.isIOS) {
            PageNavigator.goToPermanent(context, router.rt_Landing);
          } else {
            if (widget.isAppExists) {
              PageNavigator.goToPermanent(context, router.rt_Landing);
            } else {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/splashscreen', (Route<dynamic> route) => false);
            }
          }
        }
      });
    };

    rtcEngineEventHandler.remoteVideoStateChanged = (
      int uid,
      VideoRemoteState videoRemoteState,
      VideoRemoteStateReason videoRemoteStateReason,
      // int width,
      // int height,
      int elapsed,
    ) {
      setState(() {
        // final info = 'firstRemoteVideo: $uid ${videoRemoteState.width}x $height';
        // _infoStrings.add(info);
      });
    };

    rtcEngineEventHandler.localVideoStateChanged =
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

    rtcEngineEventHandler.remoteVideoStateChanged =
        (uid, state, reason, elapsed) {
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

      if (reason == VideoRemoteStateReason.Internal) {
        //FlutterToast().getToast('Remote User Went to OFFLINE', Colors.yellow);
      } else if (reason == VideoRemoteStateReason.RemoteUnmuted) {
        FlutterToast().getToast('Doctor Video is resumed', Colors.green);
        videoPauseResumeState = 1;
      } else if (reason == VideoRemoteStateReason.RemoteMuted) {
        FlutterToast().getToast('Doctor Video is paused', Colors.red);
        videoPauseResumeState = 2;
      } else {
        videoPauseResumeState = 0;
      }
    };

    rtcEngineEventHandler.localAudioStateChanged = (state, error) {
      if (state == AudioLocalState.Recording) {
        //FlutterToast().getToast('Your on UnMute', Colors.red);
      } else {
        //FlutterToast().getToast('Your on Mute', Colors.green);
      }
    };

    rtcEngineEventHandler.remoteAudioStateChanged =
        (uid, state, reason, elapsed) {
      switch (reason) {
        case AudioRemoteStateReason.RemoteUnmuted:
          FlutterToast().getToast('Doctor is on UnMute', Colors.green);
          break;
        case AudioRemoteStateReason.RemoteMuted:
          FlutterToast().getToast('Doctor is on Mute', Colors.red);
          break;
        default:
          break;
      }
      //uid is ID of the user whose audio state changes.
      /* if (reason == 1) {
        //print('REMOTE_AUDIO_REASON_NETWORK_CONGESTION- Network congestion.');
      } else if (reason == 3) {
        FlutterToast().getToast('Your on Mute', Colors.red);
        // print(
        //     'REMOTE_AUDIO_REASON_LOCAL_MUTED- The local user stops receiving the remote audio stream or disables the audio module.');
      } else if (reason == 4) {
        FlutterToast().getToast('Your on UnMute', Colors.red);
        // print(
        //     'REMOTE_AUDIO_REASON_LOCAL_UNMUTED- The local user resumes receiving the remote audio stream or enables the audio module.');
      } else if (reason == 5) {
        //FlutterToast().getToast('Doctor is on Mute', Colors.red);
        FlutterToast().getToast('Your on Mute', Colors.red);

        // print(
        //     'REMOTE_AUDIO_REASON_REMOTE_MUTED- The remote user stops sending the audio stream or disables the audio module.');
      } else if (reason == 6) {
        //FlutterToast().getToast('Doctor is on UnMute', Colors.red);
        FlutterToast().getToast('Your on UnMute', Colors.red);
        // print(
        //     'REMOTE_AUDIO_REASON_REMOTE_UNMUTED- The remote user resumes sending the audio stream or enables the audio module.');
      } else if (reason == 7) {
        print(
            'REMOTE_AUDIO_REASON_REMOTE_OFFLINE- The remote user leaves the channel.');
      } */
    };

    rtcEngineEventHandler.networkTypeChanged = (networkType) {
      if (networkType == NetworkType.LAN) {
        print('network type is LAN');
      } else if (networkType == NetworkType.WIFI) {
        print('network type is WIFI');
      } else if (networkType == NetworkType.Mobile2G) {
        print('network type is Mobile2G');
      } else if (networkType == NetworkType.Mobile3G) {
        print('network type is Mobile3G');
      } else if (networkType == NetworkType.Disconnected) {
        print('network type is Disconnected');
      } else {
        print('network type is Unknown');
      }
    };

    if (user_id != null && user_id != '') {
      widget.rtcEngine.getUserInfoByUid(user_id).then((value) {
        //print('connected user info ${value?.userAccount}');
      });
    }

    rtcEngineEventHandler.rejoinChannelSuccess = (channel, uid, elapsedTime) {
      print('After rejoining channel successfully');
      //print('channel $channel &uid $uid &elapsedTime $elapsedTime');
    };

    //Local user call status
    rtcEngineEventHandler.connectionStateChanged = (nwState, reason) {
      if (nwState == ConnectionStateType.Disconnected) {
        FlutterToast().getToast('Disconnected', Colors.red);
        //print('call was disconnected');
      } else if (nwState == ConnectionStateType.Connecting) {
        FlutterToast().getToast('Connecting..', Colors.green);
        //print('call is connecting');
      } else if (nwState == ConnectionStateType.Connected) {
        FlutterToast().getToast('Connected', Colors.green);
      } else if (nwState == ConnectionStateType.Reconnecting) {
        FlutterToast().getToast('Trying to Reconnect..', Colors.red);
        //print('call is reconnecting');
      } else if (nwState == ConnectionStateType.Failed) {
        FlutterToast().getToast('Connection Failed', Colors.red);
        //print('call is connection failed');
      }
    };

    rtcEngineEventHandler.networkQuality = (uid, tx, rx) {
      //uplink quality speed of local network state
      if (tx == NetworkQuality.Excellent) {
        print('The quality is excellent QUALITY_EXCELLENT');
      } else if (tx == NetworkQuality.Good) {
        print(
            'The quality is quite good, but the bitrate may be slightly lower than excellent. QUALITY_GOOD');
      } else if (tx == NetworkQuality.Poor) {
        print(
            'Users can feel the communication slightly impaired. QUALITY_POOR');
      } else if (tx == NetworkQuality.Bad) {
        // FlutterToast().getToast(
        //     'Poor Network. Please check you Internet connection', Colors.red);
        //print('Users can communicate not very smoothly. QUALITY_BAD');
      } else if (tx == NetworkQuality.VBad) {
        // FlutterToast().getToast(
        //     'Poor Network. Please check you Internet connection', Colors.red);
        // print(
        //     'The quality is so bad that users can barely communicate. QUALITY_VBAD');
      } else if (tx == NetworkQuality.Down) {
        // FlutterToast()
        //     .getToast('Disconnected due to Network Failure!', Colors.red);

        // print(
        //     'The network is disconnected and users cannot communicate at all. QUALITY_DOWN');
      } else if (tx == NetworkQuality.Detecting) {
        print('The SDK is detecting the network quality. QUALITY_DETECTING');
      } else if (tx == NetworkQuality.Unknown) {
        print('The quality is unknown. QUALITY_UNKNOWN');
      }

      //downlink quality speed of local network state
      if (rx == NetworkQuality.Excellent) {
        print('The quality is excellent QUALITY_EXCELLENT');
      } else if (rx == NetworkQuality.Good) {
        print(
            'The quality is quite good, but the bitrate may be slightly lower than excellent. QUALITY_GOOD');
      } else if (rx == NetworkQuality.Poor) {
        print(
            'Users can feel the communication slightly impaired. QUALITY_POOR');
      } else if (tx == NetworkQuality.Bad) {
        // FlutterToast().getToast(
        //     'Poor Network. Please check you Internet connection', Colors.red);
        //print('Users can communicate not very smoothly. QUALITY_BAD');
      } else if (tx == NetworkQuality.VBad) {
        // FlutterToast().getToast(
        //     'Poor Network. Please check you Internet connection', Colors.red);
        // print(
        //     'The quality is so bad that users can barely communicate. QUALITY_VBAD');
      } else if (tx == NetworkQuality.Down) {
        // FlutterToast()
        //     .getToast('Disconnected due to Network Failure!', Colors.red);

        // print(
        //     'The network is disconnected and users cannot communicate at all. QUALITY_DOWN');
      } else if (rx == NetworkQuality.Detecting) {
        print('The SDK is detecting the network quality. QUALITY_DETECTING');
      } else if (rx == NetworkQuality.Unknown) {
        print('The quality is unknown. QUALITY_UNKNOWN');
      }
    };

    rtcEngineEventHandler.remoteVideoStats = (stats) {
      if (videoPauseResumeState != 0) {
        // dont show try to reconnect view
      } else {
        if (stats.receivedBitrate == 0 && !isCustomViewShown) {
          isCustomViewShown = true;
          setState(() {});
        } else if (stats.receivedBitrate > 100 && isCustomViewShown) {
          isCustomViewShown = false;
          setState(() {});
        } else {
          //do nothing
        }
      }
    };
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final list = <Widget>[];
    if (widget.role == ClientRole.Broadcaster) {
      // list.add(
      //   RtcLocalView.SurfaceView(),
      // );
    }
    _users.forEach(
      (int uid) => list.add(
        RtcRemoteView.SurfaceView(
          uid: uid,
        ),
      ),
    );
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
        /* Container(
            decoration: BoxDecoration(
              //color: Color(CommonUtil.primaryColor).withOpacity(0.3),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            height: 125.0.h,
            width: 125.0.w,
            margin: EdgeInsets.symmetric(vertical: 120, horizontal: 10),
            child: attendees[0]), */
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
                          style: TextStyle(
                            color: Color(new CommonUtil().getMyPrimaryColor()),
                            fontSize: 16.0.sp,
                          ),
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
    return isCustomViewShown ? tryingToConnect() : _viewRows();
  }

  noResponseDialog(BuildContext mContext, String message) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 16.0.sp,
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  // if (Platform.isIOS) {
                  //   Navigator.pop(mContext);
                  // } else {
                  //   if (widget.isAppExists) {
                  //     Navigator.pop(mContext);
                  //   } else {
                  //     Navigator.of(mContext).pushNamedAndRemoveUntil(
                  //         '/splashscreen', (Route<dynamic> route) => false);
                  //   }
                  // }

                  if (Platform.isIOS) {
                    PageNavigator.goToPermanent(context, router.rt_Landing);
                  } else {
                    if (widget.isAppExists) {
                      PageNavigator.goToPermanent(context, router.rt_Landing);
                    } else {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/splashscreen', (Route<dynamic> route) => false);
                    }
                  }
                },
                child: Text('Ok',
                    style: TextStyle(
                      color: Color(CommonUtil().getMyPrimaryColor()),
                      fontSize: 18.0.sp,
                    )),
              ),
            ],
          );
        });
  }

  Widget tryingToConnect() {
    return Container(
      color: Colors.black.withOpacity(0.3),
      width: 1.sw,
      height: 1.sh,
      child: Center(
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 30.0.h,
              width: 30.0.h,
              child: CommonCircularIndicator(),
            ),
            SizedBox(
              height: 10.0.h,
            ),
            Text(
              'Trying to Reconnect..',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
