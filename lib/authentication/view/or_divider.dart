import 'package:flutter/material.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/authentication/constants/constants.dart';

class OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 5.0.h),
        Row(
          children: [
            Expanded(
              child: Divider(
                thickness: 2.0.h,
                indent: 5.0.w,
                endIndent: 5.0.w,
              ),
            ),
            Text(
              strOrText,
              style: TextStyle(
                fontSize: 15.0.sp,
                color: Colors.black,
              ),
            ),
            Expanded(
              child: Divider(
                thickness: 2.0.h,
                indent: 5.0.w,
                endIndent: 5.0.w,
              ),
            ),
          ],
        ),
        SizedBox(height: 5.0.h),
      ],
    );
  }
}
