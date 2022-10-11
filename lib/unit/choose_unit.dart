import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/common/common_circular_indicator.dart';
import 'package:myfhb/common/errors_widget.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/src/model/GetDeviceSelectionModel.dart';
import 'package:myfhb/src/resources/repository/health/HealthReportListForUserRepository.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/src/model/user/Tags.dart';

class ChooseUnit extends StatefulWidget {
  @override
  _ChooseUnitState createState() => _ChooseUnitState();
}

class _ChooseUnitState extends State<ChooseUnit> {
  bool isTouched = true;

  bool isPounds = false;
  bool isKg = false;

  bool isCele = false;
  bool isFaren = false;

  bool isInchFeet = false;
  bool isCenti = false;

  GetDeviceSelectionModel selectionResult;
  PreferredMeasurement preferredMeasurement;
  ProfileSetting profileSetting;

  HealthReportListForUserRepository healthReportListForUserRepository =
      HealthReportListForUserRepository();

  Height heightObj, weightObj, tempObj;
  FlutterToast toast = new FlutterToast();
  String userMappingId = '';

  bool isSettingChanged = false;
  List<Tags> tagsList = [];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (isTouched) {
          if (isSettingChanged) {
            _onWillPop();
          } else {
            Navigator.pop(context, false);
          }
        } else {
          Navigator.pop(context, false);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(fhbColors.bgColorContainer),
        appBar: AppBar(
          title: Text(Constants.UnitPreference),
          centerTitle: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 24.0.sp,
            ),
            onPressed: () {
              isTouched
                  ? isSettingChanged
                      ? _onWillPop()
                      : Navigator.of(context).pop()
                  : Navigator.of(context).pop();
            },
          ),
          flexibleSpace: GradientAppBar(),
        ),
        body: Column(
          children: [
            Expanded(
              child: getAppColorsAndDeviceValues(),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to update the changes'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => closeDialog(),
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () => applyUnitSelection(),
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  closeDialog() {
    Navigator.of(context).pop();
    Get.back();
  }

  applyUnitSelection() async {
    var preferredMeasurementNew = new PreferredMeasurement(
        height: heightObj, weight: weightObj, temperature: tempObj);
    profileSetting.preferredMeasurement = preferredMeasurement;
    var body =
        jsonEncode({'id': userMappingId, 'profileSetting': profileSetting});
    await healthReportListForUserRepository
        .updateUnitPreferences(
            userMappingId, profileSetting, preferredMeasurementNew, tagsList)
        .then((value) {
      if (value?.isSuccess ?? false) {
        toast.getToast(value?.message, Colors.green);

        PreferenceUtil.savePreferredMeasurement(
            Constants.KEY_PREFERREDMEASUREMENT, preferredMeasurementNew);
      } else {
        toast.getToast(value?.message, Colors.red);
      }
    });

    await PreferenceUtil.saveString(
        Constants.STR_KEY_HEIGHT, heightObj.unitCode);
    await PreferenceUtil.saveString(
        Constants.STR_KEY_WEIGHT, weightObj.unitCode);
    await PreferenceUtil.saveString(Constants.STR_KEY_TEMP, tempObj.unitCode);

    closeDialog();
  }

  Widget getBody() {
    var theme = Theme.of(context).copyWith(dividerColor: Colors.white);

    return Container(
      child: ListView(
        children: <Widget>[
          Theme(
            data: theme,
            child: ExpansionTile(
              backgroundColor: const Color(fhbColors.bgColorContainer),
              title: Text(variable.str_Weight,
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.black)),
              children: <Widget>[
                Container(
                    child: InkWell(
                      onTap: () {
                        isSettingChanged = true;

                        if (!isPounds) {
                          setState(() {
                            isPounds = true;
                            isKg = false;
                            weightObj = new Height(
                                unitCode: Constants.STR_VAL_WEIGHT_US,
                                unitName: 'pounds');
                          });
                        }
                      },
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(variable.str_Pounds),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: isPounds
                                    ? Icon(
                                        Icons.check,
                                        size: 30.0,
                                        color: Colors.blue,
                                      )
                                    : SizedBox(),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    color: Colors.white),
                Container(
                    child: InkWell(
                      child: ListTile(
                          title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(variable.str_Kilogram),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: isKg
                                  ? Icon(
                                      Icons.check,
                                      size: 30.0,
                                      color: Colors.blue,
                                    )
                                  : SizedBox(),
                            ),
                          )
                        ],
                      )),
                      onTap: () {
                        isSettingChanged = true;

                        if (!isKg) {
                          setState(() {
                            isPounds = false;
                            isKg = true;
                            weightObj = new Height(
                                unitCode: Constants.STR_VAL_WEIGHT_IND,
                                unitName: 'kilograms');
                          });
                        }
                      },
                    ),
                    color: Colors.white),
              ],
            ),
          ),
          Divider(),
          Theme(
            data: theme,
            child: ExpansionTile(
              backgroundColor: const Color(fhbColors.bgColorContainer),
              title: Text(variable.str_Height,
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.black)),
              children: <Widget>[
                Container(
                    child: InkWell(
                      onTap: () {
                        isSettingChanged = true;

                        if (!isInchFeet) {
                          setState(() {
                            isCenti = false;
                            isInchFeet = true;
                            heightObj = new Height(
                                unitCode: Constants.STR_VAL_HEIGHT_IND,
                                unitName: 'feet/Inches');
                          });
                        }
                      },
                      child: ListTile(
                          title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(variable.str_Feet),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: isInchFeet
                                  ? Icon(
                                      Icons.check,
                                      size: 30.0,
                                      color: Colors.blue,
                                    )
                                  : SizedBox(),
                            ),
                          )
                        ],
                      )),
                    ),
                    color: Colors.white),
                Container(
                    child: InkWell(
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(variable.str_centi),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: isCenti
                                    ? Icon(
                                        Icons.check,
                                        size: 30.0,
                                        color: Colors.blue,
                                      )
                                    : SizedBox(),
                              ),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        isSettingChanged = true;

                        if (!isCenti) {
                          setState(() {
                            isInchFeet = false;
                            isCenti = true;
                            heightObj = new Height(
                                unitCode: Constants.STR_VAL_HEIGHT_US,
                                unitName: 'centimeters');
                          });
                        }
                      },
                    ),
                    color: Colors.white),
              ],
            ),
          ),
          Divider(),
          Theme(
            data: theme,
            child: ExpansionTile(
              backgroundColor: const Color(fhbColors.bgColorContainer),
              title: Text(variable.str_Temp,
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.black)),
              children: <Widget>[
                Container(
                    child: InkWell(
                      onTap: () {
                        if (!isCele) {
                          isSettingChanged = true;

                          setState(() {
                            isFaren = false;
                            isCele = true;
                            tempObj = new Height(
                                unitCode: Constants.STR_VAL_TEMP_US,
                                unitName: 'celsius');
                          });
                        }
                      },
                      child: ListTile(
                          title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(variable.str_celesius),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: isCele
                                  ? Icon(
                                      Icons.check,
                                      size: 30.0,
                                      color: Colors.blue,
                                    )
                                  : SizedBox(),
                            ),
                          )
                        ],
                      )),
                    ),
                    color: Colors.white),
                Container(
                    child: InkWell(
                      child: ListTile(
                          title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(variable.str_far),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: isFaren
                                  ? Icon(
                                      Icons.check,
                                      size: 30.0,
                                      color: Colors.blue,
                                    )
                                  : SizedBox(),
                            ),
                          )
                        ],
                      )),
                      onTap: () {
                        isSettingChanged = true;

                        if (!isFaren) {
                          setState(() {
                            isCele = false;
                            isFaren = true;
                            tempObj = new Height(
                                unitCode: Constants.STR_VAL_TEMP_IND,
                                unitName: 'fahrenheit');
                          });
                        }
                      },
                    ),
                    color: Colors.white),
              ],
            ),
          ),
          Divider(),
        ],
      ),
      color: Colors.white,
    );
  }

  Widget getAppColorsAndDeviceValues() {
    return profileSetting == null
        ? FutureBuilder<GetDeviceSelectionModel>(
            future: getProfileSetings(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CommonCircularIndicator();
              } else if (snapshot.hasError) {
                return ErrorsWidget();
              } else {
                return getBody();
              }
            },
          )
        : getBody();
  }

  Future<GetDeviceSelectionModel> getProfileSetings() async {
    var userId = await PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);

    await healthReportListForUserRepository
        .getDeviceSelection(userIdFromBloc: userId)
        .then((value) async {
      if (value.isSuccess) {
        selectionResult = value;
        if (value.result != null && value.result.length > 0) {
          if (value.result[0] != null) {
            profileSetting = value.result[0].profileSetting;
            userMappingId = value.result[0].id;
            if (value.result[0].tags != null) {
              tagsList = value.result[0].tags != null &&
                      value.result[0].tags.length > 0
                  ? value.result[0].tags
                  : new List();
            }

            if (profileSetting != null) {
              if (profileSetting.preferredMeasurement != null) {
                preferredMeasurement = profileSetting.preferredMeasurement;
                try {
                  weightObj = preferredMeasurement?.weight;

                  await PreferenceUtil.saveString(Constants.STR_KEY_WEIGHT,
                      preferredMeasurement.weight?.unitCode);
                } catch (e) {
                  await PreferenceUtil.saveString(
                      Constants.STR_KEY_WEIGHT, Constants.STR_VAL_WEIGHT_US);
                }
                if (preferredMeasurement.weight != null) {
                  if (preferredMeasurement.weight?.unitCode.toLowerCase() ==
                      Constants.STR_VAL_WEIGHT_IND.toLowerCase()) {
                    isKg = true;
                    isPounds = false;
                  } else {
                    isKg = false;
                    isPounds = true;
                  }
                } else {
                  if (CommonUtil.REGION_CODE != "IN") {
                    isKg = false;
                    isPounds = true;
                    weightObj = new Height(
                        unitCode: Constants.STR_VAL_WEIGHT_US,
                        unitName: 'pounds');
                  } else {
                    isKg = true;
                    isPounds = false;
                    weightObj = new Height(
                        unitCode: Constants.STR_VAL_WEIGHT_IND,
                        unitName: 'kilograms');
                  }
                }

                try {
                  await PreferenceUtil.saveString(Constants.STR_KEY_HEIGHT,
                      preferredMeasurement.height?.unitCode);

                  heightObj = preferredMeasurement?.height;
                } catch (e) {
                  await PreferenceUtil.saveString(
                      Constants.STR_KEY_HEIGHT, Constants.STR_VAL_HEIGHT_US);
                }

                if (preferredMeasurement.height != null) {
                  if (preferredMeasurement.height?.unitCode ==
                      Constants.STR_VAL_HEIGHT_IND) {
                    isInchFeet = true;
                    isCenti = false;
                  } else {
                    isInchFeet = false;
                    isCenti = true;
                  }
                } else {
                  if (CommonUtil.REGION_CODE != "IN") {
                    isInchFeet = false;
                    isCenti = true;
                    heightObj = new Height(
                        unitCode: Constants.STR_VAL_HEIGHT_IND,
                        unitName: 'feet/Inches');
                  } else {
                    isInchFeet = true;
                    isCenti = false;
                    heightObj = new Height(
                        unitCode: Constants.STR_VAL_HEIGHT_US,
                        unitName: 'centimeters');
                  }
                }

                try {
                  await PreferenceUtil.saveString(Constants.STR_KEY_TEMP,
                      preferredMeasurement.temperature?.unitCode);
                  tempObj = preferredMeasurement?.temperature;
                } catch (e) {
                  await PreferenceUtil.saveString(
                      Constants.STR_KEY_TEMP, Constants.STR_VAL_TEMP_US);
                }

                if (preferredMeasurement.temperature != null) {
                  if (preferredMeasurement.temperature?.unitCode
                          .toLowerCase() ==
                      Constants.STR_VAL_TEMP_IND.toLowerCase()) {
                    isFaren = true;
                    isCele = false;
                  } else {
                    isFaren = false;
                    isCele = true;
                  }
                } else {
                  if (CommonUtil.REGION_CODE != "IN") {
                    isFaren = false;
                    isCele = true;
                    tempObj = new Height(
                        unitCode: Constants.STR_VAL_TEMP_US,
                        unitName: 'celsius');
                  } else {
                    isFaren = true;
                    isCele = false;
                    tempObj = new Height(
                        unitCode: Constants.STR_VAL_TEMP_IND,
                        unitName: 'fahrenheit');
                  }
                }

                return selectionResult;
              } else {
                commonMethodTosetDefaultValue();

                return selectionResult;
              }
            }
          }
        }
      }
    });
  }

  commonMethodTosetDefaultValue() async {
    if (CommonUtil.REGION_CODE != "IN") {
      await PreferenceUtil.saveString(
          Constants.STR_KEY_HEIGHT, Constants.STR_VAL_HEIGHT_US);
      await PreferenceUtil.saveString(
          Constants.STR_KEY_WEIGHT, Constants.STR_VAL_WEIGHT_US);
      await PreferenceUtil.saveString(
          Constants.STR_KEY_TEMP, Constants.STR_VAL_TEMP_US);

      heightObj = new Height(
          unitCode: Constants.STR_VAL_HEIGHT_US, unitName: 'centimeters');
      weightObj =
          new Height(unitCode: Constants.STR_VAL_WEIGHT_US, unitName: 'pounds');
      tempObj =
          new Height(unitCode: Constants.STR_VAL_TEMP_US, unitName: 'celsius');
      isKg = true;
      isPounds = false;

      isInchFeet = true;
      isCenti = false;

      isFaren = true;
      isCele = false;
    } else {
      await PreferenceUtil.saveString(
          Constants.STR_KEY_HEIGHT, Constants.STR_VAL_HEIGHT_IND);
      await PreferenceUtil.saveString(
          Constants.STR_KEY_WEIGHT, Constants.STR_VAL_WEIGHT_IND);
      await PreferenceUtil.saveString(
          Constants.STR_KEY_TEMP, Constants.STR_VAL_TEMP_IND);

      heightObj = new Height(
          unitCode: Constants.STR_VAL_HEIGHT_IND, unitName: 'feet/Inches');
      weightObj = new Height(
          unitCode: Constants.STR_VAL_WEIGHT_IND, unitName: 'kilograms');
      tempObj = new Height(
          unitCode: Constants.STR_VAL_TEMP_IND, unitName: 'fahrenheit');
      isKg = false;
      isPounds = true;

      isInchFeet = false;
      isCenti = true;

      isFaren = false;
      isCele = true;
    }
  }
}
