import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class PageNumberWidget extends StatelessWidget {
  const PageNumberWidget({
    this.isSelected = false,
    this.pageNumber,
  });

  final bool isSelected;
  final String pageNumber;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.all(
            10.0.sp,
          ),
          height: 50.0.sp,
          width: 50.0.sp,
          // or ClipRRect if you need to clip the content
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(CommonUtil().getMyPrimaryColor()),
            ),
            shape: BoxShape.circle,
            color: isSelected
                ? Color(CommonUtil().getMyPrimaryColor())
                : Colors.white, // inner circle color
          ),
          child: Center(
            child: Text(
              pageNumber,
              style: TextStyle(
                fontSize: 20.0.sp,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ), // inner content
        ),
        Container(
          width: 40.0.w,
          height: 1.0.h,
          color: Color(CommonUtil().getMyPrimaryColor()),
          margin: EdgeInsets.symmetric(
            horizontal: 5.0.w,
          ),
        ),
      ],
    );
  }
}
