import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/asset_image.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/src/ui/Dashboard.dart';
import 'package:myfhb/src/ui/authentication/WebCognitoScreen.dart';

class CognitoSplash extends StatefulWidget {
  final Color backgroundColor = Colors.white;
  final TextStyle styleTextUnderTheLoader = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  _CognitoSplashState createState() => _CognitoSplashState();
}

class _CognitoSplashState extends State<CognitoSplash> {
  final splashDelay = 5;
  String auth_token;
  @override
  void initState() {
    super.initState();
    restore();
    _loadWidget();
  }

  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    if (auth_token == null) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => WebCognitoScreen()));
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => DashboardScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 7,
                  child: Container(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      AssetImageWidget(
                        icon: 'assets/launcher/myfhb.png',
                        height: 200,
                        width: 200,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                      ),
                    ],
                  )),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      CircularProgressIndicator(
                        backgroundColor: Color(0xff138fcf),
                      ),
                      Container(
                        height: 10,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Spacer(),
                            Text('myFHB'),
                            Spacer(),
                          ])
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  restore() async {
    setState(() {
      auth_token = PreferenceUtil.getStringValue('drauth_token');
      //TODO: More restoring of settings would go here...
    });
  }
}
