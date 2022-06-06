import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfhb/Qurhome/QurhomeDashboard/Controller/QurhomeRegimenController.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/video_call/utils/audiocall_provider.dart';
import 'package:myfhb/video_call/utils/rtc_engine.dart';
import 'package:myfhb/video_call/widgets/audiocall_screen.dart';
import 'package:provider/provider.dart';
import 'package:screen/screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../../../../constants/fhb_constants.dart' as constants;

class MakeCallPage extends StatefulWidget {
  /// non-modifiable channel name of the page
  final String channelName;

  /// non-modifiable client role of the page
  final ClientRole role;

  final String bookId;
  final String patName;
  final String appointmentId;
  final String call_start_time;
  final bool isFromAppointment;
  final String startedTime;
  final String patId;

  /// Creates a call page with given channel name.
  const MakeCallPage(
      {Key key,
      this.channelName,
      this.role,
      this.bookId,
      this.patName,
      this.appointmentId,
      this.call_start_time,
      this.isFromAppointment,
      this.startedTime,
      this.patId})
      : super(key: key);

  @override
  _MakeCallPageState createState() => _MakeCallPageState();
}

class _MakeCallPageState extends State<MakeCallPage> {
  final _infoStrings = <String>[];
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _internetconnection = false;
  var _connectionStatus = '';
  String doctor_id, mtTitle, specialityName = null;

  String userIdForNotify = '';

  var regController = Get.find<QurhomeRegimenController>();

  SharedPreferences prefs;
  @override
  void dispose() {
    try {
      super.dispose();
      Provider.of<RTCEngineProvider>(Get.context, listen: false)
          .stopRtcEngine();
      Screen.keepOn(false);
      _connectivitySubscription.cancel();
      fbaLog(eveName: 'qurbook_screen_event', eveParams: {
        'eventTime': '${DateTime.now()}',
        'pageName': 'Call Screen',
        'screenSessionTime':
            '${DateTime.now().difference(mInitialTime).inSeconds} secs'
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    try {
      super.initState();
      mInitialTime = DateTime.now();
      Screen.keepOn(true);
      _connectivitySubscription =
          _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    try {
      prefs = await SharedPreferences.getInstance();
      try {
        doctor_id = /*await prefs.getString("doctor_id")*/ "";
        mtTitle = /*await prefs.getString("display_name")*/ "";
        specialityName = /*await prefs.getString("speciality")*/ "";
        userIdForNotify =
            await PreferenceUtil.getStringValue(constants.KEY_USERID);
      } catch (e) {}
      switch (result) {
        case ConnectivityResult.wifi:
          setState(() {
            _internetconnection = true;

            //toast.getToast(wifi_connected, Colors.green);
            Provider.of<RTCEngineProvider>(context, listen: false)
                .isCustomViewShown = false;
          });
          break;
        case ConnectivityResult.mobile:
          setState(() {
            _internetconnection = true;
            //toast.getToast(data_connected, Colors.green);
            Provider.of<RTCEngineProvider>(context, listen: false)
                .isCustomViewShown = false;
          });
          break;
        case ConnectivityResult.none:
          setState(() {
            _internetconnection = false;
            _connectionStatus = no_internet_conn;
            Future.delayed(Duration(seconds: 20), () {
              if (_internetconnection) {
                //do nothing
              } else {
                VideoCallCommonUtils().noResponseDialog(
                  context,
                  'Disconnected due to your Network Drop!',
                  patId: widget.patId,
                  isFromAppointment: widget.isFromAppointment,
                  patName: widget.patName,
                  bookId: widget.bookId,
                  appointmentId: widget.appointmentId,
                );
              }
            });
            Provider.of<RTCEngineProvider>(
              Get.context,
              listen: false,
            ).updateCustomViewShown(true);
            //toast.getToast(no_internet_conn, Colors.red);
          });
          break;
        default:
          setState(() {
            _internetconnection = false;
            _connectionStatus = failed_get_conn;
            //toast.getToast(failed_get_connectivity, Colors.red);
          });
          break;
      }
    } catch (e) {
      print(e);
    }
  }

  // void callApiToUpdateNonAppointment() {
  //   String nonAppointmentUrl = 'call-log/non-appointment-call';
  //   Map<String, dynamic> body = new Map();
  //   final now = DateTime.now();
  //   String endTime =
  //       '${DateFormat('yyyy-MM-dd HH:mm:ss', 'en_US').format(now)}';
  //   String userIdForNotify;
  //   PreferenceUtil prefs = new PreferenceUtil();
  //
  //   try {
  //     prefs.getValueBasedOnKey(struserID).then((value) {
  //       userIdForNotify = value;
  //     });
  //   } catch (e) {}
  //
  //   body['startTime'] = widget.startedTime;
  //   body['endTime'] = endTime;
  //   body['callerUser'] = userIdForNotify;
  //   body['recipientUser'] = widget.patId;
  //
  //   new ApiResponse()
  //       .putNonAppointmentCall(nonAppointmentUrl, body)
  //       .then((value) {
  //     if (value['isSuccess'] != null && value['isSuccess']) {
  //       print('SUCCESSSSSSSSSSSSSSSSSSSSSSSSS NON APPOINTMENT CALL UPDATED');
  //     }
  //   });
  // }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final list = <Widget>[];
    if (widget.role == ClientRole.Broadcaster) {
      list.add(
        RtcLocalView.SurfaceView(),
      );
    }
    Provider.of<RTCEngineProvider>(
      context,
      listen: false,
    ).users.forEach(
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
        /*
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0]), _videoView(views[1])],
        ));
        */
        return customVideoView(views);
      /* case 3:
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
        )); */
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
            borderRadius: BorderRadius.all(
              Radius.circular(
                8.0.sp,
              ),
            ),
          ),
          height: 125.0.h,
          width: 125.0.h,
          margin: EdgeInsets.symmetric(
            vertical: 120.0.h,
            horizontal: 10.0.w,
          ),
          child: attendees[0],
        ), */
      ],
    );
  }

  Widget tryingToConnect() {
    return Container(
      color: Colors.black.withOpacity(0.3),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(CommonUtil().getMyPrimaryColor()),
                ),
                backgroundColor: Colors.white.withOpacity(0.8),
              ),
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

  @override
  Widget build(BuildContext context) {
    return Consumer<RTCEngineProvider>(
      builder: (context, rtcEngineProvider, child) {
        return rtcEngineProvider?.isCustomViewShown
            ? tryingToConnect()
            : Consumer<AudioCallProvider>(builder: (context, status, child) {
                if (status.isAudioCall) {
                  return InkWell(
                    child: AudioCallScreen(
                      patName: regController.onGoingSOSCall.value
                          ? "Emergency Services"
                          : widget.patName,
                    ),
                  );
                } else {
                  return _viewRows();
                }
              });
      },
    );
  }
}
