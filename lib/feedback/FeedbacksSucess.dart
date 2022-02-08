import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../common/CommonUtil.dart';
import '../common/PreferenceUtil.dart';
import '../src/utils/PageNavigator.dart';
import '../constants/variable_constant.dart' as variable;
import '../src/utils/screenutils/size_extensions.dart';

class FeedbackSuccess extends StatefulWidget {
  @override
  _FeedbackSuccessState createState() => _FeedbackSuccessState();
}

class _FeedbackSuccessState extends State<FeedbackSuccess> {
  @override
  void initState() {
    super.initState();
    PreferenceUtil.init();
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
                child: AvatarGlow(
              startDelay: Duration(milliseconds: 1000),
              glowColor: Color(CommonUtil().getMyPrimaryColor()),
              endRadius: 80,
              duration: Duration(milliseconds: 1000),
              repeatPauseDuration: Duration(milliseconds: 10),
              child: Material(
                color: Colors.white,
                shadowColor: Colors.transparent,
                shape: CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 40,
                  child: Icon(
                    Icons.check,
                    size: 60.0.sp,
                    color: Color(CommonUtil().getMyPrimaryColor()),
                  ),
                ),
              ),
            )),
            SizedBox(height: 20.0.h),
            Text(
              variable.strSucess,
              style: TextStyle(
                  fontSize: 30.0.sp,
                  color: Color(CommonUtil().getMyPrimaryColor())),
            ),
            Text(
              variable.strFeedThank,
              style: TextStyle(
                  fontSize: 18.0.sp,
                  color:
                      Color(CommonUtil().getMyPrimaryColor()).withOpacity(0.8)),
            ),
          ],
        ));
  }
}
