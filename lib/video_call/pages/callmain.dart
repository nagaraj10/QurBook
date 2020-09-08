import 'dart:async';
import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/src/model/home_screen_arguments.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/TelehealthProviders.dart';
import 'package:myfhb/video_call/model/CallArguments.dart';
import 'package:myfhb/video_call/pages/call.dart';
import 'package:myfhb/video_call/pages/controllers.dart';
import 'package:myfhb/video_call/pages/customappbar.dart';
import 'package:myfhb/video_call/utils/callstatus.dart';
import 'package:myfhb/video_call/utils/hideprovider.dart';
import 'package:provider/provider.dart';

class CallMain extends StatelessWidget {
  BuildContext globalContext;

  /// non-modifiable channel name of the page
  String channelName;

  String doctorName;
  String doctorId;
  String doctorPic;

  /// non-modifiable client role of the page
  ClientRole role;
  CallArguments arguments;

  ///check call is made from NS
  bool isAppExists;
  bool _isFirstTime = true;
  bool _isMute = false;
  bool _isVideoHide = false;
  CallMain(
      {this.channelName,
      this.role,
      this.arguments,
      this.isAppExists,
      this.doctorName,
      this.doctorId,
      this.doctorPic});

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
                role: role,
                channelName: channelName,
                arguments: arguments,
                isAppExists: isAppExists,
              ),
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
              CustomAppBar(Platform.isIOS ? arguments.userName : doctorName),
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
                            MyControllers(callStatus, role, isAppExists,
                                Platform.isIOS ? arguments.doctorId : doctorId,
                                (isMute, isVideoHide) {
                              _isMute = isMute;
                              _isVideoHide = isVideoHide;
                            }, _isMute, _isVideoHide, doctorName, doctorPic),
                            SizedBox(
                              height: 48,
                            ),
                          ],
                        )),
                  );
                },
              ),
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
                    parameters.exit_call,
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
                        child: Text(parameters.Yes),
                        onPressed: () {
                          if (Platform.isIOS) {
                            Navigator.of(context);
                          } else {
                            Get.offAll(TelehealthProviders(
                              arguments: HomeScreenArguments(selectedIndex: 0),
                            ));
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
