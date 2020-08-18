import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfhb/src/ui/Dashboard.dart';
import 'package:myfhb/video_call/model/CallArguments.dart';
import 'package:myfhb/video_call/pages/call.dart';
import 'package:myfhb/video_call/pages/controllers.dart';
import 'package:myfhb/video_call/pages/customappbar.dart';
import 'package:myfhb/video_call/utils/callstatus.dart';
import 'package:provider/provider.dart';

class CallMain extends StatelessWidget {
  BuildContext globalContext;

  /// non-modifiable channel name of the page
  String channelName;

  /// non-modifiable client role of the page
  ClientRole role;
  CallArguments arguments;

  ///check call is made from NS
  bool isAppExists;

  CallMain({this.channelName, this.role, this.arguments, this.isAppExists});

  @override
  Widget build(BuildContext context) {
    ///update call status through provider
    globalContext = context;
    final callStatus = Provider.of<CallStatus>(context, listen: false);
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
              CustomAppBar(),
              MyControllers(callStatus, role, isAppExists),
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
                          if (Platform.isIOS) {
                            Navigator.of(context);
                          } else {
                            isAppExists
                                ? Navigator.of(context).pop(true)
                                : Get.offAll(DashboardScreen());
                          }
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
