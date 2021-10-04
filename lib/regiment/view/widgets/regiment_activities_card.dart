import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myfhb/constants/variable_constant.dart';
import '../../../src/utils/screenutils/size_extensions.dart';
import '../../models/regiment_data_model.dart';
import '../../../constants/fhb_constants.dart';
import 'form_data_dialog.dart';
import '../../view_model/regiment_view_model.dart';
import '../../models/save_response_model.dart';
import '../../models/field_response_model.dart';
import 'package:provider/provider.dart';
import 'media_icon_widget.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import '../../../common/CommonUtil.dart';
import '../../../src/ui/loader_class.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'regiment_webview.dart';

class RegimentActivitiesCard extends StatelessWidget {
  final int index;
  final String title;
  final String time;
  final Color color;
  final String eid;
  final DateTime startTime;
  final RegimentDataModel regimentData;

  const RegimentActivitiesCard({
    @required this.index,
    @required this.title,
    @required this.time,
    @required this.color,
    @required this.eid,
    @required this.startTime,
    @required this.regimentData,
  });

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
        child: Material(
          elevation: 20.0,
          child: Container(
            color: Colors.white,
            margin: EdgeInsets.only(
              left: 10.0.w,
              right: 10.0.w,
              bottom: 10.0.h,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    color: color,
                    padding: EdgeInsets.symmetric(
                      vertical: 10.0.h,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: 2.0.h,
                          ),
                          child: Text(
                            time,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0.sp,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 5.0.h,
                      horizontal: 20.0.w,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: regimentData?.isMandatory ?? false,
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: 5.0.w,
                              top: 4.0.h,
                            ),
                            child: SvgPicture.asset(
                              icon_mandatory,
                              width: 7.0.sp,
                              height: 7.0.sp,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            title?.trim(),
                            style: TextStyle(
                              fontSize: 16.0.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Switch(
                  activeColor: Colors.green,
                  inactiveThumbColor: Colors.grey[200],
                  inactiveTrackColor: Colors.grey[400],
                  value: !regimentData?.isEventDisabled,
                  onChanged: (regimentData?.isMandatory ?? false)
                      ? null
                      : (isEnabled) {
                          Provider.of<RegimentViewModel>(
                            context,
                            listen: false,
                          ).enableDisableActivity(
                            eidUser: regimentData?.teidUser,
                            startTime: regimentData?.estart,
                            isDisable: !isEnabled,
                          );
                        },
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
        ),
      );
}
