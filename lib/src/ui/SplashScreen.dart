import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/src/utils/PageNavigator.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/constants/router_variable.dart' as router;

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
        PreferenceUtil.saveString(Constants.KEY_INTRO_SLIDER, variable.strtrue);
        PageNavigator.goToPermanent(context, router.rt_WebCognito);
      } else {
        String authToken =
            PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
        if (authToken != null) {
          PageNavigator.goToPermanent(context, router.rt_Dashboard);
        } else {
          PageNavigator.goToPermanent(context, router.rt_WebCognito);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Image.asset(
        variable.icon_fhb,
        height: 150,
        width: 150,
      )),
    );
  }
}
