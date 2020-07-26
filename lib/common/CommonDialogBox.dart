import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/search_providers/models/doctors_data.dart';
import 'package:myfhb/search_providers/models/doctors_list_response.dart';
import 'package:myfhb/search_providers/models/hospital_data.dart';
import 'package:myfhb/search_providers/models/lab_data.dart';
import 'package:myfhb/search_providers/models/labs_list_response.dart';
import 'package:myfhb/search_providers/models/search_arguments.dart';
import 'package:myfhb/search_providers/screens/search_specific_list.dart';
import 'package:myfhb/src/blocs/health/HealthReportListForUserBlock.dart';
import 'package:myfhb/src/model/Category/CategoryData.dart';
import 'package:myfhb/src/model/Category/CategoryResponseList.dart';
import 'package:myfhb/src/model/Health/MediaMetaInfo.dart';
import 'package:myfhb/src/model/Health/UserHealthResponseList.dart';
import 'package:myfhb/src/model/Media/MediaData.dart';
import 'package:myfhb/src/model/Media/MediaTypeResponse.dart';
import 'package:myfhb/src/ui/audio/audio_record_screen.dart';
import 'package:myfhb/src/utils/colors_utils.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';

import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/constants/variable_constant.dart' as variable;



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

  var doctorsData, hospitalData, labData;
  String audioPathMain = '';
  bool containsAudioMain = false;
  CategoryData categoryDataObj = new CategoryData();
  MediaData mediaDataObj = new MediaData();
  File imageFile;
  HealthReportListForUserBlock _healthReportListForUserBlock =
      new HealthReportListForUserBlock();

  List<String> imagePathMain = new List();

  FHBBasicWidget fhbBasicWidget = new FHBBasicWidget();
  MediaMetaInfo mediaMetaInfo;
  String metaInfoId = '';
  bool modeOfSave;
  MediaData selectedMediaData;

  List<MediaData> mediaDataAry = PreferenceUtil.getMediaType();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  FocusNode dateOfBirthFocus = FocusNode();

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
      MediaMetaInfo mediaMetaInfo,
      bool modeOfSaveClone,
      TextEditingController fileNameClone) {
    try {
      modeOfSave = modeOfSaveClone;

      if (mediaMetaInfo != null) {
        doctorsData = mediaMetaInfo.metaInfo.doctor != null
            ? mediaMetaInfo.metaInfo.doctor
            : null;
        hospitalData = mediaMetaInfo.metaInfo.hospital != null
            ? mediaMetaInfo.metaInfo.hospital
            : null;
        labData = mediaMetaInfo.metaInfo.laboratory != null
            ? mediaMetaInfo.metaInfo.laboratory
            : null;
        mediaMetaInfo = mediaMetaInfo != null ? mediaMetaInfo : null;

        if (mediaMetaInfo != null) {
          metaInfoId = mediaMetaInfo.id;
          
        }
      }
    } catch (e) {}

    dateOfVisit.text = dateOfVisitClone.text;
    if (modeOfSave) {
      loadMemoText(mediaMetaInfo.metaInfo.memoText != null
          ? mediaMetaInfo.metaInfo.memoText
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
    setFileName(fileNameClone.text);
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
              height: 20,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    fhbBasicWidget.getTextForAlertDialog(
                        context, CommonConstants.strDoctorsName),
                    fhbBasicWidget
                        .getTextFieldForDialogWithControllerAndPressed(context,
                            (context, value) {
                      moveToSearchScreen(
                          context,
                          CommonConstants.keyDoctor,
                          doctor,
                          hospital,
                          null,
                          updateUI,
                          audioPath,
                          containsAudio);
                    }, doctor, CommonConstants.keyDoctor),
                    SizedBox(
                      height: 15,
                    ),
                    fhbBasicWidget.getTextForAlertDialog(
                        context, CommonConstants.strFileName),
                    fhbBasicWidget.getTextFieldWithNoCallbacks(
                        context, fileName),
                    SizedBox(
                      height: 15,
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
                      height: 15,
                    ),
                    fhbBasicWidget.getTextForAlertDialog(
                        context, CommonConstants.strDateOfVisit),
                   
                    _showDateOfVisit(context, dateOfVisit),
                    SizedBox(
                      height: 15,
                    ),
                    fhbBasicWidget.getTextForAlertDialog(
                        context, CommonConstants.strMemo),
                    fhbBasicWidget.getTextFieldWithNoCallbacks(
                        context, memoController),
                    SizedBox(
                      height: 15,
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
      MediaMetaInfo mediaMetaInfo,
      bool modeOfSaveClone,
      TextEditingController fileNameClone) {
    try {
      modeOfSave = modeOfSaveClone;

      if (mediaMetaInfo != null) {
        mediaMetaInfo = mediaMetaInfo != null ? mediaMetaInfo : null;

        doctorsData = mediaMetaInfo.metaInfo.doctor;

        labData = mediaMetaInfo.metaInfo.laboratory != null
            ? mediaMetaInfo.metaInfo.laboratory
            : null;
        hospitalData = mediaMetaInfo.metaInfo.hospital != null
            ? mediaMetaInfo.metaInfo.hospital
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
    setFileName(fileNameClone.text);
    if (modeOfSave) {
      loadMemoText(mediaMetaInfo.metaInfo.memoText != null
          ? mediaMetaInfo.metaInfo.memoText
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
              height: 20,
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
                      height: 15,
                    ),
                    fhbBasicWidget.getTextForAlertDialog(
                        context, CommonConstants.strDoctorsName),
                    fhbBasicWidget
                        .getTextFieldForDialogWithControllerAndPressed(context,
                            (context, value) {
                      moveToSearchScreen(
                          context,
                          CommonConstants.keyDoctor,
                          doctor,
                          null,
                          lab,
                          updateUI,
                          audioPath,
                          containsAudio);
                    }, doctor, CommonConstants.keyDoctor),
                    SizedBox(
                      height: 15,
                    ),
                    fhbBasicWidget.getTextForAlertDialog(
                        context, CommonConstants.strFileName),
                    fhbBasicWidget.getTextFieldWithNoCallbacks(
                        context, fileName),
                    SizedBox(
                      height: 15,
                    ),
                    fhbBasicWidget.getTextForAlertDialog(
                        context, CommonConstants.strDateOfVisit),
                    _showDateOfVisit(context, dateOfVisit),
                    SizedBox(
                      height: 15,
                    ),
                    fhbBasicWidget.getTextForAlertDialog(
                        context, CommonConstants.strMemo),
                    fhbBasicWidget.getTextFieldWithNoCallbacks(
                        context, memoController),
                    SizedBox(
                      height: 15,
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
      MediaMetaInfo mediaMetaInfoClone,
      bool modeOfSaveClone,
      TextEditingController fileNameClone) {
    if (mediaMetaInfoClone != null) {
      if (mediaMetaInfoClone != null) {
        metaInfoId = mediaMetaInfoClone.id;
        
      }
    }
    modeOfSave = modeOfSaveClone;
    imagePathMain.addAll(imagePath);
    if (modeOfSave) {
      loadMemoText(mediaMetaInfoClone.metaInfo.memoText != null
          ? mediaMetaInfoClone.metaInfo.memoText
          : '');
    } else {
      memoController.text = '';
    }

    setFileName(fileNameClone.text);
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
              height: 15,
            ),
            fhbBasicWidget.getTextForAlertDialog(
                context, CommonConstants.strMemo),
            fhbBasicWidget.getTextFieldWithNoCallbacks(context, memoController),
            SizedBox(
              height: 15,
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
      MediaMetaInfo mediaMetaInfoClone,
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
    imagePathMain.addAll(imagePath);
    dateOfVisit.text = dateOfVisitClone.text;
    if (idType != '' && idType != null) {
      selectedID = idType;
    }

    setFileName(fileNameClone.text);
    if (modeOfSave) {
      loadMemoText(mediaMetaInfoClone.metaInfo.memoText != null
          ? mediaMetaInfoClone.metaInfo.memoText
          : '');
    } else {
      memoController.text = '';
    }

    List<MediaData> mediaDataAry = [];

    for (MediaData mediaData in PreferenceUtil.getMediaType()) {
      var categorySplitAry = mediaData.description.split('_');
      if (categorySplitAry[0] == CommonConstants.categoryDescriptionIDDocs) {
        mediaDataAry.add(mediaData);
      }
    }

    for (MediaData mediaData in mediaDataAry) {
      var mediaDataClone = mediaData.name.split(' ');
      if (mediaDataClone.length > 0) {
        if (idType != '' && idType != null) {
          if (idType == mediaDataClone[0]) {
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
              height: 15,
            ),
            fhbBasicWidget.getTextForAlertDialog(
                context, CommonConstants.strMemo),
            fhbBasicWidget.getTextFieldWithNoCallbacks(context, memoController),
            SizedBox(
              height: 15,
            ),
            Container(
                width: MediaQuery.of(context).size.width - 60,
                child: GestureDetector(
                    onTap: () => _selectDate(context, dateOfVisit),
                    child: TextField(
                      autofocus: false,
                      readOnly:
                          true,
                      controller: dateOfVisit,
                      decoration: InputDecoration(
                          suffixIcon: new IconButton(
                        icon: new Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context, dateOfVisit),
                      )),
                    ))),
            SizedBox(
              height: 15,
            ),
            new Center(
              child: new DropdownButton(
                hint: new Text("Select ID Type"),
                value: selectedMediaData,
                onChanged: (MediaData newValue) {
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
              height: 15,
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
      MediaMetaInfo mediaMetaInfoClone,
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

    deviceName = deviceNameClone;
    imagePathMain.addAll(imagePath);
    deviceController.text = deviceControllerClone.text;
    isSelected = isSelectedClone;
    setFileName(fileNameClone.text);
    if (modeOfSave) {
      loadMemoText(mediaMetaInfoClone.metaInfo.memoText != null
          ? mediaMetaInfoClone.metaInfo.memoText
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
                height: 15,
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
                height: 15,
              ),
              fhbBasicWidget.getTextForAlertDialog(
                  context, CommonConstants.strMemo),
              fhbBasicWidget.getTextFieldWithNoCallbacks(
                  context, memoController),
              SizedBox(
                height: 15,
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
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      variable.strafood,
                      style: TextStyle(fontSize: 16),
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
                height: 15,
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
      MediaMetaInfo mediaMetaInfoClone,
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

    deviceName = deviceNameClone;
    imagePathMain.addAll(imagePath);
    deviceController.text = deviceControllerClone.text;
    setFileName(fileNameClone.text);
    if (modeOfSave) {
      loadMemoText(mediaMetaInfoClone.metaInfo.memoText != null
          ? mediaMetaInfoClone.metaInfo.memoText
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
              height: 15,
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
              height: 15,
            ),
            fhbBasicWidget.getTextForAlertDialog(
                context, CommonConstants.strMemo),
            fhbBasicWidget.getTextFieldWithNoCallbacks(context, memoController),
            SizedBox(
              height: 15,
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

  void setFileName(String fileNameClone) {
    categoryName = PreferenceUtil.getStringValue(Constants.KEY_CATEGORYNAME);
    deviceName = PreferenceUtil.getStringValue(Constants.KEY_DEVICENAME);
    categoryID = PreferenceUtil.getStringValue(Constants.KEY_CATEGORYID);

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

  }

  Future<Widget> getDialogBoxForWeightingScale(
      BuildContext context,
      String deviceNameClone,
      bool containsAudio,
      String audioPath,
      Function(bool, String) deleteAudioFunction,
      List<String> imagePath,
      Function(bool, String) updateAudioUI,
      MediaMetaInfo mediaMetaInfoClone,
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

    deviceName = deviceNameClone;
    imagePathMain.addAll(imagePath);
    deviceController.text = deviceControllerClone.text;
    setFileName(fileNameClone.text);

    if (modeOfSave) {
      loadMemoText(mediaMetaInfoClone.metaInfo.memoText != null
          ? mediaMetaInfoClone.metaInfo.memoText
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
              height: 15,
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
              height: 15,
            ),
            fhbBasicWidget.getTextForAlertDialog(
                context, CommonConstants.strMemo),
            fhbBasicWidget.getTextFieldWithNoCallbacks(context, memoController),
            SizedBox(
              height: 15,
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
      MediaMetaInfo mediaMetaInfoClone,
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

    deviceName = deviceNameClone;
    imagePathMain.addAll(imagePath);
    deviceController.text = deviceControllerClone.text;
    pulse.text = pulseClone.text;

    setFileName(fileNameClone.text);
    if (modeOfSave) {
      loadMemoText(mediaMetaInfoClone.metaInfo.memoText != null
          ? mediaMetaInfoClone.metaInfo.memoText
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
              height: 15,
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
              height: 15,
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
              height: 15,
            ),
            fhbBasicWidget.getTextForAlertDialog(
                context, CommonConstants.strMemo),
            fhbBasicWidget.getTextFieldWithNoCallbacks(context, memoController),
            SizedBox(
              height: 15,
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
      MediaMetaInfo mediaMetaInfoClone,
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

    deviceName = deviceNameClone;
    imagePathMain.addAll(imagePath);
    deviceController.text = deviceControllerClone.text;
    pulse.text = pulseClone.text;
    diaStolicPressure.text = diastolicPressureClone.text;
    setFileName(fileNameClone.text);
    if (modeOfSave) {
      loadMemoText(mediaMetaInfoClone.metaInfo.memoText != null
          ? mediaMetaInfoClone.metaInfo.memoText
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
              height: 15,
            ),
            fhbBasicWidget.getTextFiledWithHintAndSuffixText(
                context,
                CommonConstants.strSystolicPressure,
                commonConstants.bpSPUNIT,
                deviceController, (errorValue) {
              setState(() {
                errForbpSp = errorValue;
              });
            }, errForbpSp, variable.strbpunit),
            SizedBox(
              height: 15,
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
              height: 15,
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
              height: 15,
            ),
            fhbBasicWidget.getTextForAlertDialog(
                context, CommonConstants.strMemo),
            fhbBasicWidget.getTextFieldWithNoCallbacks(context, memoController),
            SizedBox(
              height: 15,
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

  moveToSearchScreen(
      BuildContext context,
      String searchParam,
      TextEditingController doctorsName,
      TextEditingController hospitalName,
      TextEditingController labName,
      Function onTextFinished,
      String audioPath,
      bool containsAudio) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => SearchSpecificList(
                  arguments: SearchArguments(
                    searchWord: searchParam,
                  ),
                  toPreviousScreen: true,
                )))
        .then((results) {
      if (results != null) {
        if (results.containsKey(Constants.keyDoctor)) {
          doctorsData = json.decode(results[Constants.keyDoctor]);


          doctorsName.text = doctorsData[parameters.strName];
          doctor.text = doctorsData[parameters.strName];
        } else if (results.containsKey(Constants.keyHospital)) {

          hospitalData = json.decode(results[Constants.keyHospital]);

          hospitalName.text = hospitalData[parameters.strName];
          hospital.text = hospitalData[parameters.strName];
        } else if (results.containsKey(Constants.keyLab)) {
          labData = json.decode(results[Constants.keyLab]);
        
          labName.text = labData[parameters.strName];
          lab.text = labData[parameters.strName];
        }
        onTextFinished();
      }
    });
  }

  Widget getMicIcon(BuildContext context, bool containsAudio, String audioPath,
      Function(bool, String) updateUI) {
    return GestureDetector(
      child: Container(
        height: 80,
        width: 80,
        padding: EdgeInsets.all(10),
        child: Material(
          color: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: CircleBorder(),
          child: CircleAvatar(
            backgroundColor: ColorUtils.greycolor,
            child: Icon(
              Icons.mic,
              size: 40,
              color: Colors.black,
            ),
            radius: 30.0,
          ),
        ),
      ),
      onTap: () async {
        await Navigator.of(context)
            .push(MaterialPageRoute(
          builder: (context) => AudioRecordScreen(
            fromVoice: false,
          ),
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

  void onPostDataToServer(BuildContext context, List<String> imagePath) async {
    if (doValidationBeforePosting()) {
      CommonUtil.showLoadingDialog(context, _keyLoader, variable.Please_Wait);

      Map<String, dynamic> postMainData = new Map();
      Map<String, dynamic> postMediaData = new Map();
      String userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);
      if (modeOfSave) {
        postMainData[parameters.struserId] = userID;
      }
      List<CategoryData> catgoryDataList = PreferenceUtil.getCategoryType();

      categoryDataObj = new CommonUtil()
          .getCategoryObjForSelectedLabel(categoryID, catgoryDataList);
      postMediaData[parameters.strcategoryInfo] = categoryDataObj.toJson();
      List<MediaData> metaDataFromSharedPrefernce =
          PreferenceUtil.getMediaType();

      if (categoryName != Constants.STR_DEVICES) {
        mediaDataObj = new CommonUtil().getMediaTypeInfoForParticularLabel(
            categoryID, metaDataFromSharedPrefernce, categoryName);
      } else {
        mediaDataObj = new CommonUtil().getMediaTypeInfoForParticularDevice(
            deviceName, metaDataFromSharedPrefernce);
      }

      postMediaData[parameters.strmediaTypeInfo] = mediaDataObj.toJson();

      postMediaData[parameters.strmemoText] = memoController.text;

      if (categoryName != Constants.STR_VOICERECORDS) {
        postMediaData[parameters.strhasVoiceNotes] =
            (audioPathMain != '' && audioPathMain != null) ? true : false;

        postMediaData[parameters.strdateOfVisit] = dateOfVisit.text;
      }

      postMediaData[parameters.strisDraft] = false;

      postMediaData[parameters.strSourceName] = CommonConstants.strTridentValue;
      postMediaData[parameters.strmemoTextRaw] = memoController.text;

      if (categoryName == CommonConstants.strDevice) {
        List<Map<String, dynamic>> postDeviceData = new List();
        Map<String, dynamic> postDeviceValues = new Map();
        Map<String, dynamic> postDeviceValuesExtra = new Map();
        Map<String, dynamic> postDeviceValuesExtraClone = new Map();

        if (deviceName == Constants.STR_GLUCOMETER) {
          postDeviceValues[parameters.strParameters] = CommonConstants.strSugarLevel;
          postDeviceValues[parameters.strvalue] = deviceController.text;
          postDeviceValues[parameters.strunit] = CommonConstants.strGlucometerValue;
          postDeviceData.add(postDeviceValues);
          postDeviceValuesExtra[parameters.strParameters] = CommonConstants.strTimeIntake;
          postDeviceValuesExtra[parameters.strvalue] = '';
          postDeviceValuesExtra[parameters.strunit] =
              isSelected[0] == true ? variable.strBefore : variable.strAfter;
          postDeviceData.add(postDeviceValuesExtra);
        } else if (deviceName == Constants.STR_THERMOMETER) {
          postDeviceValues[parameters.strParameters] = CommonConstants.strTemperature;
          postDeviceValues[parameters.strvalue] = deviceController.text;
          postDeviceValues[parameters.strunit] = CommonConstants.strTemperatureUnit;
          postDeviceData.add(postDeviceValues);
        } else if (deviceName == Constants.STR_WEIGHING_SCALE) {
          postDeviceValues[parameters.strParameters] = CommonConstants.strWeightParam;
          postDeviceValues[parameters.strvalue] = deviceController.text;
          postDeviceValues[parameters.strunit] = CommonConstants.strWeightUnit;
          postDeviceData.add(postDeviceValues);
        } else if (deviceName == Constants.STR_PULSE_OXIMETER) {
          postDeviceValues[parameters.strParameters] = CommonConstants.strOxygenParams;
          postDeviceValues[parameters.strvalue] = deviceController.text;
          postDeviceValues[parameters.strunit] = CommonConstants.strOxygenUnits;
          postDeviceData.add(postDeviceValues);

          postDeviceValuesExtra[parameters.strParameters] = CommonConstants.strPulseRate;
          postDeviceValuesExtra[parameters.strvalue] = pulse.text;
          postDeviceValuesExtra[parameters.strunit] = CommonConstants.strPulseUnit;

          postDeviceData.add(postDeviceValuesExtra);
        } else if (deviceName == Constants.STR_BP_MONITOR) {
          postDeviceValues[parameters.strParameters] = CommonConstants.strBPParams;
          postDeviceValues[parameters.strvalue] = deviceController.text;

          postDeviceValues[parameters.strunit] = CommonConstants.strBPUNits;
          postDeviceData.add(postDeviceValues);

          postDeviceValuesExtra[parameters.strParameters] =
              CommonConstants.strDiastolicParams;
          postDeviceValuesExtra[parameters.strvalue] = diaStolicPressure.text;
          postDeviceValuesExtra[parameters.strunit] = CommonConstants.strBPUNits;

          postDeviceData.add(postDeviceValuesExtra);

          postDeviceValuesExtraClone[parameters.strParameters] =
              CommonConstants.strPulseRate;
          postDeviceValuesExtraClone[parameters.strvalue] = pulse.text;
          postDeviceValuesExtraClone[parameters.strunit] = CommonConstants.strPulseUnit;

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
          postMediaData[parameters.stridType] = selectedMediaData.name.split(' ')[0];
        }
      } else if (categoryName == Constants.STR_LABREPORT) {
        postMediaData[Constants.keyDoctor] = doctorsData;
        postMediaData[Constants.keyLab] = labData;
      }
      postMediaData[parameters.strfileName] = fileName.text;

      postMainData[parameters.strmetaInfo] = postMediaData;
      if (modeOfSave) {
        postMainData[parameters.strIsActive] = true;
      }

   

      var params = json.encode(postMainData);

print(params);

      if (imagePath != null) {
        if (modeOfSave) {
          _healthReportListForUserBlock
              .updateMedia(params.toString(), metaInfoId)
              .then((updateMediaResponse) {
            if (updateMediaResponse.success) {
              PreferenceUtil.saveString(Constants.KEY_FAMILYMEMBERID, "");
              PreferenceUtil.saveMediaData(Constants.KEY_MEDIADATA, null);

              
              _healthReportListForUserBlock.getHelthReportList(condtion: false).then((value) {
                PreferenceUtil.saveCompleteData(
                    Constants.KEY_COMPLETE_DATA, value.response.data);

                Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                    .pop();

                Navigator.of(context).pop();
                Navigator.of(context).pop();
              });
            }
          });
        } else {
          _healthReportListForUserBlock
              .submit(params.toString())
              .then((savedMetaDataResponse) {
            if (savedMetaDataResponse.success) {
              if (categoryName == Constants.STR_IDDOCS) {
                PreferenceUtil.saveString(Constants.KEY_FAMILYMEMBERID, "");
                PreferenceUtil.saveMediaData(Constants.KEY_MEDIADATA, null);
              }

              postAudioToServer(
                  savedMetaDataResponse.response.data.mediaMetaID, context);
            }
          });
        }
      } else {
        _healthReportListForUserBlock
            .submit(params.toString())
            .then((savedMetaDataResponse) {
          if (savedMetaDataResponse.success) {
            PreferenceUtil.saveString(Constants.KEY_FAMILYMEMBERID, "");
            PreferenceUtil.saveMediaData(Constants.KEY_MEDIADATA, null);

            saveAudioFile(context, audioPathMain,
                savedMetaDataResponse.response.data.mediaMetaID);
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

  void postAudioToServer(String mediaMetaID, BuildContext context) {
    Map<String, dynamic> postImage = new Map();

    postImage[parameters.strmediaMetaId] = mediaMetaID;
    
    int k = 0;
    for (int i = 0; i < imagePathMain.length; i++) {
      _healthReportListForUserBlock
          .saveImage(imagePathMain[i], mediaMetaID, '')
          .then((postImageResponse) {
        
        if ((audioPathMain != '' && k == imagePathMain.length) ||
            (audioPathMain != '' && k == imagePathMain.length - 1)) {
          _healthReportListForUserBlock
              .saveImage(audioPathMain, mediaMetaID, '')
              .then((postImageResponse) {


            _healthReportListForUserBlock.getHelthReportList(condtion: false).then((value) {
              PreferenceUtil.saveCompleteData(
                      Constants.KEY_COMPLETE_DATA, value.response.data)
                  .then((value) {
                Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                    .pop();

                Navigator.of(context).pop();
                Navigator.of(context).pop(true);
              });
            });
          });
        } else if (k == imagePathMain.length - 1) {
          _healthReportListForUserBlock.getHelthReportList(condtion: false).then((value) {
            PreferenceUtil.saveCompleteData(
                    Constants.KEY_COMPLETE_DATA, value.response.data)
                .then((value) {
              Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                  .pop();

              Navigator.of(context).pop();
              Navigator.of(context).pop(true);
            });
          });
        } else if (k == imagePathMain.length && modeOfSave == true) {
          _healthReportListForUserBlock.getHelthReportList(condtion: false).then((value) {
            PreferenceUtil.saveCompleteData(
                    Constants.KEY_COMPLETE_DATA, value.response.data)
                .then((value) {
              Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                  .pop();

              Navigator.of(context).pop();
              Navigator.of(context).pop(true);
            });
          });
        }

        k++;
      });
    }
  }

  void saveAudioFile(
      BuildContext context, String audioPath, String mediaMetaID) {
    if (audioPathMain != '') {
      _healthReportListForUserBlock
          .saveImage(audioPathMain, mediaMetaID, '')
          .then((postImageResponse) {
        
        _healthReportListForUserBlock.getHelthReportList(condtion: false).then((value) {
          PreferenceUtil.saveCompleteData(
                  Constants.KEY_COMPLETE_DATA, value.response.data)
              .then((value) {
            Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

            Navigator.of(context).pop();
            Navigator.of(context).pop(true);
          });
        });
      });
    }else{
                  Navigator.of(context).pop();
                              Navigator.of(context).pop();


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
      }
    } else if (categoryName == Constants.STR_IDDOCS) {
      if (fileName.text == '') {
        validationConditon = false;
        validationMsg = CommonConstants.strFileEmpty;
      } else if (selectedMediaData == null) {
        validationConditon = false;
        validationMsg = CommonConstants.strIDEmpty;
      } else {
        validationConditon = true;
      }
    }else if (categoryName == Constants.STR_NOTES) {
       if (fileName.text == '') {
        validationConditon = false;
        validationMsg = CommonConstants.strFileEmpty;
      }else if(memoController.text=='') {
        validationConditon = false;
        validationMsg = CommonConstants.strMemoEmpty;
      }
      else {
        validationConditon = true;
      }
    }
     else if (categoryName == Constants.STR_DEVICES) {
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
          validationMsg = CommonConstants.strPulse;
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
          validationMsg = CommonConstants.strPulse;
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
      TextEditingController fileNameClone) {
    modeOfSave = modeOfSaveClone;
    containsAudioMain = containsAudio;
    audioPathMain = audioPath;
    setFileName(fileNameClone.text);
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
              height: 15,
            ),
            fhbBasicWidget.getTextForAlertDialog(
                context, CommonConstants.strMemo),
            fhbBasicWidget.getTextFieldWithNoCallbacks(context, memoController),
            SizedBox(
              height: 15,
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
        cursorColor: Theme.of(context).primaryColor,
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
      MediaMetaInfo mediaMetaInfoClone,
      bool modeOfSaveClone,
      TextEditingController fileNameClone) {
    if (mediaMetaInfoClone != null) {
      if (mediaMetaInfoClone != null) {
        metaInfoId = mediaMetaInfoClone.id;
        
      }
    }
    modeOfSave = modeOfSaveClone;
    if(imagePath!=null)
    imagePathMain.addAll(imagePath);
    if (modeOfSave) {
      loadMemoText(mediaMetaInfoClone.metaInfo.memoText != null
          ? mediaMetaInfoClone.metaInfo.memoText
          : '');
    } else {
      memoController.text = '';
    }

    setFileName(fileNameClone.text);
    categoryName=Constants.STR_NOTES;
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
              height: 15,
            ),
            fhbBasicWidget.getTextForAlertDialog(
                context, CommonConstants.strMemo),
            fhbBasicWidget.getTextFieldWithNoCallbacks(context, memoController),
            SizedBox(
              height: 15,
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
}
