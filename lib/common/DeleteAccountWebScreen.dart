import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/authentication/view/login_screen.dart';
import 'package:myfhb/common/CommonUtil.dart';
import '../../../constants/fhb_constants.dart' as Constants;
import 'PreferenceUtil.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DeleteAccountWebScreen extends StatefulWidget {
  const DeleteAccountWebScreen({Key? key}) : super(key: key);

  @override
  State<DeleteAccountWebScreen> createState() => _DeleteAccountWebScreenState();
}

class _DeleteAccountWebScreenState extends State<DeleteAccountWebScreen> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Account'),
      ),
      body: Container(
        child: WebView(
          javascriptChannels: <JavascriptChannel>{
            _toasterJavascriptChannel(context),
          },
          initialUrl: CommonUtil.WEB_URL,
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'flutterInAppWebViewPlatformReady',
        onMessageReceived: (JavascriptMessage message) {
          var json = jsonDecode(message.message);
          FlutterToast().getToast(json["message"], Colors.red);
          if (json["isSuccess"]) {
            CommonUtil().logout(moveToLoginPage);
          } else {
            Get.back();
          }
        });
  }

  void moveToLoginPage() {
    PreferenceUtil.clearAllData().then(
          (value) {
        Navigator.pushAndRemoveUntil(
          Get.context!,
          MaterialPageRoute(
            builder: (context) => PatientSignInScreen(),
          ),
              (route) => false,
        );
      },
    );
  }

}
