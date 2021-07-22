import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class PageNumberWidget extends StatelessWidget {
  const PageNumberWidget({
    this.isSelected = false,
    this.isLastItem = false,
    this.pageNumber,
    this.pageName,
  });

  final bool isSelected;
  final bool isLastItem;
  final String pageNumber;
  final String pageName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
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
            if (!isLastItem)
              Container(
                width: 40.0.w,
                height: 1.0.h,
                color: Color(CommonUtil().getMyPrimaryColor()),
                margin: EdgeInsets.symmetric(
                  horizontal: 5.0.w,
                ),
              ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 70.0.sp,
              child: Text(
                pageName ?? '',
                style: TextStyle(
                  fontSize: 12.0.sp,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? Color(CommonUtil().getMyPrimaryColor())
                      : Colors.black,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (!isLastItem)
              SizedBox(
                width: 50.0.w,
              ),
          ],
        ),
      ],
    );
  }
}
