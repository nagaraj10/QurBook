import 'package:flutter/material.dart';
import '../../constants/variable_constant.dart';
import '../../main.dart';
import '../../src/utils/screenutils/size_extensions.dart';
import '../CommonUtil.dart';

class UnreadMessagesIcon extends StatelessWidget {
  UnreadMessagesIcon({
    Key? key,
    required double this.size,
  }) : super(key: key);
  final double size;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.h,
      width: size.w,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: mAppThemeProvider.primaryColor,
          width: 5.w,
        ),
      ),
      child: Image.asset(
        icon_unread_chat,
        height: 30.h,
        width: 30.w,
        color: mAppThemeProvider.primaryColor,
      ),
    );
  }
}
