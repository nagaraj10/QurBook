import 'dart:async';
import 'dart:io';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/src/model/home_screen_arguments.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/TelehealthProviders.dart';
import 'package:myfhb/video_call/model/CallArguments.dart';
import 'package:myfhb/video_call/pages/call.dart';
import 'package:myfhb/video_call/pages/controllers.dart';
import 'package:myfhb/video_call/pages/customappbar.dart';
import 'package:myfhb/video_call/pages/localpreview.dart';
import 'package:myfhb/video_call/pages/prescription_module.dart';
import 'package:myfhb/video_call/utils/callstatus.dart';
import 'package:myfhb/video_call/utils/hideprovider.dart';
import 'package:myfhb/video_call/utils/settings.dart';
import 'package:provider/provider.dart';

class CallMain extends StatefulWidget {
  /// non-modifiable channel name of the page
  String channelName;

  String doctorName;
  String doctorId;
  String doctorPic;

  String patientId;
  String patientName;
  String patientPicUrl;

  /// non-modifiable client role of the page
  ClientRole role;
  CallArguments arguments;

  ///check call is made from NS
  bool isAppExists;

  CallMain(
      {this.channelName,
      this.role,
      this.arguments,
      this.isAppExists,
      this.doctorName,
      this.doctorId,
      this.doctorPic,
      this.patientId,
      this.patientName,
      this.patientPicUrl});

  @override
  _CallMainState createState() => _CallMainState();
}

class _CallMainState extends State<CallMain> {
  BuildContext globalContext;

  RtcEngine rtcEngine;

  bool _isFirstTime = true;

  bool _isMute = false;

  bool _isVideoHide = false;

  @override
  void initState() {
    super.initState();
    createRtcEngine();
  }

  createRtcEngine() async {
    rtcEngine = await RtcEngine.create(APP_ID);
  }

  @override
  void dispose() {
    rtcEngine.leaveChannel();
    rtcEngine.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///update call status through provider
    globalContext = context;
    final callStatus = Provider.of<CallStatus>(context, listen: false);
    final hideStatus = Provider.of<HideProvider>(context, listen: false);

    /// hide controller after 5 secs
    if (_isFirstTime) {
      _isFirstTime = false;
      Future.delayed(Duration(seconds: 10), () {
        hideStatus.hideMe();
      });
    }
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Stack(
            children: <Widget>[
              CallPage(
                rtcEngine: rtcEngine,
                role: widget.role,
                channelName: widget.channelName,
                arguments: widget.arguments,
                isAppExists: widget.isAppExists,
              ),
              /* InkWell(
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
              ), */
              LocalPreview(
                rtcEngine: rtcEngine,
              ),
              CustomAppBar(Platform.isIOS
                  ? widget.arguments.userName
                  : widget.doctorName),
              Consumer<HideProvider>(
                builder: (context, status, child) {
                  return Visibility(
                    visible: status.isControlStatus,
                    child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            MyControllers(
                                rtcEngine,
                                callStatus,
                                widget.role,
                                widget.isAppExists,
                                Platform.isIOS
                                    ? widget.arguments.doctorId
                                    : widget.doctorId, (isMute, isVideoHide) {
                              _isMute = isMute;
                              _isVideoHide = isVideoHide;
                            },
                                _isMute,
                                _isVideoHide,
                                widget.doctorName,
                                widget.doctorPic,
                                widget.patientId,
                                widget.patientName,
                                widget.patientPicUrl),
                            SizedBox(
                              height: 20.0.h,
                            ),
                          ],
                        )),
                  );
                },
              ),
              SizedBoxWidget(
                height: 20.0.h,
              ),
              PrescriptionModule(),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    return userAlert() ?? false;
  }

  Future userAlert() {
    return showDialog(
        context: globalContext,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Center(
              child: Text(
                parameters.warning,
                style: TextStyle(
                    fontSize: 20.0.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.8)),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Text(
                    parameters.exit_call,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20.0.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withOpacity(0.5)),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FlatButton(
                        child: Text(parameters.Yes),
                        onPressed: () {
                          if (Platform.isIOS) {
                            Navigator.of(context);
                          } else {
                            if (widget.isAppExists) {
                              Navigator.of(context).pop(true);
                              Navigator.pop(context);
                            } else {
                              Navigator.of(context).pop(true);
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/splashscreen',
                                  (Route<dynamic> route) => false);
                            }
                          }
                        }),
                    FlatButton(
                        child: Text(parameters.No),
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
