import 'package:flutter/material.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/regiment/models/regiment_data_model.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'form_data_dialog.dart';
import 'package:myfhb/regiment/view_model/regiment_view_model.dart';
import 'package:myfhb/regiment/models/save_response_model.dart';
import 'package:myfhb/regiment/models/field_response_model.dart';
import 'package:provider/provider.dart';
import 'media_icon_widget.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/ui/loader_class.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'regiment_webview.dart';

class RegimentDataCard extends StatelessWidget {
  final int index;
  final String title;
  final String time;
  final Color color;
  final dynamic icon;
  final String eid;
  final List<VitalsData> vitalsData;
  final Otherinfo mediaData;
  final DateTime startTime;
  final RegimentDataModel regimentData;

  const RegimentDataCard({
    @required this.index,
    @required this.title,
    @required this.time,
    @required this.color,
    @required this.icon,
    @required this.eid,
    @required this.vitalsData,
    @required this.startTime,
    @required this.mediaData,
    @required this.regimentData,
  });

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
        child: Padding(
          padding: EdgeInsets.only(
            left: 10.0.w,
            right: 10.0.w,
            bottom: 10.0.h,
          ),
          child: Material(
            color: Colors.white,
            child: InkWell(
              onTap: () => onCardPressed(context),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Material(
                      color: color,
                      child: InkWell(
                        onTap: () => onCardPressed(context),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 10.0.h,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              icon,
                              Visibility(
                                visible: Provider.of<RegimentViewModel>(context,
                                                listen: false)
                                            .regimentMode ==
                                        RegimentMode.Schedule &&
                                    !(regimentData?.asNeeded ?? false),
                                child: Padding(
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
                              ),
                            ],
                          ),
                        ),
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
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: getFieldWidgets(context),
                                ),
                              ),
                            ],
                          ),
                          Visibility(
                            visible: regimentData.ack != null,
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 5.0.h,
                                bottom: 5.0.h,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '${CommonUtil().regimentDateFormat(
                                      regimentData?.ack ?? DateTime.now(),
                                      isAck: true,
                                    )}',
                                    style: TextStyle(
                                      fontSize: 12.0.sp,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5.0.w),
                                    child: InkWell(
                                      child: Text(
                                        undo,
                                        style: TextStyle(
                                          fontSize: 14.0.sp,
                                          fontWeight: FontWeight.w500,
                                          decoration: TextDecoration.underline,
                                          color: Color(
                                              CommonUtil().getMyPrimaryColor()),
                                        ),
                                      ),
                                      onTap: () async {
                                        LoaderClass.showLoadingDialog(
                                          Get.context,
                                          canDismiss: false,
                                        );
                                        SaveResponseModel saveResponse =
                                            await Provider.of<
                                                        RegimentViewModel>(
                                                    context,
                                                    listen: false)
                                                .undoSaveFormData(
                                          eid: eid,
                                        );
                                        if (saveResponse?.isSuccess ?? false) {
                                          Future.delayed(
                                              Duration(milliseconds: 300),
                                              () async {
                                            await Provider.of<
                                                        RegimentViewModel>(
                                                    context,
                                                    listen: false)
                                                .fetchRegimentData();
                                            LoaderClass.hideLoadingDialog(
                                                Get.context);
                                          });
                                        } else {
                                          LoaderClass.hideLoadingDialog(
                                              Get.context);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
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
          ),
        ),
      );

  List<Widget> getFieldWidgets(BuildContext context) {
    List<Widget> fieldWidgets = [];
    fieldWidgets.add(
      Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 5.0.h,
              ),
              child: Text(
                '${title?.trim()}',
                style: TextStyle(
                  fontSize: 16.0.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 10.0.h,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  if (regimentData.isPlaying) {
                    stopRegimenTTS();
                  } else {
                    Provider.of<RegimentViewModel>(context, listen: false)
                        .startRegimenTTS(index, regimentData.saytext);
                  }
                },
                child: Icon(
                  regimentData.isPlaying
                      ? Icons.stop_circle_outlined
                      : Icons.play_circle_fill_rounded,
                  size: 30.0.sp,
                  color: color,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    vitalsData?.forEach((vitalData) {
      bool isNormal = true;

      isNormal = (vitalData.fieldType == FieldType.NUMBER &&
              int.tryParse(vitalData.value) != null &&
              int.tryParse(vitalData.amin) != null &&
              int.tryParse(vitalData.amax) != null &&
              int.tryParse(vitalData.value).toString().isNotEmpty &&
              int.tryParse(vitalData.amin).toString().isNotEmpty &&
              int.tryParse(vitalData.amax).toString().isNotEmpty)
          ? (int.tryParse(vitalData.value) <= int.tryParse(vitalData.amax) &&
              int.tryParse(vitalData.value) >= int.tryParse(vitalData.amin))
          : true;
      if ((vitalData.display ?? '').isNotEmpty) {
        fieldWidgets.add(
          Padding(
            padding: EdgeInsets.all(5.0.sp),
            child: Row(
              children: [
                Text(
                  //TODO: Replace with actual value from API
                  '${vitalData.vitalName} : ',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                    fontSize: 14.0.sp,
                  ),
                  maxLines: 2,
                  softWrap: true,
                ),
                Flexible(
                  child: Text(
                    //TODO: Replace with actual value from API
                    '${vitalData.display ?? ''}',
                    style: TextStyle(
                      color: isNormal ? color : Colors.red,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    });

    if (mediaData != null || (regimentData?.hashtml ?? false)) {
      fieldWidgets.add(
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 0.0.w,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Visibility(
                visible: mediaData.needPhoto == '1',
                child: MediaIconWidget(
                  color: color,
                  icon: Icons.camera_alt,
                ),
              ),
              Visibility(
                visible: mediaData.needAudio == '1',
                child: MediaIconWidget(
                  color: color,
                  icon: Icons.mic,
                ),
              ),
              Visibility(
                visible: mediaData.needVideo == '1',
                child: MediaIconWidget(
                  color: color,
                  icon: Icons.videocam,
                ),
              ),
              Visibility(
                visible: mediaData.needFile == '1',
                child: MediaIconWidget(
                  color: color,
                  icon: Icons.attach_file,
                ),
              ),
              Visibility(
                visible: regimentData.hashtml,
                child: MediaIconWidget(
                  color: color,
                  icon: Icons.menu_book_rounded,
                  onPressed: () {
                    Get.to(
                      RegimentWebView(
                        title: title,
                        selectedUrl: regimentData.htmltemplate,
                      ),
                    );
                    // CommonUtil().openWebViewNew(
                    //   regimentData.title,
                    //   regimentData.htmltemplate,
                    //   true,
                    // );
                  },
                ),
              ),
              Visibility(
                visible: !regimentData.hasform,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 5.0.w,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async {
                        stopRegimenTTS();

                        bool canEdit =
                            startTime.difference(DateTime.now()).inMinutes <=
                                    15 &&
                                Provider.of<RegimentViewModel>(context,
                                            listen: false)
                                        .regimentMode ==
                                    RegimentMode.Schedule;
                        if (canEdit || isValidSymptom(context)) {
                          LoaderClass.showLoadingDialog(
                            Get.context,
                            canDismiss: false,
                          );
                          SaveResponseModel saveResponse =
                              await Provider.of<RegimentViewModel>(context,
                                      listen: false)
                                  .saveFormData(
                            eid: eid,
                          );
                          if (saveResponse?.isSuccess ?? false) {
                            Future.delayed(Duration(milliseconds: 300),
                                () async {
                              await Provider.of<RegimentViewModel>(context,
                                      listen: false)
                                  .fetchRegimentData();
                              LoaderClass.hideLoadingDialog(Get.context);
                            });
                          } else {
                            LoaderClass.hideLoadingDialog(Get.context);
                          }
                        } else {
                          FlutterToast().getToast(
                            (Provider.of<RegimentViewModel>(context,
                                            listen: false)
                                        .regimentMode ==
                                    RegimentMode.Symptoms)
                                ? symptomsError
                                : activitiesError,
                            Colors.red,
                          );
                        }
                      },
                      child: Icon(
                        regimentData.ack == null
                            ? Icons.check_circle_outlined
                            : Icons.check_circle_rounded,
                        size: 30.0.sp,
                        color: color,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return fieldWidgets;
  }

  bool isValidSymptom(BuildContext context) {
    DateTime currentTime = DateTime.now();
    var selectedDate =
        Provider.of<RegimentViewModel>(context, listen: false).selectedDate;
    return (Provider.of<RegimentViewModel>(context, listen: false)
                .regimentMode ==
            RegimentMode.Symptoms) &&
        ((selectedDate?.year <= currentTime.year)
            ? (selectedDate?.month <= currentTime.month
                ? selectedDate?.day <= currentTime.day
                : false)
            : false);
  }

  String getDialogTitle(BuildContext context) {
    String title = '';
    if (!(regimentData?.asNeeded ?? false) &&
        Provider.of<RegimentViewModel>(context, listen: false).regimentMode ==
            RegimentMode.Schedule) {
      title =
          '${regimentData?.estart != null ? DateFormat('hh:mm a').format(regimentData.estart) : ''},${regimentData.title}';
    } else {
      title = '${regimentData.title}';
    }
    return title;
  }

  Future<void> onCardPressed(BuildContext context) async {
    stopRegimenTTS();
    bool canEdit = startTime.difference(DateTime.now()).inMinutes <= 15 &&
        Provider.of<RegimentViewModel>(context, listen: false).regimentMode ==
            RegimentMode.Schedule;
    // if (canEdit || isValidSymptom(context)) {
    FieldsResponseModel fieldsResponseModel =
        await Provider.of<RegimentViewModel>(context, listen: false)
            .getFormData(eid: eid);
    print(fieldsResponseModel);
    if (fieldsResponseModel.isSuccess &&
        (fieldsResponseModel.result.fields.length > 0 ||
            mediaData.toJson().toString().contains('1')) &&
        Provider.of<RegimentViewModel>(context, listen: false).regimentStatus !=
            RegimentStatus.DialogOpened) {
      Provider.of<RegimentViewModel>(context, listen: false)
          .updateRegimentStatus(RegimentStatus.DialogOpened);
      bool value = await showDialog(
        context: context,
        builder: (context) => FormDataDialog(
          fieldsData: fieldsResponseModel.result.fields,
          eid: eid,
          color: color,
          mediaData: mediaData,
          formTitle: getDialogTitle(context),
          canEdit: canEdit || isValidSymptom(context),
        ),
      );
      if (value != null && (value ?? false)) {
        LoaderClass.showLoadingDialog(
          Get.context,
          canDismiss: false,
        );
        Future.delayed(Duration(milliseconds: 300), () async {
          await Provider.of<RegimentViewModel>(context, listen: false)
              .fetchRegimentData();
          LoaderClass.hideLoadingDialog(Get.context);
        });
      }

      Provider.of<RegimentViewModel>(context, listen: false)
          .updateRegimentStatus(RegimentStatus.DialogClosed);
    } else if (!regimentData.hasform) {
      FlutterToast().getToast(
        tickInfo,
        Colors.black,
      );
    }
  }

  stopRegimenTTS() {
    Provider.of<RegimentViewModel>(Get.context, listen: false).stopRegimenTTS();
  }
}
