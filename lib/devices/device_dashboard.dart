import 'dart:convert';
import 'package:get/get.dart';
import 'package:myfhb/src/ui/SheelaAI/Models/sheela_arguments.dart';
import '../constants/router_variable.dart';
import '../src/utils/screenutils/size_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import '../common/CommonConstants.dart';
import '../common/CommonUtil.dart';
import '../common/FHBBasicWidget.dart';
import '../common/PreferenceUtil.dart';
import '../common/customized_checkbox.dart';
import '../constants/fhb_constants.dart';
import 'device_dashboard_arguments.dart';
import '../src/blocs/Category/CategoryListBlock.dart';
import '../src/blocs/Media/MediaTypeBlock.dart';
import '../src/blocs/health/HealthReportListForUserBlock.dart';
import '../src/model/Category/catergory_result.dart';
import '../src/model/Media/media_data_list.dart';
import '../src/model/Media/media_result.dart';
import '../src/utils/FHBUtils.dart';
import '../widgets/GradientAppBar.dart';
import '../constants/variable_constant.dart' as variable;
import '../constants/fhb_constants.dart' as Constants;
import '../colors/fhb_colors.dart' as fhbColors;
import '../constants/fhb_parameters.dart' as parameters;
import '../constants/variable_constant.dart' as variable;

class Devicedashboard extends StatefulWidget {
  DeviceDashboardArguments arguments;
  Devicedashboard({this.arguments});
  @override
  _DevicedashboardScreenState createState() => _DevicedashboardScreenState();
}

class _DevicedashboardScreenState extends State<Devicedashboard> {
  GlobalKey<ScaffoldState> scaffold_state = GlobalKey<ScaffoldState>();
  TextEditingController deviceController = TextEditingController(text: '');
  TextEditingController pulse = TextEditingController(text: '');
  TextEditingController memoController = TextEditingController(text: '');
  TextEditingController diaStolicPressure = TextEditingController(text: '');

  String validationMsg;
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  CategoryResult categoryDataObj = CategoryResult();
  MediaResult mediaDataObj = MediaResult();
  String categoryName = Constants.STR_DEVICES;
  String categoryID = '14c3f2a1-70d3-49dd-a922-6bee255eed26';
  final HealthReportListForUserBlock _healthReportListForUserBlock =
      HealthReportListForUserBlock();

  List<String> imagePathMain = List();
  FlutterToast toast = FlutterToast();
  var commonConstants = CommonConstants();
  bool _value;
  List<bool> isSelected = List(2);

  String deviceName = Constants.STR_WEIGHING_SCALE;

  String errorMsg = '', errorMsgDia = '', errorMsgSys = '';
  FHBBasicWidget fhbBasicWidget = FHBBasicWidget();
  bool onOkClicked = false;

  final CategoryListBlock _categoryListBlock = CategoryListBlock();
  List<CategoryResult> catgoryDataList = [];
  final MediaTypeBlock _mediaTypeBlock = MediaTypeBlock();
  MediaDataList mediaTypesResponse = MediaDataList();

