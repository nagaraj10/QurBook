import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/authentication/view/login_screen.dart';
import 'package:get/get.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/src/model/home_screen_arguments.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/TelehealthProviders.dart';

import '../utils/PageNavigator.dart';

class SplashScreen extends StatefulWidget {
  final String nsRoute;
  final String bookingID;
  final String doctorID;

  SplashScreen({this.nsRoute,this.bookingID,this.doctorID});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    PreferenceUtil.init();
    Future.delayed(const Duration(seconds: 3), () {
      var isFirstTime = PreferenceUtil.isKeyValid(Constants.KEY_INTRO_SLIDER);

      var deviceIfo = PreferenceUtil.isKeyValid(Constants.KEY_DEVICEINFO);
      if (!isFirstTime) {
        PreferenceUtil.saveString(Constants.KEY_INTRO_SLIDER, variable.strtrue);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => PatientSignInScreen()),
            (route) => false);

        // PageNavigator.goToPermanent(context, router.rt_WebCognito);
      } else {
        String authToken =
            PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN);
        if (authToken != null) {
          if (deviceIfo) {
            if (widget.nsRoute == 'reschedule') {
              Get.offAll(TelehealthProviders(
                arguments: HomeScreenArguments(selectedIndex: 1),
              ));
            } else if (widget.nsRoute == 'cancel_appointment') {
              //cancel appointments route
              Get.offAll(TelehealthProviders(
                arguments: HomeScreenArguments(
                    selectedIndex: 0, isCancelDialogShouldShow: true,bookingId: widget.bookingID),
              ));
            } else {
              PageNavigator.goToPermanent(context, router.rt_Dashboard);
            }
          } else {
            FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

            _firebaseMessaging.getToken().then((token) {
              new CommonUtil()
                  .sendDeviceToken(
                      PreferenceUtil.getStringValue(Constants.KEY_USERID),
                      PreferenceUtil.getStringValue(Constants.KEY_EMAIL),
                      PreferenceUtil.getStringValue(Constants.MOB_NUM),
                      token,
                      true)
                  .then((value) {
                PageNavigator.goToPermanent(context, router.rt_Dashboard);
              });
            });
          }
        } else {
          //PageNavigator.goToPermanent(context, router.rt_WebCognito);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PatientSignInScreen()));
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
