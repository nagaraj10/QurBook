import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/colors/fhb_colors.dart';
import 'package:myfhb/common/CommonConstants.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/FHBBasicWidget.dart';
import 'package:myfhb/common/customized_checkbox.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/device_integration/model/DeleteDeviceHealthRecord.dart';
import 'package:myfhb/device_integration/model/DeviceIntervalData.dart';
import 'package:myfhb/device_integration/model/HeartRate.dart';
import 'package:myfhb/src/blocs/Category/CategoryListBlock.dart';
import 'package:myfhb/src/blocs/Media/MediaTypeBlock.dart';
import 'package:myfhb/src/blocs/health/HealthReportListForUserBlock.dart';
import 'package:myfhb/src/model/Category/catergory_result.dart';
import 'package:myfhb/src/model/Media/media_data_list.dart';
import 'package:myfhb/src/model/Media/media_result.dart';
import 'package:myfhb/src/resources/repository/health/HealthReportListForUserRepository.dart';
import 'package:myfhb/src/ui/bot/view/ChatScreen.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:provider/provider.dart';

import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;

import 'package:myfhb/widgets/GradientAppBar.dart';

import 'package:myfhb/device_integration/model/BPValues.dart';
import 'package:myfhb/device_integration/model/GulcoseValues.dart';
import 'package:myfhb/device_integration/model/OxySaturationValues.dart';
import 'package:myfhb/device_integration/model/TemperatureValues.dart';
import 'package:myfhb/device_integration/model/WeightValues.dart';
import 'package:myfhb/device_integration/viewModel/Device_model.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'dart:convert';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class EachDeviceValues extends StatefulWidget {
  EachDeviceValues(
      {this.device_name,
      this.device_icon,
      this.sheelaRequestString,
      this.deviceNameForAdding});

  final String device_name;
  final String device_icon;
  final String sheelaRequestString;
  final String deviceNameForAdding;

  @override
  _EachDeviceValuesState createState() => _EachDeviceValuesState();
}

class _EachDeviceValuesState extends State<EachDeviceValues> {
  GlobalKey<ScaffoldState> scaffold_state = new GlobalKey<ScaffoldState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  String errorMsg = '';
  bool onOkClicked = false;
  String categoryName = STR_DEVICES;

  CategoryListBlock _categoryListBlock = new CategoryListBlock();
  List<CategoryResult> catgoryDataList = new List();
  MediaTypeBlock _mediaTypeBlock = new MediaTypeBlock();
  MediaDataList mediaTypesResponse = new MediaDataList();

  CategoryResult categoryDataObj = new CategoryResult();
  String categoryID = '14c3f2a1-70d3-49dd-a922-6bee255eed26';
  MediaResult mediaDataObj = new MediaResult();

  TextEditingController deviceController = new TextEditingController(text: '');
  TextEditingController pulse = new TextEditingController(text: '');
  TextEditingController memoController = new TextEditingController(text: '');
  TextEditingController diaStolicPressure = new TextEditingController(text: '');

  List<bool> isSelected = new List(2);

  HealthReportListForUserBlock _healthReportListForUserBlock =
      new HealthReportListForUserBlock();

  List<String> imagePathMain = new List();

  FlutterToast toast = new FlutterToast();

  String validationMsg;

  FHBBasicWidget fhbBasicWidget = new FHBBasicWidget();

  var commonConstants = new CommonConstants();

  @override
  void initState() {
    mInitialTime = DateTime.now();
    super.initState();
    catgoryDataList = PreferenceUtil.getCategoryType();
    if (catgoryDataList == null) {
      _categoryListBlock.getCategoryLists().then((value) {
        catgoryDataList = value.result;
      });
    }
    _mediaTypeBlock.getMediTypesList().then((value) {
      mediaTypesResponse = value;
    });
  }

  @override
  void dispose() {
    super.dispose();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'Device Value Screen',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
  }

