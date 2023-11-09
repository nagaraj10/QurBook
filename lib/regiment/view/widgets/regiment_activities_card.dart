import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/regiment/service/regiment_service.dart';
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
  final String? title;
  final String time;
  final Color color;
  final String? eid;
  final DateTime? startTime;
  final RegimentDataModel regimentData;

  const RegimentActivitiesCard({
    required this.index,
    required this.title,
    required this.time,
    required this.color,
    required this.eid,
    required this.startTime,
    required this.regimentData,
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
                          visible: regimentData.isMandatory,
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
                            title!.trim(),
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
                  value: !regimentData.isEventDisabled,
                  onChanged: (isEnabled) {
                    if (CommonUtil.isUSRegion()) {
                      showDialogBoxForReason(context, isEnabled);
                    } else {
                      enableActivityMethod(context, isEnabled);
                    }
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

  void enableActivityMethod(BuildContext context, bool isEnabled) {
    Provider.of<RegimentViewModel>(
      context,
      listen: false,
    ).enableDisableActivity(
      eidUser: regimentData.teidUser,
      startTime: regimentData.estart!,
      isDisable: !isEnabled,
    );
  }

  void showDialogBoxForReason(BuildContext context, bool isEnabled) {
    TextEditingController controller = TextEditingController();
    if (isEnabled) {
      enableActivityMethod(context, isEnabled);
    } else {
      showDialog(
          context: context,
          builder: (__) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                contentPadding: EdgeInsets.all(8),
                content: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              confirmButton,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: CommonUtil().isTablet!
                                      ? tabTitle
                                      : mobileTitle),
                            ),
                          ),
                          Spacer(),
                          IconButton(
                              padding: EdgeInsets.all(8.0),
                              icon: Icon(
                                Icons.close,
                                size: CommonUtil().isTablet!
                                    ? imageCloseTab
                                    : imageCloseMobile,
                              ),
                              onPressed: () {
                                try {
                                  Navigator.pop(context);
                                } catch (e, stackTrace) {
                                  print(e);
                                }
                              })
                        ],
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Text(
                          strReasonDiabling,
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: CommonUtil().isTablet!
                                  ? tabFontTitle
                                  : mobileFontTitle),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: controller,
                          decoration: InputDecoration(
                            hintText: strReasonDiablingHint,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(
                                      CommonUtil().getQurhomePrimaryColor())),
                            ),
                            border: OutlineInputBorder(
                                // borderSide: new BorderSide(color: Colors.teal)
                                ),
                          ),
                          keyboardType: TextInputType.multiline,
                          minLines: 5, //Normal textInputField will be displayed
                          maxLines:
                              6, // when user presses enter it will adapt to it
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Color(
                                      CommonUtil().getQurhomePrimaryColor())),
                              onPressed: () {
                                Provider.of<RegimentViewModel>(
                                  context,
                                  listen: false,
                                ).eid = eid ?? "";
                                if (controller.text.isNotEmpty) {
                                  Provider.of<RegimentViewModel>(
                                    context,
                                    listen: false,
                                  ).disableComment = controller.text;
                                  enableActivityMethod(context, isEnabled);
                                } else {
                                  Provider.of<RegimentViewModel>(
                                    context,
                                    listen: false,
                                  ).disableComment = strDisableText;
                                  enableActivityMethod(context, isEnabled);
                                }
                              },
                              child: Text(
                                DISABLE,
                                style: TextStyle(color: Colors.white),
                              )),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Color(
                                      CommonUtil().getQurhomePrimaryColor())),
                              onPressed: () {
                                try {
                                  Navigator.pop(context);
                                } catch (e, stackTrace) {
                                  print(e);
                                }
                              },
                              child: Text(
                                strCancel,
                                style: TextStyle(color: Colors.white),
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              );
            });
          });
    }
  }
}
