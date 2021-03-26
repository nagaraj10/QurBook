import 'package:flutter/material.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/common/CommonUtil.dart';

class RegimentDataCard extends StatelessWidget {
  final title;

  const RegimentDataCard({
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 10.0.w,
        right: 10.0.w,
        top: 10.0.h,
      ),
      child: Container(
        height: 100.0.h,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                color: Color(CommonUtil().getMyPrimaryColor()),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //TODO: Change Icon to Image when data is from API
                    Icon(
                      Icons.directions_walk_rounded,
                      color: Colors.white,
                      size: 24.0.sp,
                    ),
                    Text(
                      //TODO: Replace with actual time
                      '06:00 AM',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0.sp,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Text('${title}'),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 3.0.w,
              child: Container(
                color: Color(CommonUtil().getMyPrimaryColor()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
