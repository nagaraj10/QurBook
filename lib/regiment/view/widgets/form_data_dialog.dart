import 'dart:async';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/FlatButton.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myfhb/Qurhome/Loaders/loader_qurhome.dart';
import 'package:myfhb/authentication/constants/constants.dart';
import 'package:myfhb/constants/router_variable.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/regiment/service/regiment_service.dart';
import 'package:myfhb/src/ui/SheelaAI/Models/sheela_arguments.dart';
import 'package:myfhb/src/ui/audio/AudioRecorder.dart';
import 'package:myfhb/src/utils/ImageViewer.dart';
import 'package:provider/provider.dart';

import '../../../common/CommonUtil.dart';
import '../../../common/PreferenceUtil.dart';
import '../../../constants/fhb_constants.dart';
import '../../../constants/fhb_constants.dart' as Constants;
import '../../../constants/fhb_query.dart';
import '../../../main.dart';
import '../../../src/resources/network/ApiBaseHelper.dart';
import '../../../src/ui/audio/AudioScreenArguments.dart';
import '../../../src/ui/loader_class.dart';
import '../../../src/utils/screenutils/size_extensions.dart';
import '../../models/field_response_model.dart';
import '../../models/regiment_data_model.dart';
import '../../models/save_response_model.dart';
import '../../view_model/AddRegimentModel.dart';
import '../../view_model/pickImageController.dart';
import '../../view_model/regiment_view_model.dart';
import 'AutoCloseText.dart';
import 'form_field_widget.dart';
import 'media_icon_widget.dart';

class FormDataDialog extends StatefulWidget {
  FormDataDialog({
    required this.fieldsData,
    required this.eid,
    required this.color,
    required this.mediaData,
    required this.formTitle,
    required this.canEdit,
    required this.triggerAction,
    required this.introText,
    this.isFollowEvent,
    this.followEventContext,
    this.isFromQurHomeSymptom = false,
    this.isFromQurHomeRegimen = false,
    @required this.providerId,
    this.uformData,
    this.showEditIcon,
    this.fromView = false,
    this.appBarTitle,
    this.regimen,
    this.isReadOnly = false,
  });

  final List<FieldModel>? fieldsData;
  final String? eid;
  final Color color;
  final Otherinfo? mediaData;
  final String? formTitle;
  bool canEdit;
  bool? showEditIcon;
  bool? fromView;
  final Function(String? eventId, String? followContext, String? activityName)
      triggerAction;
  final bool? isFollowEvent;
  final bool isFromQurHomeSymptom;
  final bool isFromQurHomeRegimen;
  final String? followEventContext;
  final String? providerId;
  final String introText;
  final UformData? uformData;
  final String? appBarTitle;
  final RegimentDataModel? regimen;
  final bool isReadOnly;

  @override
  State<StatefulWidget> createState() => FormDataDialogState();
}

class FormDataDialogState extends State<FormDataDialog> {
  List<FieldModel>? fieldsData;

  String? eid;
  Color? color;
  Otherinfo? mediaData;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String videoFileName = 'Add Video';
  String audioFileName = 'Add Audio';
  String imageFileName = 'Add Image';
  String docFileName = 'Add File';

  String imagePaths = '';

  final ApiBaseHelper _helper = ApiBaseHelper();
  Map<String, dynamic> saveMap = {};
  ValueNotifier isUploading = ValueNotifier(false);

  String timeText = '';
  TimeOfDay? _currentTime = TimeOfDay.now();

  DateTime? initDate;
  String? providerId;

  var saveResponse;

  var actvityStatus = '';
  bool isTouched = true;
  bool isSettingChanged = false;
  bool isUpdatePressed = false;

  VitalsData? vitalData;
  VitalsData? vitalDataClone;

  bool isFirstTimeUpdate = true; // Flag to indicate if this is the first time update is being performed

