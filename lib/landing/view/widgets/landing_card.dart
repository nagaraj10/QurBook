import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class LandingCard extends StatelessWidget {
  const LandingCard({
    @required this.title,
    @required this.icon,
    @required this.color,
    this.lastStatus,
    this.alerts,
    this.onPressed,
    this.onAddPressed,
    this.isEnabled = true,
    this.onLinkPressed,
    this.iconColor,
    this.eventName,
  });

  final String title;
  final String icon;
  final Color color;
  final String lastStatus;
  final String alerts;
  final Function onPressed;
  final Function onAddPressed;
  final bool isEnabled;
  final Function onLinkPressed;
  final Color iconColor;
  final String eventName;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.all(0.0.sp),
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0.sp),
              topRight: Radius.circular(20.0.sp),
            ),
          ),
          elevation: 5.0,
          color: Colors.white,
          shadowColor: Colors.white54,
          child: Stack(
            children: [
              InkWell(
                onTap: onPressed,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border(
                      bottom: BorderSide(
                        color: color,
                        width: 2.0.h,
                      ),
                    ),
                  ),
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
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Visibility(
                        visible: isEnabled && (eventName ?? '').isNotEmpty,
                        child: Text(
                          eventName?.trim() ?? '',
                          style: TextStyle(
                            fontSize: 14.0.sp,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Visibility(
                        visible: isEnabled && (lastStatus ?? '').isNotEmpty,
                        child: Text(
                          lastStatus ?? '',
                          style: TextStyle(
                            fontSize: 14.0.sp,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Visibility(
                        visible: isEnabled && (alerts ?? '').isNotEmpty,
                        child: InkWell(
                          onTap: onLinkPressed,
                          child: Text(
                            alerts ?? '',
                            style: TextStyle(
                              fontSize: 14.0.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              decoration: onLinkPressed != null
                                  ? TextDecoration.underline
                                  : TextDecoration.none,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SvgPicture.asset(
                            icon,
                            width: 40.0.sp,
                            height: 40.0.sp,
                            color: iconColor,
                          ),
                          Visibility(
                            visible: onAddPressed != null,
                            child: Container(
                              height: 30.0.sp,
                              width: 30.0.sp,
                              child: FloatingActionButton(
                                onPressed: onAddPressed ?? () {},
                                elevation: 2.0,
                                heroTag: '$title',
                                child: Icon(
                                  Icons.add,
                                  color: color,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: !isEnabled,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0.sp),
                      topRight: Radius.circular(20.0.sp),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
