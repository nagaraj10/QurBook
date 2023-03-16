
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gmiwidgetspackage/widgets/asset_image.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/regiment/service/regiment_service.dart';
import 'package:myfhb/reminders/QurPlanReminders.dart';
import 'package:myfhb/src/utils/ImageViewer.dart';
import 'package:path/path.dart';
import '../../../src/utils/screenutils/size_extensions.dart';
import '../../models/regiment_data_model.dart';
import '../../../constants/fhb_constants.dart';
import 'AutoCloseText.dart';
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

class RegimentDataCard extends StatelessWidget {
  final int index;
  final dynamic title;
  final dynamic time;
  final Color color;
  final dynamic icon;
  final dynamic eid;
  final List<VitalsData>? vitalsData;
  final Otherinfo? mediaData;
  final DateTime? startTime;
  final RegimentDataModel regimentData;

  final dynamic uid;
  final dynamic aid;
  final dynamic formId;
  final dynamic formName;

  const RegimentDataCard({
    required this.index,
    required this.title,
    required this.time,
    required this.color,
    required this.icon,
    required this.eid,
    required this.vitalsData,
    required this.startTime,
    required this.mediaData,
    required this.regimentData,
    this.uid = '',
    this.aid = '',
    this.formId = '',
    this.formName = '',
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
            color: regimentData?.activityOrgin == strAppointmentRegimen
                ? Color(CommonUtil().getMyPrimaryColor())
                : Colors.white,
            child: InkWell(
              onTap: () {
                if (regimentData?.activityOrgin == strAppointmentRegimen) {
                  if ((regimentData?.eid != null) &&
                      (regimentData?.eid != '')) {
                    CommonUtil().goToAppointmentDetailScreen(regimentData?.eid);
                  }
                } else {
                  onCardPressed(context,
                      aid: aid, uid: uid, formId: formId, formName: formName);
                }
              },
              child: Row(
                children: [
                  Expanded(
                    child: Material(
                      color:
                          regimentData?.activityOrgin == strAppointmentRegimen
                              ? Colors.white
                              : color,
                      child: InkWell(
                        onTap: () {
                          if (regimentData?.activityOrgin !=
                              strAppointmentRegimen) {
                            onCardPressed(context,
                                aid: aid,
                                uid: uid,
                                formId: formId,
                                formName: formName);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 10.0.h,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              regimentData?.activityOrgin ==
                                      strAppointmentRegimen
                                  ? getAppointmentIcon()
                                  : icon,
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
                                      color: regimentData?.activityOrgin ==
                                              strAppointmentRegimen
                                          ? Color(
                                              CommonUtil().getMyPrimaryColor())
                                          : Colors.white,
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
                            visible: (regimentData?.isModifiedToday ?? false) ||
                                regimentData.ack_local != null,
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 5.0.h,
                                bottom: 5.0.h,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Visibility(
                                    visible:
                                        regimentData?.isModifiedToday ?? false,
                                    child: SvgPicture.asset(
                                      icon_modified,
                                      width: 20.0.sp,
                                      height: 20.0.sp,
                                    ),
                                  ),
                                  Visibility(
                                    visible: regimentData.ack_local != null,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          '${CommonUtil().regimentDateFormat(
                                            regimentData.asNeeded
                                                ? regimentData?.ack_local ??
                                                    DateTime.now()
                                                : regimentData?.ack_local ??
                                                    DateTime.now(),
                                            isAck: true,
                                          )}',
                                          style: TextStyle(
                                            fontSize: 12.0.sp,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 5.0.w),
                                          child: InkWell(
                                            onTap: () async {
                                              LoaderClass.showLoadingDialog(
                                                Get.context!,
                                                canDismiss: false,
                                              );
                                              var saveResponse = await Provider
                                                      .of<RegimentViewModel>(
                                                          context,
                                                          listen: false)
                                                  .undoSaveFormData(
                                                eid: eid,
                                              );
                                              if (saveResponse?.isSuccess ??
                                                  false) {
                                                Future.delayed(
                                                    Duration(milliseconds: 300),
                                                    () async {
                                                  await Provider.of<
                                                              RegimentViewModel>(
                                                          context,
                                                          listen: false)
                                                      .fetchRegimentData();
                                                  LoaderClass.hideLoadingDialog(
                                                      Get.context!);
                                                });
                                              } else {
                                                LoaderClass.hideLoadingDialog(
                                                    Get.context!);
                                              }
                                            },
                                            child: Text(
                                              undo,
                                              style: TextStyle(
                                                fontSize: 14.0.sp,
                                                fontWeight: FontWeight.w500,
                                                decoration:
                                                    TextDecoration.underline,
                                                color: Color(CommonUtil()
                                                    .getMyPrimaryColor()),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
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
                  if (regimentData?.activityOrgin != strAppointmentRegimen)
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
    final fieldWidgets = <Widget>[];
    fieldWidgets.add(
      Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 5.0.h,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getNameFromTitle(regimentData)!,
                          style: TextStyle(
                            fontSize: 16.0.sp,
                            fontWeight: FontWeight.w500,
                            color: regimentData?.activityOrgin ==
                                    strAppointmentRegimen
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        if (regimentData?.healthOrgName != null &&
                            regimentData?.healthOrgName != '' &&
                            regimentData?.healthOrgName != strSelfRegimen &&
                            regimentData?.activityOrgin ==
                                strAppointmentRegimen)
                          if (regimentData?.doctorSessionId != null)
                            getHealthOrgName(regimentData),
                        if (regimentData?.doctorSessionId == null)
                          Text(
                            regimentData?.serviceCategory?.name ?? '',
                            style: getTextStyle(),
                          ),
                        if (regimentData?.doctorSessionId == null &&
                            regimentData?.modeOfService?.name != null)
                          Text(
                            regimentData?.modeOfService?.name ?? '',
                            style: getTextStyle(),
                          )
                        else
                          SizedBox(),
                        if (regimentData?.estart != null &&
                            regimentData?.estart != '' &&
                            regimentData?.eend != null &&
                            regimentData?.eend != '' &&
                            regimentData?.activityOrgin ==
                                strAppointmentRegimen)
                          getStartEndTime(regimentData),
                        (regimentData?.healthOrgName != null &&
                                regimentData?.healthOrgName != '' &&
                                regimentData?.healthOrgName != strSelfRegimen &&
                                regimentData?.activityOrgin ==
                                    strAppointmentRegimen)
                            ? SizedBox(height: 4.h)
                            : SizedBox(height: 20.h),
                        if (regimentData?.activityOrgin ==
                            strAppointmentRegimen)
                          Container(
                            alignment: Alignment.bottomRight,
                            child: getShowAppointmentBnt(),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (regimentData?.activityOrgin != strAppointmentRegimen)
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10.0.h,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    if (regimentData.isPlaying.value) {
                      stopRegimenTTS();
                    } else {
                      Provider.of<RegimentViewModel>(context, listen: false)
                          .startRegimenTTS(
                        index,
                        staticText: regimentData?.title ?? '',
                        dynamicText: regimentData?.sayTextDynamic ?? '',
                      );
                    }
                  },
                  child: Obx(() {
                    return Icon(
                      regimentData.isPlaying.value
                          ? Icons.stop_circle_outlined
                          : Icons.play_circle_fill_rounded,
                      size: 30.0.sp,
                      color: color,
                    );
                  }),
                ),
              ),
            ),
        ],
      ),
    );

    vitalsData?.forEach((vitalData) {
      var isNormal = true;

      if (vitalData.fieldType == FieldType.NUMBER &&
          (vitalData.value ?? "").isNotEmpty &&
          (vitalData.amin ?? "").isNotEmpty &&
          (vitalData.amax ?? "").isNotEmpty) {
        try {
          isNormal = (double.tryParse(vitalData.value).toString().isNotEmpty &&
                  double.tryParse(vitalData.amin).toString().isNotEmpty &&
                  double.tryParse(vitalData.amax).toString().isNotEmpty)
              ? (double.tryParse(vitalData.value)! <=
                      double.tryParse(vitalData.amax)! &&
                  double.tryParse(vitalData.value)! >=
                      double.tryParse(vitalData.amin)!)
              : true;
        } catch (e) {
          //print(e);
        }
      }

      if ((vitalData.display ?? '').isNotEmpty) {
        fieldWidgets.add(
          Padding(
            padding: EdgeInsets.all(5.0.sp),
            child: Row(
              children: [
                Text(
                  //TODO: Replace with actual value from API
                  '${CommonUtil().showDescTextRegimenList(vitalData)} : ',
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
                    vitalData.display ?? '',
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
    dynamic imageUrl = null;
    regimentData?.uformdata?.vitalsData?.forEach((vital) {
      if ((vital.photo?.url ?? "").isNotEmpty) {
        imageUrl = vital.photo?.url;
      }
    });
    if (regimentData.ack == null) if (mediaData?.snoozeText != null &&
        mediaData!.snoozeText!.length > 0) {
      fieldWidgets.add(Padding(
        padding: EdgeInsets.all(5.0.sp),
        child: Text(
          mediaData!.snoozeText!,
          style: TextStyle(
              fontSize: 16.0.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey[500]),
        ),
      ));
    }
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
                visible: mediaData!.needPhoto == '1',
                child: MediaIconWidget(
                  color: color,
                  icon: imageUrl != null
                      ? Icons.camera_alt
                      : Icons.camera_alt_outlined,
                  onPressed: imageUrl != null
                      ? () {
                          Get.to(
                            () => ImageViewer(
                                imageUrl, eid, regimentData?.providerid),
                          );
                        }
                      : null,
                ),
              ),
              Visibility(
                visible: mediaData!.needAudio == '1',
                child: MediaIconWidget(
                  color: color,
                  icon: Icons.mic,
                ),
              ),
              Visibility(
                visible: mediaData!.needVideo == '1',
                child: MediaIconWidget(
                  color: color,
                  icon: Icons.videocam,
                ),
              ),
              Visibility(
                visible: mediaData!.needFile == '1',
                child: MediaIconWidget(
                  color: color,
                  icon: Icons.attach_file,
                ),
              ),
              Visibility(
                visible: regimentData.hashtml!,
                child: MediaIconWidget(
                  color: color,
                  icon: Icons.menu_book_rounded,
                  onPressed: () {
                    Get.to(
                      RegimentWebView(
                        title: title,
                        selectedUrl: regimentData?.htmltemplate,
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
                visible: !regimentData.hasform!,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 5.0.w,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async {
                        stopRegimenTTS();
                        final canEdit =
                            startTime!.difference(DateTime.now()).inMinutes <=
                                    15 &&
                                Provider.of<RegimentViewModel>(context,
                                            listen: false)
                                        .regimentMode ==
                                    RegimentMode.Schedule;
                        if (canEdit || isValidSymptom(context)) {
                          if (regimentData?.eid != null &&
                              regimentData?.eid != '') {
                            RegimentService.getActivityStatus(
                                    eid: regimentData?.eid)
                                .then((value) {
                              if (value?.isSuccess ?? false) {
                                if (value?.result != null) {
                                  if (value?.result![0].planStatus ==
                                          UnSubscribed ||
                                      value?.result![0].planStatus == Expired) {
                                    var message =
                                        (value?.result![0].planStatus ==
                                                UnSubscribed)
                                            ? UnSubscribed
                                            : Expired;
                                    CommonUtil().showDialogForActivityStatus(
                                        'Plan $message, $msgData', Get.context!,
                                        pressOk: () {
                                      Get.back();
                                      logRegimenActivity(Get.context!);
                                    });
                                  } else {
                                    logRegimenActivity(Get.context!);
                                  }
                                } else {
                                  logRegimenActivity(Get.context!);
                                }
                              } else {
                                logRegimenActivity(Get.context!);
                              }
                            });
                          } else {
                            logRegimenActivity(Get.context!);
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

  logRegimenActivity(BuildContext context) async {
    LoaderClass.showLoadingDialog(
      Get.context!,
      canDismiss: false,
    );
    var saveResponse =
        await Provider.of<RegimentViewModel>(context, listen: false)
            .saveFormData(
      eid: eid,
    );
    if (saveResponse?.isSuccess ?? false) {
      if ((saveResponse?.result != null) &&
          (saveResponse?.result?.actions != null) &&
          (saveResponse?.result?.actions?.returnData != null)) {
        LoaderClass.hideLoadingDialog(Get.context!);
        checkForReturnActionsProviderForm(
          returnAction: saveResponse?.result?.actions?.returnData,
        );
      } else {
        Future.delayed(Duration(milliseconds: 300), () async {
          await Provider.of<RegimentViewModel>(context, listen: false)
              .fetchRegimentData();
          LoaderClass.hideLoadingDialog(Get.context!);
        });
      }
      /* Future.delayed(Duration(milliseconds: 300),
                                () async {
                              await Provider.of<RegimentViewModel>(context,
                                      listen: false)
                                  .fetchRegimentData();
                              LoaderClass.hideLoadingDialog(Get.context);
                            });*/
    } else {
      LoaderClass.hideLoadingDialog(Get.context!);
    }
  }

  bool isValidSymptom(BuildContext context) {
    var currentTime = DateTime.now();
    final selectedDate = Provider.of<RegimentViewModel>(context, listen: false)
        .selectedRegimenDate;
    return (Provider.of<RegimentViewModel>(context, listen: false)
                .regimentMode ==
            RegimentMode.Symptoms) &&
        ((selectedDate.year <= currentTime.year)
            ? (selectedDate.month <= currentTime.month
                ? selectedDate.day <= currentTime.day
                : false)
            : false);
  }

  String? getDialogTitle(BuildContext context, String? activityName) {
    String? title = '';
    if (!(regimentData?.asNeeded ?? false) &&
        Provider.of<RegimentViewModel>(context, listen: false).regimentMode ==
            RegimentMode.Schedule) {
      if (activityName != null && activityName != '') {
        title = activityName?.capitalizeFirstofEach;
      } else {
        title =
            '${regimentData?.estart != null ? DateFormat('hh:mm a').format(regimentData.estart!) : ''},${regimentData.title}';
      }
    } else {
      if (activityName != null && activityName != '') {
        title = activityName?.capitalizeFirstofEach;
      } else {
        title = regimentData.title;
      }
    }
    return title;
  }

  Future<void> onCardPressed(BuildContext context,
      {String? eventIdReturn,
      String? followEventContext,
      String? activityName,
      dynamic uid,
      dynamic aid,
      dynamic formId,
      dynamic formName}) async {
    try {
      stopRegimenTTS();
      var eventId = eventIdReturn ?? eid;
      if (eventId == null || eventId == '' || eventId == 0) {
        final response = await Provider.of<RegimentViewModel>(context,
                listen: false)
            .getEventId(uid: uid, aid: aid, formId: formId, formName: formName);
        if (response != null &&
            response.isSuccess! &&
            response.result != null) {
          print('forEventId: ' + response.toJson().toString());
          eventId = response.result?.eid.toString();
        }
      }
      var canEdit = startTime!.difference(DateTime.now()).inMinutes <= 15 &&
          Provider.of<RegimentViewModel>(context, listen: false).regimentMode ==
              RegimentMode.Schedule;
      // if (canEdit || isValidSymptom(context)) {
      final fieldsResponseModel =
          await Provider.of<RegimentViewModel>(context, listen: false)
              .getFormData(eid: eventId);
      print(fieldsResponseModel);
      if (fieldsResponseModel.isSuccess! &&
          (fieldsResponseModel.result!.fields!.isNotEmpty ||
              mediaData!.toJson().toString().contains('1')) &&
          Provider.of<RegimentViewModel>(context, listen: false)
                  .regimentStatus !=
              RegimentStatus.DialogOpened) {
        Provider.of<RegimentViewModel>(context, listen: false)
            .updateRegimentStatus(RegimentStatus.DialogOpened);
        var value = await showDialog(
          context: context,
          builder: (context) => FormDataDialog(
            fieldsData: fieldsResponseModel.result!.fields,
            eid: eventId,
            color: color,
            mediaData: mediaData,
            formTitle: getDialogTitle(context, activityName),
            canEdit: canEdit || isValidSymptom(context),
            triggerAction: (String? triggerEventId, String? followContext,
                String? activityName) {
              Provider.of<RegimentViewModel>(Get.context!, listen: false)
                  .updateRegimentStatus(RegimentStatus.DialogClosed);
              Get.back();
              onCardPressed(Get.context!,
                  eventIdReturn: triggerEventId,
                  followEventContext: followContext,
                  activityName: activityName);
            },
            followEventContext: followEventContext,
            isFollowEvent: eventIdReturn != null,
            providerId: regimentData?.providerid,
          ),
        );
        if (value != null && (value ?? false)) {
          LoaderClass.showLoadingDialog(
            Get.context!,
            canDismiss: false,
          );
          Future.delayed(Duration(milliseconds: 300), () async {
            await Provider.of<RegimentViewModel>(context, listen: false)
                .fetchRegimentData();
            LoaderClass.hideLoadingDialog(Get.context!);
          });
        }
        QurPlanReminders.getTheRemindersFromAPI();
        Provider.of<RegimentViewModel>(context, listen: false)
            .updateRegimentStatus(RegimentStatus.DialogClosed);
      } else if (!regimentData.hasform!) {
        FlutterToast().getToast(
          tickInfo,
          Colors.black,
        );
      }
    } catch (e) {
      LoaderClass.hideLoadingDialog(Get.context!);
    }
  }

  getHealthOrgName(RegimentDataModel regimen) {
    if (regimentData.healthOrgName != null &&
        regimentData.healthOrgName != '') {
      return Text(
        regimentData.healthOrgName?.trim(),
        style: TextStyle(
            fontSize: 16.0.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey[500]),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  TextStyle getTextStyle() {
    return TextStyle(
        fontSize: 16.0.sp,
        fontWeight: FontWeight.w500,
        color: regimentData?.activityOrgin == strAppointmentRegimen
            ? Colors.white
            : Colors.black);
  }

  getStartEndTime(RegimentDataModel regimen) {
    if (regimentData.estart != null &&
        regimentData.estart != '' &&
        regimentData.eend != null &&
        regimentData.eend != '') {
      return Row(
        children: [
          Text(
            DateFormat('hh:mm a').format(regimentData.estart!),
            style: TextStyle(fontSize: 16.0.sp, color: Colors.white),
          ),
          Text(
            ' - ' + DateFormat('hh:mm a').format(regimentData.eend!),
            style: TextStyle(fontSize: 16.0.sp, color: Colors.white),
          ),
          Text(
            ' (' +
                (CommonUtil.convertMinuteToHour(regimentData?.duration ?? 0))
                    .toString() +
                ')',
            style: TextStyle(fontSize: 16.0.sp, color: Colors.white),
          ),
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  }

  dynamic getAppointmentIcon() {
    final iconSize = 40.0.sp;

    return Image.asset(
      icon_appointment_regimen,
      height: iconSize,
      width: iconSize,
      color: Color(CommonUtil().getMyPrimaryColor()),
    );
  }

  getShowAppointmentBnt() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(
            strAppointmentRegimen,
            style: TextStyle(
              fontSize: 11.sp,
              color: Color(CommonUtil().getMyPrimaryColor()),
            ),
          )),
    );
  }

  stopRegimenTTS() {
    Provider.of<RegimentViewModel>(Get.context!, listen: false).stopRegimenTTS();
  }

  checkForReturnActionsProviderForm({
    ReturnModel? returnAction,
  }) async {
    if ((returnAction?.action ?? '').isNotEmpty &&
        (returnAction?.message ?? '').isNotEmpty) {
      await showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
          onWillPop: () async {
            Provider.of<RegimentViewModel>(Get.context!, listen: false)
                .cachedEvents = [];
            Get.back();
            await Provider.of<RegimentViewModel>(context, listen: false)
                .fetchRegimentData();
          } as Future<bool> Function()?,
          child: AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 24.0.sp,
                    ),
                    onPressed: () async {
                      Provider.of<RegimentViewModel>(Get.context!, listen: false)
                          .cachedEvents = [];
                      Navigator.pop(context);
                      await Provider.of<RegimentViewModel>(context,
                              listen: false)
                          .fetchRegimentData();
                    }),
              ],
            ),
            titlePadding: EdgeInsets.only(
              top: 10.0.h,
              right: 5.0.w,
              left: 15.0.w,
            ),
            content: Container(
              width: 0.75.sw,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 10.0.h,
                    ),
                    child: Text(
                      returnAction?.message ?? '',
                      style: TextStyle(
                        fontSize: 16.0.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RaisedButton(
                        onPressed: () async {
                          if (returnAction?.eid != null &&
                              (returnAction?.action ?? '') == startActivity) {
                            if (returnAction?.activityName == '' ||
                                returnAction?.activityName == null) {
                              Provider.of<RegimentViewModel>(Get.context!,
                                      listen: false)
                                  .cachedEvents = [];
                            }
                            Provider.of<RegimentViewModel>(Get.context!,
                                    listen: false)
                                .updateRegimentStatus(
                                    RegimentStatus.DialogClosed);
                            Get.back();
                            onCardPressed(Get.context!,
                                eventIdReturn: returnAction?.eid,
                                followEventContext: returnAction?.context,
                                activityName: returnAction?.activityName);
                          } else {
                            Provider.of<RegimentViewModel>(Get.context!,
                                    listen: false)
                                .cachedEvents = [];
                            Get.back();
                            await Provider.of<RegimentViewModel>(context,
                                    listen: false)
                                .fetchRegimentData();
                          }
                        },
                        color: Color(CommonUtil().getMyPrimaryColor()),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              5.0.sp,
                            ),
                          ),
                        ),
                        child: Text(
                          okButton,
                          style: TextStyle(
                            fontSize: 16.0.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      if ((returnAction?.action == startActivity) &&
                          (returnAction?.eid != null) &&
                          (returnAction?.activityName != ''))
                        Padding(
                          padding: EdgeInsets.only(
                            left: 20.0.w,
                          ),
                          child: RaisedButton(
                            onPressed: () async {
                              Provider.of<RegimentViewModel>(Get.context!,
                                      listen: false)
                                  .cachedEvents = [];
                              Get.back();
                              await Provider.of<RegimentViewModel>(context,
                                      listen: false)
                                  .fetchRegimentData();
                            },
                            color: Color(CommonUtil().getMyPrimaryColor()),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  5.0.sp,
                                ),
                              ),
                            ),
                            child: Text(
                              laterButton,
                              style: TextStyle(
                                fontSize: 16.0.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  if ((returnAction?.eid == null) &&
                      (returnAction?.activityName == ''))
                    AutoCloseText(needReload: true),
                ],
              ),
            ),
            contentPadding: EdgeInsets.only(
              top: 0.0.h,
              left: 10.0.w,
              right: 10.0.w,
              bottom: 10.0.w,
            ),
          ),
        ),
      );
    } else {
      Provider.of<RegimentViewModel>(Get.context!, listen: false).cachedEvents =
          [];
      Future.delayed(Duration(milliseconds: 300), () async {
        await Provider.of<RegimentViewModel>(Get.context!, listen: false)
            .fetchRegimentData();
        //LoaderClass.hideLoadingDialog(Get.context);
      });
      //LoaderClass.hideLoadingDialog(Get.context);
    }
  }

  String? getNameFromTitle(RegimentDataModel regimentData) {
    String? name = '';
    name = (regimentData?.activityOrgin == strAppointmentRegimen)
        ? regimentData?.doctorSessionId != null
            ? 'Dr. ' + title?.trim()
            : title?.trim()
        : title?.trim();

    return name;
  }
}
