import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/common/common_circular_indicator.dart';
import 'package:myfhb/unit/choose_unit.dart';
import 'package:myfhb/my_providers/models/Hospitals.dart';
import 'package:myfhb/src/utils/language/language_utils.dart';
import 'package:myfhb/unit/choose_unit.dart';
import 'CommonConstants.dart';
import 'CommonUtil.dart';
import 'FHBBasicWidget.dart';
import 'PreferenceUtil.dart';
import '../constants/fhb_constants.dart' as Constants;
import '../constants/fhb_parameters.dart' as parameters;
import '../constants/variable_constant.dart' as variable;
import '../my_providers/bloc/providers_block.dart';
import '../my_providers/models/Doctors.dart';
import '../my_providers/models/MyProviderResponseNew.dart';
import '../my_providers/models/User.dart';
import '../my_providers/models/UserAddressCollection.dart' as address;
import '../search_providers/models/doctors_data.dart';
import '../search_providers/models/hospital_data.dart';
import '../search_providers/models/lab_data.dart';
import '../search_providers/models/search_arguments.dart';
import '../search_providers/screens/search_specific_list.dart';
import '../src/blocs/Category/CategoryListBlock.dart';
import '../src/blocs/Media/MediaTypeBlock.dart';
import '../src/blocs/health/HealthReportListForUserBlock.dart';
import '../src/model/Category/CategoryData.dart';
import '../src/model/Category/catergory_result.dart';
import '../src/model/Health/MediaMetaInfo.dart';
import '../src/model/Health/asgard/health_record_list.dart';
import '../src/model/Media/MediaData.dart';
import '../src/model/Media/media_data_list.dart';
import '../src/model/Media/media_result.dart';
import '../src/model/common_response.dart';
import '../src/resources/network/ApiResponse.dart';
import '../src/ui/MyRecord.dart';
import '../src/ui/MyRecordsArguments.dart';
import '../src/ui/audio/AudioScreenArguments.dart';
import '../src/ui/audio/audio_record_screen.dart';
import '../src/utils/FHBUtils.dart';
import '../src/utils/colors_utils.dart';
import '../src/utils/screenutils/size_extensions.dart';
import '../telehealth/features/MyProvider/view/CommonWidgets.dart';
import 'package:myfhb/src/ui/audio/AudioRecorder.dart';
import 'package:myfhb/constants/fhb_router.dart' as router;
import 'package:get/get.dart';

class CommonDialogBox {
  String categoryName, deviceName;
  TextEditingController fileName = TextEditingController();
  TextEditingController doctor = TextEditingController();
  TextEditingController lab = TextEditingController();
  TextEditingController hospital = TextEditingController();

  TextEditingController dateOfVisit = TextEditingController();
  TextEditingController deviceController = TextEditingController();
  TextEditingController pulse = TextEditingController();
  TextEditingController memoController = TextEditingController();
  TextEditingController diaStolicPressure = TextEditingController();

  List<CategoryResult> filteredCategoryData = [];
  final CategoryListBlock _categoryListBlock = CategoryListBlock();

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
  CategoryResult categoryDataObj = CategoryResult();
  MediaResult mediaDataObj = MediaResult();
  File imageFile;
  final HealthReportListForUserBlock _healthReportListForUserBlock =
      HealthReportListForUserBlock();

  List<String> imagePathMain = List();

  FHBBasicWidget fhbBasicWidget = FHBBasicWidget();
  MediaMetaInfo mediaMetaInfo;
  String metaInfoId = '';
  bool modeOfSave;
  MediaResult selectedMediaData;

  String metaId;

  List<MediaResult> mediaDataAry = PreferenceUtil.getMediaType();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  FocusNode dateOfBirthFocus = FocusNode();
  FlutterToast toast = FlutterToast();

  String fromClassNew = '';
  HealthResult deviceHealthResult;
  bool forNotes = false;

  final ProvidersBloc _providersBloc = ProvidersBloc();
  final ProvidersBloc _providersBlocFor = ProvidersBloc();
  Future<MyProvidersResponse> _medicalPreferenceList;
  Future<MyProvidersResponse> _medicalhospitalPreferenceList;

  List<Doctors> doctorsListFromProvider;
  List<Doctors> copyOfdoctorsModel;

  List<Hospitals> hospitalListFromProvider;
  List<Hospitals> copyOfhospitalModel;

  Doctors doctorObj;
  Hospitals hospitalObj;

  CommonWidgets commonWidgets = CommonWidgets();
  bool showDoctorList = true;
  bool showHospitalList = true;

  String tempUnit = "F";
  String weightMainUnit = "kg";
  String heightUnit = "feet";

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
      _medicalhospitalPreferenceList =
          _providersBloc.getMedicalPreferencesForHospital();

