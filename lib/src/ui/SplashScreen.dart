import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        PageNavigator.goToPermanent(context, '/sign_in_screen');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          Constants.APP_NAME,
          style: TextStyle(color: Colors.black54),
        ),
      ),
    );
  }
}
