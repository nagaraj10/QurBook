import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';

import '../main.dart';

class GradientAppBar extends StatefulWidget {
  @override
  _GradientAppBarState createState() => _GradientAppBarState();
}

class _GradientAppBarState extends State<GradientAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[
            mAppThemeProvider.primaryColor,
            Color(CommonUtil().getMyGredientColor())
          ],
              stops: [
            0.3,
            1.0
          ])),
    );
  }
}