      if (mediaMetaInfo != null) {
        deviceHealthResult = mediaMetaInfo;

        doctorsData = mediaMetaInfo.metadata.doctor ?? null;
        hospitalData = mediaMetaInfo.metadata.hospital ?? null;
        /* labData = mediaMetaInfo.metaInfo.laboratory != null
            ? mediaMetaInfo.metaInfo.laboratory
            : null;*/
        mediaMetaInfo = mediaMetaInfo ?? null;

        setDoctorValueFromResponse(mediaMetaInfo);

        if (mediaMetaInfo != null) {
          metaInfoId = mediaMetaInfo.id;
        }
      }
    } catch (e) {}

    dateOfVisit.text = dateOfVisitClone.text;
    if (modeOfSave) {
      loadMemoText(mediaMetaInfo.metadata.memoText ?? '');
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
    final dialog = StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
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
                      children: [
                        Expanded(
                          flex: 2,
                          child: fhbBasicWidget.getTextFiledWithHint(
                              context, 'Choose Doctor', doctor,
                              enabled: false),
                        ),
                        if (showDoctorList)
                          Container(
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
                        else
                          Container(),
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
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: fhbBasicWidget.getTextFiledWithHint(
                              context, 'Choose Hospital', hospital,
                              enabled: false),
                        ),
                        if (showHospitalList)
                          Container(
                            height: 50,
                            child: hospitalListFromProvider != null
                                ? getHospitalDropDown(
                                    hospitalListFromProvider,
                                    hospitalObj,
                                    () {
                                      Navigator.pop(context);
                                      moveToSearchScreen(
                                          context,
                                          CommonConstants.keyHospital,
                                          doctor,
                                          hospital,
                                          null,
                                          updateUI,
                                          audioPath,
                                          containsAudio,
                                          setState: setState);
                                    },
                                  )
                                : getAllHospitalRoles(hospitalObj, () {
                                    Navigator.pop(context);
                                    moveToSearchScreen(
                                        context,
                                        CommonConstants.keyHospital,
                                        doctor,
                                        hospital,
                                        null,
                                        updateUI,
                                        audioPath,
                                        containsAudio,
                                        setState: setState);
                                  }),
                          )
                        else
                          Container(),
                      ],
                    ),
                    /* fhbBasicWidget
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
                    }, hospital, CommonConstants.keyHospital),*/
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
            if (modeOfSave)
              fhbBasicWidget.getSaveButton(() {
                onPostDataToServer(context, imagePath);
              })
            else
              containsAudioMain
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
        builder: (context) => dialog);
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
        mediaMetaInfo = mediaMetaInfo ?? null;
        deviceHealthResult = mediaMetaInfo;

        doctorsData = mediaMetaInfo.metadata.doctor;
        setDoctorValueFromResponse(mediaMetaInfo);

        labData = mediaMetaInfo.metadata.laboratory ?? null;
        hospitalData = mediaMetaInfo.metadata.hospital ?? null;

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
      loadMemoText(mediaMetaInfo.metadata.memoText ?? '');
    } else {
      memoController.text = '';
    }

    var dialog = StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
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
                      children: [
                        Expanded(
                          flex: 2,
                          child: fhbBasicWidget.getTextFiledWithHint(
                              context, 'Choose Doctor', doctor,
                              enabled: false),
                        ),
                        if (showDoctorList)
                          Container(
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
                        else
                          Container(),
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
                        context, memoController,
                        isFileField: true),
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
                    ? fhbBasicWidget
                        .getAudioIconWithFile(audioPathMain, containsAudioMain,
                            (containsAudio, audioPath) {
                        audioPathMain = audioPath;
                        containsAudioMain = containsAudio;
                        updateAudioUI(containsAudioMain, audioPathMain);
                        setState(() {});
                      }, context, imagePath, onPostDataToServer)
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
        context: context,
        builder: (context) => dialog,
        barrierDismissible: false);
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

      loadMemoText(mediaMetaInfoClone.metadata.memoText ?? '');
    } else {
      memoController.text = '';
    }

    setFileName(fileNameClone.text, mediaMetaInfoClone);
    var dialog = StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
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
          children: [
            fhbBasicWidget.getTextForAlertDialog(
                context, CommonConstants.strFileName),
            fhbBasicWidget.getTextFieldWithNoCallbacks(context, fileName),
            SizedBox(
              height: 15.0.h,
            ),
            fhbBasicWidget.getTextForAlertDialog(
                context, CommonConstants.strMemo),
            fhbBasicWidget.getTextFieldWithNoCallbacks(context, memoController,
                isFileField: true),
            SizedBox(
              height: 15.0.h,
            ),
            if (modeOfSave)
              fhbBasicWidget.getSaveButton(() {
                onPostDataToServer(context, imagePath);
              })
            else
              containsAudioMain
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
        context: context,
        builder: (context) => dialog,
        barrierDismissible: false);
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
      loadMemoText(mediaMetaInfoClone.metadata.memoText ?? '');
    } else {
      memoController.text = '';
    }

    final mediaDataAry = <MediaResult>[];

    for (var mediaData in PreferenceUtil.getMediaType()) {
      final categorySplitAry = mediaData.description.split('_');
      if (categorySplitAry[0] == CommonConstants.categoryDescriptionIDDocs) {
        mediaDataAry.add(mediaData);
      }
    }

    for (var mediaData in mediaDataAry) {
      final mediaDataClone = mediaData.name.split(' ');
      if (mediaDataClone.isNotEmpty) {
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

    var dialog = StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
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
          children: [
            fhbBasicWidget.getTextForAlertDialog(
                context, CommonConstants.strFileName),
            fhbBasicWidget.getTextFieldWithNoCallbacks(context, fileName),
            SizedBox(
              height: 15.0.h,
            ),
            fhbBasicWidget.getTextForAlertDialog(
                context, CommonConstants.strMemo),
            fhbBasicWidget.getTextFieldWithNoCallbacks(context, memoController,
                isFileField: true),
            SizedBox(
              height: 15.0.h,
            ),
            Container(
                width: 1.sw - 60,
                child: GestureDetector(
                    onTap: () => _selectDate(context, dateOfVisit),
                    child: TextField(
                      readOnly: true,
                      controller: dateOfVisit,
                      decoration: InputDecoration(
                          labelText: CommonConstants.exprityDate,
                          suffixIcon: IconButton(
                            icon: Icon(
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
            Center(
              child: DropdownButton(
                hint: Text('Select ID Type'),
                value: selectedMediaData,
                onChanged: (newValue) {
                  setState(() {
                    selectedMediaData = newValue;
                    PreferenceUtil.saveMediaData(
                        Constants.KEY_MEDIADATA, selectedMediaData);
                  });
                },
                items: mediaDataAry.map((idType) {
                  return DropdownMenuItem(
                    value: idType,
                    child: new Text(
                      idType.name,
                      style: new TextStyle(color: Colors.black),
                    ),
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
                    ? fhbBasicWidget
                        .getAudioIconWithFile(audioPathMain, containsAudioMain,
                            (containsAudio, audioPath) {
                        audioPathMain = audioPath;
                        containsAudioMain = containsAudio;
                        updateAudioUI(containsAudioMain, audioPathMain);
                        setState(() {});
                      }, context, imagePath, onPostDataToServer)
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
        context: context,
        builder: (context) => dialog,
        barrierDismissible: false);
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
    final commonConstants = CommonConstants();
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
      loadMemoText(mediaMetaInfoClone.metadata.memoText ?? '');
    } else {
      memoController.text = '';
    }

    final dialog = StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
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
              }, errGluco, variable.strGlucUnit,
                  range: isSelected[0] == true ? 'Fast' : 'PP'),
              SizedBox(
                height: 15.0.h,
              ),
              fhbBasicWidget.getTextForAlertDialog(
                  context, CommonConstants.strMemo),
              fhbBasicWidget.getTextFieldWithNoCallbacks(
                  context, memoController,
                  isFileField: true),
              SizedBox(
                height: 15.0.h,
              ),
              fhbBasicWidget.getTextForAlertDialog(
                  context, CommonConstants.strTimeTaken),
              ToggleButtons(
                borderColor: Colors.black,
                fillColor: Colors.grey[100],
                borderWidth: 2,
                selectedBorderColor: Color(CommonUtil().getMyPrimaryColor()),
                selectedColor: Color(CommonUtil().getMyPrimaryColor()),
                borderRadius: BorderRadius.circular(10),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      variable.strbfood,
                      style: TextStyle(
                        fontSize: 16.0.sp,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      variable.strafood,
                      style: TextStyle(
                        fontSize: 16.0.sp,
                      ),
                    ),
                  ),
                ],
                onPressed: (index) {
                  setState(() {
                    for (var i = 0; i < isSelected.length; i++) {
                      isSelected[i] = i == index;
                    }
                  });
                },
                isSelected: isSelected,
              ),
              SizedBox(
                height: 15.0.h,
              ),
              if (modeOfSave)
                fhbBasicWidget.getSaveButton(() {
                  onPostDataToServer(context, imagePath);
                })
              else
                containsAudioMain
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

    return showDialog(
        context: context,
        builder: (context) => dialog,
        barrierDismissible: false);
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
      TextEditingController fileNameClone,
      {String tempMainUnit,
      Function(String) updateUnit}) {
    final commonConstants = CommonConstants();
    commonConstants.getCountryMetrics();
    if (mediaMetaInfoClone != null) {
      if (mediaMetaInfoClone != null) {
        metaInfoId = mediaMetaInfoClone.id;
      }
    }
    if (tempMainUnit == null) {
      tempMainUnit = "F";
    } else {
      tempUnit = tempMainUnit;
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
      loadMemoText(mediaMetaInfoClone.metadata.memoText ?? '');
    } else {
      memoController.text = '';
    }
    var dialog = StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
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
          children: [
            fhbBasicWidget.getTextForAlertDialog(
                context, CommonConstants.strFileName),
            fhbBasicWidget.getTextFieldWithNoCallbacks(context, fileName),
            SizedBox(
              height: 15.0.h,
            ),
            Row(
              children: [
                Expanded(
                    flex: 2,
                    child: fhbBasicWidget.getTextFiledWithHintAndSuffixText(
                        context,
                        CommonConstants.strTemperature,
                        tempMainUnit,
                        deviceController, (errorValue) {
                      setState(() {
                        errTemp = errorValue;
                      });
                    }, errTemp, tempMainUnit,
                        range: "", device: "Temp", showLabel: false)),
                SizedBox(width: 20),
                Container(
                    width: 50,
                    child: GestureDetector(
                      child: fhbBasicWidget.getTextForAlertDialog(
                          context, tempMainUnit),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => ChooseUnit(),
                          ),
                        ).then(
                          (value) {
                            tempMainUnit = PreferenceUtil.getStringValue(
                                Constants.STR_KEY_TEMP);
                            updateUnit(tempMainUnit);
                            tempUnit = tempMainUnit;
                            setState(() {});
                          },
                        );
                      },
                    ))
              ],
            ),
            SizedBox(
              height: 15.0.h,
            ),
            fhbBasicWidget.getTextForAlertDialog(
                context, CommonConstants.strMemo),
            fhbBasicWidget.getTextFieldWithNoCallbacks(context, memoController,
                isFileField: true),
            SizedBox(
              height: 15.0.h,
            ),
            if (modeOfSave)
              fhbBasicWidget.getSaveButton(() {
                onPostDataToServer(context, imagePath);
              })
            else
              containsAudioMain
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
        context: context,
        builder: (context) => dialog,
        barrierDismissible: false);
  }

  void setFileName(String fileNameClone, HealthResult healthResult,
      {String voiceRecord}) async {
    try {
      categoryName = healthResult.metadata.healthRecordCategory.categoryName;
      deviceName = healthResult.metadata.healthRecordType.name;
      categoryID = healthResult.metadata.healthRecordCategory.id;
    } catch (e) {
      categoryName = PreferenceUtil.getStringValue(Constants.KEY_CATEGORYNAME);
      deviceName = PreferenceUtil.getStringValue(Constants.KEY_DEVICENAME);
      categoryID = PreferenceUtil.getStringValue(Constants.KEY_CATEGORYID);
    }

    if (modeOfSave) {
      fileName.text = fileNameClone;
    } else {
      if (fileNameClone == '') {
        if (categoryName == CommonConstants.strDevice) {
          fileName = TextEditingController(
              text: deviceName +
                  '_${DateTime.now().toUtc().millisecondsSinceEpoch}');
        } else {
          fileName = TextEditingController(
              text: categoryName +
                  '_${DateTime.now().toUtc().millisecondsSinceEpoch}');
        }
      } else {
        fileName.text = fileNameClone;
      }
    }

    if (forNotes) {
      categoryName = AppConstants.notes;
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
      TextEditingController fileNameClone,
      {String weightUnit,
      Function(String) updateUnit}) {
    final commonConstants = CommonConstants();
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

    if (weightUnit == null) {
      weightUnit = "kg";
    } else {
      weightMainUnit = weightUnit;
    }
    if (modeOfSave) {
      deviceHealthResult = mediaMetaInfoClone;
      loadMemoText(mediaMetaInfoClone.metadata.memoText ?? '');
    } else {
      memoController.text = '';
    }

    var dialog = StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
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
          children: [
            fhbBasicWidget.getTextForAlertDialog(
                context, CommonConstants.strFileName),
            fhbBasicWidget.getTextFieldWithNoCallbacks(context, fileName),
            SizedBox(
              height: 15.0.h,
            ),
            Row(
              children: [
                Expanded(
                    flex: 2,
                    child: fhbBasicWidget.getTextFiledWithHintAndSuffixText(
                        context,
                        CommonConstants.strWeight,
                        weightUnit,
                        deviceController, (errorValue) {
                      setState(() {
                        errWeight = errorValue;
                      });
                    }, errWeight, weightUnit, range: "", showLabel: false)),
                SizedBox(width: 20),
                Container(
                    width: 50,
                    child: GestureDetector(
                      child: fhbBasicWidget.getTextForAlertDialog(
                          context, weightUnit),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => ChooseUnit(),
                          ),
                        ).then(
                          (value) {
                            weightUnit = PreferenceUtil.getStringValue(
                                Constants.STR_KEY_WEIGHT);
                            updateUnit(weightUnit);
                            weightMainUnit = weightUnit;
                            setState(() {});
                          },
                        );
                      },
                    ))
              ],
            ),
            SizedBox(
              height: 15.0.h,
            ),
            fhbBasicWidget.getTextForAlertDialog(
                context, CommonConstants.strMemo),
            fhbBasicWidget.getTextFieldWithNoCallbacks(context, memoController,
                isFileField: true),
            SizedBox(
              height: 15.0.h,
            ),
            if (modeOfSave)
              fhbBasicWidget.getSaveButton(() {
                onPostDataToServer(context, imagePath);
              })
            else
              containsAudioMain
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
        context: context,
        builder: (context) => dialog,
        barrierDismissible: false);
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
    final commonConstants = CommonConstants();
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
      loadMemoText(mediaMetaInfoClone.metadata.memoText ?? '');
    } else {
      memoController.text = '';
    }

    var dialog = StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
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
            }, errPoOs, variable.strpulseUnit, range: ""),
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
            }, errPoPulse, variable.strpulse, range: ""),
            SizedBox(
              height: 15.0.h,
            ),
            fhbBasicWidget.getTextForAlertDialog(
                context, CommonConstants.strMemo),
            fhbBasicWidget.getTextFieldWithNoCallbacks(context, memoController,
                isFileField: true),
            SizedBox(
              height: 15.0.h,
            ),
            modeOfSave
                ? fhbBasicWidget.getSaveButton(() {
                    onPostDataToServer(context, imagePath);
                  })
                : containsAudioMain
                    ? fhbBasicWidget
                        .getAudioIconWithFile(audioPathMain, containsAudioMain,
                            (containsAudio, audioPath) {
                        audioPathMain = audioPath;
                        containsAudioMain = containsAudio;
                        updateAudioUI(containsAudioMain, audioPathMain);
                        setState(() {});
                      }, context, imagePath, onPostDataToServer)
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
        context: context,
        builder: (context) => dialog,
        barrierDismissible: false);
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
    final commonConstants = CommonConstants();
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
      loadMemoText(mediaMetaInfoClone.metadata.memoText ?? '');
    } else {
      memoController.text = '';
    }

    final dialog = StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
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
            }, errForbpSp, variable.strbpunit, range: "Sys"),
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
            }, errFForbpDp, variable.strbpunit, range: "Dia"),
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
            }, errForbpPulse, variable.strpulse, range: ""),
            SizedBox(
              height: 15.0.h,
            ),
            fhbBasicWidget.getTextForAlertDialog(
                context, CommonConstants.strMemo),
            fhbBasicWidget.getTextFieldWithNoCallbacks(context, memoController,
                isFileField: true),
            SizedBox(
              height: 15.0.h,
            ),
            modeOfSave
                ? fhbBasicWidget.getSaveButton(() {
                    onPostDataToServer(context, imagePath);
                  })
                : containsAudioMain
                    ? fhbBasicWidget
                        .getAudioIconWithFile(audioPathMain, containsAudioMain,
                            (containsAudio, audioPath) {
                        audioPathMain = audioPath;
                        containsAudioMain = containsAudio;
                        updateAudioUI(containsAudioMain, audioPathMain);
                        setState(() {});
                      }, context, imagePath, onPostDataToServer)
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
        context: context,
        builder: (context) => dialog,
        barrierDismissible: false);
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController dateOfVisit) async {
    var dateTime = DateTime.now();

    final picked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime.now());

    if (picked != null) {
      dateTime = picked ?? dateTime;
      dateOfVisit.text = FHBUtils().getFormattedDateOnly(dateTime.toString());
    }
  }

  Future<void> _selectDateFuture(
      BuildContext context, TextEditingController dateOfVisit) async {
    var dateTime = DateTime.now();

    final picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));

    if (picked != null) {
      dateTime = picked ?? dateTime;
      dateOfVisit.text = FHBUtils().getFormattedDateOnly(dateTime.toString());
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
      onTap: () async {
        await Navigator.of(context)
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
    );
  }

  void onPostDataToServer(BuildContext context, List<String> imagePath,
      {Function onRefresh}) async {
    if (doValidationBeforePosting()) {
      CommonUtil.showLoadingDialog(context, _keyLoader, variable.Please_Wait);

      var postMainData = Map<String, dynamic>();
      var postMediaData = Map<String, dynamic>();

      var userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);
      if (modeOfSave) {
        postMainData[parameters.struserId] = userID;
      }
      final catgoryDataList = PreferenceUtil.getCategoryType();

      categoryDataObj = CommonUtil()
          .getCategoryObjForSelectedLabel(categoryID, catgoryDataList);
      postMediaData[parameters.strhealthRecordCategory] =
          categoryDataObj.toJson();
      var _mediaTypeBlock = MediaTypeBlock();

      var mediaTypesResponse = await _mediaTypeBlock.getMediTypesList();

      final metaDataFromSharedPrefernce = mediaTypesResponse.result;
      if (categoryName != Constants.STR_DEVICES) {
        mediaDataObj = CommonUtil().getMediaTypeInfoForParticularLabel(
            categoryID, metaDataFromSharedPrefernce, categoryName);
      } else {
        mediaDataObj = CommonUtil().getMediaTypeInfoForParticularDevice(
            deviceName, metaDataFromSharedPrefernce);
      }

      postMediaData[parameters.strhealthRecordType] = mediaDataObj.toJson();

      postMediaData[parameters.strmemoText] = memoController.text;

      if (categoryName != AppConstants.voiceRecords) {
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
        var dateTime = DateTime.now();
        postMediaData[parameters.strStartDate] =
            deviceHealthResult.metadata.startDateTime ??
                dateTime.toUtc().toString();
        postMediaData[parameters.strEndDate] =
            deviceHealthResult.metadata.endDateTime ??
                dateTime.toUtc().toString();
      } else {
        final dateTime = DateTime.now();
        postMediaData[parameters.strStartDate] = dateTime.toUtc().toString();
        postMediaData[parameters.strEndDate] = dateTime.toUtc().toString();
      }
      final commonConstants = CommonConstants();

      if (categoryName == CommonConstants.strDevice) {
        final List<Map<String, dynamic>> postDeviceData = [];
        final Map<String, dynamic> postDeviceValues = {};
        final Map<String, dynamic> postDeviceValuesExtra = {};
        final Map<String, dynamic> postDeviceValuesExtraClone = {};

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
          postDeviceValues[parameters.strunit] = tempUnit;
          postDeviceData.add(postDeviceValues);
        } else if (deviceName == Constants.STR_WEIGHING_SCALE) {
          postDeviceValues[parameters.strParameters] =
              CommonConstants.strWeightParam;
          postDeviceValues[parameters.strvalue] = deviceController.text;
          postDeviceValues[parameters.strunit] = weightMainUnit;
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
      } else if (categoryName == AppConstants.prescription ||
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
      if (imagePath != null && imagePath.length > 0 && imagePath.length == 1) {
        final folderName = File(imagePath[0]);
        final fileNoun = folderName.path.split('/').last;
        if (fileNoun.contains('.pdf')) {
          postMediaData[parameters.strfileName] = fileName.text + '.pdf';
        } else {
          postMediaData[parameters.strfileName] = fileName.text;
        }
      } else {
        postMediaData[parameters.strfileName] = fileName.text;
      }

      postMainData[parameters.strmetaInfo] = postMediaData;
      if (modeOfSave) {
        postMainData[parameters.strIsActive] = false;
      }

      final params = json.encode(postMediaData);
      print(params);

      if (modeOfSave) {
        audioPathMain = '';
        await _healthReportListForUserBlock
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
        await _healthReportListForUserBlock
            .createHealtRecords(params.toString(), imagePath, audioPathMain)
            .then((value) {
          if (value != null && value.isSuccess) {
            _healthReportListForUserBlock
                .getHelthReportLists()
                .then((value) async {
              await PreferenceUtil.saveCompleteData(
                  Constants.KEY_COMPLETE_DATA, value);
              if (categoryName == AppConstants.voiceRecords) {
                Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                    .pop();

                Navigator.of(context).pop();

                final List<String> recordIds = [];
                recordIds.add(value.result[0].id);
                CommonUtil.audioPage = true;
                if (fromClassNew == 'audio') {
                  await Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyRecords(
                            argument: MyRecordsArgument(
                          categoryPosition:
                              getCategoryPosition(AppConstants.voiceRecords),
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
                              getCategoryPosition(AppConstants.voiceRecords),
                          allowSelect: false,
                          isAudioSelect: true,
                          isNotesSelect: false,
                          selectedMedias: List(),
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
              } else if (categoryName == AppConstants.notes) {
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
      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(variable.strAPP_NAME),
                content: Text(validationMsg),
              ));
    }
  }

  void postAudioToServer(String mediaMetaID, BuildContext context,
      {Function onRefresh}) {
    final Map<String, dynamic> postImage = {};

    postImage[parameters.strmediaMetaId] = mediaMetaID;

    var k = 0;
    for (var i = 0; i < imagePathMain.length; i++) {
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

                if (categoryName == AppConstants.notes) {
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

              if (categoryName == AppConstants.notes) {
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

              if (categoryName == AppConstants.notes) {
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

            if (categoryName == AppConstants.notes) {
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
      if (categoryName == AppConstants.notes) {
        Navigator.of(context).pop();
        onRefresh(true);
      } else {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
    }
  }

  bool doValidationBeforePosting() {
    var validationConditon = false;
    if (categoryName == AppConstants.prescription ||
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
    } else if (categoryName == AppConstants.bills ||
        categoryName == Constants.STR_OTHERS ||
        categoryName == Constants.STR_CLAIMSRECORD) {
      if (fileName.text == '') {
        validationConditon = false;
        validationMsg = CommonConstants.strFileEmpty;
      } else {
        validationConditon = true;
      }
    } else if (categoryName == AppConstants.voiceRecords) {
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
    } else if (categoryName == AppConstants.notes) {
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

    filteredCategoryData = PreferenceUtil.getCategoryTypeDisplay(
        Constants.KEY_CATEGORYLIST_VISIBLE);
    fromClassNew = fromClass;
    final dialog = StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: fhbBasicWidget
            .getTextTextTitleWithPurpleColor(AppConstants.voiceRecords),
        content: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            if (modeOfSave)
              fhbBasicWidget.getSaveButton(() {
                onPostDataToServer(context, null);
              })
            else
              containsAudioMain
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
        context: context,
        builder: (context) => dialog,
        barrierDismissible: false);
  }

  void setPrefreferedProvidersIfAvailable(
      String hospitalText, String doctorsText, String labtext) {
    try {
      PreferenceUtil.getPreferedDoctor(Constants.KEY_PREFERRED_DOCTOR)
          .then((doctorIds) {
        if (doctorIds != null) {
          final preferedDoctorData = DoctorsData(
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
          var preferredHospitalData = HospitalData(
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
          final preferredlabData = LabData(
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
        readOnly: true,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        onSubmitted: (term) {
          dateOfBirthFocus.unfocus();
        },
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(Icons.calendar_today),
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
      loadMemoText(mediaMetaInfoClone.metadata.memoText ?? '');
    } else {
      memoController.text = '';
    }

    setFileName(fileNameClone.text, mediaMetaInfoClone);
    categoryName = AppConstants.notes;
    var dialog = StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            fhbBasicWidget
                .getTextTextTitleWithPurpleColor(categoryName ?? 'Notes'),
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
                context,
                memoController,
                Constants.STR_NOTES_HINT,
                500,
                "",
                (value) {},
                false),
            SizedBox(
              height: 15.0.h,
            ),
            if (modeOfSave)
              fhbBasicWidget.getSaveButton(() {
                onPostDataToServer(context, imagePath, onRefresh: refresh);
              })
            else
              containsAudioMain
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
        context: context,
        builder: (context) => dialog,
        barrierDismissible: false);
  }

  getCategoryPosition(String categoryName) {
    int categoryPosition;
    switch (categoryName) {
      case AppConstants.notes:
        categoryPosition = pickPosition(categoryName);
        return categoryPosition;
        break;

      case AppConstants.prescription:
        categoryPosition = pickPosition(categoryName);
        return categoryPosition;
        break;

      case AppConstants.voiceRecords:
        categoryPosition = pickPosition(categoryName);
        return categoryPosition;
        break;
      case AppConstants.bills:
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
    var position = 0;
    List<CategoryResult> categoryDataList = [];
    categoryDataList = getCategoryList();
    for (var i = 0;
        i < (categoryDataList == null ? 0 : categoryDataList.length);
        i++) {
      if (categoryName == categoryDataList[i].categoryName) {
        print(categoryName + ' ****' + categoryDataList[i].categoryName);
        position = i;
      }
    }
    if (categoryName == AppConstants.prescription) {
      return position;
    } else {
      return position;
    }
  }

  List<CategoryResult> getCategoryList() {
    if (filteredCategoryData == null || filteredCategoryData.isEmpty) {
      _categoryListBlock.getCategoryLists().then((value) {
        filteredCategoryData = CommonUtil().fliterCategories(value.result);
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
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              familyWidget = Center(
                  child: SizedBox(
                width: 30.0.h,
                height: 30.0.h,
                child: CommonCircularIndicator(),
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
                  snapshot.data.data.result.doctors.isNotEmpty) {
                doctorsListFromProvider = snapshot.data.data.result.doctors;
                filterDuplicateDoctor();
                familyWidget = getDoctorDropDown(
                  doctorsListFromProvider,
                  doctorObj,
                  onAdd,
                );
              } else {
                doctorsListFromProvider = List();
                familyWidget = getDoctorDropDownWhenNoList(
                    doctorsListFromProvider, null, onAdd);
              }

              return familyWidget;
              break;
          }
        } else {
          doctorsListFromProvider = [];
          familyWidget = Container(
            width: 100.0.h,
            height: 100.0.h,
          );
        }
        return familyWidget;
      },
    );
  }

  Widget getAllHospitalRoles(Hospitals hospitalObj, Function onAdd) {
    Widget familyWidget;

    return StreamBuilder<ApiResponse<MyProvidersResponse>>(
      stream: _providersBloc.providershospitalListStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              familyWidget = Center(
                  child: SizedBox(
                width: 30.0.h,
                height: 30.0.h,
                child: CommonCircularIndicator(),
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
                  snapshot.data.data.result.hospitals != null &&
                  snapshot.data.data.result.hospitals.isNotEmpty) {
                hospitalListFromProvider = snapshot.data.data.result.hospitals;
                filterDuplicateHospital();
                familyWidget = getHospitalDropDown(
                  hospitalListFromProvider,
                  hospitalObj,
                  onAdd,
                );
              } else {
                hospitalListFromProvider = List();
                familyWidget = getHospitalsDropDownWhenNoList(
                    hospitalListFromProvider, null, onAdd);
              }

              return familyWidget;
              break;
          }
        } else {
          hospitalListFromProvider = [];
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
      for (var doctorsObjS in doctors) {
        if (doctorsObjS.id == doctorObjSample.id) {
          doctorObj = doctorsObjS;
        }
      }
    }

    return StatefulBuilder(builder: (context, setState) {
      return PopupMenuButton<Doctors>(
        offset: Offset(-100, 70),
        //padding: EdgeInsets.all(20),
        itemBuilder: (context) => (doctors != null && doctors.isNotEmpty)
            ? doctors
                .mapIndexed((index, element) => index == doctors.length - 1
                    ? PopupMenuItem<Doctors>(
                        value: element,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              width: 0.5.sw,
                              child: Text(element.user != null
                                  ? new CommonUtil().getDoctorName(element.user)
                                  : ''),
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
                          width: 0.5.sw,
                          child: Text(element.user != null
                              ? new CommonUtil().getDoctorName(element.user)
                              : ''),
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
                ? CommonUtil().getDoctorName(value.user)
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
      for (final doctorsObjS in doctors) {
        if (doctorsObjS.id == doctorObjSample.id) {
          doctorObj = doctorsObjS;
        }
      }
    }

    return (doctors != null && doctors.isNotEmpty)
        ? StatefulBuilder(builder: (context, setState) {
            return PopupMenuButton<Doctors>(
              offset: Offset(-100, 70),
              //padding: EdgeInsets.all(20),
              itemBuilder: (context) => doctors
                  .mapIndexed((index, element) => index == doctors.length - 1
                      ? PopupMenuItem<Doctors>(
                          value: element,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                width: 0.5.sw,
                                child: Text(
                                  element.user.name,
                                ),
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
                            width: 0.5.sw,
                            child: Text(
                              element.user.name,
                            ),
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
              offset: Offset(-100, 70),
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

  getHospitalsDropDownWhenNoList(List<Hospitals> hospitallist,
      Hospitals hospitalObjSample, Function onAddClick,
      {Widget child}) {
    if (hospitalObjSample != null) {
      for (var hospitalObjS in hospitallist) {
        if (hospitalObjS.id == hospitalObjSample.id) {
          hospitalObj = hospitalObjS;
        }
      }
    }

    return (hospitallist != null && hospitallist.isNotEmpty)
        ? StatefulBuilder(builder: (context, setState) {
            return PopupMenuButton<Hospitals>(
              offset: Offset(-100, 70),
              //padding: EdgeInsets.all(20),
              itemBuilder: (context) => hospitallist
                  .mapIndexed(
                      (index, element) => index == hospitallist.length - 1
                          ? PopupMenuItem<Hospitals>(
                              value: element,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    width: 0.5.sw,
                                    child: Text(
                                      element.name,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  fhbBasicWidget.getSaveButton(() {
                                    onAddClick();
                                  }, text: 'Add Hospital'),
                                  SizedBox(height: 10),
                                ],
                              ))
                          : PopupMenuItem<Hospitals>(
                              value: element,
                              child: Container(
                                width: 0.5.sw,
                                child: Text(
                                  element.name,
                                ),
                              ),
                            ))
                  .toList(),
              onSelected: (value) {
                hospitalObj = value;
                setHospitalValue(value);
                setState(() {
                  hospital.text =
                      hospitalObj.name != null ? hospitalObj.name : '';
                });
              },
              child: child ?? getIconButton(),
            );
          })
        : StatefulBuilder(builder: (context, setState) {
            return PopupMenuButton<Hospitals>(
              offset: Offset(-100, 70),
              itemBuilder: (context) => <PopupMenuItem<Hospitals>>[
                PopupMenuItem<Hospitals>(
                    child: Container(
                  width: 150,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      fhbBasicWidget.getSaveButton(() {
                        onAddClick();
                      }, text: 'Add Hospital'),
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
    final doctorNewObj = Doctor(
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

  void setHospitalValue(Hospitals newValue) {
    final hospitalNewObj = Hospital(
      healthOrganizationId: newValue.id,
      healthOrganizationName: newValue.name,
      addressLine1:
          newValue.healthOrganizationAddressCollection[0]?.addressLine1,
      addressLine2:
          newValue.healthOrganizationAddressCollection[0]?.addressLine2,
      cityName: newValue.healthOrganizationAddressCollection[0]?.city?.name,
      stateName: newValue.healthOrganizationAddressCollection[0]?.state?.name,
      /*healthOrganizationTypeName: newValue.healthOrganizationType?.name,
      healthOrganizationTypeId: newValue.healthOrganizationType?.id,
      phoneNumber: newValue.healthOrganizationContactCollection[0]?.phoneNumber,
      phoneNumberTypeId: newValue.healthOrganizationContactCollection[0]?.phoneNumberType?.id,
      phoneNumberTypeName: newValue.healthOrganizationContactCollection[0]?.phoneNumberType?.name,
      pincode: newValue.healthOrganizationAddressCollection[0]?.pincode*/
    );

    hospitalData = hospitalNewObj;
  }

  void setValueToDoctorDropdown(doctorsData, Function onTextFinished) {
    final userAddressCollection3 = address.UserAddressCollection3(
        addressLine1: doctorsData[parameters.strAddressLine1],
        addressLine2: doctorsData[parameters.strAddressLine2]);
    final List<address.UserAddressCollection3> userAddressCollection3List = [];
    userAddressCollection3List.add(userAddressCollection3);
    final user = User(
        id: doctorsData[parameters.struserId],
        name: doctorsData[parameters.strName],
        firstName: doctorsData[parameters.strFirstName],
        lastName: doctorsData[parameters.strLastName],
        userAddressCollection3: userAddressCollection3List);

    doctorObj = Doctors(
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
      final doctorFromRespon = mediaMetaInfo.metadata.doctor;

      final userAddressCollection3 = address.UserAddressCollection3(
          addressLine1: doctorFromRespon.addressLine1,
          addressLine2: doctorFromRespon.addressLine2);
      var userAddressCollection3List = List<address.UserAddressCollection3>();
      userAddressCollection3List.add(userAddressCollection3);
      var user = User(
          id: doctorFromRespon.userId,
          name: doctorFromRespon.name,
          firstName: doctorFromRespon.firstName,
          lastName: doctorFromRespon.lastName,
          userAddressCollection3: userAddressCollection3List);

      doctorObj = Doctors(
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
    if (doctorsListFromProvider.isNotEmpty) {
      copyOfdoctorsModel = doctorsListFromProvider;
      var ids = copyOfdoctorsModel.map((e) => e?.user?.id).toSet();
      copyOfdoctorsModel.retainWhere((x) => ids.remove(x?.user?.id));
      doctorsListFromProvider = copyOfdoctorsModel;
    }
  }

  void filterDuplicateHospital() {
    if (hospitalListFromProvider.isNotEmpty) {
      copyOfhospitalModel = hospitalListFromProvider;
      var ids = copyOfhospitalModel.map((e) => e?.id).toSet();
      copyOfhospitalModel.retainWhere((x) => ids.remove(x?.id));
      hospitalListFromProvider = copyOfhospitalModel;
    }
  }

  getHospitalDropDown(List<Hospitals> hospitallist, Hospitals hospitalObjSample,
      Function onAddClick,
      {Widget child}) {
    if (hospitalObjSample != null) {
      for (var hospitalObjS in hospitallist) {
        if (hospitalObjS.id == hospitalObjSample.id) {
          hospitalObj = hospitalObjS;
        }
      }
    }

    return StatefulBuilder(builder: (context, setState) {
      return PopupMenuButton<Hospitals>(
        offset: Offset(-100, 70),
        //padding: EdgeInsets.all(20),
        itemBuilder: (context) => (hospitallist != null &&
                hospitallist.isNotEmpty)
            ? hospitallist
                .mapIndexed((index, element) => index == hospitallist.length - 1
                    ? PopupMenuItem<Hospitals>(
                        value: element,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              width: 0.5.sw,
                              child: Text(
                                  element.name != null ? element.name : ''),
                            ),
                            SizedBox(height: 10),
                            fhbBasicWidget.getSaveButton(() {
                              onAddClick();
                            }, text: 'Add Hospital'),
                            SizedBox(height: 10),
                          ],
                        ))
                    : PopupMenuItem<Hospitals>(
                        value: element,
                        child: Container(
                          width: 0.5.sw,
                          child: Text(element.name != null ? element.name : ''),
                        ),
                      ))
                .toList()
            : PopupMenuItem<Hospitals>(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    fhbBasicWidget.getSaveButton(() {
                      onAddClick();
                    }, text: 'Add Hospital'),
                    SizedBox(height: 10)
                  ],
                ),
              ),
        onSelected: (value) {
          hospitalObj = value;
          setHospitalValue(value);
          setState(() {
            hospital.text = hospitalObj.name != null ? hospitalObj.name : '';
            ;
          });
        },
        child: child ?? getIconButton(),
      );
    });
  }

  Widget getFutureAllHospitalRoles(Hospitals hospitalObj, Function onAdd) {
    Widget familyWidget;

    return StreamBuilder<ApiResponse<MyProvidersResponse>>(
      stream: _providersBloc.providershospitalListStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              familyWidget = Center(
                  child: SizedBox(
                width: 30.0.h,
                height: 30.0.h,
                child: CommonCircularIndicator(),
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
                  snapshot.data.data.result.hospitals != null &&
                  snapshot.data.data.result.hospitals.isNotEmpty) {
                hospitalListFromProvider = snapshot.data.data.result.hospitals;
                //filterDuplicateHospital();
                familyWidget = getHospitalDropDown(
                  hospitalListFromProvider,
                  hospitalObj,
                  onAdd,
                );
              } else {
                hospitalListFromProvider = List();
                familyWidget = getHospitalsDropDownWhenNoList(
                    hospitalListFromProvider, null, onAdd);
              }

              return familyWidget;
              break;
          }
        } else {
          hospitalListFromProvider = [];
          familyWidget = Container(
            width: 100.0.h,
            height: 100.0.h,
          );
        }
        return familyWidget;
      },
    );
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
