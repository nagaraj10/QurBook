import 'package:flutter/material.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class BadgeIconBig extends StatelessWidget {
  BadgeIconBig({
    this.icon,
    this.badgeCount = 0,
    this.showIfZero = false,
    this.badgeColor = Colors.red,
    this.badgeTextStyle,
    this.badgeTextSize,
    this.right,
    this.top,
    this.boxConstraints,
  });

  final Widget? icon;
  final int badgeCount;
  final bool showIfZero;
  final Color badgeColor;
  final double? right;
  final double? top;
  final TextStyle? badgeTextStyle;
  final double? badgeTextSize;
  final BoxConstraints? boxConstraints;

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      icon!,
      if (badgeCount > 0 || showIfZero)
        Positioned(
          right: right ?? 37,
          top: top ?? 37,
          child: Container(
            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(20),
            ),
            constraints:boxConstraints?? BoxConstraints(
              minWidth: 42.0.w,
              minHeight: 38.0.h,
            ),
            child: Center(
              child: Text(
                badgeCount.toString(),
                style: badgeTextStyle ??
                    TextStyle(
                        color: Colors.white,
                        fontSize: badgeTextSize??20.0.sp,
                        fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
    ]);
  }
}