  @override
  void initState() {
    mInitialTime = DateTime.now();
    super.initState();
    deviceName = widget.arguments.deviceName;
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
      'pageName': 'Device Dashboard Screen',
      'screenSessionTime':
          '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          key: scaffold_state,
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            flexibleSpace: GradientAppBar(),
            leading: IconWidget(
              icon: Icons.arrow_back_ios,
              colors: Colors.white,
              size: 24.0.sp,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            titleSpacing: 0,
            title: Text(deviceName),
          ),
          body: Column(
            children: [
              getCardBasedOnDevices(deviceName),
              SizedBox(
                height: 20.0.h,
              ),
              Text(errorMsg),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8, top: 4, right: 8, bottom: 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(width: 50),
                      OutlineButton(
                        onPressed: onOkClicked
                            ? () {}
                            : () async {
                                onOkClicked = true;

                                await FHBUtils().check().then((intenet) {
                                  if (intenet != null && intenet) {
                                    createDeviceRecords(deviceName);
                                  } else {
                                    onOkClicked = false;
                                    FHBBasicWidget().showInSnackBar(
                                        Constants.STR_NO_CONNECTIVITY,
                                        scaffold_state);
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
                        textColor: Color(CommonUtil().getMyPrimaryColor()),
                        color: Colors.transparent,
                        borderSide: BorderSide(
                            color: Color(CommonUtil().getMyPrimaryColor())),
                        shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Text('OK'),
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
          ),
          floatingActionButton: IconButton(
            icon: Image.asset(variable.icon_mayaMain),
            iconSize: 60,
            onPressed: () {
              Get.toNamed(
                rt_Sheela,
                arguments: SheelaArgument(
                  sheelaInputs: getDeviceForString(),
                ),
              );

              /* Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return ChatScreen(
                      arguments: SheelaArgument(
                        sheelaInputs: getDeviceForString(),
                      ),
                    );
                  },
                ),
              ); */
            },
          ),
        ));
  }

  Future<bool> _onBackPressed() {
    onOkClicked = false;
    Navigator.of(context).pop(true);
    /*return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("NO"),
              ),
              SizedBox(height: 16.0.h),
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(true),
                child: Text("YES"),
              ),
            ],
          ),
        ) ??
        false;*/
  }

  String getDeviceForString() {
    switch (widget.arguments.deviceName) {
      case STR_GLUCOMETER:
        return variable.requestSheelaForglucose;
        break;
      case STR_THERMOMETER:
        return variable.requestSheelaFortemperature;
      case STR_BP_MONITOR:
        return variable.requestSheelaForbp;
      case STR_WEIGHING_SCALE:
        return variable.requestSheelaForweight;
      case STR_PULSE_OXIMETER:
        return variable.requestSheelaForpo;
      default:
        return variable.requestSheelaForglucose;
        break;
    }
  }

  Widget getCardForBPMonitor(String deviceName) {
    return Container(
        //height: 70.0.h,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(left: 15, right: 15, top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color(fhbColors.cardShadowColor),
              blurRadius: 16, // has the effect of extending the shadow
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
                                  color: Color(CommonConstants.bplightColor)),
                              softWrap: true,
                            ),
                            fhbBasicWidget.getErrorMsgForUnitEntered(
                                context,
                                CommonConstants.strSystolicPressure,
                                commonConstants.bpDPUNIT,
                                deviceController, (errorValue) {
                              setState(() {
                                errorMsgSys = errorValue;
                                errorMsg = errorMsgSys;
                              });
                            }, errorMsgSys, variable.strbpunit, deviceName,
                                range: "Sys")
                          ],
                        ),
                      )),
                      Expanded(
                          flex: 1,
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
                              fhbBasicWidget.getErrorMsgForUnitEntered(
                                  context,
                                  CommonConstants.strDiastolicPressure,
                                  commonConstants.bpDPUNIT,
                                  diaStolicPressure, (errorValue) {
                                setState(() {
                                  errorMsgDia = errorValue;
                                  errorMsg = errorMsgDia;
                                });
                              }, errorMsgDia, variable.strbpunit, deviceName,
                                  range: "Dia")
                            ],
                          )),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Pul',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.0.sp,
                                  color: Color(CommonConstants.bplightColor)),
                              softWrap: true,
                            ),
                            fhbBasicWidget.getErrorMsgForUnitEntered(
                                context,
                                CommonConstants.strPulse,
                                commonConstants.bpPulseUNIT,
                                pulse, (errorValue) {
                              setState(() {
                                errorMsg = errorValue;
                              });
                            }, errorMsg, variable.strpulse, deviceName),
                          ],
                        ),
                      )),
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

  void createDeviceRecords(String deviceName) async {
    if (doValidation(deviceName)) {
      CommonUtil.showLoadingDialog(context, _keyLoader, variable.Please_Wait);

      final Map<String, dynamic> postMainData = {};
      final postMediaData = Map<String, dynamic>();

      var userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);
      try {
        catgoryDataList = PreferenceUtil.getCategoryType();
        categoryDataObj = CommonUtil()
            .getCategoryObjForSelectedLabel(categoryID, catgoryDataList);
        postMediaData[parameters.strhealthRecordCategory] =
            categoryDataObj.toJson();
      } catch (e) {
        if (catgoryDataList == null) {
          await _categoryListBlock.getCategoryLists().then((value) {
            catgoryDataList = value.result;
            categoryDataObj = CommonUtil()
                .getCategoryObjForSelectedLabel(categoryID, catgoryDataList);
            postMediaData[parameters.strhealthRecordCategory] =
                categoryDataObj.toJson();
          });
        }
      }

      var metaDataFromSharedPrefernce = List<MediaResult>();
      if (mediaTypesResponse != null &&
          mediaTypesResponse.result != null &&
          mediaTypesResponse.result.isNotEmpty) {
        metaDataFromSharedPrefernce = mediaTypesResponse.result;
      } else {
        mediaTypesResponse = await _mediaTypeBlock.getMediTypesList();

        metaDataFromSharedPrefernce = mediaTypesResponse.result;
      }
      mediaDataObj = CommonUtil().getMediaTypeInfoForParticularDevice(
          deviceName, metaDataFromSharedPrefernce);

      postMediaData[parameters.strhealthRecordType] = mediaDataObj.toJson();

      postMediaData[parameters.strmemoText] = memoController.text;
      postMediaData[parameters.strhasVoiceNotes] = false;
      postMediaData[parameters.strisDraft] = false;

      postMediaData[parameters.strSourceName] = CommonConstants.strTridentValue;
      postMediaData[parameters.strmemoTextRaw] = memoController.text;
      final dateTime = DateTime.now();
      postMediaData[parameters.strStartDate] = dateTime.toUtc().toString();
      postMediaData[parameters.strEndDate] = dateTime.toUtc().toString();
      final commonConstants = CommonConstants();

      if (categoryName == variable.strDevices) {
        var postDeviceData = List<Map<String, dynamic>>();
        final Map<String, dynamic> postDeviceValues = {};
        final Map<String, dynamic> postDeviceValuesExtra = {};
        final postDeviceValuesExtraClone = Map<String, dynamic>();

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
          if (isSelected[0] == true) {
            postDeviceValuesExtra[parameters.strunit] = variable.strBefore;
          } else if (isSelected[1] == true) {
            postDeviceValuesExtra[parameters.strunit] = variable.strAfter;
          }

          postDeviceData.add(postDeviceValuesExtra);
        } else if (deviceName == Constants.STR_THERMOMETER) {
          postDeviceValues[parameters.strParameters] =
              CommonConstants.strTemperature;
          postDeviceValues[parameters.strvalue] = deviceController.text;
          postDeviceValues[parameters.strunit] =
              CommonConstants.strTemperatureValue;
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
        postMediaData[parameters.strfileName] =
            deviceName + '_${DateTime.now().toUtc().millisecondsSinceEpoch}';
        final dateTime = DateTime.now();

        postMediaData[parameters.strdateOfVisit] =
            FHBUtils().getFormattedDateOnly(dateTime.toString());

        postMainData[parameters.strmetaInfo] = postMediaData;

        final params = json.encode(postMediaData);

        await _healthReportListForUserBlock
            .createHealtRecords(params.toString(), imagePathMain, '')
            .then((value) {
          if (value != null && value.isSuccess) {
            _healthReportListForUserBlock.getHelthReportLists().then((value) {
              Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                  .pop();
              errorMsg = '';
              onOkClicked = false;

              PreferenceUtil.saveCompleteData(
                  Constants.KEY_COMPLETE_DATA, value);
              Navigator.of(context).pop(true);

              /*setState(() {
                deviceController.text = '';
                pulse.text = '';
                diaStolicPressure.text = '';
                isSelected[0] = null;
                isSelected[1] = null;
              });*/
            });
          } else {
            errorMsg = '';
            onOkClicked = false;
            Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
            toast.getToast(Constants.ERR_MSG_RECORD_CREATE, Colors.red);
          }
        });
      }
    } else {
      onOkClicked = false;

      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(variable.strAPP_NAME),
                content: Text(validationMsg),
              ));
    }
  }

  bool doValidation(String deviceName) {
    var validationConditon = false;
    if (categoryName == Constants.STR_DEVICES) {
      if (deviceName == Constants.STR_GLUCOMETER) {
        if (deviceController.text == '' || deviceController.text == null) {
          validationConditon = false;
          validationMsg = CommonConstants.strSugarLevelEmpty;
        } else if (isSelected[0] == null && isSelected[1] == null) {
          validationConditon = false;
          validationMsg = CommonConstants.strSugarFasting;
        } else {
          validationConditon = true;
        }
      } else if (deviceName == Constants.STR_BP_MONITOR) {
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
      } else if (deviceName == Constants.STR_THERMOMETER) {
        if (deviceController.text == '' || deviceController.text == null) {
          validationConditon = false;
          validationMsg = CommonConstants.strtemperatureEmpty;
        } else {
          validationConditon = true;
        }
      } else if (deviceName == Constants.STR_WEIGHING_SCALE) {
        if (deviceController.text == '' || deviceController.text == null) {
          validationConditon = false;
          validationMsg = CommonConstants.strWeightEmpty;
        } else {
          validationConditon = true;
        }
      } else if (deviceName == Constants.STR_PULSE_OXIMETER) {
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

  Widget getCardForThermometer(String deviceName) {
    return Container(
        //height: 70.0.h,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(left: 15, right: 15, top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color(fhbColors.cardShadowColor),
              blurRadius: 16, // has the effect of extending the shadow
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
            ),
            SizedBox(
              width: 5.0.w,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
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
                          deviceController, (errorValue) {
                        setState(() {
                          errorMsg = errorValue;
                        });
                      }, errorMsg, commonConstants.tempUNIT, deviceName,
                          range: "", device: "Temp")
                    ],
                  ),
                  Column(
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

  Widget getCardForWeighingScale(String deviceName) {
    return Container(
        //height: 70.0.h,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(left: 15, right: 15, top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color(fhbColors.cardShadowColor),
              blurRadius: 16, // has the effect of extending the shadow
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
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
            ),
            SizedBox(
              width: 5.0.w,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: <Widget>[
                      Text(
                        'kg',
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
                      }, errorMsg, commonConstants.weightUNIT, deviceName,
                          range: ''),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget getCardForPulseOxidometer(String deviceName) {
    return Container(
        //height: 70.0.h,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(left: 15, right: 15, top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color(fhbColors.cardShadowColor),
              blurRadius: 16, // has the effect of extending the shadow
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
            ),
            SizedBox(
              width: 5.0.w,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Column(
                    children: <Widget>[
                      Text(
                        'SpO2',
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
                      child: Column(
                    children: <Widget>[
                      Text(
                        'PR bpm',
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

  Widget getCardForGlucometer(String deviceName) {
    return Container(
        //height: 70.0.h,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(left: 15, right: 15, top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color(fhbColors.cardShadowColor),
              blurRadius: 16, // has the effect of extending the shadow
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
            ),
            SizedBox(
              width: 5.0.w,
            ),
            Expanded(
                child: Column(
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Column(
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
                      child: Column(
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
}
