
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/colors/fhb_colors.dart';
import 'package:myfhb/common/CommonUtil.dart';
import '../../../constants/fhb_constants.dart';
import '../../../src/utils/screenutils/size_extensions.dart';

class LandingCard extends StatelessWidget {
  const LandingCard({
    required this.title,
    required this.icon,
    required this.color,
    this.lastStatus,
    this.alerts,
    this.onPressed,
    this.onAddPressed,
    this.onTicketPressed,
    this.isEnabled = true,
    this.onLinkPressed,
    this.alertsColor,
    this.eventName,
    this.onEventPressed,
    this.ticketsCount,
  });

  final String title;
  final String? ticketsCount;
  final String icon;
  final Color color;
  final String? lastStatus;
  final String? alerts;
  final Function? onPressed;
  final Function? onAddPressed;
  final Function? onTicketPressed;
  final bool isEnabled;
  final Function? onLinkPressed;
  final Color? alertsColor;
  final String? eventName;
  final Function? onEventPressed;

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
          elevation: 5,
          color: Colors.white,
          shadowColor: Colors.black54,
          child: Stack(
            children: [
              InkWell(
                onTap: onPressed as void Function()?,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title ?? '',
                        style: TextStyle(
                          fontSize: 18.0.sp,
                          color: color,
                          // fontWeight: FontWeight.w600,
                        ),
                      ),
                      Visibility(
                        visible: onLinkPressed == null &&
                            isEnabled &&
                            (alerts ?? '').isNotEmpty,
                        child: Text(
                          alerts ?? '',
                          style: TextStyle(
                            fontSize: alertsColor != null ? 14.0.sp : 12.0.sp,
                            color: alertsColor ?? Colors.black54,
                            decoration: onLinkPressed != null
                                ? TextDecoration.underline
                                : TextDecoration.none,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Visibility(
                        visible: onLinkPressed != null &&
                            isEnabled &&
                            (alerts ?? '').isNotEmpty,
                        child: InkWell(
                          onTap: onLinkPressed as void Function()?,
                          child: Text(
                            alerts ?? '',
                            style: TextStyle(
                              fontSize: alertsColor != null ? 12.0.sp : 12.0.sp,
                              color: Colors.black54,
                              decoration: onLinkPressed != null
                                  ? TextDecoration.underline
                                  : TextDecoration.none,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: isEnabled && (eventName ?? '').isNotEmpty,
                        child: InkWell(
                          child: Text(
                            (eventName ?? '').isNotEmpty
                                ? toBeginningOfSentenceCase(
                                    eventName?.trim() ?? '')!
                                : '',
                            style: TextStyle(
                              fontSize: 12.0.sp,
                              color: Colors.black54,
                              height: 1.3.h,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: isEnabled && (lastStatus ?? '').isNotEmpty,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              lastStatus ?? '',
                              style: TextStyle(
                                fontSize: 12.0.sp,
                                color: Colors.black54,
                                decoration: TextDecoration.none,
                                height: 1.3.h,
                              ),
                              textAlign: TextAlign.end,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Visibility(
                      //   visible: onLinkPressed != null &&
                      //       isEnabled &&
                      //       (alerts ?? '').isNotEmpty,
                      //   child: InkWell(
                      //     onTap: onLinkPressed,
                      //     child: Text(
                      //       alerts ?? '',
                      //       style: TextStyle(
                      //         fontSize: alertsColor != null ? 12.0.sp : 12.0.sp,
                      //         color: Colors.black54,
                      //         decoration: onLinkPressed != null
                      //             ? TextDecoration.underline
                      //             : TextDecoration.none,
                      //       ),
                      //       maxLines: 3,
                      //       overflow: TextOverflow.ellipsis,
                      //     ),
                      //   ),
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SvgPicture.asset(
                            icon,
                            width: 40.0.sp,
                            height: 40.0.sp,
                          ),
                          Spacer(),
                          Visibility(
                            visible: onAddPressed != null,
                            child: Container(
                              height: 30.0.sp,
                              width: 30.0.sp,
                              child: FloatingActionButton(
                                onPressed: onAddPressed as void Function()? ?? () {},
                                elevation: 2,
                                backgroundColor: color,
                                heroTag: title,
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: onTicketPressed != null,
                            child: Container(
                              height: 40.0.sp,
                              width: 40.0.sp,
                              child: FloatingActionButton(
                                onPressed: onTicketPressed as void Function()? ?? () {},
                                elevation: 2,
                                backgroundColor:
                                    Color(CommonUtil().getMyPrimaryColor()),
                                heroTag: title,
                                child: new Stack(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: new Image.asset(
                                        'assets/icons/10.png',
                                        height: 35,
                                        width: 35,
                                      ),
                                    ),
                                    ticketsCount != null
                                        ? Positioned(
                                            right: 5,
                                            left: 5,
                                            child: new Container(
                                              padding: EdgeInsets.all(1),
                                              decoration: new BoxDecoration(
                                                color: Colors.yellow,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              constraints: BoxConstraints(
                                                minWidth: 5,
                                                minHeight: 5,
                                              ),
                                              child: new Text(
                                                ticketsCount!,
                                                style: new TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 8,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ],
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
                visible: false && !isEnabled,
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
