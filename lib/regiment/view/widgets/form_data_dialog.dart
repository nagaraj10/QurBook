import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myfhb/Qurhome/Loaders/loader_qurhome.dart';
import 'package:myfhb/regiment/service/regiment_service.dart';
import 'package:myfhb/reminders/QurPlanReminders.dart';
import 'package:myfhb/src/ui/audio/AudioRecorder.dart';
import 'package:provider/provider.dart';

import '../../../common/CommonUtil.dart';
import '../../../common/PreferenceUtil.dart';
import '../../../constants/fhb_constants.dart';
import '../../../constants/fhb_constants.dart' as Constants;
import '../../../constants/fhb_query.dart';
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
  FormDataDialog(
      {required this.fieldsData,
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
      this.providerId});

  final List<FieldModel>? fieldsData;
  final String? eid;
  final Color color;
  final Otherinfo? mediaData;
  final String? formTitle;
  final bool canEdit;
  final Function(String? eventId, String? followContext, String? activityName)
      triggerAction;
  final bool? isFollowEvent;
  final bool isFromQurHomeSymptom;
  final bool isFromQurHomeRegimen;
  final String? followEventContext;
  final String? providerId;
  final String introText;

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
  TimeOfDay? _currentTime = new TimeOfDay.now();

  DateTime? initDate;
  String? providerId;

  var saveResponse;

  var actvityStatus = '';

  @override
  void initState() {
    super.initState();
    try {
      widget.fieldsData?.sort((a, b) => (a.seq ?? 0).compareTo(b.seq ?? 0));
    } catch (e) {}
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    setCurrentTime();
    return widget.isFromQurHomeRegimen
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Color(CommonUtil().getQurhomePrimaryColor()),
              toolbarHeight: CommonUtil().isTablet! ? 110.00 : null,
              elevation: 0,
              centerTitle: false,
              titleSpacing: 0,
              title: Flexible(
                child: Text(
                  widget.formTitle!,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              leading: IconWidget(
                icon: Icons.arrow_back_ios,
                colors: Colors.white,
                size: CommonUtil().isTablet! ? 38.0 : 24.0,
                onTap: () {
                  Get.back(result: false);
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
                  Text(
                    widget.introText,
                    maxLines: 10,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                        color: Color(CommonUtil().getQurhomePrimaryColor()),
                        fontSize: 18.h),
                  ),
                  if ((widget.introText).trim().isNotEmpty)
                    SizedBox(height: 5.0)
                  else
                    SizedBox.shrink(),
                  Expanded(child: getBody()),
                ],
              ),
            ),
            floatingActionButton: onSaveBtn(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
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
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.only(
          bottom: widget.isFromQurHomeRegimen ? 100 : 0),
      children: [
        Container(
          width:
              widget.isFromQurHomeRegimen ? double.infinity : 0.75.sw,
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
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: 10.0.h,
                  ),
                  child: FormFieldWidget(
                    canEdit: widget.canEdit,
                    fieldData: fieldsData![index],
                    isFromQurHomeRegimen: widget.isFromQurHomeRegimen,
                    isFromQurHomeSymptom: widget.isFromQurHomeSymptom ||
                        widget.isFromQurHomeRegimen,
                    updateValue: (
                      updatedFieldData, {
                      isAdd,
                      title,
                    }) {
                      if (isAdd == null || isAdd) {
                        isAdd = isAdd ?? false;
                        final oldValue = saveMap.putIfAbsent(
                          isAdd ? 'pf_$title' : 'pf_${updatedFieldData.title}',
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
              },
            ),
          ),
        ),
        Container(
          width:
              widget.isFromQurHomeRegimen ? double.infinity : 0.75.sw,
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
                      : null,
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
                                imageFileName,
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
                                        ? Color(CommonUtil()
                                            .getQurhomePrimaryColor())
                                        : Color(
                                            CommonUtil().getMyPrimaryColor()),
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
            width: widget.isFromQurHomeRegimen
                ? double.infinity
                : 0.75.sw,
            padding: EdgeInsets.only(
              bottom: 4.0.h,
              left: 10.0.w,
              right: 10.0.w,
            ),
            child: Visibility(
              child: Text(
                (Provider.of<RegimentViewModel>(context, listen: false)
                            .regimentMode ==
                        RegimentMode.Symptoms)
                    ? symptomsError
                    : activitiesError,
                style: TextStyle(
                  fontSize: 14.0.sp,
                  color: Colors.red[500],
                ),
              ),
              visible: widget.canEdit ? false : true,
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
                                ? Color(CommonUtil().getQurhomePrimaryColor())
                                : Color(CommonUtil().getMyPrimaryColor()),
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
                                  ? Color(CommonUtil().getQurhomePrimaryColor())
                                  : Color(CommonUtil().getMyPrimaryColor())),
                        ),
                        IconButton(
                          icon: Icon(Icons.access_time, size: 16.sp),
                          onPressed: () async {
                            timeText = await selectTime(context);
                            setState(() {});
                          },
                        ),
                        Text(
                          '${timeText}',
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
                return RaisedButton(
                    onPressed: val == false
                        ? () async {
                            if (widget.canEdit) {
                              if (_formKey.currentState!.validate()) {
                                if (actvityStatus == UnSubscribed ||
                                    actvityStatus == Expired) {
                                  var message = (actvityStatus == UnSubscribed)
                                      ? UnSubscribed
                                      : Expired;
                                  CommonUtil().showDialogForActivityStatus(
                                      'Plan $message, $msgData', context,
                                      pressOk: () {
                                    Get.back();
                                    clickSaveButton();
                                  });
                                } else {
                                  clickSaveButton();
                                }
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
                          }
                        : null,
                    color: widget.isFromQurHomeSymptom ||
                            widget.isFromQurHomeRegimen
                        ? Color(CommonUtil().getQurhomePrimaryColor())
                        : Color(CommonUtil().getMyPrimaryColor()),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(
                        5.0.sp,
                      )),
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
      QurPlanReminders.getTheRemindersFromAPI();
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
              onWillPop: () {
                Provider.of<RegimentViewModel>(Get.context!, listen: false)
                    .cachedEvents = [];
                Get.back();
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
                  width: widget.isFromQurHomeRegimen
                      ? double.infinity
                      : 0.75.sw,
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
                            color: widget.isFromQurHomeSymptom ||
                                    widget.isFromQurHomeRegimen
                                ? Color(CommonUtil().getQurhomePrimaryColor())
                                : Color(CommonUtil().getMyPrimaryColor()),
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
          child: RaisedButton(
            onPressed: () {
              Provider.of<RegimentViewModel>(Get.context!, listen: false)
                  .cachedEvents = [];
              Get.back();
            },
            color: widget.isFromQurHomeSymptom || widget.isFromQurHomeRegimen
                ? Color(CommonUtil().getQurhomePrimaryColor())
                : Color(CommonUtil().getMyPrimaryColor()),
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
    TimeOfDay selectedTime = new TimeOfDay.now();
    MaterialLocalizations localizations = MaterialLocalizations.of(context);
    String formattedTime = localizations.formatTimeOfDay(selectedTime,
        alwaysUse24HourFormat: false);
    if (formattedTime != null) {
      timeText = formattedTime;
    }
  }
}
