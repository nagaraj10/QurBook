import 'package:flutter/material.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/common/CommonUtil.dart';

class RegimentDataCard extends StatelessWidget {
  final String title;
  final String time;
  final Color color;
  final IconData icon;
  final bool needCheckbox;

  const RegimentDataCard({
    this.title,
    this.time,
    this.color,
    this.icon,
    this.needCheckbox: false,
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
                color: color,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //TODO: Change Icon to Image when data is from API
                    Icon(
                      icon,
                      color: Colors.white,
                      size: 24.0.sp,
                    ),
                    Text(
                      //TODO: Replace with actual time
                      time,
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
                padding: EdgeInsets.symmetric(
                  vertical: 5.0.h,
                  horizontal: 20.0.w,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${title}',
                            style: TextStyle(
                              fontSize: 16.0.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 5.0.h,
                          ),
                          Container(
                            height: 58.0.h,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              //TODO: Replace with actual count from API
                              itemCount: 4,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: EdgeInsets.all(5.0.sp),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        //TODO: Replace with actual value from API
                                        needCheckbox ? 'Medicine' : 'Sys',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                          fontSize: 14.0.sp,
                                        ),
                                        maxLines: 2,
                                        softWrap: true,
                                      ),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Text(
                                              //TODO: Replace with actual value from API
                                              '${index * 35}',
                                              style: TextStyle(
                                                color: color,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16.0.sp,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10.0.w,
                                            ),
                                            Visibility(
                                              visible: needCheckbox ?? false,
                                              child: Container(
                                                width: 10.0.w,
                                                child: Checkbox(
                                                  //TODO: Replace with actual value from API
                                                  value: true,
                                                  checkColor: Colors.white,
                                                  activeColor: Colors.black,
                                                  onChanged: (val) {},
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 10.0.h,
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.edit,
                            size: 24.0.sp,
                          ),
                          Spacer(),
                          Icon(
                            Icons.play_circle_fill_rounded,
                            size: 30.0.sp,
                            color: color,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 3.0.w,
              child: Container(
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
