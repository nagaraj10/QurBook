import 'package:flutter/material.dart';
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
        top: 10.0.h,
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 14.0.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
