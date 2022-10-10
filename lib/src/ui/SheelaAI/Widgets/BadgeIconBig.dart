import 'package:flutter/material.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class BadgeIconBig extends StatelessWidget {
  BadgeIconBig(
      {this.icon,
        this.badgeCount = 0,
        this.showIfZero = false,
        this.badgeColor = Colors.red,
        TextStyle badgeTextStyle})
      : this.badgeTextStyle = badgeTextStyle ??
      TextStyle(
        color: Colors.white,
        fontSize: 10.0.sp,
      );
  final Widget icon;
  final int badgeCount;
  final bool showIfZero;
  final Color badgeColor;
  final TextStyle badgeTextStyle;

  @override
  Widget build(BuildContext context) {
    return new Stack(children: <Widget>[
      icon,
      if (badgeCount > 0 || showIfZero) badge(badgeCount),
    ]);
  }

  Widget badge(int count) => Positioned(
    right: 0,
    top: 0,
    child: new Container(
      padding: EdgeInsets.all(0),
      decoration: new BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(14),
      ),
      constraints: BoxConstraints(
        minWidth: 34.0.w,
        minHeight: 28.0.h,
      ),
      child: Text(
        count.toString(),
        style: new TextStyle(
          color: Colors.white,
          fontSize: 22.0.sp,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );
}
