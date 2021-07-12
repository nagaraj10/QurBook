import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/my_providers/bloc/providers_block.dart';
import 'package:myfhb/my_providers/models/Doctors.dart';
import 'package:myfhb/my_providers/models/MyProviderResponseNew.dart';
import 'package:myfhb/my_providers/models/User.dart';
import 'package:myfhb/my_providers/models/UserAddressCollection.dart'
    as address;
import 'package:myfhb/search_providers/models/doctors_data.dart';
import 'package:myfhb/search_providers/models/hospital_data.dart';
import 'package:myfhb/search_providers/models/lab_data.dart';
import 'package:myfhb/search_providers/models/search_arguments.dart';
import 'package:myfhb/search_providers/screens/search_specific_list.dart';
import 'package:myfhb/src/blocs/Category/CategoryListBlock.dart';
import 'package:myfhb/src/blocs/Media/MediaTypeBlock.dart';
import 'package:myfhb/src/blocs/health/HealthReportListForUserBlock.dart';
import 'package:myfhb/src/model/Category/CategoryData.dart';
import 'package:myfhb/src/model/Category/catergory_result.dart';
import 'package:myfhb/src/model/Health/MediaMetaInfo.dart';
import 'package:myfhb/src/model/Health/asgard/health_record_list.dart';
import 'package:myfhb/src/model/Media/MediaData.dart';
import 'package:myfhb/src/model/Media/media_data_list.dart';
import 'package:myfhb/src/model/Media/media_result.dart';
import 'package:myfhb/src/model/common_response.dart';
import 'package:myfhb/src/resources/network/ApiResponse.dart';
import 'package:myfhb/src/ui/MyRecord.dart';
import 'package:myfhb/src/ui/MyRecordsArguments.dart';
import 'package:myfhb/src/ui/audio/AudioScreenArguments.dart';
import 'package:myfhb/src/ui/audio/audio_record_screen.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/CommonWidgets.dart';

class CommonDialogBox {
  String categoryName, deviceName;
  TextEditingController fileName = new TextEditingController();
  TextEditingController doctor = new TextEditingController();
  TextEditingController lab = new TextEditingController();
  TextEditingController hospital = new TextEditingController();

  TextEditingController dateOfVisit = new TextEditingController();
  TextEditingController deviceController = new TextEditingController();
  TextEditingController pulse = new TextEditingController();
  TextEditingController memoController = new TextEditingController();
  TextEditingController diaStolicPressure = new TextEditingController();

  List<CategoryResult> filteredCategoryData = new List();
  CategoryListBlock _categoryListBlock = new CategoryListBlock();

  String errForbpSp = '',
      errFForbpDp = '',
      errForbpPulse = '',
      errGluco = '',
      errWeight = '',
      errTemp = '',
      errPoPulse = '',
      errPoOs = '';

  String validationMsg;
  List<bool> isSelected;
  String selectedID;

  String categoryID;
  String categoryIDForNotes = '257b24f5-e0a7-419d-9e23-826b4c52497c';

  var doctorsData, hospitalData, labData;
  String audioPathMain = '';
  bool containsAudioMain = false;
  CategoryResult categoryDataObj = new CategoryResult();
  MediaResult mediaDataObj = new MediaResult();
  File imageFile;
  HealthReportListForUserBlock _healthReportListForUserBlock =
      new HealthReportListForUserBlock();

  List<String> imagePathMain = new List();

  FHBBasicWidget fhbBasicWidget = new FHBBasicWidget();
  MediaMetaInfo mediaMetaInfo;
  String metaInfoId = '';
  bool modeOfSave;
  MediaResult selectedMediaData;

  String metaId;

  List<MediaResult> mediaDataAry = PreferenceUtil.getMediaType();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  FocusNode dateOfBirthFocus = FocusNode();
  FlutterToast toast = new FlutterToast();

  String fromClassNew = '';
  HealthResult deviceHealthResult;
  bool forNotes = false;

  ProvidersBloc _providersBloc = new ProvidersBloc();
  Future<MyProvidersResponse> _medicalPreferenceList;
  List<Doctors> doctorsListFromProvider;
  List<Doctors> copyOfdoctorsModel;

  Doctors doctorObj;

  CommonWidgets commonWidgets = new CommonWidgets();
  bool showDoctorList = true;