  @override
  void initState() {
    super.initState();
    widget.fieldsData?.sort(
      (a, b) => intOrStringValue(
        a.seq,
      ).compareTo(
        intOrStringValue(
          b.seq,
        ),
      ),
    );
    if ((widget.fieldsData?.length ?? 0) > 1 && CommonUtil.isUSRegion()) {
      widget.fieldsData?.forEach((fieldData) {
        String strSeq =
            CommonUtil().validString((fieldData.seq ?? 0).toString());
        if (strSeq != null && strSeq != '0' && strSeq.trim().isNotEmpty) {
          String desc = CommonUtil().showDescriptionTextForm(fieldData);
          if (desc != null && desc.trim().isNotEmpty) {
            desc = strSeq + ". " + desc;
            fieldData.description = desc;
          }
        }
      });
    }

    fieldsData = widget.fieldsData;
    eid = widget.eid;
    color = widget.color;
    mediaData = widget.mediaData;
    providerId = widget.providerId;

    if (eid != null && eid != '') {
      RegimentService.getActivityStatus(eid: eid!).then((value) {
        if (value.isSuccess ?? false) {
          actvityStatus = value.result![0].planStatus ?? '';
        }
      });
    }
  }

  int intOrStringValue(dynamic o) {
    if (o == null) {
      return 0;
    }
    var result = 0;
    if (o is String) {
      result = int.tryParse(o) ?? 0;
    } else if (o is int) {
      result = o;
    }
    return result;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if this is the first time update is being performed
    if (isFirstTimeUpdate) {
      isFirstTimeUpdate = false;
      initDate = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
      setCurrentTime();
    }
    return widget.isFromQurHomeRegimen
        ? WillPopScope(
            onWillPop: () async {
              isTouched
                  ? isSettingChanged
                      ? _onWillPop()
                      : Get.back(result: false)
                  : Get.back(result: false);

              return Future.value(true);
            },
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: mAppThemeProvider.qurHomePrimaryColor,
                toolbarHeight: CommonUtil().isTablet! ? 110.00 : null,
                elevation: 0,
                centerTitle: false,
                titleSpacing: 0,
                title: Text(
                  widget.appBarTitle ?? '',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.fade,
                  maxLines: 2,
                ),
                leading: IconWidget(
                  icon: Icons.arrow_back_ios,
                  colors: Colors.white,
                  size: CommonUtil().isTablet! ? 38.0 : 24.0,
                  onTap: () {
                    isTouched
                        ? isSettingChanged
                            ? _onWillPop()
                            : Get.back(result: false)
                        : Get.back(result: false);
                  },
                ),
              ),
              body: Container(
                padding: EdgeInsets.only(
                  top: 5.0.h,
                  left: 15.0.w,
                  right: 15.0.w,
                  //bottom: 15.0.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.formTitle ?? '',
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.fade,
                            maxLines: 2,
                            style: TextStyle(
                                color: mAppThemeProvider.qurHomePrimaryColor,
                                fontSize: 18.h),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            try {
                              if (widget.regimen?.activityOrgin == strSurvey) {
                                redirectToSheelaScreen(widget.regimen,
                                    isSurvey: true, isRetakeSurvey: true);
                                return;
                              }

                              setState(() {
                                widget.canEdit = true;
                                widget.fromView = false;
                              });
                            } catch (e, stackTrace) {
                              CommonUtil()
                                  .appLogs(message: e, stackTrace: stackTrace);
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: 7.0.w,
                            ),
                            child: (widget.fromView! &&
                                    !widget.isReadOnly)
                                ? Image.asset(
                                    icon_edit,
                                    height: 20.sp,
                                    width: 20.sp,
                                    color: Colors.black,
                                  )
                                : Container(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      widget.introText ?? '',
                      maxLines: 10,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                          color: mAppThemeProvider.qurHomePrimaryColor,
                          fontSize: 18.h),
                    ),
                    if ((widget.introText ?? '').trim().isNotEmpty)
                      SizedBox(height: 5.0)
                    else
                      SizedBox.shrink(),
                    Expanded(child: getBody()),
                  ],
                ),
              ),
              floatingActionButton:
                  !widget.isReadOnly
                      ? onSaveBtn()
                      : onBackBtn(),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
            ),
          )
        : AlertDialog(
            title: getTitle(),
            titlePadding: EdgeInsets.only(
              top: 10.0.h,
              right: 5.0.w,
              left: 15.0.w,
              bottom: 10.0.h,
            ),
            content: getBody(),
            contentPadding: EdgeInsets.only(
              top: 0.0.h,
              left: 10.0.w,
              right: 10.0.w,
              bottom: 10.0.w,
            ),
          );
  }

  getBody() {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Container(
        width: widget.isFromQurHomeRegimen ? double.infinity : 0.75.sw,
        child: getListView(),
      );
    });
  }

  getListView() {
    int indexTemp = 0;
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.only(bottom: widget.isFromQurHomeRegimen ? 100 : 0),
      children: [
        Container(
          width: widget.isFromQurHomeRegimen ? double.infinity : 0.75.sw,
          padding: EdgeInsets.only(
            bottom: 10.0.h,
            left: 10.0.w,
            right: 10.0.w,
          ),
          child: Form(
            key: _formKey,
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(
                bottom: 10.0.h,
                top: 0.0.h,
              ),
              physics: NeverScrollableScrollPhysics(),
              itemCount: fieldsData!.length,
              itemBuilder: (context, index) {
                bool isVisible = false;
                VitalsData? vitalsDataParam = getVitalsData(
                    widget.uformData?.vitalsData!, fieldsData![index]);
                if (((widget.regimen?.activityOrgin ?? "") == strSurvey) &&
                    (vitalsDataParam != null) &&
                    (CommonUtil()
                        .validString(vitalsDataParam.value ?? "")
                        .trim()
                        .isNotEmpty)) {
                  isVisible = true;
                  FieldModel fieldData = fieldsData![index];
                  String strTitle =
                      CommonUtil().showDescriptionTextForm(fieldData);
                  if (strTitle.contains(".")) {
                    indexTemp++;
                    String strTitleTemp = strTitle.split(".").last;
                    strTitleTemp = "$indexTemp.$strTitleTemp";
                    fieldData.strTitleDesc = strTitleTemp;
                    fieldData.isSurvey = true;
                  }
                }
                return ((widget.regimen?.activityOrgin ?? "") == strSurvey)
                    ? isVisible
                        ? getView(vitalsDataParam, index)
                        : SizedBox.shrink()
                    : getView(vitalsDataParam, index);
              },
            ),
          ),
        ),
        if (widget.isReadOnly) getNoteBox() else const SizedBox.shrink(),
        Container(
          width: widget.isFromQurHomeRegimen ? double.infinity : 0.75.sw,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: mediaData!.needPhoto == '1',
                child: InkWell(
                  onTap: widget.canEdit
                      ? () {
                          _showSelectionDialog(context);
                        }
                      : () {
                          var imageUrl;
                          widget.uformData?.vitalsData?.forEach((vital) {
                            if ((vital.photo?.url ?? "").isNotEmpty) {
                              imageUrl = vital.photo?.url;
                            }
                          });

                          if (imageUrl != null)
                            Get.to(
                              () =>
                                  ImageViewer(imageUrl, eid, widget.providerId),
                            );
                        },
                  child: ValueListenableBuilder(
                    valueListenable: isUploading,
                    builder: (contxt, dynamic val, child) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MediaIconWidget(
                            color: color,
                            icon: Icons.camera_alt,
                            padding: 10.0.sp,
                          ),
                          Expanded(
                            child: SizedBox(
                              //width: 250.0.w,
                              child: Text(
                                widget.canEdit ? imageFileName : "View Image",
                                style: TextStyle(
                                  fontSize: 14.0.sp,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ),
                          ),
                          val
                              ? SizedBox(
                                  width: 20.0.w,
                                  height: 18.0.h,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: widget.isFromQurHomeSymptom ||
                                            widget.isFromQurHomeRegimen
                                        ? mAppThemeProvider.qurHomePrimaryColor
                                        : mAppThemeProvider.primaryColor,
                                  ),
                                )
                              : SizedBox.shrink(),
                          SizedBox(
                            width: 5,
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
              Visibility(
                visible: mediaData!.needAudio == '1',
                child: InkWell(
                  onTap: widget.canEdit
                      ? () {
                          Navigator.of(context)
                              .push(
                            MaterialPageRoute(
                              builder: (context) => AudioRecorder(
                                arguments: AudioScreenArguments(
                                  fromVoice: false,
                                ),
                              ),
                            ),
                          )
                              .then((results) {
                            final String? audioPath =
                                results[Constants.keyAudioFile];
                            if (audioPath != null && audioPath != '') {
                              imagePaths = audioPath;
                              setState(() {
                                audioFileName = strUploading;
                              });
                              if (imagePaths != null && imagePaths != '') {
                                saveMediaRegiment(imagePaths, providerId)
                                    .then((value) {
                                  if (value.isSuccess!) {
                                    setState(() {
                                      audioFileName = audioPath.split('/').last;
                                    });
                                    final oldValue = saveMap.putIfAbsent(
                                      'audio',
                                      () => value.result!.accessUrl,
                                    );
                                    if (oldValue != null) {
                                      saveMap['audio'] =
                                          value.result!.accessUrl;
                                    }
                                  } else {
                                    setState(() {
                                      audioFileName = 'Add Audio';
                                    });
                                  }
                                });
                              }
                            }
                          });
                        }
                      : null,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MediaIconWidget(
                        color: color,
                        icon: Icons.mic,
                        padding: 10.0.sp,
                      ),
                      SizedBox(
                        width: 250.0.w,
                        child: Text(
                          audioFileName,
                          style: TextStyle(
                            fontSize: 14.0.sp,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: mediaData!.needVideo == '1',
                child: InkWell(
                  onTap: widget.canEdit
                      ? () {
                          getOpenGallery(strVideo);
                        }
                      : null,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MediaIconWidget(
                        color: color,
                        icon: Icons.videocam,
                        padding: 10.0.sp,
                      ),
                      SizedBox(
                        width: 250.0.w,
                        child: Text(
                          videoFileName,
                          style: TextStyle(
                            fontSize: 14.0.sp,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: mediaData!.needFile == '1',
                child: InkWell(
                  onTap: widget.canEdit
                      ? () {
                          getOpenGallery(strFiles);
                        }
                      : null,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MediaIconWidget(
                        color: color,
                        icon: Icons.attach_file,
                        padding: 10.0.sp,
                      ),
                      SizedBox(
                        width: 250.0.w,
                        child: Text(
                          docFileName,
                          style: TextStyle(
                            fontSize: 14.0.sp,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
            width: widget.isFromQurHomeRegimen ? double.infinity : 0.75.sw,
            padding: EdgeInsets.only(
              bottom: 4.0.h,
              left: 10.0.w,
              right: 10.0.w,
            ),
            child: Visibility(
              child: Text(
                CommonUtil().getErrorMessage(widget?.regimen, context),
                style: TextStyle(
                  fontSize: 14.0.sp,
                  color: Colors.red[500],
                ),
              ),
              visible: getVisibility(),
            )),
        if (Provider.of<RegimentViewModel>(context, listen: false)
                .regimentFilter ==
            RegimentFilter.AsNeeded)
          Container(
            child: Column(
              children: [
                InkWell(
                  onTap: () async {
                    initDate = await selectDate(context, initDate!);
                    setState(() {});
                  },
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: 4.w),
                        Text(
                          'Select Date:',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: widget.isFromQurHomeSymptom ||
                                    widget.isFromQurHomeRegimen
                                ? mAppThemeProvider.qurHomePrimaryColor
                                : mAppThemeProvider.primaryColor,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.calendar_today, size: 16.sp),
                          onPressed: () async {
                            initDate = await selectDate(context, initDate!);
                            setState(() {});
                          },
                        ),
                        Text(
                          '${CommonUtil.dateConversionToApiFormat(initDate!)}',
                          style: TextStyle(fontSize: 15.sp),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    timeText = await selectTime(context);
                    setState(() {});
                  },
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: 4.w),
                        Text(
                          'Select Time:',
                          style: TextStyle(
                              fontSize: 14.sp,
                              color: widget.isFromQurHomeSymptom ||
                                      widget.isFromQurHomeRegimen
                                  ? mAppThemeProvider.qurHomePrimaryColor
                                  : mAppThemeProvider.primaryColor),
                        ),
                        IconButton(
                          icon: Icon(Icons.access_time, size: 16.sp),
                          onPressed: () async {
                            timeText = await selectTime(context);
                            setState(() {});
                          },
                        ),
                        Text(
                          timeText,
                          style: TextStyle(fontSize: 15.sp),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        widget.isFromQurHomeRegimen ? SizedBox.shrink() : onSaveBtn(),
      ],
    );
  }

  /// Returns a dotted border widget containing a note text.
  /// The note indicates that provider-based patients have view-only access.
  Widget getNoteBox() => Padding(
        padding: const EdgeInsets.all(12),
        child: DottedBorder(
          borderType: BorderType.RRect,
          color: Colors.grey,
          padding: const EdgeInsets.all(10),
          radius: const Radius.circular(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                Constants.strNote,
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  Constants.strProviderBasedPatientsHaveViewOnlyAccess,
                  style: TextStyle(fontSize: 12.sp),
                ),
              )
            ],
          ),
        ),
      );

  Widget onSaveBtn() {
    return Container(
      width: widget.isFromQurHomeRegimen ? double.infinity : 0.75.sw,
      margin: EdgeInsets.only(
        bottom: widget.isFromQurHomeRegimen ? 5.0.h : 0.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ValueListenableBuilder(
              valueListenable: isUploading,
              builder: (contxt, val, child) {
                return ElevatedButton(
                    onPressed: val == false
                        ? () async {
                            commonSaveMethod();
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.fromView!
                          ? Colors.grey
                          : widget.isFromQurHomeSymptom ||
                                  widget.isFromQurHomeRegimen
                              ? mAppThemeProvider.qurHomePrimaryColor
                              : mAppThemeProvider.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            5.0.sp,
                          ),
                        ),
                      ),
                    ),
                    child: Text(
                      saveButton,
                      style: TextStyle(
                        fontSize: 16.0.sp,
                        color: Colors.white,
                      ),
                    ));
              }),
        ],
      ),
    );
  }

  Widget onBackBtn() {
    return Container(
      width: widget.isFromQurHomeRegimen ? double.infinity : 0.75.sw,
      margin: EdgeInsets.only(
        bottom: widget.isFromQurHomeRegimen ? 5.0.h : 0.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () {
                Get.back(result: false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.fromView!
                    ? Colors.grey
                    : widget.isFromQurHomeSymptom || widget.isFromQurHomeRegimen
                        ? mAppThemeProvider.qurHomePrimaryColor
                        : mAppThemeProvider.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      5.0.sp,
                    ),
                  ),
                ),
              ),
              child: Text(
                strBack,
                style: TextStyle(
                  fontSize: 16.0.sp,
                  color: Colors.white,
                ),
              ))
        ],
      ),
    );
  }

  clickSaveButton() async {
    var events = '';
    saveMap.forEach((key, value) {
      events += '&$key=$value';
      var provider = Provider.of<RegimentViewModel>(context, listen: false);
      provider.cachedEvents.removeWhere((element) => element.contains(key));
      provider.cachedEvents.add('&$key=$value'.toString());
    });
    if (widget.isFromQurHomeSymptom || widget.isFromQurHomeRegimen) {
      LoaderQurHome.showLoadingDialog(
        Get.context!,
        canDismiss: false,
      );
    } else {
      LoaderClass.showLoadingDialog(
        Get.context!,
        canDismiss: false,
      );
    }

    final saveResponse =
        await Provider.of<RegimentViewModel>(context, listen: false)
            .saveFormData(
      eid: eid,
      events: events,
      isFollowEvent: widget.isFollowEvent,
      followEventContext: widget.followEventContext,
      selectedDate: initDate,
      selectedTime: _currentTime,
    );
    if (saveResponse.isSuccess ?? false) {
      if (widget.isFromQurHomeSymptom || widget.isFromQurHomeRegimen) {
        LoaderQurHome.hideLoadingDialog(Get.context!);
      } else {
        LoaderClass.hideLoadingDialog(Get.context!);
      }
      if (Provider.of<RegimentViewModel>(context, listen: false)
              .regimentStatus ==
          RegimentStatus.DialogOpened) {
        Navigator.pop(context, true);
      } else if (widget.isFromQurHomeRegimen) {
        Get.back(result: true);
        if (isUpdatePressed) Navigator.pop(context, true);
      }
      checkForReturnActions(
        returnAction: saveResponse.result?.actions?.returnData,
      );
    }
  }

  Widget getTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                widget.formTitle!,
                style: TextStyle(
                  fontSize: 16.0.sp,
                ),
                overflow: TextOverflow.fade,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.close,
                size: 24.0.sp,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        Text(
          widget.introText,
          maxLines: 10,
          style: TextStyle(color: Colors.black, fontSize: 16.h),
        ),
      ],
    );
  }

  checkForReturnActions({
    ReturnModel? returnAction,
  }) async {
    if ((returnAction?.action ?? '').isNotEmpty &&
        (returnAction?.message ?? '').isNotEmpty) {
      await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return WillPopScope(
              onWillPop: () async {
                Provider.of<RegimentViewModel>(Get.context!, listen: false)
                    .cachedEvents = [];
                Get.back();
                return true;
              },
              child: AlertDialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.close,
                          size: 24.0.sp,
                        ),
                        onPressed: () {
                          Provider.of<RegimentViewModel>(Get.context!,
                                  listen: false)
                              .cachedEvents = [];
                          Navigator.pop(context);
                        }),
                  ],
                ),
                titlePadding: EdgeInsets.only(
                  top: 10.0.h,
                  right: 5.0.w,
                  left: 15.0.w,
                ),
                content: Container(
                  width:
                      widget.isFromQurHomeRegimen ? double.infinity : 0.75.sw,
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
                          ElevatedButton(
                            onPressed: () {
                              if (returnAction?.eid != null &&
                                  (returnAction?.action ?? '') ==
                                      startActivity) {
                                if (returnAction?.activityName == '' ||
                                    returnAction?.activityName == null) {
                                  Provider.of<RegimentViewModel>(Get.context!,
                                          listen: false)
                                      .cachedEvents = [];
                                }
                                widget.triggerAction(
                                  returnAction?.eid,
                                  returnAction?.context,
                                  returnAction?.activityName,
                                );
                              } else {
                                Provider.of<RegimentViewModel>(Get.context!,
                                        listen: false)
                                    .cachedEvents = [];
                                Get.back();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.isFromQurHomeSymptom ||
                                      widget.isFromQurHomeRegimen
                                  ? mAppThemeProvider.qurHomePrimaryColor
                                  : mAppThemeProvider.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    5.0.sp,
                                  ),
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
                          getLaterButton(returnAction)!,
                        ],
                      ),
                      SizedBox(height: 5.h),
                      if ((returnAction?.eid == null) &&
                          (returnAction?.activityName == ''))
                        AutoCloseText(),
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
            );
          });
    } else {
      Provider.of<RegimentViewModel>(Get.context!, listen: false).cachedEvents =
          [];
    }
  }

  Widget? getLaterButton(ReturnModel? returnAction) {
    if ((returnAction?.eid != null) && (returnAction?.activityName != '')) {
      if (returnAction?.action == startActivity) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20.0.w,
          ),
          child: ElevatedButton(
            onPressed: () {
              Provider.of<RegimentViewModel>(Get.context!, listen: false)
                  .cachedEvents = [];
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  widget.isFromQurHomeSymptom || widget.isFromQurHomeRegimen
                      ? mAppThemeProvider.qurHomePrimaryColor
                      : mAppThemeProvider.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    5.0.sp,
                  ),
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
        );
      }
    } else {
      return SizedBox.shrink();
    }
  }

  Future<AddMediaRegimentModel> saveMediaRegiment(
      String imagePaths, String? providerId) async {
    var patientId = PreferenceUtil.getStringValue(Constants.KEY_USERID);

    final response = await _helper.saveRegimentMedia(
        qr_save_regi_media, imagePaths, patientId, providerId);
    return AddMediaRegimentModel.fromJson(response);
  }

  void getOpenGallery(String fromPath) {
    PickImageController.instance
        .cropImageFromFile(fromPath)
        .then((croppedFile) {
      if (croppedFile != null) {
        setState(() {
          if (fromPath == strGallery) {
            isUploading.value = true;
            imageFileName = strUploading;
          } else if (fromPath == strFiles) {
            docFileName = strUploading;
          } else if (fromPath == strVideo) {
            videoFileName = strUploading;
          } else if (fromPath == strAudio) {
            audioFileName = strUploading;
          }
        });
        imagePaths = croppedFile.path;

        if (imagePaths != null && imagePaths != '') {
          saveMediaRegiment(imagePaths, providerId).then((value) {
            if (value.isSuccess!) {
              var file = File(croppedFile.path);
              setState(() {
                if (fromPath == strGallery) {
                  isUploading.value = false;
                  imageFileName = file.path.split('/').last;
                } else if (fromPath == strFiles) {
                  docFileName = file.path.split('/').last;
                } else if (fromPath == strVideo) {
                  videoFileName = file.path.split('/').last;
                } else if (fromPath == strAudio) {
                  audioFileName = file.path.split('/').last;
                }
              });

              final oldValue = saveMap.putIfAbsent(
                fromPath,
                () => value.result!.accessUrl,
              );
              if (oldValue != null) {
                saveMap[fromPath] = value.result!.accessUrl;
              }
            } else {
              setState(() {
                if (fromPath == strGallery) {
                  isUploading.value = false;
                  imageFileName = 'Add Image';
                } else if (fromPath == strFiles) {
                  docFileName = 'Add File';
                } else if (fromPath == strVideo) {
                  videoFileName = 'Add Video';
                } else if (fromPath == strAudio) {
                  audioFileName = 'Add Audio';
                }
              });
            }
          });
        }
      }
    });
  }

  imgFromCamera(String fromPath) async {
    late File _image;
    var picker = ImagePicker();
    var pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        isUploading.value = true;
        imageFileName = strUploading;
        _image = File(pickedFile.path);
        imagePaths = _image.path;
      }
    });
    if (imagePaths != null && imagePaths != '') {
      await saveMediaRegiment(imagePaths, providerId).then((value) {
        if (value.isSuccess!) {
          isUploading.value = false;
          setState(() {
            imageFileName = _image.path.split('/').last;
          });

          final oldValue = saveMap.putIfAbsent(
            fromPath,
            () => value.result!.accessUrl,
          );
          if (oldValue != null) {
            saveMap[fromPath] = value.result!.accessUrl;
          }
        } else {
          isUploading.value = false;
          imageFileName = 'Add Image';
        }
      });
    }
  }

  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Choose an action'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        getOpenGallery(strGallery);
                        Navigator.of(context).pop();
                      },
                      child: Text("Gallery"),
                    ),
                    Padding(padding: EdgeInsets.all(8)),
                    GestureDetector(
                      child: Text('Camera'),
                      onTap: () {
                        imgFromCamera(strGallery);
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              ));
        });
  }

  Future<DateTime> selectDate(BuildContext context, DateTime _date) async {
    DateTime firstDate;

    firstDate = DateTime(
        DateTime.now().year, DateTime.now().month - 1, DateTime.now().day);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: firstDate,
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      _date = picked;
    }
    return _date;
  }

  Future<String> selectTime(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: _currentTime!,
    );

    _currentTime = selectedTime;
    print(_currentTime);

    MaterialLocalizations localizations = MaterialLocalizations.of(context);
    if (selectedTime != null) {
      String formattedTime = localizations.formatTimeOfDay(selectedTime,
          alwaysUse24HourFormat: false);
      if (formattedTime != null) {
        timeText = formattedTime;
      }
    }
    return timeText;
  }

  void setCurrentTime() {
    TimeOfDay selectedTime = TimeOfDay.now();
    MaterialLocalizations localizations = MaterialLocalizations.of(context);
    String formattedTime = localizations.formatTimeOfDay(selectedTime,
        alwaysUse24HourFormat: false);
    if (formattedTime != null) {
      timeText = formattedTime;
    }
  }

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(strConfirms),
        content: Text(strUpdateMsg),
        actions: <Widget>[
          FlatButtonWidget(
            bgColor: Colors.transparent,
            isSelected: true,
            onPress: () => closeDialog(),
            title: strNO,
          ),
          FlatButtonWidget(
            bgColor: Colors.transparent,
            isSelected: true,
            onPress: () {
              isUpdatePressed = true;
              commonSaveMethod();
            },
            title: strYES,
          ),
        ],
      ),
    ).then((value) => value as bool);
  }

  closeDialog() {
    Navigator.of(context).pop();
    Get.back();
  }

  getVitalsData(List<VitalsData>? vitalsData, FieldModel fieldModel) {
    try {
      if (vitalsData != null && vitalsData.length > 0) {
        for (VitalsData? vitalsDataObj in vitalsData!) {
          if (vitalsDataObj?.vitalName == fieldModel.title)
            return vitalsDataObj;
        }
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      return null;
    }
  }

  getVisibility() {
    if (widget.showEditIcon == true || widget.fromView!) {
      return false;
    } else {
      if (widget.canEdit) {
        return false;
      } else {
        return true;
      }
    }
  }

  redirectToSheelaScreen(RegimentDataModel? regimen,
      {bool isSurvey = false, bool isRetakeSurvey = false}) {
    try {
      Get.toNamed(
        rt_Sheela,
        arguments: SheelaArgument(
            eId: regimen?.eid ?? "",
            isSurvey: isSurvey,
            fromRegimenByTap: true, // for this is from regimen while tap on card or sheela icon
            isRetakeSurvey: isRetakeSurvey),
      )?.then((value) {
        Get.back(result: true);
        if (isUpdatePressed) Navigator.pop(context, true);
      });
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  getView(VitalsData? vitalsDataParam, int index) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 10.0.h,
      ),
      child: FormFieldWidget(
        canEdit: widget.isReadOnly ? false : widget.canEdit,
        fieldData: fieldsData![index],
        vitalsData: vitalsDataParam,
        isFromQurHomeRegimen: widget.isFromQurHomeRegimen,
        isFromQurHomeSymptom:
            widget.isFromQurHomeSymptom || widget.isFromQurHomeRegimen,
        isChanged: (settings) {
          isSettingChanged = settings;
        },
        updateValue: (
          updatedFieldData, {
          isAdd,
          title,
        }) {
          if (isAdd == null || isAdd) {
            isAdd = isAdd ?? false;
            final oldValue = saveMap.putIfAbsent(
              isAdd
                  ? 'pf_$title'
                  : 'pf_${updatedFieldData.title}',
              () => updatedFieldData.value,
            );
            if (oldValue != null) {
              saveMap[isAdd
                      ? 'pf_$title'
                      : 'pf_${updatedFieldData.title}'] =
                  updatedFieldData.value;
            }
          } else {
            saveMap.remove('pf_$title');
          }
        },
      ),
    );
  }

  void commonSaveMethod() {
    if (widget.fromView!) {
    } else if (widget.canEdit) {
      if (_formKey.currentState!.validate()) {
        if (actvityStatus == UnSubscribed || actvityStatus == Expired) {
          var message =
              (actvityStatus == UnSubscribed) ? UnSubscribed : Expired;
          CommonUtil().showDialogForActivityStatus(
              'Plan $message, $msgData', context, pressOk: () {
            Get.back();
            clickSaveButton();
          });
        } else {
          clickSaveButton();
        }
      }
    } else {
      FlutterToast().getToast(
        CommonUtil().getErrorMessage(widget?.regimen, context),
        Colors.red,
      );
    }
  }
}
