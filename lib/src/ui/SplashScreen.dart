import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/src/utils/PageNavigator.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    PreferenceUtil.init();
    Future.delayed(const Duration(seconds: 2), () {
      String authToken = PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
      print('auth token : $authToken');
      //PageNavigator.goToPermanent(context, '/sign_in_screen');
      if (authToken != null) {
        PageNavigator.goToPermanent(context, '/dashboard_screen');
        //PageNavigator.goToPermanent(context, '/review_page');
      } else {
        PageNavigator.goToPermanent(context, '/sign_in_screen');
      }
      //setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Image.asset(
        'assets/launcher/myfhb.png',
        height: 150,
        width: 150,
      )),
    );
  }
}