  Future<Widget> getDialogBoxForPrescription(
      BuildContext context,
      TextEditingController hospitalNameClone,
      TextEditingController doctorsNameClone,
      TextEditingController dateOfVisitClone,
      bool containsAudio,
      String audioPath,
      Function(bool, String) deleteAudioFunction,
      Function updateUI,
      Function(bool, String) updateAudioUI,
      List<String> imagePath,
      HealthResult mediaMetaInfo,
      bool modeOfSaveClone,
      TextEditingController fileNameClone) {
    try {
      modeOfSave = modeOfSaveClone;
      audioPathMain = audioPath;
      containsAudioMain = containsAudio;

      _medicalPreferenceList = _providersBloc.getMedicalPreferencesForDoctors();

      if (mediaMetaInfo != null) {
        deviceHealthResult = mediaMetaInfo;

        doctorsData = mediaMetaInfo.metadata.doctor != null
            ? mediaMetaInfo.metadata.doctor
            : null;
        hospitalData = mediaMetaInfo.metadata.hospital != null
            ? mediaMetaInfo.metadata.hospital
            : null;
        /* labData = mediaMetaInfo.metaInfo.laboratory != null
            ? mediaMetaInfo.metaInfo.laboratory
            : null;*/
        mediaMetaInfo = mediaMetaInfo != null ? mediaMetaInfo : null;

        setDoctorValueFromResponse(mediaMetaInfo);

        if (mediaMetaInfo != null) {
          metaInfoId = mediaMetaInfo.id;
        }
      }
    } catch (e) {}

    dateOfVisit.text = dateOfVisitClone.text;
    if (modeOfSave) {
      loadMemoText(mediaMetaInfo.metadata.memoText != null
          ? mediaMetaInfo.metadata.memoText
          : '');
    } else {
      memoController.text = '';
    }

    if (modeOfSaveClone) {
      hospital.text = hospitalNameClone.text;
      doctor.text = doctorsNameClone.text;
    } else {
      setPrefreferedProvidersIfAvailable(
          hospitalNameClone.text, doctorsNameClone.text, '');
    }

    imagePathMain.addAll(imagePath);
    setFileName(fileNameClone.text, mediaMetaInfo);
    StatefulBuilder dialog = new StatefulBuilder(builder: (context, setState) {
      return new AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            fhbBasicWidget.getTextTextTitleWithPurpleColor(categoryName),
            IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black54,
                size: 24.0.sp,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20.0.h,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    fhbBasicWidget.getTextForAlertDialog(
                        context, CommonConstants.strDoctorsName),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: fhbBasicWidget.getTextFiledWithHint(
                              context, 'Choose Doctor', doctor,
                              enabled: false),
                        ),
                        showDoctorList
                            ? Container(
                                height: 50,
                                child: doctorsListFromProvider != null
                                    ? getDoctorDropDown(
                                        doctorsListFromProvider,
                                        doctorObj,
                                        () {
                                          Navigator.pop(context);
                                          moveToSearchScreen(
                                              context,
                                              CommonConstants.keyDoctor,
                                              doctor,
                                              hospital,
                                              null,
                                              updateUI,
                                              audioPath,
                                              containsAudio,
                                              setState: setState);
                                        },
                                      )
                                    : getAllCustomRoles(doctorObj, () {
                                        Navigator.pop(context);
                                        moveToSearchScreen(
                                            context,
                                            CommonConstants.keyDoctor,
                                            doctor,
                                            hospital,
                                            null,
                                            updateUI,
                                            audioPath,
                                            containsAudio,
                                            setState: setState);
                                      }),
                              )
                            : Container(),
                      ],
                    ),
                    SizedBox(
                      height: 15.0.h,
                    ),
                    fhbBasicWidget.getTextForAlertDialog(
                        context, CommonConstants.strFileName),
                    fhbBasicWidget.getTextFieldWithNoCallbacks(
                        context, fileName),
                    SizedBox(
                      height: 15.0.h,
                    ),
                    fhbBasicWidget.getTextForAlertDialog(
                        context, CommonConstants.strHospitalNameWithoutStar),
                    fhbBasicWidget
                        .getTextFieldForDialogWithControllerAndPressed(context,
                            (context, value) {
                      moveToSearchScreen(
                          context,
                          CommonConstants.keyHospital,
                          doctor,
                          hospital,
                          null,
                          updateUI,
                          audioPath,
                          containsAudio);
                    }, hospital, CommonConstants.keyHospital),
                    SizedBox(
                      height: 15.0.h,
                    ),
                    fhbBasicWidget.getTextForAlertDialog(
                        context, CommonConstants.strDateOfVisit),
                    _showDateOfVisit(context, dateOfVisit),
                    SizedBox(
                      height: 15.0.h,
                    ),
                    fhbBasicWidget.getTextForAlertDialog(
                        context, CommonConstants.strMemo),
                    fhbBasicWidget.getTextFieldWithNoCallbacksForMemo(
                        context, memoController),
                    SizedBox(
                      height: 15.0.h,
                    ),
                  ],
                ),
              ),
            ),
            modeOfSave
                ? fhbBasicWidget.getSaveButton(() {
                    onPostDataToServer(context, imagePath);
                  })
                : containsAudioMain
                    ? fhbBasicWidget.getAudioIconWithFile(
                        audioPathMain,
                        containsAudioMain,
                        (containsAudio, audioPath) {
                          audioPathMain = audioPath;
                          containsAudioMain = containsAudio;
                          updateAudioUI(containsAudioMain, audioPathMain);
                          setState(() {});
                        },
                        context,
                        imagePath,
                        (context, imagePath) {
                          onPostDataToServer(context, imagePath);
                        })
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          fhbBasicWidget
                              .getMicIcon(context, containsAudio, audioPath,
                                  (containsAudio, audioPath) {
                            audioPathMain = audioPath;
                            containsAudioMain = containsAudio;
                            updateAudioUI(containsAudioMain, audioPathMain);
                            setState(() {});
                          }),
                          fhbBasicWidget.getSaveButton(() {
                            onPostDataToServer(context, imagePath);
                          })
                        ],
                      ),
          ],
        ),
      );
    });

    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => dialog);
  }

  Future<Widget> getDialogBoxForLabReport(
      BuildContext context,
      TextEditingController labNameClone,
      TextEditingController doctorsNameClone,
      TextEditingController dateOfVisitClone,
      bool containsAudio,
      String audioPath,
      Function(bool, String) deleteAudioFunction,
      Function updateUI,
      Function(bool, String) updateAudioUI,
      List<String> imagePath,
      HealthResult mediaMetaInfo,
      bool modeOfSaveClone,
      TextEditingController fileNameClone) {
    try {
      modeOfSave = modeOfSaveClone;
      audioPathMain = audioPath;
      containsAudioMain = containsAudio;
      _medicalPreferenceList = _providersBloc.getMedicalPreferencesForDoctors();
      if (mediaMetaInfo != null) {
        mediaMetaInfo = mediaMetaInfo != null ? mediaMetaInfo : null;
        deviceHealthResult = mediaMetaInfo;

        doctorsData = mediaMetaInfo.metadata.doctor;
        setDoctorValueFromResponse(mediaMetaInfo);

        labData = mediaMetaInfo.metadata.laboratory != null
            ? mediaMetaInfo.metadata.laboratory
            : null;
        hospitalData = mediaMetaInfo.metadata.hospital != null
            ? mediaMetaInfo.metadata.hospital
            : null;

        if (mediaMetaInfo != null) {
          metaInfoId = mediaMetaInfo.id;
        }
      }
    } catch (e) {}
    dateOfVisit.text = dateOfVisitClone.text;

    if (modeOfSaveClone) {
      lab.text = labNameClone.text;
      doctor.text = doctorsNameClone.text;
    } else {
      setPrefreferedProvidersIfAvailable(
          '', doctorsNameClone.text, labNameClone.text);
    }

    imagePathMain.addAll(imagePath);
    setFileName(fileNameClone.text, mediaMetaInfo);
    if (modeOfSave) {
      loadMemoText(mediaMetaInfo.metadata.memoText != null
          ? mediaMetaInfo.metadata.memoText
          : '');
    } else {
      memoController.text = '';
    }

    StatefulBuilder dialog = new StatefulBuilder(builder: (context, setState) {
      return new AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            fhbBasicWidget.getTextTextTitleWithPurpleColor(categoryName),
            IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black54,
                size: 24.0.sp,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20.0.h,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    fhbBasicWidget.getTextForAlertDialog(
                        context, CommonConstants.strLabName),
                    fhbBasicWidget
                        .getTextFieldForDialogWithControllerAndPressed(context,
                            (context, value) {
                      moveToSearchScreen(
                          context,
                          CommonConstants.keyLab,
                          doctor,
                          null,
                          lab,
                          updateUI,
                          audioPath,
                          containsAudio);
                    }, lab, CommonConstants.keyLab),
                    SizedBox(
                      height: 15.0.h,
                    ),
                    fhbBasicWidget.getTextForAlertDialog(
                        context, CommonConstants.strDoctorsName),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: fhbBasicWidget.getTextFiledWithHint(
                              context, 'Choose Doctor', doctor,
                              enabled: false),
                        ),
                        showDoctorList
                            ? Container(
                                height: 50,
                                child: doctorsListFromProvider != null
                                    ? getDoctorDropDown(
                                        doctorsListFromProvider,
                                        doctorObj,
                                        () {
                                          Navigator.pop(context);
                                          moveToSearchScreen(
                                              context,
                                              CommonConstants.keyDoctor,
                                              doctor,
                                              hospital,
                                              null,
                                              updateUI,
                                              audioPath,
                                              containsAudio,
                                              setState: setState);
                                        },
                                      )
                                    : getAllCustomRoles(doctorObj, () {
                                        Navigator.pop(context);
                                        moveToSearchScreen(
                                            context,
                                            CommonConstants.keyDoctor,
                                            doctor,
                                            hospital,
                                            null,
                                            updateUI,
                                            audioPath,
                                            containsAudio,
                                            setState: setState);
                                      }),
                              )
                            : Container(),
                      ],
                    ),
                    SizedBox(
                      height: 15.0.h,
                    ),
                    fhbBasicWidget.getTextForAlertDialog(
                        context, CommonConstants.strFileName),
                    fhbBasicWidget.getTextFieldWithNoCallbacks(
                        context, fileName),
                    SizedBox(
                      height: 15.0.h,
                    ),
                    fhbBasicWidget.getTextForAlertDialog(
                        context, CommonConstants.strDateOfVisit),
                    _showDateOfVisit(context, dateOfVisit),
                    SizedBox(
                      height: 15.0.h,
                    ),
                    fhbBasicWidget.getTextForAlertDialog(
                        context, CommonConstants.strMemo),
                    fhbBasicWidget.getTextFieldWithNoCallbacks(
                        context, memoController),
                    SizedBox(
                      height: 15.0.h,
                    ),
                  ],
                ),
              ),
            ),
            modeOfSave
                ? fhbBasicWidget.getSaveButton(() {
                    onPostDataToServer(context, imagePath);
                  })
                : containsAudioMain
                    ? fhbBasicWidget.getAudioIconWithFile(
                        audioPathMain,
                        containsAudioMain,
                        (containsAudio, audioPath) {
                          audioPathMain = audioPath;
                          containsAudioMain = containsAudio;
                          updateAudioUI(containsAudioMain, audioPathMain);
                          setState(() {});
                        },
                        context,
                        imagePath,
                        (context, imagePath) {
                          onPostDataToServer(context, imagePath);
                        })
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          fhbBasicWidget
                              .getMicIcon(context, containsAudio, audioPath,
                                  (containsAudio, audioPath) {
                            audioPathMain = audioPath;
                            containsAudioMain = containsAudio;
                            updateAudioUI(containsAudioMain, audioPathMain);
                            setState(() {});
                          }),
                          fhbBasicWidget.getSaveButton(() {
                            onPostDataToServer(context, imagePath);
                          })
                        ],
                      ),
          ],
        ),
      );
    });

    return showDialog(
        context: context, builder: (BuildContext context) => dialog);
  }

  Future<Widget> getDialogBoxForBillsAndOthers(
      BuildContext context,
      bool containsAudio,
      String audioPath,
      Function(bool, String) deleteAudioFunction,
      List<String> imagePath,
      Function(bool, String) updateAudioUI,
      HealthResult mediaMetaInfoClone,
      bool modeOfSaveClone,
      TextEditingController fileNameClone) {
    if (mediaMetaInfoClone != null) {
      if (mediaMetaInfoClone != null) {
        metaInfoId = mediaMetaInfoClone.id;
      }
    }
    modeOfSave = modeOfSaveClone;
    audioPathMain = audioPath;
    containsAudioMain = containsAudio;
    imagePathMain.addAll(imagePath);
    if (modeOfSave) {
      deviceHealthResult = mediaMetaInfoClone;

      loadMemoText(mediaMetaInfoClone.metadata.memoText != null
          ? mediaMetaInfoClone.metadata.memoText
          : '');
    } else {
      memoController.text = '';
    }

    setFileName(fileNameClone.text, mediaMetaInfoClone);
    StatefulBuilder dialog = new StatefulBuilder(builder: (context, setState) {
      return new AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            fhbBasicWidget.getTextTextTitleWithPurpleColor(categoryName),
            IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black54,
                size: 24.0.sp,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
        content: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            fhbBasicWidget.getTextForAlertDialog(
                context, CommonConstants.strFileName),
            fhbBasicWidget.getTextFieldWithNoCallbacks(context, fileName),
            SizedBox(
              height: 15.0.h,
            ),
            fhbBasicWidget.getTextForAlertDialog(
                context, CommonConstants.strMemo),
            fhbBasicWidget.getTextFieldWithNoCallbacks(context, memoController),
            SizedBox(
              height: 15.0.h,
            ),
            modeOfSave
                ? fhbBasicWidget.getSaveButton(() {
                    onPostDataToServer(context, imagePath);
                  })
                : containsAudioMain
                    ? fhbBasicWidget.getAudioIconWithFile(
                        audioPathMain,
                        containsAudioMain,
                        (containsAudio, audioPath) {
                          audioPathMain = audioPath;
                          containsAudioMain = containsAudio;
                          updateAudioUI(containsAudioMain, audioPathMain);
                          setState(() {});
                        },
                        context,
                        imagePath,
                        (context, imagePath) {
                          onPostDataToServer(context, imagePath);
                        })
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          fhbBasicWidget
                              .getMicIcon(context, containsAudio, audioPath,
                                  (containsAudio, audioPath) {
                            audioPathMain = audioPath;
                            containsAudioMain = containsAudio;
                            updateAudioUI(containsAudioMain, audioPathMain);
                            setState(() {});
                          }),
                          fhbBasicWidget.getSaveButton(() {
                            onPostDataToServer(context, imagePath);
                          })
                        ],
                      ),
          ],
        )),
      );
    });

    return showDialog(
        context: context, builder: (BuildContext context) => dialog);
  }

  Future<Widget> getDialogForIDDocs(
      BuildContext context,
      bool containsAudio,
      String audioPath,
      Function(bool, String) deleteAudioFunction,
      List<String> imagePath,
      Function(bool, String) updateAudioUI,
      HealthResult mediaMetaInfoClone,
      bool modeOfSaveClone,
      TextEditingController fileNameClone,
      TextEditingController dateOfVisitClone,
      String idType) {
    if (mediaMetaInfoClone != null) {
      if (mediaMetaInfoClone != null) {
        metaInfoId = mediaMetaInfoClone.id;
      }
    }
    modeOfSave = modeOfSaveClone;
    audioPathMain = audioPath;
    containsAudioMain = containsAudio;
    imagePathMain.addAll(imagePath);
    dateOfVisit.text = dateOfVisitClone.text;
    if (idType != '' && idType != null) {
      selectedID = idType;
    }

    setFileName(fileNameClone.text, mediaMetaInfoClone);
    if (modeOfSave) {
      deviceHealthResult = mediaMetaInfoClone;
      loadMemoText(mediaMetaInfoClone.metadata.memoText != null
          ? mediaMetaInfoClone.metadata.memoText
          : '');
    } else {
      memoController.text = '';
    }

    List<MediaResult> mediaDataAry = [];

    for (MediaResult mediaData in PreferenceUtil.getMediaType()) {
      var categorySplitAry = mediaData.description.split('_');
      if (categorySplitAry[0] == CommonConstants.categoryDescriptionIDDocs) {
        mediaDataAry.add(mediaData);
      }
    }

    for (MediaResult mediaData in mediaDataAry) {
      var mediaDataClone = mediaData.name.split(' ');
      if (mediaDataClone.length > 0) {
        if (idType != '' && idType != null) {
          if (idType == mediaData.id) {
            selectedID = idType;
            selectedMediaData = mediaData;

            PreferenceUtil.saveMediaData(
                Constants.KEY_MEDIADATA, selectedMediaData);
          }
        }
      }
    }

    StatefulBuilder dialog = new StatefulBuilder(builder: (context, setState) {
      return new AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            fhbBasicWidget.getTextTextTitleWithPurpleColor(categoryName),
            IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black54,
                size: 24.0.sp,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
        content: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            fhbBasicWidget.getTextForAlertDialog(
                context, CommonConstants.strFileName),
            fhbBasicWidget.getTextFieldWithNoCallbacks(context, fileName),
            SizedBox(
              height: 15.0.h,
            ),
            fhbBasicWidget.getTextForAlertDialog(
                context, CommonConstants.strMemo),
            fhbBasicWidget.getTextFieldWithNoCallbacks(context, memoController),
            SizedBox(
              height: 15.0.h,
            ),
            Container(
                width: 1.sw - 60,
                child: GestureDetector(
                    onTap: () => _selectDate(context, dateOfVisit),
                    child: TextField(
                      autofocus: false,
                      readOnly: true,
                      controller: dateOfVisit,
                      decoration: InputDecoration(
                          labelText: CommonConstants.exprityDate,
                          suffixIcon: new IconButton(
                            icon: new Icon(
                              Icons.calendar_today,
                              size: 24.0.sp,
                            ),
                            onPressed: () =>
                                _selectDateFuture(context, dateOfVisit),
                          )),
                    ))),
            SizedBox(
              height: 15.0.h,
            ),
            new Center(
              child: new DropdownButton(
                hint: new Text("Select ID Type"),
                value: selectedMediaData,
                onChanged: (MediaResult newValue) {
                  setState(() {
                    selectedMediaData = newValue;
                    PreferenceUtil.saveMediaData(
                        Constants.KEY_MEDIADATA, selectedMediaData);
                  });
                },
                items: mediaDataAry.map((idType) {
                  return DropdownMenuItem(
                    child: new Text(
                      idType.name,
                      style: new TextStyle(color: Colors.black),
                    ),
                    value: idType,
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              height: 15.0.h,
            ),
            modeOfSave
                ? fhbBasicWidget.getSaveButton(() {
                    onPostDataToServer(context, imagePath);
                  })
                : containsAudioMain
                    ? fhbBasicWidget.getAudioIconWithFile(
                        audioPathMain,
                        containsAudioMain,
                        (containsAudio, audioPath) {
                          audioPathMain = audioPath;
                          containsAudioMain = containsAudio;
                          updateAudioUI(containsAudioMain, audioPathMain);
                          setState(() {});
                        },
                        context,
                        imagePath,
                        (context, imagePath) {
                          onPostDataToServer(context, imagePath);
                        })
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          fhbBasicWidget
                              .getMicIcon(context, containsAudio, audioPath,
                                  (containsAudio, audioPath) {
                            audioPathMain = audioPath;
                            containsAudioMain = containsAudio;
                            updateAudioUI(containsAudioMain, audioPathMain);
                            setState(() {});
                          }),
                          fhbBasicWidget.getSaveButton(() {
                            onPostDataToServer(context, imagePath);
                          })
                        ],
                      ),
          ],
        )),
      );
    });

    return showDialog(context: context, builder: (context) => dialog);
  }

  Future<Widget> getDialogBoxForGlucometer(
      BuildContext context,
      String deviceNameClone,
      bool containsAudio,
      String audioPath,
      Function(bool, String) deleteAudioFunction,
      List<String> imagePath,
      Function(bool, String) updateAudioUI,
      HealthResult mediaMetaInfoClone,
      bool modeOfSaveClone,
      TextEditingController deviceControllerClone,
      List<bool> isSelectedClone,
      TextEditingController fileNameClone) {
    var commonConstants = new CommonConstants();
    commonConstants.getCountryMetrics();
    if (mediaMetaInfoClone != null) {
      if (mediaMetaInfoClone != null) {
        metaInfoId = mediaMetaInfoClone.id;
      }
    }
    modeOfSave = modeOfSaveClone;
    setFileName(fileNameClone.text, mediaMetaInfoClone);
    audioPathMain = audioPath;
    containsAudioMain = containsAudio;
    deviceName = deviceNameClone;
    imagePathMain.addAll(imagePath);
    deviceController.text = deviceControllerClone.text;
    isSelected = isSelectedClone;
    if (modeOfSave) {
      deviceHealthResult = mediaMetaInfoClone;
      loadMemoText(mediaMetaInfoClone.metadata.memoText != null
          ? mediaMetaInfoClone.metadata.memoText
          : '');
    } else {
      memoController.text = '';
    }

    StatefulBuilder dialog = new StatefulBuilder(builder: (context, setState) {
      return new AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              fhbBasicWidget.getTextTextTitleWithPurpleColor(deviceName),
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.black54,
                  size: 24.0.sp,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
          content: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              fhbBasicWidget.getTextForAlertDialog(
                  context, CommonConstants.strFileName),
              fhbBasicWidget.getTextFieldWithNoCallbacks(context, fileName),
              SizedBox(
                height: 15.0.h,
              ),
              fhbBasicWidget.getTextFiledWithHintAndSuffixText(
                  context,
                  CommonConstants.strValue,
                  commonConstants.glucometerUNIT,
                  deviceController, (errorValue) {
                setState(() {
                  errGluco = errorValue;
                });
              }, errGluco, variable.strGlucUnit),
              SizedBox(
                height: 15.0.h,
              ),
              fhbBasicWidget.getTextForAlertDialog(
                  context, CommonConstants.strMemo),
              fhbBasicWidget.getTextFieldWithNoCallbacks(
                  context, memoController),
              SizedBox(
                height: 15.0.h,
              ),
              fhbBasicWidget.getTextForAlertDialog(
                  context, CommonConstants.strTimeTaken),
              ToggleButtons(
                borderColor: Colors.black,
                fillColor: Colors.grey[100],
                borderWidth: 2,
                selectedBorderColor:
                    Color(new CommonUtil().getMyPrimaryColor()),
                selectedColor: Color(new CommonUtil().getMyPrimaryColor()),
                borderRadius: BorderRadius.circular(10),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      variable.strbfood,
                      style: TextStyle(
                        fontSize: 16.0.sp,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      variable.strafood,
                      style: TextStyle(
                        fontSize: 16.0.sp,
                      ),
                    ),
                  ),
                ],
                onPressed: (int index) {
                  setState(() {
                    for (int i = 0; i < isSelected.length; i++) {
                      isSelected[i] = i == index;
                    }
                  });
                },
                isSelected: isSelected,
              ),
              SizedBox(
                height: 15.0.h,
              ),
              modeOfSave
                  ? fhbBasicWidget.getSaveButton(() {
                      onPostDataToServer(context, imagePath);
                    })
                  : containsAudioMain
                      ? fhbBasicWidget.getAudioIconWithFile(
                          audioPathMain,
                          containsAudioMain,
                          (containsAudio, audioPath) {
                            audioPathMain = audioPath;
                            containsAudioMain = containsAudio;
                            updateAudioUI(containsAudioMain, audioPathMain);
                            setState(() {});
                          },
                          context,
                          imagePath,
                          (context, imagePath) {
                            onPostDataToServer(context, imagePath);
                          })
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            fhbBasicWidget
                                .getMicIcon(context, containsAudio, audioPath,
                                    (containsAudio, audioPath) {
                              audioPathMain = audioPath;
                              containsAudioMain = containsAudio;
                              updateAudioUI(containsAudioMain, audioPathMain);
                              setState(() {});
                            }),
                            fhbBasicWidget.getSaveButton(() {
                              onPostDataToServer(context, imagePath);
                            })
                          ],
                        ),
            ],
          )));
    });

    return showDialog(context: context, builder: (context) => dialog);
  }

  Future<Widget> getDialogBoxForTemperature(
      BuildContext context,
      String deviceNameClone,
      bool containsAudio,
      String audioPath,
      Function(bool, String) deleteAudioFunction,
      List<String> imagePath,
      Function(bool, String) updateAudioUI,
      HealthResult mediaMetaInfoClone,
      bool modeOfSaveClone,
      TextEditingController deviceControllerClone,
      TextEditingController fileNameClone) {
    var commonConstants = new CommonConstants();
    commonConstants.getCountryMetrics();
    if (mediaMetaInfoClone != null) {
      if (mediaMetaInfoClone != null) {
        metaInfoId = mediaMetaInfoClone.id;
      }
    }
    modeOfSave = modeOfSaveClone;
    setFileName(fileNameClone.text, mediaMetaInfoClone);
    audioPathMain = audioPath;
    containsAudioMain = containsAudio;
    deviceName = deviceNameClone;
    imagePathMain.addAll(imagePath);
    deviceController.text = deviceControllerClone.text;
    if (modeOfSave) {
      deviceHealthResult = mediaMetaInfoClone;
      loadMemoText(mediaMetaInfoClone.metadata.memoText != null
          ? mediaMetaInfoClone.metadata.memoText
          : '');
    } else {
      memoController.text = '';
    }
    StatefulBuilder dialog = new StatefulBuilder(builder: (context, setState) {
      return new AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            fhbBasicWidget.getTextTextTitleWithPurpleColor(deviceName),
            IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black54,
                size: 24.0.sp,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
        content: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            fhbBasicWidget.getTextForAlertDialog(
                context, CommonConstants.strFileName),
            fhbBasicWidget.getTextFieldWithNoCallbacks(context, fileName),
            SizedBox(
              height: 15.0.h,
            ),
            fhbBasicWidget.getTextFiledWithHintAndSuffixText(
                context,
                CommonConstants.strTemperature,
                commonConstants.tempUNIT,
                deviceController, (errorValue) {
              setState(() {
                errTemp = errorValue;
              });
            }, errTemp, commonConstants.tempUNIT),
            SizedBox(
              height: 15.0.h,
            ),
            fhbBasicWidget.getTextForAlertDialog(
                context, CommonConstants.strMemo),
            fhbBasicWidget.getTextFieldWithNoCallbacks(context, memoController),
            SizedBox(
              height: 15.0.h,
            ),
            modeOfSave
                ? fhbBasicWidget.getSaveButton(() {
                    onPostDataToServer(context, imagePath);
                  })
                : containsAudioMain
                    ? fhbBasicWidget.getAudioIconWithFile(
                        audioPathMain,
                        containsAudioMain,
                        (containsAudio, audioPath) {
                          audioPathMain = audioPath;
                          containsAudioMain = containsAudio;
                          updateAudioUI(containsAudioMain, audioPathMain);
                          setState(() {});
                        },
                        context,
                        imagePath,
                        (context, imagePath) {
                          onPostDataToServer(context, imagePath);
                        })
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          fhbBasicWidget
                              .getMicIcon(context, containsAudio, audioPath,
                                  (containsAudio, audioPath) {
                            audioPathMain = audioPath;
                            containsAudioMain = containsAudio;
                            updateAudioUI(containsAudioMain, audioPathMain);
                            setState(() {});
                          }),
                          fhbBasicWidget.getSaveButton(() {
                            onPostDataToServer(context, imagePath);
                          })
                        ],
                      ),
          ],
        )),
      );
    });

    return showDialog(
        context: context, builder: (BuildContext context) => dialog);
  }

  void setFileName(String fileNameClone, HealthResult healthResult,
      {String voiceRecord}) async {
    try {
      categoryName = healthResult.metadata.healthRecordCategory.categoryName;
      deviceName = healthResult.metadata.healthRecordType.name;
      categoryID = healthResult.metadata.healthRecordCategory.id;
    } catch (e) {
      categoryName =
          await PreferenceUtil.getStringValue(Constants.KEY_CATEGORYNAME);
      deviceName =
          await PreferenceUtil.getStringValue(Constants.KEY_DEVICENAME);
      categoryID =
          await PreferenceUtil.getStringValue(Constants.KEY_CATEGORYID);
    }

    if (modeOfSave) {
      fileName.text = fileNameClone;
    } else {
      if (fileNameClone == '') {
        if (categoryName == CommonConstants.strDevice) {
          fileName = new TextEditingController(
              text: deviceName +
                  '_${DateTime.now().toUtc().millisecondsSinceEpoch}');
        } else {
          fileName = new TextEditingController(
              text: categoryName +
                  '_${DateTime.now().toUtc().millisecondsSinceEpoch}');
        }
      } else {
        fileName.text = fileNameClone;
      }
    }

    if (forNotes) {
      categoryName = Constants.STR_NOTES;
      categoryID = categoryIDForNotes;
    }
  }

  Future<Widget> getDialogBoxForWeightingScale(
      BuildContext context,
      String deviceNameClone,
      bool containsAudio,
      String audioPath,
      Function(bool, String) deleteAudioFunction,
      List<String> imagePath,
      Function(bool, String) updateAudioUI,
      HealthResult mediaMetaInfoClone,
      bool modeOfSaveClone,
      TextEditingController deviceControllerClone,
      TextEditingController fileNameClone) {
    var commonConstants = new CommonConstants();
    commonConstants.getCountryMetrics();
    if (mediaMetaInfoClone != null) {
      if (mediaMetaInfoClone != null) {
        metaInfoId = mediaMetaInfoClone.id;
      }
    }
    modeOfSave = modeOfSaveClone;
    setFileName(fileNameClone.text, mediaMetaInfoClone);
    audioPathMain = audioPath;
    containsAudioMain = containsAudio;
    deviceName = deviceNameClone;
    imagePathMain.addAll(imagePath);
    deviceController.text = deviceControllerClone.text;

    if (modeOfSave) {
      deviceHealthResult = mediaMetaInfoClone;
      loadMemoText(mediaMetaInfoClone.metadata.memoText != null
          ? mediaMetaInfoClone.metadata.memoText
          : '');
    } else {
      memoController.text = '';
    }

    StatefulBuilder dialog = new StatefulBuilder(builder: (context, setState) {
      return new AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            fhbBasicWidget.getTextTextTitleWithPurpleColor(deviceName),
            IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black54,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
        content: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            fhbBasicWidget.getTextForAlertDialog(
                context, CommonConstants.strFileName),
            fhbBasicWidget.getTextFieldWithNoCallbacks(context, fileName),
            SizedBox(
              height: 15.0.h,
            ),
            fhbBasicWidget.getTextFiledWithHintAndSuffixText(
                context,
                CommonConstants.strWeight,
                commonConstants.weightUNIT,
                deviceController, (errorValue) {
              setState(() {
                errWeight = errorValue;
              });
            }, errWeight, commonConstants.weightUNIT),
            SizedBox(
              height: 15.0.h,
            ),
            fhbBasicWidget.getTextForAlertDialog(
                context, CommonConstants.strMemo),
            fhbBasicWidget.getTextFieldWithNoCallbacks(context, memoController),
            SizedBox(
              height: 15.0.h,
            ),
            modeOfSave
                ? fhbBasicWidget.getSaveButton(() {
                    onPostDataToServer(context, imagePath);
                  })
                : containsAudioMain
                    ? fhbBasicWidget.getAudioIconWithFile(
                        audioPathMain,
                        containsAudioMain,
                        (containsAudio, audioPath) {
                          audioPathMain = audioPath;
                          containsAudioMain = containsAudio;
                          updateAudioUI(containsAudioMain, audioPathMain);
                          setState(() {});
                        },
                        context,
                        imagePath,
                        (context, imagePath) {
                          onPostDataToServer(context, imagePath);
                        })
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          fhbBasicWidget
                              .getMicIcon(context, containsAudio, audioPath,
                                  (containsAudio, audioPath) {
                            audioPathMain = audioPath;
                            containsAudioMain = containsAudio;
                            updateAudioUI(containsAudioMain, audioPathMain);
                            setState(() {});
                          }),
                          fhbBasicWidget.getSaveButton(() {
                            onPostDataToServer(context, imagePath);
                          })
                        ],
                      ),
          ],
        )),
      );
    });

    return showDialog(
        context: context, builder: (BuildContext context) => dialog);
  }

  Future<Widget> getDialogBoxForPulseOxidometer(
      BuildContext context,
      String deviceNameClone,
      bool containsAudio,
      String audioPath,
      Function(bool, String) deleteAudioFunction,
      List<String> imagePath,
      Function(bool, String) updateAudioUI,
      HealthResult mediaMetaInfoClone,
      bool modeOfSaveClone,
      TextEditingController deviceControllerClone,
      TextEditingController pulseClone,
      TextEditingController fileNameClone) {
    var commonConstants = new CommonConstants();
    commonConstants.getCountryMetrics();
    if (mediaMetaInfoClone != null) {
      if (mediaMetaInfoClone != null) {
        metaInfoId = mediaMetaInfoClone.id;
      }
    }
    modeOfSave = modeOfSaveClone;
    setFileName(fileNameClone.text, mediaMetaInfoClone);
    audioPathMain = audioPath;
    containsAudioMain = containsAudio;
    deviceName = deviceNameClone;
    imagePathMain.addAll(imagePath);
    deviceController.text = deviceControllerClone.text;
    pulse.text = pulseClone.text;

    if (modeOfSave) {
      deviceHealthResult = mediaMetaInfoClone;
      loadMemoText(mediaMetaInfoClone.metadata.memoText != null
          ? mediaMetaInfoClone.metadata.memoText
          : '');
    } else {
      memoController.text = '';
    }

    StatefulBuilder dialog = new StatefulBuilder(builder: (context, setState) {
      return new AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            fhbBasicWidget.getTextTextTitleWithPurpleColor(deviceName),
            IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black54,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
        content: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            fhbBasicWidget.getTextForAlertDialog(
                context, CommonConstants.strFileName),
            fhbBasicWidget.getTextFieldWithNoCallbacks(context, fileName),
            SizedBox(
              height: 15.0.h,
            ),
            fhbBasicWidget.getTextFiledWithHintAndSuffixText(
                context,
                CommonConstants.strOxygenSaturation,
                commonConstants.poOxySatUNIT,
                deviceController, (errorValue) {
              setState(() {
                errPoOs = errorValue;
              });
            }, errPoOs, variable.strpulseUnit),
            SizedBox(
              height: 15.0.h,
            ),
            fhbBasicWidget.getTextFiledWithHintAndSuffixText(
                context,
                CommonConstants.strPulse,
                commonConstants.poPulseUNIT,
                pulse, (errorValue) {
              setState(() {
                errPoPulse = errorValue;
              });
            }, errPoPulse, variable.strpulse),
            SizedBox(
              height: 15.0.h,
            ),
            fhbBasicWidget.getTextForAlertDialog(
                context, CommonConstants.strMemo),
            fhbBasicWidget.getTextFieldWithNoCallbacks(context, memoController),
            SizedBox(
              height: 15.0.h,
            ),
            modeOfSave
                ? fhbBasicWidget.getSaveButton(() {
                    onPostDataToServer(context, imagePath);
                  })
                : containsAudioMain
                    ? fhbBasicWidget.getAudioIconWithFile(
                        audioPathMain,
                        containsAudioMain,
                        (containsAudio, audioPath) {
                          audioPathMain = audioPath;
                          containsAudioMain = containsAudio;
                          updateAudioUI(containsAudioMain, audioPathMain);
                          setState(() {});
                        },
                        context,
                        imagePath,
                        (context, imagePath) {
                          onPostDataToServer(context, imagePath);
                        })
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          fhbBasicWidget
                              .getMicIcon(context, containsAudio, audioPath,
                                  (containsAudio, audioPath) {
                            audioPathMain = audioPath;
                            containsAudioMain = containsAudio;
                            updateAudioUI(containsAudioMain, audioPathMain);
                            setState(() {});
                          }),
                          fhbBasicWidget.getSaveButton(() {
                            onPostDataToServer(context, imagePath);
                          })
                        ],
                      ),
          ],
        )),
      );
    });

    return showDialog(
        context: context, builder: (BuildContext context) => dialog);
  }

  Future<Widget> getDialogBoxForBPMonitor(
      BuildContext context,
      String deviceNameClone,
      bool containsAudio,
      String audioPath,
      Function(bool, String) deleteAudioFunction,
      List<String> imagePath,
      Function(bool, String) updateAudioUI,
      HealthResult mediaMetaInfoClone,
      bool modeOfSaveClone,
      TextEditingController deviceControllerClone,
      TextEditingController pulseClone,
      TextEditingController diastolicPressureClone,
      TextEditingController fileNameClone) {
    var commonConstants = new CommonConstants();
    commonConstants.getCountryMetrics();
    if (mediaMetaInfoClone != null) {
      if (mediaMetaInfoClone != null) {
        metaInfoId = mediaMetaInfoClone.id;
      }
    }
    modeOfSave = modeOfSaveClone;
    setFileName(fileNameClone.text, mediaMetaInfoClone);
    audioPathMain = audioPath;
    containsAudioMain = containsAudio;
    deviceName = deviceNameClone;
    imagePathMain.addAll(imagePath);
    deviceController.text = deviceControllerClone.text;
    pulse.text = pulseClone.text;
    diaStolicPressure.text = diastolicPressureClone.text;
    if (modeOfSave) {
      deviceHealthResult = mediaMetaInfoClone;
      loadMemoText(mediaMetaInfoClone.metadata.memoText != null
          ? mediaMetaInfoClone.metadata.memoText
          : '');
    } else {
      memoController.text = '';
    }

    StatefulBuilder dialog = new StatefulBuilder(builder: (context, setState) {
      return new AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            fhbBasicWidget.getTextTextTitleWithPurpleColor(deviceName),
            IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black54,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
        content: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            fhbBasicWidget.getTextForAlertDialog(
                context, CommonConstants.strFileName),
            fhbBasicWidget.getTextFieldWithNoCallbacks(context, fileName),
            SizedBox(
              height: 15.0.h,
            ),
            fhbBasicWidget.getTextFiledWithHintAndSuffixText(
                context,
                CommonConstants.strSystolicPressure,
                commonConstants.bpDPUNIT,
                deviceController, (errorValue) {
              setState(() {
                errForbpSp = errorValue;
              });
            }, errForbpSp, variable.strbpunit),
            SizedBox(
              height: 15.0.h,
            ),
            fhbBasicWidget.getTextFiledWithHintAndSuffixText(
                context,
                CommonConstants.strDiastolicPressure,
                commonConstants.bpDPUNIT,
                diaStolicPressure, (errorValue) {
              setState(() {
                errFForbpDp = errorValue;
              });
            }, errFForbpDp, variable.strbpdp),
            SizedBox(
              height: 15.0.h,
            ),
            fhbBasicWidget.getTextFiledWithHintAndSuffixText(
                context,
                CommonConstants.strPulse,
                commonConstants.bpPulseUNIT,
                pulse, (errorValue) {
              setState(() {
                errForbpPulse = errorValue;
              });
            }, errForbpPulse, variable.strpulse),
            SizedBox(
              height: 15.0.h,
            ),
            fhbBasicWidget.getTextForAlertDialog(
                context, CommonConstants.strMemo),
            fhbBasicWidget.getTextFieldWithNoCallbacks(context, memoController),
            SizedBox(
              height: 15.0.h,
            ),
            modeOfSave
                ? fhbBasicWidget.getSaveButton(() {
                    onPostDataToServer(context, imagePath);
                  })
                : containsAudioMain
                    ? fhbBasicWidget.getAudioIconWithFile(
                        audioPathMain,
                        containsAudioMain,
                        (containsAudio, audioPath) {
                          audioPathMain = audioPath;
                          containsAudioMain = containsAudio;
                          updateAudioUI(containsAudioMain, audioPathMain);
                          setState(() {});
                        },
                        context,
                        imagePath,
                        (context, imagePath) {
                          onPostDataToServer(context, imagePath);
                        })
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          fhbBasicWidget
                              .getMicIcon(context, containsAudio, audioPath,
                                  (containsAudio, audioPath) {
                            audioPathMain = audioPath;
                            containsAudioMain = containsAudio;
                            updateAudioUI(containsAudioMain, audioPathMain);
                            setState(() {});
                          }),
                          fhbBasicWidget.getSaveButton(() {
                            onPostDataToServer(context, imagePath);
                          })
                        ],
                      ),
          ],
        )),
      );
    });

    return showDialog(
        context: context, builder: (BuildContext context) => dialog);
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController dateOfVisit) async {
    DateTime dateTime = DateTime.now();

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime.now());

    if (picked != null) {
      dateTime = picked ?? dateTime;
      dateOfVisit.text =
          new FHBUtils().getFormattedDateOnly(dateTime.toString());
    }
  }

  Future<void> _selectDateFuture(
      BuildContext context, TextEditingController dateOfVisit) async {
    DateTime dateTime = DateTime.now();

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));

    if (picked != null) {
      dateTime = picked ?? dateTime;
      dateOfVisit.text =
          new FHBUtils().getFormattedDateOnly(dateTime.toString());
    }
  }

  moveToSearchScreen(
      BuildContext context,
      String searchParam,
      TextEditingController doctorsName,
      TextEditingController hospitalName,
      TextEditingController labName,
      Function onTextFinished,
      String audioPath,
      bool containsAudio,
      {setState}) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => SearchSpecificList(
                  arguments: SearchArguments(
                    searchWord: searchParam,
                  ),
                  toPreviousScreen: true,
                  isSkipUnknown:
                      searchParam == CommonConstants.keyDoctor ? true : false,
                )))
        .then((results) {
      if (results != null) {
        if (results.containsKey(Constants.keyDoctor)) {
          doctorsData = json.decode(results[Constants.keyDoctor]);
          try {
            setValueToDoctorDropdown(doctorsData, setState);
          } catch (e) {}

          print(doctorsData[parameters.strFirstName]);
          if (doctorsData[parameters.strName] != '' &&
              doctorsData[parameters.strName] != null) {
            doctorsName.text = doctorsData[parameters.strName];
            doctor.text = doctorsData[parameters.strName];
          } else {
            doctorsName.text = doctorsData[parameters.strFirstName] +
                ' ' +
                doctorsData[parameters.strLastName];
            doctor.text = doctorsData[parameters.strFirstName] +
                ' ' +
                doctorsData[parameters.strLastName];
          }
        } else if (results.containsKey(Constants.keyHospital)) {
          hospitalData = json.decode(results[Constants.keyHospital]);

          hospitalName.text =
              hospitalData[parameters.strHealthOrganizationName];
          hospital.text = hospitalData[parameters.strHealthOrganizationName];
        } else if (results.containsKey(Constants.keyLab)) {
          labData = json.decode(results[Constants.keyLab]);

          labName.text = labData[parameters.strHealthOrganizationName];
          lab.text = labData[parameters.strHealthOrganizationName];
        }
        onTextFinished();
      }
    });
  }

  Widget getMicIcon(BuildContext context, bool containsAudio, String audioPath,
      Function(bool, String) updateUI) {
    return GestureDetector(
      child: Container(
        height: 80.0.h,
        width: 80.0.h,
        padding: EdgeInsets.all(10),
        child: Material(
          color: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: CircleBorder(),
          child: CircleAvatar(
            backgroundColor: ColorUtils.greycolor,
            child: Icon(
              Icons.mic,
              size: 40.0.sp,
              color: Colors.black,
            ),
            radius: 30.0.sp,
          ),
        ),
      ),
      onTap: () async {
        await Navigator.of(context)
            .push(MaterialPageRoute(
          builder: (context) => AudioRecordScreen(
              arguments: AudioScreenArguments(
            fromVoice: false,
          )),
        ))
            .then((results) {
          if (results != null) {
            if (results.containsKey(Constants.keyAudioFile)) {
              containsAudio = true;
              audioPath = results[Constants.keyAudioFile];

              audioPathMain = audioPath;
              containsAudioMain = containsAudio;

              updateUI(containsAudioMain, audioPathMain);
            }
          }
        });
      },
    );
  }

  void onPostDataToServer(BuildContext context, List<String> imagePath,
      {Function onRefresh}) async {
    if (doValidationBeforePosting()) {
      CommonUtil.showLoadingDialog(context, _keyLoader, variable.Please_Wait);

      Map<String, dynamic> postMainData = new Map();
      Map<String, dynamic> postMediaData = new Map();

      String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);
      if (modeOfSave) {
        postMainData[parameters.struserId] = userID;
      }
      List<CategoryResult> catgoryDataList = PreferenceUtil.getCategoryType();

      categoryDataObj = new CommonUtil()
          .getCategoryObjForSelectedLabel(categoryID, catgoryDataList);
      postMediaData[parameters.strhealthRecordCategory] =
          categoryDataObj.toJson();
      MediaTypeBlock _mediaTypeBlock = new MediaTypeBlock();

      MediaDataList mediaTypesResponse =
          await _mediaTypeBlock.getMediTypesList();

      List<MediaResult> metaDataFromSharedPrefernce = mediaTypesResponse.result;
      if (categoryName != Constants.STR_DEVICES) {
        mediaDataObj = new CommonUtil().getMediaTypeInfoForParticularLabel(
            categoryID, metaDataFromSharedPrefernce, categoryName);
      } else {
        mediaDataObj = new CommonUtil().getMediaTypeInfoForParticularDevice(
            deviceName, metaDataFromSharedPrefernce);
      }

      postMediaData[parameters.strhealthRecordType] = mediaDataObj.toJson();

      postMediaData[parameters.strmemoText] = memoController.text;

      if (categoryName != Constants.STR_VOICERECORDS) {
        postMediaData[parameters.strhasVoiceNotes] =
            (audioPathMain != '' && audioPathMain != null) ? true : false;

        postMediaData[parameters.strdateOfVisit] = dateOfVisit.text;
      } else {
        postMediaData[parameters.strhasVoiceNotes] =
            (audioPathMain != '' && audioPathMain != null) ? true : false;
      }

      postMediaData[parameters.strisDraft] = false;

      postMediaData[parameters.strSourceName] = CommonConstants.strTridentValue;
      postMediaData[parameters.strmemoTextRaw] = memoController.text;
      if (modeOfSave) {
        DateTime dateTime = DateTime.now();
        postMediaData[parameters.strStartDate] =
            deviceHealthResult.metadata.startDateTime ??
                dateTime.toUtc().toString();
        postMediaData[parameters.strEndDate] =
            deviceHealthResult.metadata.endDateTime ??
                dateTime.toUtc().toString();
      } else {
        DateTime dateTime = DateTime.now();
        postMediaData[parameters.strStartDate] = dateTime.toUtc().toString();
        postMediaData[parameters.strEndDate] = dateTime.toUtc().toString();
      }
      var commonConstants = new CommonConstants();

      if (categoryName == CommonConstants.strDevice) {
        List<Map<String, dynamic>> postDeviceData = new List();
        Map<String, dynamic> postDeviceValues = new Map();
        Map<String, dynamic> postDeviceValuesExtra = new Map();
        Map<String, dynamic> postDeviceValuesExtraClone = new Map();

        if (deviceName == Constants.STR_GLUCOMETER) {
          postDeviceValues[parameters.strParameters] =
              CommonConstants.strSugarLevel;
          postDeviceValues[parameters.strvalue] = deviceController.text;
          postDeviceValues[parameters.strunit] =
              CommonConstants.strGlucometerValue;
          postDeviceData.add(postDeviceValues);
          postDeviceValuesExtra[parameters.strParameters] =
              CommonConstants.strTimeIntake;
          postDeviceValuesExtra[parameters.strvalue] = '';
          postDeviceValuesExtra[parameters.strunit] =
              isSelected[0] == true ? variable.strBefore : variable.strAfter;
          postDeviceData.add(postDeviceValuesExtra);
        } else if (deviceName == Constants.STR_THERMOMETER) {
          postDeviceValues[parameters.strParameters] =
              CommonConstants.strTemperature;
          postDeviceValues[parameters.strvalue] = deviceController.text;
          postDeviceValues[parameters.strunit] = commonConstants.tempUNIT;
          postDeviceData.add(postDeviceValues);
        } else if (deviceName == Constants.STR_WEIGHING_SCALE) {
          postDeviceValues[parameters.strParameters] =
              CommonConstants.strWeightParam;
          postDeviceValues[parameters.strvalue] = deviceController.text;
          postDeviceValues[parameters.strunit] = CommonConstants.strWeightUnit;
          postDeviceData.add(postDeviceValues);
        } else if (deviceName == Constants.STR_PULSE_OXIMETER) {
          postDeviceValues[parameters.strParameters] =
              CommonConstants.strOxygenParams;
          postDeviceValues[parameters.strvalue] = deviceController.text;
          postDeviceValues[parameters.strunit] = CommonConstants.strOxygenUnits;
          postDeviceData.add(postDeviceValues);

          postDeviceValuesExtra[parameters.strParameters] =
              CommonConstants.strPulseRate;
          postDeviceValuesExtra[parameters.strvalue] = pulse.text;
          postDeviceValuesExtra[parameters.strunit] =
              CommonConstants.strPulseValue;

          postDeviceData.add(postDeviceValuesExtra);
        } else if (deviceName == Constants.STR_BP_MONITOR) {
          postDeviceValues[parameters.strParameters] =
              CommonConstants.strBPParams;
          postDeviceValues[parameters.strvalue] = deviceController.text;

          postDeviceValues[parameters.strunit] = CommonConstants.strBPUNits;
          postDeviceData.add(postDeviceValues);

          postDeviceValuesExtra[parameters.strParameters] =
              CommonConstants.strDiastolicParams;
          postDeviceValuesExtra[parameters.strvalue] = diaStolicPressure.text;
          postDeviceValuesExtra[parameters.strunit] =
              CommonConstants.strBPUNits;

          postDeviceData.add(postDeviceValuesExtra);

          postDeviceValuesExtraClone[parameters.strParameters] =
              CommonConstants.strPulseRate;
          postDeviceValuesExtraClone[parameters.strvalue] = pulse.text;
          postDeviceValuesExtraClone[parameters.strunit] =
              CommonConstants.strPulseUnit;

          postDeviceData.add(postDeviceValuesExtraClone);
        }
        postMediaData[parameters.strdeviceReadings] = postDeviceData;
      } else if (categoryName == Constants.STR_PRESCRIPTION ||
          categoryName == Constants.STR_MEDICALREPORT) {
        postMediaData[Constants.keyDoctor] = doctorsData;
        if (hospitalData == null) {
        } else {
          postMediaData[Constants.keyHospital] = hospitalData;
        }
      } else if (categoryName == Constants.STR_IDDOCS) {
        if (selectedMediaData != null) {
          postMediaData[parameters.stridType] =
              selectedMediaData.name.split(' ')[0];
        }
      } else if (categoryName == Constants.STR_LABREPORT) {
        postMediaData[Constants.keyDoctor] = doctorsData;
        postMediaData[Constants.keyLab] = labData;
      }
      postMediaData[parameters.strfileName] = fileName.text;

      postMainData[parameters.strmetaInfo] = postMediaData;
      if (modeOfSave) {
        postMainData[parameters.strIsActive] = false;
      }

      var params = json.encode(postMediaData);
      print(params);

      if (modeOfSave) {
        audioPathMain = '';
        _healthReportListForUserBlock
            .updateHealthRecords(
                params.toString(), imagePath, audioPathMain, metaInfoId)
            .then((value) {
          if (value.isSuccess && value != null) {
            _healthReportListForUserBlock.getHelthReportLists().then((value) {
              PreferenceUtil.saveCompleteData(
                  Constants.KEY_COMPLETE_DATA, value);

              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            });
          } else {
            Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
            toast.getToast(Constants.ERR_MSG_RECORD_CREATE, Colors.red);
          }
        });
      } else {
        _healthReportListForUserBlock
            .createHealtRecords(params.toString(), imagePath, audioPathMain)
            .then((value) {
          if (value != null && value.isSuccess) {
            _healthReportListForUserBlock
                .getHelthReportLists()
                .then((value) async {
              PreferenceUtil.saveCompleteData(
                  Constants.KEY_COMPLETE_DATA, value);
              if (categoryName == Constants.STR_VOICERECORDS) {
                Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                    .pop();

                Navigator.of(context).pop();

                List<String> recordIds = new List();
                recordIds.add(value.result[0].id);
                CommonUtil.audioPage = true;
                if (fromClassNew == 'audio') {
                  await Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyRecords(
                            argument: MyRecordsArgument(
                          categoryPosition:
                              getCategoryPosition(Constants.STR_VOICERECORDS),
                          allowSelect: false,
                          isAudioSelect: true,
                          isNotesSelect: false,
                          selectedMedias: recordIds,
                          isFromChat: false,
                          showDetails: true,
                          isAssociateOrChat: false,
                          userID: userID,
                          fromClass: 'audio',
                        )),
                      )).then((results) {});
                } else if (fromClassNew == '') {
                  CommonUtil.audioPage = false;

                  await Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyRecords(
                            argument: MyRecordsArgument(
                          categoryPosition:
                              getCategoryPosition(Constants.STR_VOICERECORDS),
                          allowSelect: false,
                          isAudioSelect: true,
                          isNotesSelect: false,
                          selectedMedias: new List(),
                          isFromChat: false,
                          showDetails: true,
                          isAssociateOrChat: false,
                          userID: userID,
                          fromClass: fromClassNew,
                        )),
                      )).then((results) {});
                } else {
                  Navigator.of(context).pop();
                }
              } else if (categoryName == Constants.STR_NOTES) {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                onRefresh(true);
              } else {
                Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                    .pop();

                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              }
            });
          } else {
            Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
            toast.getToast(Constants.ERR_MSG_RECORD_CREATE, Colors.red);
          }
        });
      }
    } else {
      showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text(variable.strAPP_NAME),
            content: new Text(validationMsg),
          ));
    }
  }

  void postAudioToServer(String mediaMetaID, BuildContext context,
      {Function onRefresh}) {
    Map<String, dynamic> postImage = new Map();

    postImage[parameters.strmediaMetaId] = mediaMetaID;

    int k = 0;
    for (int i = 0; i < imagePathMain.length; i++) {
      _healthReportListForUserBlock
          .saveImage(imagePathMain[i].trim(), mediaMetaID, '')
          .then((postImageResponse) {
        if ((audioPathMain != '' && k == imagePathMain.length) ||
            (audioPathMain != '' && k == imagePathMain.length - 1)) {
          _healthReportListForUserBlock
              .saveImage(audioPathMain, mediaMetaID, '')
              .then((postImageResponse) {
            _healthReportListForUserBlock.getHelthReportLists().then((value) {
              PreferenceUtil.saveCompleteData(
                      Constants.KEY_COMPLETE_DATA, value)
                  .then((value) {
                Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                    .pop();

                if (categoryName == Constants.STR_NOTES) {
                  Navigator.of(context).pop();
                  onRefresh(true);
                } else {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(true);
                }
              });
            });
          });
        } else if (k == imagePathMain.length - 1) {
          _healthReportListForUserBlock.getHelthReportLists().then((value) {
            PreferenceUtil.saveCompleteData(Constants.KEY_COMPLETE_DATA, value)
                .then((value) {
              Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                  .pop();

              if (categoryName == Constants.STR_NOTES) {
                Navigator.of(context).pop();
                onRefresh(true);
              } else {
                Navigator.of(context).pop();
                Navigator.of(context).pop(true);
              }
            });
          });
        } else if (k == imagePathMain.length && modeOfSave == true) {
          _healthReportListForUserBlock.getHelthReportLists().then((value) {
            PreferenceUtil.saveCompleteData(Constants.KEY_COMPLETE_DATA, value)
                .then((value) {
              Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                  .pop();

              if (categoryName == Constants.STR_NOTES) {
                Navigator.of(context).pop();
                onRefresh(true);
              } else {
                Navigator.of(context).pop();
                Navigator.of(context).pop(true);
              }
            });
          });
        }

        k++;
      });
    }
  }

  void saveAudioFile(BuildContext context, String audioPath, String mediaMetaID,
      {Function onRefresh}) {
    if (audioPathMain != '') {
      _healthReportListForUserBlock
          .saveImage(audioPathMain, mediaMetaID, '')
          .then((postImageResponse) {
        _healthReportListForUserBlock.getHelthReportLists().then((value) {
          PreferenceUtil.saveCompleteData(Constants.KEY_COMPLETE_DATA, value)
              .then((value) {
            Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

            if (categoryName == Constants.STR_NOTES) {
              Navigator.of(context).pop();
              onRefresh(true);
            } else {
              Navigator.of(context).pop();
              Navigator.of(context).pop(true);
            }
          });
        });
      });
    } else {
      if (categoryName == Constants.STR_NOTES) {
        Navigator.of(context).pop();
        onRefresh(true);
      } else {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
    }
  }

  bool doValidationBeforePosting() {
    bool validationConditon = false;
    if (categoryName == Constants.STR_PRESCRIPTION ||
        categoryName == Constants.STR_MEDICALREPORT) {
      if (doctor.text == '') {
        validationConditon = false;
        validationMsg = CommonConstants.strDoctorsEmpty;
      } else if (fileName.text == '') {
        validationConditon = false;
        validationMsg = CommonConstants.strFileEmpty;
      } else if (memoController.text.length > 500) {
        validationConditon = false;
        validationMsg = CommonConstants.strMemoCrossedLimit;
      } else {
        validationConditon = true;
      }
    } else if (categoryName == Constants.STR_LABREPORT) {
      if (lab.text == '') {
        validationConditon = false;
        validationMsg = CommonConstants.strLabEmpty;
      } else if (doctor.text == '') {
        validationConditon = false;
        validationMsg = CommonConstants.strDoctorsEmpty;
      } else if (fileName.text == '') {
        validationConditon = false;
        validationMsg = CommonConstants.strFileEmpty;
      } else {
        validationConditon = true;
      }
    } else if (categoryName == Constants.STR_BILLS ||
        categoryName == Constants.STR_OTHERS ||
        categoryName == Constants.STR_CLAIMSRECORD) {
      if (fileName.text == '') {
        validationConditon = false;
        validationMsg = CommonConstants.strFileEmpty;
      } else {
        validationConditon = true;
      }
    } else if (categoryName == Constants.STR_VOICERECORDS) {
      if (fileName.text == '') {
        validationConditon = false;
        validationMsg = CommonConstants.strFileEmpty;
      } else {
        validationConditon = true;
        validationMsg = CommonConstants.strExpDateEmpty;
      }
    } else if (categoryName == Constants.STR_IDDOCS) {
      if (fileName.text == '') {
        validationConditon = false;
        validationMsg = CommonConstants.strFileEmpty;
      } else if (dateOfVisit.text == '') {
        validationConditon = false;
        validationMsg = CommonConstants.strExpDateEmpty;
      } else if (selectedMediaData == null) {
        validationConditon = false;
        validationMsg = CommonConstants.strIDEmpty;
      } else {
        validationConditon = true;
      }
    } else if (categoryName == Constants.STR_NOTES) {
      if (fileName.text == '') {
        validationConditon = false;
        validationMsg = CommonConstants.strFileEmpty;
      } else if (memoController.text == '') {
        validationConditon = false;
        validationMsg = CommonConstants.strMemoEmpty;
      } else {
        validationConditon = true;
      }
    } else if (categoryName == Constants.STR_DEVICES) {
      if (deviceName == Constants.STR_GLUCOMETER) {
        if (fileName.text == '') {
          validationConditon = false;
          validationMsg = CommonConstants.strFileEmpty;
        } else if (deviceController.text == '' ||
            deviceController.text == null) {
          validationConditon = false;
          validationMsg = CommonConstants.strSugarLevelEmpty;
        } else {
          validationConditon = true;
        }
      } else if (deviceName == Constants.STR_BP_MONITOR) {
        if (fileName.text == '') {
          validationConditon = false;
          validationMsg = CommonConstants.strFileEmpty;
        } else if (deviceController.text == '' ||
            deviceController.text == null) {
          validationConditon = false;
          validationMsg = CommonConstants.strSystolicsEmpty;
        } else if (diaStolicPressure.text == '' ||
            diaStolicPressure.text == null) {
          validationConditon = false;
          validationMsg = CommonConstants.strDiastolicEmpty;
        } else if (pulse.text == '' || pulse.text == null) {
          validationConditon = false;
          validationMsg = CommonConstants.strPulseEmpty;
        } else {
          validationConditon = true;
        }
      } else if (deviceName == Constants.STR_THERMOMETER) {
        if (fileName.text == '') {
          validationConditon = false;
          validationMsg = CommonConstants.strFileEmpty;
        } else if (deviceController.text == '' ||
            deviceController.text == null) {
          validationConditon = false;
          validationMsg = CommonConstants.strtemperatureEmpty;
        } else {
          validationConditon = true;
        }
      } else if (deviceName == Constants.STR_WEIGHING_SCALE) {
        if (fileName.text == '') {
          validationConditon = false;
          validationMsg = CommonConstants.strFileEmpty;
        } else if (deviceController.text == '' ||
            deviceController.text == null) {
          validationConditon = false;
          validationMsg = CommonConstants.strWeightEmpty;
        } else {
          validationConditon = true;
        }
      } else if (deviceName == Constants.STR_PULSE_OXIMETER) {
        if (fileName.text == '') {
          validationConditon = false;
          validationMsg = CommonConstants.strFileEmpty;
        } else if (deviceController.text == '' ||
            deviceController.text == null) {
          validationConditon = false;
          validationMsg = CommonConstants.strOxugenSaturationEmpty;
        } else if (pulse.text == '' || pulse.text == null) {
          validationConditon = false;
          validationMsg = CommonConstants.strPulseEmpty;
        } else {
          validationConditon = true;
        }
      }
    }

    return validationConditon;
  }

  Future<Widget> getDialogForVoicerecords(
      BuildContext context,
      bool containsAudio,
      String audioPath,
      Function(bool, String) deleteAudioFunction,
      Function(bool, String) updateAudioUI,
      bool modeOfSaveClone,
      TextEditingController fileNameClone,
      {String fromClass}) async {
    modeOfSave = modeOfSaveClone;
    containsAudioMain = containsAudio;
    audioPathMain = audioPath;
    categoryName = PreferenceUtil.getStringValue(Constants.KEY_CATEGORYNAME);
    deviceName = PreferenceUtil.getStringValue(Constants.KEY_CATEGORYNAME);
    categoryID = PreferenceUtil.getStringValue(Constants.KEY_CATEGORYID);
    setFileName(fileNameClone.text, null);

    filteredCategoryData = await PreferenceUtil.getCategoryTypeDisplay(
        Constants.KEY_CATEGORYLIST_VISIBLE);
    fromClassNew = fromClass;
    StatefulBuilder dialog = new StatefulBuilder(builder: (context, setState) {
      return new AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: fhbBasicWidget
            .getTextTextTitleWithPurpleColor(Constants.STR_VOICERECORDS),
        content: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            fhbBasicWidget.getTextForAlertDialog(
                context, CommonConstants.strFileName),
            fhbBasicWidget.getTextFieldWithNoCallbacks(context, fileName),
            SizedBox(
              height: 15.0.h,
            ),
            fhbBasicWidget.getTextForAlertDialog(
                context, CommonConstants.strMemo),
            fhbBasicWidget.getTextFieldWithNoCallbacksForMemo(
                context, memoController),
            SizedBox(
              height: 15.0.h,
            ),
            modeOfSave
                ? fhbBasicWidget.getSaveButton(() {
                    onPostDataToServer(context, null);
                  })
                : containsAudioMain
                    ? fhbBasicWidget.getAudioIconWithFile(
                        audioPath,
                        containsAudio,
                        (containsAudio, audioPath) {
                          audioPathMain = audioPath;
                          containsAudioMain = containsAudio;
                          deleteAudioFunction(containsAudio, audioPath);
                        },
                        context,
                        null,
                        (context, imagePath) {
                          onPostDataToServer(context, imagePath);
                        })
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          fhbBasicWidget
                              .getMicIcon(context, containsAudio, audioPath,
                                  (containsAudio, audioPath) {
                            audioPathMain = audioPath;
                            containsAudioMain = containsAudio;
                            updateAudioUI(containsAudioMain, audioPathMain);
                            setState(() {});
                          }),
                          fhbBasicWidget.getSaveButton(() {
                            onPostDataToServer(context, null);
                          })
                        ],
                      ),
          ],
        )),
      );
    });

    return showDialog(
        context: context, builder: (BuildContext context) => dialog);
  }

  void setPrefreferedProvidersIfAvailable(
      String hospitalText, String doctorsText, String labtext) {
    try {
      PreferenceUtil.getPreferedDoctor(Constants.KEY_PREFERRED_DOCTOR)
          .then((doctorIds) {
        if (doctorIds != null) {
          DoctorsData preferedDoctorData = new DoctorsData(
              id: doctorIds.id,
              name: doctorIds.name,
              addressLine1: doctorIds.addressLine1,
              addressLine2: doctorIds.addressLine2,
              website: doctorIds.website,
              googleMapUrl: doctorIds.googleMapUrl,
              phoneNumber1: doctorIds.phoneNumber1,
              phoneNumber2: doctorIds.phoneNumber2,
              phoneNumber3: doctorIds.phoneNumber3,
              phoneNumber4: doctorIds.phoneNumber4,
              city: doctorIds.city,
              state: doctorIds.state,
              createdBy: doctorIds.createdBy,
              description: doctorIds.description,
              isActive: doctorIds.isActive,
              specialization: doctorIds.specialization,
              isUserDefined: doctorIds.isUserDefined,
              lastModifiedOn: doctorIds.lastModifiedOn);

          doctorsData = preferedDoctorData;

          doctor.text = preferedDoctorData.name;
        }
      });
    } catch (e) {
      doctor.text = doctorsText;
    }

    try {
      PreferenceUtil.getPreferredHospital(Constants.KEY_PREFERRED_HOSPITAL)
          .then((hospitalIds) {
        if (hospitalIds != null) {
          HospitalData preferredHospitalData = new HospitalData(
              id: hospitalIds.id,
              name: hospitalIds.name,
              addressLine1: hospitalIds.addressLine1,
              addressLine2: hospitalIds.addressLine2,
              website: hospitalIds.website,
              googleMapUrl: hospitalIds.googleMapUrl,
              phoneNumber1: hospitalIds.phoneNumber1,
              phoneNumber2: hospitalIds.phoneNumber2,
              phoneNumber3: hospitalIds.phoneNumber3,
              phoneNumber4: hospitalIds.phoneNumber4,
              city: hospitalIds.city,
              state: hospitalIds.state,
              createdBy: hospitalIds.createdBy,
              description: hospitalIds.description,
              isActive: hospitalIds.isActive,
              isUserDefined: hospitalIds.isUserDefined,
              lastModifiedOn: hospitalIds.lastModifiedOn);

          hospitalData = preferredHospitalData;

          hospital.text = preferredHospitalData.name;
        }
      });
    } catch (e) {
      hospital.text = hospitalText;
    }

    try {
      PreferenceUtil.getPreferredLab(Constants.KEY_PREFERRED_LAB)
          .then((laborartoryIds) {
        if (laborartoryIds != null) {
          LabData preferredlabData = new LabData(
              id: laborartoryIds.id,
              name: laborartoryIds.name,
              addressLine1: laborartoryIds.addressLine1,
              addressLine2: laborartoryIds.addressLine2,
              website: laborartoryIds.website,
              googleMapUrl: laborartoryIds.googleMapUrl,
              phoneNumber1: laborartoryIds.phoneNumber1,
              phoneNumber2: laborartoryIds.phoneNumber2,
              phoneNumber3: laborartoryIds.phoneNumber3,
              phoneNumber4: laborartoryIds.phoneNumber4,
              city: laborartoryIds.city,
              state: laborartoryIds.state,
              createdBy: laborartoryIds.createdBy,
              description: laborartoryIds.description,
              isActive: laborartoryIds.isActive,
              isUserDefined: laborartoryIds.isUserDefined,
              lastModifiedOn: laborartoryIds.lastModifiedOn);

          labData = preferredlabData;

          lab.text = preferredlabData.name;
        }
      });
    } catch (e) {
      lab.text = labtext;
    }
  }

  void dateOfBirthTapped(
      BuildContext context, TextEditingController dateOfVisit) {
    _selectDate(context, dateOfVisit);
  }

  Widget _showDateOfVisit(
      BuildContext context, TextEditingController dateOfVisit) {
    return GestureDetector(
      onTap: () {
        dateOfBirthTapped(context, dateOfVisit);
      },
      child: Container(
          child: TextField(
        cursorColor: Color(CommonUtil().getMyPrimaryColor()),
        controller: dateOfVisit,
        maxLines: 1,
        autofocus: false,
        readOnly: true,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        onSubmitted: (term) {
          dateOfBirthFocus.unfocus();
        },
        decoration: InputDecoration(
          suffixIcon: new IconButton(
            icon: new Icon(Icons.calendar_today),
            onPressed: () {
              _selectDate(context, dateOfVisit);
            },
          ),
        ),
      )),
    );
  }

  void loadMemoText(String memoText) {
    memoController.text = memoText;
  }

  Future<Widget> getDialogBoxForNotes(
      BuildContext context,
      bool containsAudio,
      String audioPath,
      Function(bool, String) deleteAudioFunction,
      List<String> imagePath,
      Function(bool, String) updateAudioUI,
      HealthResult mediaMetaInfoClone,
      bool modeOfSaveClone,
      TextEditingController fileNameClone,
      Function(bool) refresh) {
    if (mediaMetaInfoClone != null) {
      if (mediaMetaInfoClone != null) {
        metaInfoId = mediaMetaInfoClone.id;
      }
    }
    modeOfSave = modeOfSaveClone;
    containsAudioMain = containsAudio;
    audioPathMain = audioPath;
    forNotes = true;

    if (imagePath != null) imagePathMain.addAll(imagePath);
    if (modeOfSave) {
      deviceHealthResult = mediaMetaInfoClone;
      loadMemoText(mediaMetaInfoClone.metadata.memoText != null
          ? mediaMetaInfoClone.metadata.memoText
          : '');
    } else {
      memoController.text = '';
    }

    setFileName(fileNameClone.text, mediaMetaInfoClone);
    categoryName = Constants.STR_NOTES;
    StatefulBuilder dialog = new StatefulBuilder(builder: (context, setState) {
      return new AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            fhbBasicWidget.getTextTextTitleWithPurpleColor(
                categoryName != null ? categoryName : 'Notes'),
            IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black54,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
        content: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            fhbBasicWidget.getTextForAlertDialog(
                context, CommonConstants.strFileName),
            fhbBasicWidget.getTextFieldWithNoCallbacks(context, fileName),
            SizedBox(
              height: 15.0.h,
            ),
            fhbBasicWidget.getTextForAlertDialog(
                context, CommonConstants.strMemo),
            fhbBasicWidget.getRichTextFieldWithNoCallbacks(
                context, memoController,Constants.STR_NOTES_HINT,500),
            SizedBox(
              height: 15.0.h,
            ),
            modeOfSave
                ? fhbBasicWidget.getSaveButton(() {
                    onPostDataToServer(context, imagePath, onRefresh: refresh);
                  })
                : containsAudioMain
                    ? fhbBasicWidget.getAudioIconWithFile(
                        audioPathMain,
                        containsAudioMain,
                        (containsAudio, audioPath) {
                          audioPathMain = audioPath;
                          containsAudioMain = containsAudio;
                          updateAudioUI(containsAudioMain, audioPathMain);
                          setState(() {});
                        },
                        context,
                        imagePath,
                        (context, imagePath) {
                          onPostDataToServer(context, imagePath,
                              onRefresh: refresh);
                        })
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          fhbBasicWidget
                              .getMicIcon(context, containsAudio, audioPath,
                                  (containsAudio, audioPath) {
                            audioPathMain = audioPath;
                            containsAudioMain = containsAudio;
                            updateAudioUI(containsAudioMain, audioPathMain);
                            setState(() {});
                          }),
                          fhbBasicWidget.getSaveButton(() {
                            onPostDataToServer(context, imagePath,
                                onRefresh: refresh);
                          })
                        ],
                      ),
          ],
        )),
      );
    });

    return showDialog(
        context: context, builder: (BuildContext context) => dialog);
  }

  getCategoryPosition(String categoryName) {
    int categoryPosition;
    switch (categoryName) {
      case Constants.STR_NOTES:
        categoryPosition = pickPosition(categoryName);
        return categoryPosition;
        break;

      case Constants.STR_PRESCRIPTION:
        categoryPosition = pickPosition(categoryName);
        return categoryPosition;
        break;

      case Constants.STR_VOICERECORDS:
        categoryPosition = pickPosition(categoryName);
        return categoryPosition;
        break;
      case Constants.STR_BILLS:
        categoryPosition = pickPosition(categoryName);
        return categoryPosition;
        break;
      default:
        categoryPosition = 0;
        return categoryPosition;

        break;
    }
  }

  int pickPosition(String categoryName) {
    int position = 0;
    List<CategoryResult> categoryDataList = List();
    categoryDataList = getCategoryList();
    for (int i = 0;
        i < (categoryDataList == null ? 0 : categoryDataList.length);
        i++) {
      if (categoryName == categoryDataList[i].categoryName) {
        print(categoryName + ' ****' + categoryDataList[i].categoryName);
        position = i;
      }
    }
    if (categoryName == Constants.STR_PRESCRIPTION) {
      return position;
    } else {
      return position;
    }
  }

  List<CategoryResult> getCategoryList() {
    if (filteredCategoryData == null || filteredCategoryData.length == 0) {
      _categoryListBlock.getCategoryLists().then((value) {
        filteredCategoryData = new CommonUtil().fliterCategories(value.result);
        PreferenceUtil.saveCategoryList(
            Constants.KEY_CATEGORYLIST_VISIBLE, filteredCategoryData);
        //filteredCategoryData.add(categoryDataObjClone);
        return filteredCategoryData;
      });
    } else {
      return filteredCategoryData;
    }
  }

  Widget getAllCustomRoles(Doctors doctorObj, Function onAdd) {
    Widget familyWidget;

    return StreamBuilder<ApiResponse<MyProvidersResponse>>(
      stream: _providersBloc.providersListStream,
      builder:
          (context, AsyncSnapshot<ApiResponse<MyProvidersResponse>> snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              familyWidget = Center(
                  child: SizedBox(
                child: CircularProgressIndicator(),
                width: 30.0.h,
                height: 30.0.h,
              ));
              break;

            case Status.ERROR:
              familyWidget = Center(
                  child: Text(Constants.STR_ERROR_LOADING_DATA,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16.0.sp,
                      )));
              break;

            case Status.COMPLETED:
              if (snapshot.data != null &&
                  snapshot.data.data != null &&
                  snapshot.data.data.result != null &&
                  snapshot.data.data.result.doctors != null &&
                  snapshot.data.data.result.doctors.length > 0) {
                doctorsListFromProvider = snapshot.data.data.result.doctors;
                filterDuplicateDoctor();
                familyWidget = getDoctorDropDown(
                  doctorsListFromProvider,
                  doctorObj,
                  onAdd,
                );
              } else {
                doctorsListFromProvider = new List();
                familyWidget = getDoctorDropDownWhenNoList(
                    doctorsListFromProvider, null, onAdd);
              }

              return familyWidget;
              break;
          }
        } else {
          doctorsListFromProvider = new List();
          familyWidget = Container(
            width: 100.0.h,
            height: 100.0.h,
          );
        }
        return familyWidget;
      },
    );
  }

  getDoctorDropDown(
      List<Doctors> doctors, Doctors doctorObjSample, Function onAddClick,
      {Widget child}) {
    if (doctorObjSample != null) {
      for (Doctors doctorsObjS in doctors) {
        if (doctorsObjS.id == doctorObjSample.id) {
          doctorObj = doctorsObjS;
        }
      }
    }

    return StatefulBuilder(builder: (context, setState) {
      return PopupMenuButton<Doctors>(
        offset: Offset(-100.0, 70.0),
        //padding: EdgeInsets.all(20),
        itemBuilder: (context) => (doctors != null && doctors.length > 0)
            ? doctors
                .mapIndexed((int index, element) => index == doctors.length - 1
                    ? PopupMenuItem<Doctors>(
                        value: element,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text(element.user != null
                                  ? new CommonUtil().getDoctorName(element.user)
                                  : ''),
                              width: 0.5.sw,
                            ),
                            SizedBox(height: 10),
                            fhbBasicWidget.getSaveButton(() {
                              onAddClick();
                            }, text: 'Add Doctor'),
                            SizedBox(height: 10),
                          ],
                        ))
                    : PopupMenuItem<Doctors>(
                        value: element,
                        child: Container(
                          child: Text(element.user != null
                              ? new CommonUtil().getDoctorName(element.user)
                              : ''),
                          width: 0.5.sw,
                        ),
                      ))
                .toList()
            : PopupMenuItem<Doctors>(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    fhbBasicWidget.getSaveButton(() {
                      onAddClick();
                    }, text: 'Add Doctor'),
                    SizedBox(height: 10)
                  ],
                ),
              ),
        onSelected: (value) {
          doctorObj = value;
          setDoctorValue(value);
          setState(() {
            doctor.text = value.user != null
                ? new CommonUtil().getDoctorName(value.user)
                : '';
          });
        },
        child: child ?? getIconButton(),
      );
    });
  }

  getDoctorDropDownWhenNoList(
      List<Doctors> doctors, Doctors doctorObjSample, Function onAddClick,
      {Widget child}) {
    if (doctorObjSample != null) {
      for (Doctors doctorsObjS in doctors) {
        if (doctorsObjS.id == doctorObjSample.id) {
          doctorObj = doctorsObjS;
        }
      }
    }

    return (doctors != null && doctors.length > 0)
        ? StatefulBuilder(builder: (context, setState) {
            return PopupMenuButton<Doctors>(
              offset: Offset(-100.0, 70.0),
              //padding: EdgeInsets.all(20),
              itemBuilder: (context) => doctors
                  .mapIndexed(
                      (int index, element) => index == doctors.length - 1
                          ? PopupMenuItem<Doctors>(
                              value: element,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                      element.user.name,
                                    ),
                                    width: 0.5.sw,
                                  ),
                                  SizedBox(height: 10),
                                  fhbBasicWidget.getSaveButton(() {
                                    onAddClick();
                                  }, text: 'Add Doctor'),
                                  SizedBox(height: 10),
                                ],
                              ))
                          : PopupMenuItem<Doctors>(
                              value: element,
                              child: Container(
                                child: Text(
                                  element.user.name,
                                ),
                                width: 0.5.sw,
                              ),
                            ))
                  .toList(),
              onSelected: (value) {
                doctorObj = value;
                setDoctorValue(value);
                setState(() {
                  doctor.text = doctorObj.user.name;
                });
              },
              child: child ?? getIconButton(),
            );
          })
        : StatefulBuilder(builder: (context, setState) {
            return PopupMenuButton<Doctors>(
              offset: Offset(-100.0, 70.0),
              itemBuilder: (context) => <PopupMenuItem<Doctors>>[
                PopupMenuItem<Doctors>(
                    child: Container(
                  width: 150,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      fhbBasicWidget.getSaveButton(() {
                        onAddClick();
                      }, text: 'Add Doctor'),
                      SizedBox(height: 10)
                    ],
                  ),
                )),
              ],
              onSelected: (_) {},
              child: getIconButton(),
            );
          });
  }

  void setDoctorValue(Doctors newValue) {
    Doctor doctorNewObj = new Doctor(
      doctorId: newValue.id,
      name: newValue.user.name,
      firstName: newValue.user.firstName,
      lastName: newValue.user.lastName,
      addressLine1: newValue.user.userAddressCollection3[0].addressLine1,
      addressLine2: newValue.user.userAddressCollection3[0].addressLine2,
      isMciVerified: newValue.isMciVerified,
      isTelehealthEnabled: newValue.isTelehealthEnabled,
      profilePicThumbnailUrl: newValue.user.profilePicThumbnailUrl,
      specialization: newValue.specialization,
      userId: newValue.user.id,
    );

    doctorsData = doctorNewObj;
  }

  void setValueToDoctorDropdown(doctorsData, Function onTextFinished) {
    address.UserAddressCollection3 userAddressCollection3 =
        new address.UserAddressCollection3(
            addressLine1: doctorsData[parameters.strAddressLine1],
            addressLine2: doctorsData[parameters.strAddressLine2]);
    List<address.UserAddressCollection3> userAddressCollection3List =
        new List();
    userAddressCollection3List.add(userAddressCollection3);
    User user = new User(
        id: doctorsData[parameters.struserId],
        name: doctorsData[parameters.strName],
        firstName: doctorsData[parameters.strFirstName],
        lastName: doctorsData[parameters.strLastName],
        userAddressCollection3: userAddressCollection3List);

    doctorObj = new Doctors(
        id: doctorsData[parameters.strDoctorId],
        specialization: doctorsData[parameters.strSpecilization],
        isTelehealthEnabled: doctorsData[parameters.strisTelehealthEnabled],
        isMciVerified: doctorsData[parameters.strisMCIVerified],
        user: user);

    doctorsListFromProvider.add(doctorObj);
    filterDuplicateDoctor();
    getDoctorDropDown(doctorsListFromProvider, doctorObj, onTextFinished);
  }

  void setDoctorValueFromResponse(HealthResult mediaMetaInfo) {
    if (mediaMetaInfo.metadata.doctor != null) {
      Doctor doctorFromRespon = mediaMetaInfo.metadata.doctor;

      address.UserAddressCollection3 userAddressCollection3 =
          new address.UserAddressCollection3(
              addressLine1: doctorFromRespon.addressLine1,
              addressLine2: doctorFromRespon.addressLine2);
      List<address.UserAddressCollection3> userAddressCollection3List =
          new List();
      userAddressCollection3List.add(userAddressCollection3);
      User user = new User(
          id: doctorFromRespon.userId,
          name: doctorFromRespon.name,
          firstName: doctorFromRespon.firstName,
          lastName: doctorFromRespon.lastName,
          userAddressCollection3: userAddressCollection3List);

      doctorObj = new Doctors(
          id: doctorFromRespon.doctorId,
          specialization: doctorFromRespon.specialization,
          isTelehealthEnabled: doctorFromRespon.isTelehealthEnabled,
          isMciVerified: doctorFromRespon.isMciVerified,
          user: user);
    }
  }

  Widget getIconButton() {
    return IconButton(
      icon: Icon(Icons.arrow_drop_down),
      color: Color(CommonUtil().getMyPrimaryColor()),
      iconSize: 40,
    );
  }

  void filterDuplicateDoctor() {
    if (doctorsListFromProvider.length > 0) {
      copyOfdoctorsModel = doctorsListFromProvider;
      final ids = copyOfdoctorsModel.map((e) => e?.user?.id).toSet();
      copyOfdoctorsModel.retainWhere((x) => ids.remove(x?.user?.id));
      doctorsListFromProvider = copyOfdoctorsModel;
    }
  }
}

extension FicListExtension<T> on List<T> {
  /// Maps each element of the list.
  /// The [map] function gets both the original [item] and its [index].
  ///
  Iterable<E> mapIndexed<E>(E Function(int index, T item) map) sync* {
    for (var index = 0; index < length; index++) {
      yield map(index, this[index]);
    }
  }
}
