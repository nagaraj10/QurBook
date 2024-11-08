import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';

import '../../main.dart';

class GradientAppBarQurhome extends StatefulWidget {
  @override
  _GradientAppBarState createState() => _GradientAppBarState();
}

class _GradientAppBarState extends State<GradientAppBarQurhome> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: <Color>[
            mAppThemeProvider.qurHomePrimaryColor,
            mAppThemeProvider.qurhomeGradientColor
          ],
          stops: [0.3, 1.0],
        ),
      ),
    );
  }
}
