import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';

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
            Color(new CommonUtil().getMyPrimaryColor()),
            Color(new CommonUtil().getMyGredientColor())
          ],
              stops: [
            0.3,
            1.0
          ])),
    );
  }
}
