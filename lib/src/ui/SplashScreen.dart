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
      var isFirstTime = PreferenceUtil.isKeyValid(Constants.KEY_INTRO_SLIDER);
      if (!isFirstTime) {
        PreferenceUtil.saveString(Constants.KEY_INTRO_SLIDER, 'true');
        PageNavigator.goToPermanent(context, '/intro_slider');
      } else {
        String authToken =
            PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);

        if (authToken != null) {
          PageNavigator.goToPermanent(context, '/dashboard_screen');
        } else {
          PageNavigator.goToPermanent(context, '/sign_in_screen');
        }
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