  @override
  Widget build(BuildContext context) {
    DevicesViewModel _devicesmodel = Provider.of<DevicesViewModel>(context);
    return Scaffold(
      key: scaffold_state,
      appBar: AppBar(
        title: Text(
          getStringValue(),
          style: TextStyle(fontSize: 18.0.sp),
        ),
        actions: <Widget>[
          Image.asset(
            widget.device_icon,
            height: 40.0.h,
            width: 40.0.h,
          ),
          SizedBoxWidget(
            width: 15.0.w,
          )
        ],
        flexibleSpace: GradientAppBar(),
      ),
      body: Container(
        color: Colors.grey[200],
        child: Column(
          children: [
            SizedBoxWidget(height: 5.0.h),
            Container(child: getAddDeviceReadings()),
            SizedBoxWidget(height: 5.0.h),
            Expanded(
              child: getValues(context, _devicesmodel),
            ),
          ],
        ),
      ),
      floatingActionButton: IconButton(
        icon: Image.asset(icon_mayaMain),
        iconSize: 60,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return ChatScreen(
                  sheelaInputs: widget.sheelaRequestString,
                );
              },
            ),
          ).then((value) {
            setState(() {});
          });
        },
      ),
    );
  }

  Widget getAddDeviceReadings() {
    return Column(
      children: [
        getCardBasedOnDevices(widget.deviceNameForAdding),
        SizedBox(
          height: 20.0.h,
        ),
        Text(
          errorMsg,
          style: TextStyle(fontSize: 14.0.sp),
        ),
        SizedBoxWidget(height: 5.0.h),
        new Container(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 8.0, top: 4.0, right: 8.0, bottom: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  width: 50,
                ),
                OutlineButton(
                  onPressed: onOkClicked
                      ? () {}
                      : () async {
                          onOkClicked = true;

                          new FHBUtils().check().then((intenet) {
                            if (intenet != null && intenet) {
                              createDeviceRecords(widget.deviceNameForAdding);
                            } else {
                              onOkClicked = false;
                              new FHBBasicWidget().showInSnackBar(
                                  STR_NO_CONNECTIVITY, scaffold_state);
                            }
                          });
                        } /*() {
                      new FHBUtils().check().then((intenet) {
                        if (intenet != null && intenet) {
                          createDeviceRecords(deviceName);
                        } else {
                          new FHBBasicWidget().showInSnackBar(
                              Constants.STR_NO_CONNECTIVITY, scaffold_state);
                        }
                      });
                    }*/
                  ,
                  child: Text('OK'),
                  textColor: Color(CommonUtil().getMyPrimaryColor()),
                  color: Colors.transparent,
                  borderSide: BorderSide(
                      color: Color(CommonUtil().getMyPrimaryColor())),
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                //submitButton(_otpVerifyBloc)
                MaterialButton(
                  onPressed: () {
                    //matchOtp();
                  },
                  child: Text('',
                      style: TextStyle(
                          fontSize: 22.0.sp, fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void deleteDeviceRecord(String deviceId) async {
    HealthReportListForUserRepository healthReportListForUserRepository =
        HealthReportListForUserRepository();

    DeleteDeviceHealthRecord deviceHealthRecord;

    FlutterToast toast = new FlutterToast();

    await healthReportListForUserRepository
        .deleteDeviceRecords(deviceId)
        .then((value) {
      deviceHealthRecord = value;
      if (deviceHealthRecord.isSuccess) {
        toast.getToast('Deleted Successfully', Colors.green);
        setState(() {});
      } else {
        toast.getToast('Unable to delete the record', Colors.red);
      }
    });
  }

  void createDeviceRecords(String deviceName) async {
    if (doValidation(deviceName)) {
      CommonUtil.showLoadingDialog(context, _keyLoader, variable.Please_Wait);

      Map<String, dynamic> postMainData = new Map();
      Map<String, dynamic> postMediaData = new Map();

      String userID = PreferenceUtil.getStringValue(KEY_USERID);
      try {
        catgoryDataList = PreferenceUtil.getCategoryType();
        categoryDataObj = new CommonUtil()
            .getCategoryObjForSelectedLabel(categoryID, catgoryDataList);
        postMediaData[strhealthRecordCategory] = categoryDataObj.toJson();
      } catch (e) {
        if (catgoryDataList == null) {
          _categoryListBlock.getCategoryLists().then((value) {
            catgoryDataList = value.result;
            categoryDataObj = new CommonUtil()
                .getCategoryObjForSelectedLabel(categoryID, catgoryDataList);
            postMediaData[strhealthRecordCategory] = categoryDataObj.toJson();
          });
        }
      }

      List<MediaResult> metaDataFromSharedPrefernce = new List();
      if (mediaTypesResponse != null &&
          mediaTypesResponse.result != null &&
          mediaTypesResponse.result.length > 0) {
        metaDataFromSharedPrefernce = mediaTypesResponse.result;
      } else {
        mediaTypesResponse = await _mediaTypeBlock.getMediTypesList();

        metaDataFromSharedPrefernce = mediaTypesResponse.result;
      }
      mediaDataObj = new CommonUtil().getMediaTypeInfoForParticularDevice(
          deviceName, metaDataFromSharedPrefernce);

      postMediaData[parameters.strhealthRecordType] = mediaDataObj.toJson();

      postMediaData[parameters.strmemoText] = memoController.text;
      postMediaData[parameters.strhasVoiceNotes] = false;
      postMediaData[parameters.strisDraft] = false;

      postMediaData[parameters.strSourceName] = CommonConstants.strTridentValue;
      postMediaData[parameters.strmemoTextRaw] = memoController.text;
      DateTime dateTime = DateTime.now();
      postMediaData[parameters.strStartDate] = dateTime.toUtc().toString();
      postMediaData[parameters.strEndDate] = dateTime.toUtc().toString();
      var commonConstants = new CommonConstants();

      if (categoryName == CommonConstants.strDevice) {
        List<Map<String, dynamic>> postDeviceData = new List();
        Map<String, dynamic> postDeviceValues = new Map();
        Map<String, dynamic> postDeviceValuesExtra = new Map();
        Map<String, dynamic> postDeviceValuesExtraClone = new Map();

        if (deviceName == STR_GLUCOMETER) {
          postDeviceValues[parameters.strParameters] =
              CommonConstants.strSugarLevel;
          postDeviceValues[parameters.strvalue] = deviceController.text;
          postDeviceValues[parameters.strunit] =
              CommonConstants.strGlucometerValue;
          postDeviceData.add(postDeviceValues);
          postDeviceValuesExtra[parameters.strParameters] =
              CommonConstants.strTimeIntake;
          postDeviceValuesExtra[parameters.strvalue] = '';
          if (isSelected[0] == true) {
            postDeviceValuesExtra[parameters.strunit] = variable.strBefore;
          } else if (isSelected[1] == true) {
            postDeviceValuesExtra[parameters.strunit] = variable.strAfter;
          }

          postDeviceData.add(postDeviceValuesExtra);
        } else if (deviceName == STR_THERMOMETER) {
          postDeviceValues[parameters.strParameters] =
              CommonConstants.strTemperature;
          postDeviceValues[parameters.strvalue] = deviceController.text;
          postDeviceValues[parameters.strunit] =
              CommonConstants.strTemperatureValue;
          postDeviceData.add(postDeviceValues);
        } else if (deviceName == STR_WEIGHING_SCALE) {
          postDeviceValues[parameters.strParameters] =
              CommonConstants.strWeightParam;
          postDeviceValues[parameters.strvalue] = deviceController.text;
          postDeviceValues[parameters.strunit] = CommonConstants.strWeightUnit;
          postDeviceData.add(postDeviceValues);
        } else if (deviceName == STR_PULSE_OXIMETER) {
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
        } else if (deviceName == STR_BP_MONITOR) {
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
        postMediaData[parameters.strfileName] =
            deviceName + '_${DateTime.now().toUtc().millisecondsSinceEpoch}';
        DateTime dateTime = DateTime.now();

        postMediaData[parameters.strdateOfVisit] =
            new FHBUtils().getFormattedDateOnly(dateTime.toString());

        postMainData[parameters.strmetaInfo] = postMediaData;

        var params = json.encode(postMediaData);

        _healthReportListForUserBlock
            .createHealtRecords(params.toString(), imagePathMain, '')
            .then((value) {
          if (value != null && value.isSuccess) {
            _healthReportListForUserBlock.getHelthReportLists().then((value) {
              /*Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                  .pop();*/
              errorMsg = '';
              onOkClicked = false;

              PreferenceUtil.saveCompleteData(KEY_COMPLETE_DATA, value);
              Navigator.of(context).pop(true);

              setState(() {
                deviceController.text = '';
                pulse.text = '';
                diaStolicPressure.text = '';
                isSelected[0] = null;
                isSelected[1] = null;
              });
            });
          } else {
            errorMsg = '';
            onOkClicked = false;
            Navigator.of(context).pop(true);
            //Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
            toast.getToast(ERR_MSG_RECORD_CREATE, Colors.red);
          }
        });
      }
    } else {
      onOkClicked = false;

      showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text(variable.strAPP_NAME),
            content: new Text(validationMsg),
          ));
    }
  }

  bool doValidation(String deviceName) {
    bool validationConditon = false;
    if (categoryName == STR_DEVICES) {
      if (deviceName == STR_GLUCOMETER) {
        if (deviceController.text == '' || deviceController.text == null) {
          validationConditon = false;
          validationMsg = CommonConstants.strSugarLevelEmpty;
        } else if (isSelected[0] == null && isSelected[1] == null) {
          validationConditon = false;
          validationMsg = CommonConstants.strSugarFasting;
        } else {
          validationConditon = true;
        }
      } else if (deviceName == STR_BP_MONITOR) {
        if (deviceController.text == '' || deviceController.text == null) {
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
      } else if (deviceName == STR_THERMOMETER) {
        if (deviceController.text == '' || deviceController.text == null) {
          validationConditon = false;
          validationMsg = CommonConstants.strtemperatureEmpty;
        } else {
          validationConditon = true;
        }
      } else if (deviceName == STR_WEIGHING_SCALE) {
        if (deviceController.text == '' || deviceController.text == null) {
          validationConditon = false;
          validationMsg = CommonConstants.strWeightEmpty;
        } else {
          validationConditon = true;
        }
      } else if (deviceName == STR_PULSE_OXIMETER) {
        if (deviceController.text == '' || deviceController.text == null) {
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

  Widget getCardBasedOnDevices(String deviceName) {
    switch (deviceName) {
      case CommonConstants.STR_BP_MONITOR:
        return getCardForBPMonitor(deviceName);
        break;
      case CommonConstants.STR_THERMOMETER:
        return getCardForThermometer(deviceName);
        break;
      case CommonConstants.STR_PULSE_OXIDOMETER:
        return getCardForPulseOxidometer(deviceName);
        break;
      case CommonConstants.STR_WEIGHING_SCALE:
        return getCardForWeighingScale(deviceName);
        break;
      case CommonConstants.STR_GLUCOMETER:
        return getCardForGlucometer(deviceName);
        break;
      default:
        return getCardForBPMonitor(deviceName);
        break;
    }
  }

  Widget getCardForBPMonitor(String deviceName) {
    return Container(
        //height: 70.0.h,
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.only(left: 15, right: 15, top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color(cardShadowColor),
              blurRadius: 16, // has the effect of softening the shadow
              spreadRadius: 0, // has the effect of extending the shadow
            )
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  children: [
                    Image.asset(
                      Devices_BP,
                      height: 30.0.h,
                      width: 30.0.h,
                      color: Color(CommonConstants.bpDarkColor),
                    ),
                    Text(
                      CommonConstants.STR_BP_MONITOR,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0.sp,
                          color: Color(CommonConstants.bpDarkColor)),
                      softWrap: true,
                    ),
                  ],
                ),
                SizedBox(
                  width: 5.0.w,
                ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 15.0.w,
                      ),
                      Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Sys',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.0.sp,
                                      color:
                                          Color(CommonConstants.bplightColor)),
                                  softWrap: true,
                                ),
                                /*Container(
                                  child: TextFormField(
                                      textAlign: TextAlign.center,
                                      controller: deviceController,
                                      style: TextStyle(
                                          fontSize: 15.0.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Color(
                                              CommonConstants.bpDarkColor)),
                                      decoration: InputDecoration(
                                          border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(CommonConstants
                                                    .bpDarkColor),
                                                width: 0.5),
                                          ),
                                          hintText: '0',
                                          hintStyle: TextStyle(
                                              color: Colors.grey, fontSize: 15.0.sp),
                                          contentPadding: EdgeInsets.zero),
                                      cursorColor:
                                          Color(CommonConstants.bpDarkColor),
                                      keyboardType: TextInputType.number,
                                      cursorWidth: 0.5,
                                      onSaved: (input) => setState(() {})),
                                )*/
                                fhbBasicWidget.getErrorMsgForUnitEntered(
                                  context,
                                  CommonConstants.strSystolicPressure,
                                  commonConstants.bpDPUNIT,
                                  deviceController,
                                  (errorValue) {
                                    setState(() {
                                      errorMsg = errorValue;
                                    });
                                  },
                                  errorMsg,
                                  variable.strbpunit,
                                  deviceName,
                                )
                              ],
                            ),
                          ),
                          flex: 1),
                      Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Dia',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.0.sp,
                                    color: Color(CommonConstants.bplightColor)),
                                softWrap: true,
                              ),
                              /*Container(
                                constraints: BoxConstraints(maxWidth: 100),
                                child: TextFormField(
                                    controller: diaStolicPressure,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 15.0.sp,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            Color(CommonConstants.bpDarkColor)),
                                    decoration: InputDecoration(
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 0.5),
                                        ),
                                        hintText: '0',
                                        hintStyle: TextStyle(
                                            color: Colors.grey, fontSize: 15.0.sp),
                                        contentPadding: EdgeInsets.zero),
                                    cursorColor:
                                        Color(CommonConstants.bpDarkColor),
                                    keyboardType: TextInputType.number,
                                    cursorWidth: 0.5,
                                    onSaved: (input) => setState(() {})),
                              ),*/
                              fhbBasicWidget.getErrorMsgForUnitEntered(
                                context,
                                CommonConstants.strDiastolicPressure,
                                commonConstants.bpDPUNIT,
                                diaStolicPressure,
                                (errorValue) {
                                  setState(() {
                                    errorMsg = errorValue;
                                  });
                                },
                                errorMsg,
                                variable.strbpunit,
                                deviceName,
                              )
                            ],
                          ),
                          flex: 1),
                      Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Pul',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.0.sp,
                                      color:
                                          Color(CommonConstants.bplightColor)),
                                  softWrap: true,
                                ),
                                /*Container(
                                  constraints: BoxConstraints(maxWidth: 100),
                                  child: TextFormField(
                                      textAlign: TextAlign.center,
                                      controller: pulse,
                                      style: TextStyle(
                                          fontSize: 15.0.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Color(
                                              CommonConstants.bpDarkColor)),
                                      decoration: InputDecoration(
                                          border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(CommonConstants
                                                    .bpDarkColor),
                                                width: 0.5),
                                          ),
                                          hintText: '0',
                                          hintStyle: TextStyle(
                                              color: Colors.grey, fontSize: 15.0.sp),
                                          contentPadding: EdgeInsets.zero),
                                      cursorColor:
                                          Color(CommonConstants.bpDarkColor),
                                      keyboardType: TextInputType.number,
                                      cursorWidth: 0.5,
                                      onSaved: (input) => setState(() {})),
                                ),*/
                                fhbBasicWidget.getErrorMsgForUnitEntered(
                                  context,
                                  CommonConstants.strPulse,
                                  commonConstants.bpPulseUNIT,
                                  pulse,
                                  (errorValue) {
                                    setState(() {
                                      errorMsg = errorValue;
                                    });
                                  },
                                  errorMsg,
                                  variable.strpulse,
                                  deviceName,
                                ),
                              ],
                            ),
                          ),
                          flex: 1),
                      SizedBox(
                        width: 15.0.w,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Widget getCardForThermometer(String deviceName) {
    return Container(
        //height: 70.0.h,
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.only(left: 15, right: 15, top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color(cardShadowColor),
              blurRadius: 16, // has the effect of softening the shadow
              spreadRadius: 0, // has the effect of extending the shadow
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Image.asset(
                    Devices_THM,
                    height: 40.0.h,
                    width: 40.0.h,
                    color: Color(CommonConstants.ThermoDarkColor),
                  ),
                  Text(
                    CommonConstants.STR_THERMOMETER,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0.sp,
                        color: Color(CommonConstants.ThermoDarkColor)),
                    softWrap: true,
                  ),
                ],
              ),
              flex: 1,
            ),
            SizedBox(
              width: 5.0.w,
            ),
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Temp',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0.sp,
                            color: Color(CommonConstants.ThermolightColor)),
                        softWrap: true,
                      ),
                      /*Container(
                        width: 50,
                        constraints: BoxConstraints(maxWidth: 100),
                        child: TextFormField(
                            controller: deviceController,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15.0.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(CommonConstants.ThermoDarkColor)),
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(
                                          CommonConstants.ThermoDarkColor),
                                      width: 0.5),
                                ),
                                hintText: '0',
                                hintStyle:
                                    TextStyle(color: Colors.grey, fontSize: 15.0.sp),
                                contentPadding: EdgeInsets.zero),
                            cursorColor: Color(CommonConstants.ThermoDarkColor),
                            keyboardType: TextInputType.number,
                            cursorWidth: 0.5,
                            onSaved: (input) => setState(() {})),
                      )*/
                      fhbBasicWidget.getErrorMsgForUnitEntered(
                        context,
                        CommonConstants.strTemperature,
                        commonConstants.tempUNIT,
                        deviceController,
                        (errorValue) {
                          setState(() {
                            errorMsg = errorValue;
                          });
                        },
                        errorMsg,
                        commonConstants.tempUNIT,
                        deviceName,
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0.sp,
                            color: Color(CommonUtil().getMyPrimaryColor())),
                        softWrap: true,
                      ),
                      Container(
                        width: 50.0.w,
                        constraints: BoxConstraints(maxWidth: 100.0.w),
                        child: Text(
                          'F',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14.0.sp,
                              color: Color(CommonConstants.ThermoDarkColor)),
                          softWrap: true,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ));
  }

  Widget getCardForPulseOxidometer(String deviceName) {
    return Container(
        //height: 70.0.h,
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.only(left: 15, right: 15, top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color(cardShadowColor),
              blurRadius: 16, // has the effect of softening the shadow
              spreadRadius: 0, // has the effect of extending the shadow
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Image.asset(
                    Devices_OxY,
                    height: 30.0.h,
                    width: 30.0.h,
                    color: Color(CommonConstants.pulseDarkColor),
                  ),
                  SizedBox(
                    height: 10.0.h,
                  ),
                  Text(
                    deviceName,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0.sp,
                        color: Color(CommonConstants.pulseDarkColor)),
                    softWrap: true,
                  ),
                ],
              ),
              flex: 1,
            ),
            SizedBox(
              width: 5.0.w,
            ),
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'SPO2',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0.sp,
                                color: Color(CommonConstants.pulselightColor)),
                            softWrap: true,
                          ),
                          fhbBasicWidget.getErrorMsgForUnitEntered(
                              context,
                              CommonConstants.strOxygenSaturation,
                              commonConstants.poOxySatUNIT,
                              deviceController, (errorValue) {
                            setState(() {
                              errorMsg = errorValue;
                            });
                          }, errorMsg, variable.strpulseUnit, deviceName),
                        ],
                      )),
                  Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'PRBpm',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0.sp,
                                color: Color(CommonConstants.pulselightColor)),
                            softWrap: true,
                          ),
                          /* Container(
                            width: 50,
                            constraints: BoxConstraints(maxWidth: 100),
                            child: TextFormField(
                                controller: pulse,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15.0.sp,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        Color(CommonConstants.pulseDarkColor)),
                                decoration: InputDecoration(
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(
                                              CommonConstants.pulseDarkColor),
                                          width: 0.5),
                                    ),
                                    hintText: '0',
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 15.0.sp),
                                    contentPadding: EdgeInsets.zero),
                                cursorColor:
                                    Color(CommonConstants.pulseDarkColor),
                                keyboardType: TextInputType.number,
                                cursorWidth: 0.5,
                                onSaved: (input) => setState(() {})),
                          ),*/
                          fhbBasicWidget.getErrorMsgForUnitEntered(
                              context,
                              CommonConstants.strPulse,
                              commonConstants.poPulseUNIT,
                              pulse, (errorValue) {
                            setState(() {
                              errorMsg = errorValue;
                            });
                          }, errorMsg, variable.strpulse, deviceName),
                        ],
                      ))
                ],
              ),
            ),
          ],
        ));
  }

  Widget getCardForWeighingScale(String deviceName) {
    return Container(
        //height: 70.0.h,
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.only(left: 15, right: 15, top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color(cardShadowColor),
              blurRadius: 16, // has the effect of softening the shadow
              spreadRadius: 0, // has the effect of extending the shadow
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Image.asset(
                    Devices_WS,
                    height: 30.0.h,
                    width: 30.0.h,
                    color: Color(CommonConstants.weightDarkColor),
                  ),
                  Text(
                    CommonConstants.STR_WEIGHING_SCALE,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0.sp,
                        color: Color(CommonConstants.weightDarkColor)),
                    softWrap: true,
                  ),
                ],
              ),
              flex: 1,
            ),
            SizedBox(
              width: 5.0.w,
            ),
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Kg',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0.sp,
                            color: Color(CommonConstants.weightlightColor)),
                        softWrap: true,
                      ),
                      fhbBasicWidget.getErrorMsgForUnitEntered(
                          context,
                          CommonConstants.strWeight,
                          commonConstants.weightUNIT,
                          deviceController, (errorValue) {
                        setState(() {
                          errorMsg = errorValue;
                        });
                      }, errorMsg, commonConstants.weightUNIT, deviceName),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget getCardForGlucometer(String deviceName) {
    return Container(
        //height: 70.0.h,
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.only(left: 15, right: 15, top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color(cardShadowColor),
              blurRadius: 16, // has the effect of softening the shadow
              spreadRadius: 0, // has the effect of extending the shadow
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Image.asset(
                    Devices_GL,
                    height: 40.0.h,
                    width: 40.0.h,
                    color: Color(CommonConstants.GlucoDarkColor),
                  ),
                  SizedBox(
                    height: 10.0.h,
                  ),
                  Text(
                    deviceName,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0.sp,
                        color: Color(CommonConstants.GlucoDarkColor)),
                    softWrap: true,
                  ),
                ],
              ),
              flex: 1,
            ),
            SizedBox(
              width: 5.0.w,
            ),
            Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'mg/dl',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.0.sp,
                          color: Color(CommonConstants.GlucolightColor)),
                      softWrap: true,
                    ),
                    fhbBasicWidget.getErrorMsgForUnitEntered(
                        context,
                        CommonConstants.strValue,
                        commonConstants.glucometerUNIT,
                        deviceController, (errorValue) {
                      setState(() {
                        errorMsg = errorValue;
                      });
                    }, errorMsg, variable.strGlucUnit, deviceName)
                  ],
                )),
            SizedBox(
              width: 5.0.w,
            ),
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Fasting',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0.sp,
                                color: Colors.grey),
                            softWrap: true,
                          ),
                          Container(
                              width: 50.0.w,
                              constraints: BoxConstraints(maxWidth: 100.0.w),
                              child: MyCheckbox(
                                  value: isSelected[0],
                                  onChanged: (value) {
                                    setState(() {
                                      isSelected[0] = value;
                                      isSelected[1] = null;
                                    });
                                  })),
                        ],
                      )),
                  SizedBox(
                    width: 5.0.w,
                  ),
                  Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'PP',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0.sp,
                                color: Colors.grey),
                            softWrap: true,
                          ),
                          Container(
                              width: 50.0.w,
                              constraints: BoxConstraints(maxWidth: 100.0.w),
                              child: MyCheckbox(
                                  value: isSelected[1],
                                  onChanged: (value) {
                                    setState(() {
                                      isSelected[1] = value;
                                      isSelected[0] = null;
                                    });
                                  })),
                        ],
                      ))
                ],
              ),
            ),
          ],
        ));
  }

  String getFormattedDateTime(String datetime) {
    DateTime dateTimeStamp = DateTime.parse(datetime);
    String formattedDate = DateFormat('d MMM yyyy').format(dateTimeStamp);
    return formattedDate;
  }

  String getFormattedTime(String datetime) {
    DateTime dateTimeStamp = DateTime.parse(datetime).toLocal();
    String formattedDate = DateFormat('h:mm a').format(dateTimeStamp);
    return formattedDate;
  }

  String getFormattedTimeClone(String datetime) {
    DateTime dateTimeStamp = DateTime.parse(datetime);
    String formattedDate = DateFormat('h:mm a').format(dateTimeStamp);
    return formattedDate;
  }

  Widget getValues(BuildContext context, DevicesViewModel devicesViewModel) {
    var todayDate = getFormattedDateTime(DateTime.now().toString());
    switch (widget.device_name) {
      case strDataTypeBP:
        {
          return FutureBuilder<List<dynamic>>(
              future: devicesViewModel.fetchBPDetails(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return new Center(
                    child: new CircularProgressIndicator(
                      backgroundColor:
                          Color(new CommonUtil().getMyPrimaryColor()),
                    ),
                  );
                }
                List<dynamic> translis = snapshot.data;
                List<BPResult> bpResult = translis.first;
                List<DeviceIntervalData> deviceFullList = translis.last;
                return !bpResult.isEmpty
                    ? GroupedListView<BPResult, String>(
                        groupBy: (element) =>
                            getFormattedDateTime(element.startDateTime),
                        elements: bpResult,
                        sort: false,
                        groupSeparatorBuilder: (String value) => Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Row(
                            children: [
                              SizedBoxWidget(width: 15.0.w),
                              Text(
                                todayDate != value ? value : 'Today, ' + value,
                                style: TextStyle(
                                    fontSize: 14.0.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        indexedItemBuilder: (context, i, index) {
                          return buildRowForBp(
                              bpResult[index].sourceType,
                              getFormattedDateTime(
                                  bpResult[index].startDateTime),
                              '${bpResult[index].systolic}',
                              '${bpResult[index].diastolic}',
                              '',
                              'Systolic',
                              'Diastolic',
                              '',
                              (bpResult[index].sourceType == 'Google Fit' ||
                                      bpResult[index].sourceType ==
                                          'Apple Health')
                                  ? getFormattedTimeClone(
                                      bpResult[index].startDateTime)
                                  : getFormattedTime(
                                      bpResult[index].startDateTime),
                              bpResult[index].bpm != null
                                  ? bpResult[index].bpm.toString()
                                  : '',
                              bpResult[index].deviceId);
                        },
                      )
                    : Container(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 40, right: 40),
                            child: Text(
                              "No health record details available.",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontFamily: variable.font_roboto),
                            ),
                          ),
                        ),
                      );
              });
        }
        break;
      case strGlusoceLevel:
        {
          return FutureBuilder<List<dynamic>>(
              future: devicesViewModel.fetchGLDetails(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return new Center(
                    child: new CircularProgressIndicator(
                      backgroundColor:
                          Color(new CommonUtil().getMyPrimaryColor()),
                    ),
                  );
                }

                List<dynamic> translis = snapshot.data;
                List<GVResult> translist = translis.first;
                List<DeviceIntervalData> deviceFullList = translis.last;
                return !translist.isEmpty
                    ? GroupedListView<GVResult, String>(
                        groupBy: (element) =>
                            getFormattedDateTime(element.startDateTime),
                        elements: translist,
                        sort: false,
                        groupSeparatorBuilder: (String value) => Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Row(
                            children: [
                              SizedBoxWidget(width: 15.0.w),
                              Text(
                                todayDate != value ? value : 'Today, ' + value,
                                style: TextStyle(
                                    fontSize: 14.0.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        indexedItemBuilder: (context, i, index) {
                          return buildRowForGulcose(
                              translist[index].sourceType,
                              getFormattedDateTime(
                                  translist[index].startDateTime),
                              '${translist[index].bloodGlucoseLevel}',
                              translist[index].mealContext == null ||
                                      translist[index].mealContext == ''
                                  ? 'Random'
                                  : '${translist[index].mealContext}',
                              '',
                              'Blood Glucose',
                              'Meal Type',
                              '',
                              (translist[index].sourceType == 'Google Fit' ||
                                      translist[index].sourceType ==
                                          'Apple Health')
                                  ? getFormattedTimeClone(
                                      translist[index].startDateTime)
                                  : getFormattedTime(
                                      translist[index].startDateTime),
                              translist[index].bgUnit,
                              translist[index].deviceId);
                        },
                      )
                    : Container(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 40, right: 40),
                            child: Text(
                              "No health record details available.",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontFamily: variable.font_roboto),
                            ),
                          ),
                        ),
                      );
              });
        }
        break;
      case strOxgenSaturation:
        {
          return FutureBuilder<List<dynamic>>(
              future: devicesViewModel.fetchOXYDetails(''),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return new Center(
                    child: new CircularProgressIndicator(
                      backgroundColor:
                          Color(new CommonUtil().getMyPrimaryColor()),
                    ),
                  );
                }
                List<dynamic> translis = snapshot.data;
                List<OxyResult> translist = translis.first;
                List<DeviceIntervalData> deviceFullList = translis.last;
                return !translist.isEmpty
                    ? GroupedListView<OxyResult, String>(
                        groupBy: (element) =>
                            getFormattedDateTime(element.startDateTime),
                        elements: translist,
                        sort: false,
                        groupSeparatorBuilder: (String value) => Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Row(
                            children: [
                              SizedBoxWidget(width: 15.0.w),
                              Text(
                                todayDate != value ? value : 'Today, ' + value,
                                style: TextStyle(
                                    fontSize: 14.0.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        indexedItemBuilder: (context, i, index) {
                          return buildRowForOxygen(
                              translist[index].sourceType,
                              getFormattedDateTime(
                                  translist[index].startDateTime),
                              '${translist[index].oxygenSaturation}',
                              '',
                              '',
                              'SPO2',
                              '',
                              '',
                              (translist[index].sourceType == 'Google Fit' ||
                                      translist[index].sourceType ==
                                          'Apple Health')
                                  ? getFormattedTimeClone(
                                      translist[index].startDateTime)
                                  : getFormattedTime(
                                      translist[index].startDateTime),
                              '',
                              deviceFullList[index]
                                          .heartRateCollection[0]
                                          .bpm !=
                                      null
                                  ? deviceFullList[index]
                                      .heartRateCollection[0]
                                      .bpm
                                      .toString()
                                  : '',
                              translist[index].deviceId);
                        },
                      )
                    : Container(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 40, right: 40),
                            child: Text(
                              "No health record details available.",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontFamily: variable.font_roboto),
                            ),
                          ),
                        ),
                      );
              });
        }
        break;
      case strWeight:
        {
          return FutureBuilder<List<dynamic>>(
              future: devicesViewModel.fetchWVDetails(''),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return new Center(
                    child: new CircularProgressIndicator(
                      backgroundColor:
                          Color(new CommonUtil().getMyPrimaryColor()),
                    ),
                  );
                }

                List<dynamic> translis = snapshot.data;
                List<WVResult> translist = translis.first;
                List<DeviceIntervalData> deviceFullList = translis.last;
                return !translist.isEmpty
                    ? GroupedListView<WVResult, String>(
                        groupBy: (element) =>
                            getFormattedDateTime(element.startDateTime),
                        elements: translist,
                        sort: false,
                        groupSeparatorBuilder: (String value) => Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Row(
                            children: [
                              SizedBoxWidget(width: 15.0.w),
                              Text(
                                todayDate != value ? value : 'Today, ' + value,
                                style: TextStyle(
                                    fontSize: 14.0.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        indexedItemBuilder: (context, i, index) {
                          return buildRowForTempWeight(
                              translist[index].sourceType,
                              getFormattedDateTime(
                                  translist[index].startDateTime),
                              '${translist[index].weight}',
                              '',
                              '',
                              'Weight',
                              '',
                              '',
                              (translist[index].sourceType == 'Google Fit' ||
                                      translist[index].sourceType ==
                                          'Apple Health')
                                  ? getFormattedTimeClone(
                                      translist[index].startDateTime)
                                  : getFormattedTime(
                                      translist[index].startDateTime),
                              'Kg',
                              translist[index].deviceId);
                        },
                      )
                    : Container(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 40, right: 40),
                            child: Text(
                              "No health record details available.",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontFamily: variable.font_roboto),
                            ),
                          ),
                        ),
                      );
              });
        }
        break;
      case strTemperature:
        {
          return FutureBuilder<List<dynamic>>(
              future: devicesViewModel.fetchTMPDetails(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return new Center(
                    child: new CircularProgressIndicator(
                      backgroundColor:
                          Color(new CommonUtil().getMyPrimaryColor()),
                    ),
                  );
                }

                List<dynamic> translis = snapshot.data;
                List<TMPResult> translist = translis.first;
                List<DeviceIntervalData> deviceFullList = translis.last;
                return !translist.isEmpty
                    ? GroupedListView<TMPResult, String>(
                        groupBy: (element) =>
                            getFormattedDateTime(element.startDateTime),
                        elements: translist,
                        sort: false,
                        groupSeparatorBuilder: (String value) => Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Row(
                            children: [
                              SizedBoxWidget(width: 15.0.w),
                              Text(
                                todayDate != value ? value : 'Today, ' + value,
                                style: TextStyle(
                                    fontSize: 14.0.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        indexedItemBuilder: (context, i, index) {
                          return buildRowForTempWeight(
                              translist[index].sourceType,
                              getFormattedDateTime(
                                  translist[index].startDateTime),
                              '${translist[index].temperature}',
                              '',
                              '',
                              'Temperature',
                              '',
                              '',
                              (translist[index].sourceType == 'Google Fit' ||
                                      translist[index].sourceType ==
                                          'Apple Health')
                                  ? getFormattedTimeClone(
                                      translist[index].startDateTime)
                                  : getFormattedTime(
                                      translist[index].startDateTime),
                              'F',
                              translist[index].deviceId);
                        },
                      )
                    : Container(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 40, right: 40),
                            child: Text(
                              "No health record details available.",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontFamily: variable.font_roboto),
                            ),
                          ),
                        ),
                      );
              });
        }
        break;
      default:
        {
          //statements;
        }
        break;
    }
  }

  getStringValue() {
    switch (widget.device_name) {
      case strDataTypeBP:
        {
          return strBPTitle;
        }
        break;
      case strGlusoceLevel:
        {
          return strGLTitle;
        }
        break;
      case strOxgenSaturation:
        {
          return strOxyTitle;
        }
        break;
      case strWeight:
        {
          return strWgTitle;
        }
        break;
      case strTemperature:
        {
          return strTmpTitle;
        }
        break;
      default:
        {
          //statements;
        }
        break;
    }
  }

  Widget buildRowForBp(
      String type,
      String date,
      String value1,
      String value2,
      String value3,
      String valuename1,
      String valuename2,
      String valuename3,
      String time,
      String bpm,
      String deviceId) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Container(
        height: 60.0.h,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 10.0.w,
                ),
                Column(
                  children: [
                    Center(
                      child: Text(time,
                          style:
                              TextStyle(color: Colors.grey, fontSize: 11.0.sp)),
                    ),
                    SizedBox(
                      height: 2.0.h,
                    ),
                    type == null ? Icons.device_unknown : TypeIcon(type),
                  ],
                ),
                SizedBox(
                  width: 10.0.w,
                ),
                valuename1 != ''
                    ? Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 5.0.h),
                            Text(
                              valuename1,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 13.0.sp),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 5.0.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  value1 == '' ? '' : value1,
                                  style: TextStyle(
                                      color: Color(
                                          new CommonUtil().getMyPrimaryColor()),
                                      fontSize: 15.0.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBoxWidget(
                                  width: 2.0.w,
                                ),
                                Text(
                                  value1 == '' ? '' : 'mm Hg',
                                  style: TextStyle(
                                      color: Color(
                                          new CommonUtil().getMyPrimaryColor()),
                                      fontSize: 11.0.sp),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
                valuename2 != ''
                    ? Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 5.0.h),
                            Text(
                              valuename2 == '' ? '' : valuename2,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 13.0.sp),
                            ),
                            SizedBox(
                              height: 5.0.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  value2,
                                  style: TextStyle(
                                      color: Color(
                                          new CommonUtil().getMyPrimaryColor()),
                                      fontSize: 15.0.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBoxWidget(
                                  width: 2,
                                ),
                                Text(
                                  value1 == '' ? '' : 'mm Hg',
                                  style: TextStyle(
                                      color: Color(
                                          new CommonUtil().getMyPrimaryColor()),
                                      fontSize: 11.0.sp),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
                bpm != ''
                    ? Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 5.0.h),
                            Text(
                              'Pulse',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 13.0.sp),
                            ),
                            SizedBox(
                              height: 5.0.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  bpm != '' ? bpm : '',
                                  style: TextStyle(
                                      color: Color(
                                          new CommonUtil().getMyPrimaryColor()),
                                      fontSize: 15.0.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBoxWidget(
                                  width: 2,
                                ),
                                Text(
                                  bpm == '' ? '' : CommonConstants.strPulseUnit,
                                  style: TextStyle(
                                      color: Color(
                                          new CommonUtil().getMyPrimaryColor()),
                                      fontSize: 11.0.sp),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
                getDeleteIcon(deviceId, type),
                SizedBoxWidget(width: 10)
                /*Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                  ],
                ),
              )*/
                /*valuename3 != ''
                  ? Expanded(
                      flex: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 5.0.h),
                          Text(
                            valuename3 == '' ? '' : valuename3,
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(
                            height: 5.0.h,
                          ),
                          Text(
                            value3,
                            style: TextStyle(
                                color: Colors.lightBlueAccent,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),*/
                /*Expanded(
                  flex: 4,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          date,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )),*/
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getDeleteIcon(String deviceId, String type) {
    if (type == strsourceHK ||
        type == strsourceGoogle ||
        type == strsourceCARGIVER) {
      return SizedBox();
    } else {
      return GestureDetector(
        onTap: () {
          deleteDeviceRecord(deviceId);
        },
        child: Image.asset(
          'assets/icons/delete_icon.png',
          height: 16.0.h,
          width: 16.0.h,
        ),
      );
    }
  }

  Widget buildRowForGulcose(
      String type,
      String date,
      String value1,
      String value2,
      String value3,
      String valuename1,
      String valuename2,
      String valuename3,
      String time,
      String unit,
      String deviceId) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Container(
        height: 60.0.h,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 8.0,
                  ),
                  Column(
                    children: [
                      Center(
                        child: Text(time,
                            style: TextStyle(
                                color: Colors.grey, fontSize: 11.0.sp)),
                      ),
                      SizedBox(
                        height: 2.0.h,
                      ),
                      type == null ? Icons.device_unknown : TypeIcon(type),
                    ],
                  ),
                  SizedBox(
                    width: 110.0.w,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        getMealText(value2),
                        style:
                            TextStyle(color: Colors.black, fontSize: 13.0.sp),
                      ),
                      SizedBox(
                        height: 5.0.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            value1 == '' ? '' : value1,
                            style: TextStyle(
                                color:
                                    Color(new CommonUtil().getMyPrimaryColor()),
                                fontSize: 15.0.sp,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBoxWidget(
                            width: 2,
                          ),
                          Text(
                            value1 == '' ? '' : unit,
                            style: TextStyle(
                                color:
                                    Color(new CommonUtil().getMyPrimaryColor()),
                                fontSize: 11.0.sp),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        getDeleteIcon(deviceId, type),
                        SizedBoxWidget(width: 10)
                      ],
                    ),
                  ),
                  /*Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      valuename2 == '' ? '' : valuename2,
                      style: TextStyle(color: Colors.black, fontSize: 13.0.sp),
                    ),
                    SizedBox(
                      height: 5.0.h,
                    ),
                    Text(
                      value2,
                      style: TextStyle(
                          color: Color(new CommonUtil().getMyPrimaryColor()),
                          fontSize: 14.0.sp),
                    ),
                  ],
                ),
                SizedBox(
                  width: 18.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      valuename3 == '' ? '' : valuename3,
                      style: TextStyle(color: Colors.black, fontSize: 13.0.sp),
                    ),
                    SizedBox(
                      height: 5.0.h,
                    ),
                    Text(
                      value3,
                      style: TextStyle(
                          color: Color(new CommonUtil().getMyPrimaryColor()),
                          fontSize: 14.0.sp),
                    ),
                  ],
                ),*/
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  getMealText(String mealText) {
    if (mealText != null) {
      if (mealText == 'After Meal') {
        mealText = 'PP';
      } else if (mealText == 'Before Meal') {
        mealText = 'Fasting';
      } else if (mealText == 'Random') {
        mealText = 'Random';
      } else {
        mealText = '';
      }
    } else {
      mealText = '';
    }
    return mealText;
  }

  Widget buildRowForTempWeight(
      String type,
      String date,
      String value1,
      String value2,
      String value3,
      String valuename1,
      String valuename2,
      String valuename3,
      String time,
      String unit,
      String deviceId) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Container(
        height: 60.0.h,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 15,
                ),
                Column(
                  children: [
                    /*Container(
                    width: 42.0.w,
                    height: 14.0.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: <Color>[
                              Color(new CommonUtil().getMyPrimaryColor()),
                              Color(new CommonUtil().getMyGredientColor())
                            ],
                            stops: [
                              0.3,
                              1.0
                            ])),
                    child: Center(
                      child: Text(time,
                          style: TextStyle(color: Colors.white, fontSize: 11.0.sp)),
                    ),
                  ),*/
                    Center(
                      child: Text(time,
                          style:
                              TextStyle(color: Colors.grey, fontSize: 11.0.sp)),
                    ),
                    SizedBox(
                      height: 2.0.h,
                    ),
                    type == null ? Icons.device_unknown : TypeIcon(type),
                  ],
                ),
                valuename1 != ''
                    ? Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 5.0.h),
                            Column(
                              children: [
                                Text(
                                  valuename1,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 13.0.sp),
                                  textAlign: TextAlign.center,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      value1 == '' ? '' : value1,
                                      style: TextStyle(
                                          color: Color(new CommonUtil()
                                              .getMyPrimaryColor()),
                                          fontSize: 15.0.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBoxWidget(
                                      width: 2,
                                    ),
                                    Text(
                                      unit != '' ? unit : '',
                                      style: TextStyle(
                                          color: Color(new CommonUtil()
                                              .getMyPrimaryColor()),
                                          fontSize: 14.0.sp),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    : SizedBoxWidget(),
                getDeleteIcon(deviceId, type),
                SizedBoxWidget(width: 10)
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRowForOxygen(
      String type,
      String date,
      String value1,
      String value2,
      String value3,
      String valuename1,
      String valuename2,
      String valuename3,
      String time,
      String unit,
      String bpm,
      String deviceId) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Container(
        height: 60.0.h,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 15,
                ),
                Column(
                  children: [
                    /*Container(
                    width: 42.0.w,
                    height: 14.0.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: <Color>[
                              Color(new CommonUtil().getMyPrimaryColor()),
                              Color(new CommonUtil().getMyGredientColor())
                            ],
                            stops: [
                              0.3,
                              1.0
                            ])),
                    child: Center(
                      child: Text(time,
                          style: TextStyle(color: Colors.white, fontSize: 11.0.sp)),
                    ),
                  ),*/
                    Center(
                      child: Text(time,
                          style:
                              TextStyle(color: Colors.grey, fontSize: 11.0.sp)),
                    ),
                    SizedBox(
                      height: 2.0.h,
                    ),
                    type == null ? Icons.device_unknown : TypeIcon(type),
                  ],
                ),
                valuename1 != ''
                    ? Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 5.0.h),
                            Column(
                              children: [
                                Text(
                                  valuename1,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 13.0.sp),
                                  textAlign: TextAlign.center,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      value1 == '' ? '' : value1,
                                      style: TextStyle(
                                          color: Color(new CommonUtil()
                                              .getMyPrimaryColor()),
                                          fontSize: 15.0.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBoxWidget(
                                      width: 5,
                                    ),
                                    Text(
                                      unit != '' ? unit : '',
                                      style: TextStyle(
                                          color: Color(new CommonUtil()
                                              .getMyPrimaryColor()),
                                          fontSize: 14.0.sp),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    : SizedBoxWidget(),
                bpm != ''
                    ? Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 5.0.h),
                            Column(
                              children: [
                                Text(
                                  'PRBpm',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 13.0.sp),
                                  textAlign: TextAlign.center,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      bpm == '' ? '' : bpm,
                                      style: TextStyle(
                                          color: Color(new CommonUtil()
                                              .getMyPrimaryColor()),
                                          fontSize: 15.0.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    /* SizedBoxWidget(
                              width: 5,
                            ),
                            Text(
                              unit != '' ? unit : '',
                              style: TextStyle(
                                  color: Color(
                                      new CommonUtil().getMyPrimaryColor()),
                                  fontSize: 14.0.sp),
                            ),*/
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    : SizedBoxWidget(),
                getDeleteIcon(deviceId, type),
                SizedBoxWidget(width: 10)
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget TypeIcon(String type) {
    if (type == strsourceHK) {
      return Image.asset(
        'assets/devices/fit.png',
        height: 32.0.h,
        width: 32.0.h,
      );
    } else if (type == strsourceGoogle) {
      return Image.asset(
        'assets/settings/googlefit.png',
        height: 32.0.h,
        width: 32.0.h,
      );
    } else if (type == strsourceSheela) {
      return Image.asset(
        'assets/maya/maya_us_main.png',
        height: 32.0.h,
        width: 32.0.h,
      );
    } else if (type == strsourceCARGIVER) {
      return Image.asset(
        'assets/devices/caregiver_source.png',
        height: 32.0.h,
        width: 32.0.h,
        color: Color(new CommonUtil().getMyPrimaryColor()),
      );
    } else {
      return Image.asset(
        'assets/icons/myfhb_source.png',
        height: 32.0.h,
        width: 32.0.h,
        color: Color(new CommonUtil().getMyPrimaryColor()),
      );
    }
  }
}
