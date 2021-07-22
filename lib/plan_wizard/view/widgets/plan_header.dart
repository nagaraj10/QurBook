import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class PlanHeader extends StatelessWidget {
  const PlanHeader({
    @required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      padding: EdgeInsets.only(
        left: 10.0.w,
        right: 10.0.w,
        top: 5.0.h,
        bottom: 5.0.h,
      ),
      color: Color(CommonUtil().getMyPrimaryColor()),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.0.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
