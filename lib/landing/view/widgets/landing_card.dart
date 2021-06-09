import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;

class LandingCard extends StatelessWidget {
  const LandingCard({
    @required this.title,
    @required this.icon,
    @required this.color,
    this.lastStatus,
    this.alerts,
    this.onPressed,
  });

  final String title;
  final String icon;
  final Color color;
  final String lastStatus;
  final String alerts;
  final Function onPressed;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.all(10.0.sp),
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              20.0.sp,
            ),
          ),
          elevation: 5.0,
          color: Colors.grey.shade200,
          child: InkWell(
            onTap: onPressed,
            child: Card(
              color: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  20.0.sp,
                ),
              ),
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.all(
                  20.0.sp,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${title ?? ''}',
                      style: TextStyle(
                        fontSize: 14.0.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Visibility(
                      visible: (lastStatus ?? '').isNotEmpty,
                      child: Text(
                        lastStatus ?? '',
                        style: TextStyle(
                          fontSize: 14.0.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: (alerts ?? '').isNotEmpty,
                      child: Text(
                        alerts ?? '',
                        style: TextStyle(
                          fontSize: 14.0.sp,
                          color: color,
                        ),
                      ),
                    ),
                    Container(
                      child: SvgPicture.asset(
                        icon,
                        width: 40.0.sp,
                        height: 40.0.sp,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
