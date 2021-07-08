import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class PlanHeader extends StatelessWidget {
  const PlanHeader({
    @required this.title,
    this.titleColor,
  });

  final String title;
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      color: titleColor ?? Color(CommonUtil().getMyPrimaryColor()),
      padding: EdgeInsets.symmetric(
        horizontal: 10.0.w,
        vertical: 10.0.h,
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.0.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
