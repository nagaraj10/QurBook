
import 'package:flutter/material.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class BadgeIcon extends StatelessWidget {
  BadgeIcon(
      {this.icon,
      this.badgeCount = 0,
      this.showIfZero = false,
      this.isForSheelaQueue = false,
      this.badgeColor = Colors.red,
      this.size = 15,
      this.fontSize = 12,
      TextStyle? badgeTextStyle})
      : this.badgeTextStyle = badgeTextStyle ??
            TextStyle(
              color: Colors.white,
              fontSize: 10.0.sp,
            );
  final Widget? icon;
  final int? badgeCount;
  final bool showIfZero;
  final bool isForSheelaQueue;
  final Color badgeColor;
  double size;
  double fontSize;
  final TextStyle badgeTextStyle;

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      icon!,
      if (badgeCount! > 0 || showIfZero) badge(badgeCount),
    ]);
  }

  Widget badge(int? count) => Positioned(
        right: 0,
        top: 0,
        child: Container(
            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(9.5),
            ),
            constraints: BoxConstraints(
              minWidth: size.h,
              minHeight: size.h,
            ),
            child: getText(isForSheelaQueue, count)),
      );

  getText(bool isForSheelaQueueBadge, int? count) {
    return isForSheelaQueueBadge
        ? Text(
            count! > 9 ? '9+' : count.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize.sp,
            ),
            textAlign: TextAlign.center,
          )
        : Text(
            count.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize.sp,
            ),
            textAlign: TextAlign.center,
          );
  }
}
