// ignore: file_names
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/IconWidget.dart';
import 'package:gmiwidgetspackage/widgets/SizeBoxWithChild.dart';
import 'package:gmiwidgetspackage/widgets/flutterToast.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/add_family_user_info/services/add_family_user_info_repository.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/common/SwitchProfile.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/device_integration/view/screens/Clipper.dart';
import 'package:myfhb/devices/device_dashboard_arguments.dart';
import 'package:myfhb/my_family/bloc/FamilyListBloc.dart';
import 'package:myfhb/my_family/screens/MyFamily.dart';
import 'package:myfhb/src/model/GetDeviceSelectionModel.dart';
import 'package:myfhb/src/model/common_response.dart';
import 'package:myfhb/src/model/user/MyProfileModel.dart';
import 'package:myfhb/src/model/user/user_accounts_arguments.dart';
import 'package:myfhb/src/resources/repository/health/HealthReportListForUserRepository.dart';
import 'package:myfhb/src/ui/HomeScreen.dart';
import 'package:myfhb/src/ui/user/UserAccounts.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:provider/provider.dart';

import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

import 'package:myfhb/device_integration/view/screens/Device_Data.dart';
import 'package:myfhb/device_integration/view/screens/Device_Value.dart';

import 'package:myfhb/device_integration/viewModel/Device_model.dart';

import 'package:myfhb/device_integration/model/LastMeasureSync.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/router_variable.dart' as router;
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';

class ShowDevicesNew extends StatefulWidget {
  @override
  _ShowDevicesNewState createState() => _ShowDevicesNewState();
}

class _ShowDevicesNewState extends State<ShowDevicesNew> {
  DevicesViewModel devicesViewModel;

  LastMeasureSyncValues deviceValues;
  DeviceData finalList;

  String dateForBp;
  String dateForGulcose;
  String dateForOs;
  String dateForWeight;
  String dateForTemp;

  String sourceForBp = '';
  String sourceForGluco = '';
  String sourceForThermo = '';
  String sourceForPulse = '';
  String sourceForWeigh = '';

  String timeForBp;
  String timeForGulcose;
  String timeForOs;
  String timeForWeight;
  String timeForTemp;

  DateTime dateTimeStampForBp;
  DateTime dateTimeStampForGulcose;
  DateTime dateTimeStampForOs;
  DateTime dateTimeStampForWeight;
  DateTime dateTimeStampForTemp;

  var devicevalue1ForBp;
  var devicevalue2ForBp;

  var devicevalue1ForGulcose;
  var deviceMealContext;
  var deviceMealType;
  var devicevalue1ForOs;
  var devicevalue1ForWeight;
  var devicevalue1ForTemp;

  bool bpMonitor = true;
  bool glucoMeter = true;
  bool pulseOximeter = true;
  bool thermoMeter = true;
  bool weighScale = true;

  var averageForSys;
  var averageForDia;
  var averageForPul;

  var averageForPulForBp;

  var pulseBp;
  var prbPMOxi;

  var averageForFasting;
  var averageForPP = '';

  var averageForTemp;

  var averageForSPO2;
  var averageForPRBpm;

  var averageForWeigh;
  bool isFamilyAvail = false;

  MyProfileModel myProfile;
  AddFamilyUserInfoRepository addFamilyUserInfoRepository =
      AddFamilyUserInfoRepository();

  HealthReportListForUserRepository healthReportListForUserRepository =
      HealthReportListForUserRepository();
  GetDeviceSelectionModel selectionResult;

  final GlobalKey<State> _key = new GlobalKey<State>();

  FlutterToast toast = new FlutterToast();
  FamilyListBloc _familyListBloc;

  AddFamilyUserInfoRepository _addFamilyUserInfoRepository =
      new AddFamilyUserInfoRepository();

  final double circleRadius = 38.0;
  final double circleBorderWidth = 0.0;

  @override
  void initState() {
    _familyListBloc = new FamilyListBloc();
    getFamilyLength();

    super.initState();
  }

  getFamilyLength() async {
    _familyListBloc.getFamilyMembersListNew().then((familyMembersList) {
      setState(() {
        if (familyMembersList != null && familyMembersList.result != null) {
          if (familyMembersList.result.sharedByUsers != null) {
            isFamilyAvail = true;
          } else {
            isFamilyAvail = false;
          }
        } else {
          isFamilyAvail = false;
        }
      });
    });
  }

  navigateToAddFamily() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return UserAccounts(arguments: UserAccountsArguments(selectedIndex: 1));
    })).then((value) {
      getFamilyLength();
      setState(() {});
    });
  }

  Future<MyProfileModel> getMyProfile() async {
    var userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    await addFamilyUserInfoRepository.getMyProfileInfoNew(userId).then((value) {
      myProfile = value;
    });
    return myProfile;
  }

  Future<GetDeviceSelectionModel> getDeviceSelectionValues() async {
    await healthReportListForUserRepository.getDeviceSelection().then((value) {
      selectionResult = value;
      if (selectionResult.isSuccess) {
        if (selectionResult.result != null) {
          bpMonitor =
              selectionResult.result[0].profileSetting.bpMonitor != null &&
                      selectionResult.result[0].profileSetting.bpMonitor != ''
                  ? selectionResult.result[0].profileSetting.bpMonitor
                  : true;
          glucoMeter =
              selectionResult.result[0].profileSetting.glucoMeter != null &&
                      selectionResult.result[0].profileSetting.glucoMeter != ''
                  ? selectionResult.result[0].profileSetting.glucoMeter
                  : true;
          pulseOximeter =
              selectionResult.result[0].profileSetting.pulseOximeter != null &&
                      selectionResult.result[0].profileSetting.pulseOximeter !=
                          ''
                  ? selectionResult.result[0].profileSetting.pulseOximeter
                  : true;
          thermoMeter =
              selectionResult.result[0].profileSetting.thermoMeter != null &&
                      selectionResult.result[0].profileSetting.thermoMeter != ''
                  ? selectionResult.result[0].profileSetting.thermoMeter
                  : true;
          weighScale =
              selectionResult.result[0].profileSetting.weighScale != null &&
                      selectionResult.result[0].profileSetting.weighScale != ''
                  ? selectionResult.result[0].profileSetting.weighScale
                  : true;
          if (selectionResult.result[0].profileSetting != null) {
            if (selectionResult.result[0].profileSetting.preColor != null &&
                selectionResult.result[0].profileSetting.preColor != null) {
              PreferenceUtil.saveTheme(Constants.keyPriColor,
                  selectionResult.result[0].profileSetting.preColor);
              PreferenceUtil.saveTheme(Constants.keyGreyColor,
                  selectionResult.result[0].profileSetting.greColor);
              //HomeScreen.of(context).refresh();
              //setState(() {});
            } else {
              PreferenceUtil.saveTheme(Constants.keyPriColor, 0xff5f0cf9);
              PreferenceUtil.saveTheme(Constants.keyGreyColor, 0xff9929ea);
            }
          } else {
            PreferenceUtil.saveTheme(Constants.keyPriColor, 0xff5f0cf9);
            PreferenceUtil.saveTheme(Constants.keyGreyColor, 0xff9929ea);
          }
        } else {
          bpMonitor = true;
          glucoMeter = true;
          pulseOximeter = true;
          thermoMeter = true;
          weighScale = true;
        }
      } else {
        bpMonitor = true;
        glucoMeter = true;
        pulseOximeter = true;
        thermoMeter = true;
        weighScale = true;
      }
    });
    return selectionResult;
  }

  Widget getDeviceVisibleValues(BuildContext context) {
    return FutureBuilder<GetDeviceSelectionModel>(
      future: getDeviceSelectionValues(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SafeArea(
            child: SizedBox(
              height: 1.sh / 1.3,
              child: Center(
                  child: CircularProgressIndicator(
                      backgroundColor:
                          Color(CommonUtil().getMyPrimaryColor()))),
            ),
          );
        } else if (snapshot.hasError) {
          return Text(
            'Error: ${snapshot.error}',
            style: TextStyle(
              fontSize: 14.0.sp,
            ),
          );
        } else {
          return getValuesFromSharedPrefernce(context);
        }
      },
    );
  }

  Widget getMealType() {
    if (deviceValues.bloodGlucose.entities.isNotEmpty) {
      if (deviceMealContext != '') {
        return Text(
          getMealText(deviceMealContext.toString()),
          style: TextStyle(
            color: Colors.black,
            fontSize: 8.0.sp,
            fontWeight: FontWeight.w400,
          ),
        );
      } else {
        return Text(
          '-',
          style: TextStyle(
            color: Colors.black,
            fontSize: 8.0.sp,
            fontWeight: FontWeight.w400,
          ),
        );
      }
    } else {
      return Text(
        '-',
        style: TextStyle(
          color: Colors.black,
          fontSize: 8.0.sp,
          fontWeight: FontWeight.w400,
        ),
      );
    }
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

  Widget getValuesFromSharedPrefernce(BuildContext context) {
    return new FutureBuilder<MyProfileModel>(
      future: getMyProfile(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SafeArea(
            child: SizedBox(
              height: 1.sh / 1.3,
              child: new Center(
                child: new CircularProgressIndicator(
                  backgroundColor: Color(
                    new CommonUtil().getMyPrimaryColor(),
                  ),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return new Text(
            'Error: ${snapshot.error}',
            style: TextStyle(
              fontSize: 14.0.sp,
            ),
          );
        } else {
          return getBody(context);
        }
      },
    );
  }

  Widget showProfileImageNew() {
    String userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    return FutureBuilder<CommonResponse>(
      future: _addFamilyUserInfoRepository.getUserProfilePic(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot?.data?.isSuccess && snapshot?.data?.result != null) {
            return Image.network(
              snapshot.data.result,
              fit: BoxFit.cover,
              width: 38,
              height: 38,
              headers: {
                HttpHeaders.authorizationHeader:
                    PreferenceUtil.getStringValue(Constants.KEY_AUTHTOKEN)
              },
            );
          } else {
            return Center(
              child: Text(
                myProfile != null
                    ? myProfile.result != null
                        ? myProfile.result.firstName != null
                            ? myProfile.result.firstName[0].toUpperCase()
                            : ''
                        : ''
                    : '',
                style: TextStyle(
                  color: Color(new CommonUtil().getMyPrimaryColor()),
                  fontSize: 16.0,
                  fontWeight: FontWeight.w200,
                ),
              ),
            );
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 1.0,
                backgroundColor: Color(new CommonUtil().getMyPrimaryColor()),
              ),
            ),
          );
        } else {
          return Center(
            child: Text(
              myProfile != null
                  ? myProfile.result != null
                      ? myProfile.result.firstName != null
                          ? myProfile.result.firstName[0].toUpperCase()
                          : ''
                      : ''
                  : '',
              style: TextStyle(
                color: Color(new CommonUtil().getMyPrimaryColor()),
                fontSize: 16.0,
                fontWeight: FontWeight.w200,
              ),
            ),
          );
        }
      },
    );
  }

  Widget build(BuildContext context) {
    return getDeviceVisibleValues(context);
  }

  Widget getBody(BuildContext context) {
    DevicesViewModel _devicesmodel = Provider.of<DevicesViewModel>(context);
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: getValues(context, _devicesmodel),
        ),
      ),
    );
  }

  Widget getValues(BuildContext context, DevicesViewModel devicesViewModel) {
    return FutureBuilder<LastMeasureSyncValues>(
        future: devicesViewModel.fetchDeviceDetails(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            deviceValues = snapshot.data;
            return projectWidget(context);
          } else {
            return SizedBox(
              height: 1.sh / 1.3,
              child: new Center(
                child: new CircularProgressIndicator(
                  backgroundColor: Color(
                    new CommonUtil().getMyPrimaryColor(),
                  ),
                ),
              ),
            );
          }
        });
  }

  Widget projectWidget(BuildContext context) {
    if (deviceValues.toString() == null) {
      return new Center(
        child: new CircularProgressIndicator(
          backgroundColor: Colors.grey,
        ),
      );
    }

    if (deviceValues.bloodPressure.entities.isNotEmpty) {
      dateTimeStampForBp = deviceValues.bloodPressure.entities[0].startDateTime;
      //deviceValues.bloodPressure.entities[0].lastsyncdatetime;
      dateForBp =
          "${DateFormat(parameters.strDateYMD, variable.strenUs).format(dateTimeStampForBp)}";
      timeForBp =
          "${DateFormat(parameters.strTimeHM, variable.strenUs).format(dateTimeStampForBp)}";

      devicevalue1ForBp =
          deviceValues.bloodPressure.entities[0].systolic.toString();
      devicevalue2ForBp =
          deviceValues.bloodPressure.entities[0].diastolic.toString();

      if (deviceValues.bloodPressure.entities[0].deviceHealthRecord != null) {
        sourceForBp = deviceValues
            .bloodPressure.entities[0].deviceHealthRecord.sourceType.code
            .toString();
      }

      try {
        if (deviceValues.bloodPressure.entities[0].deviceHealthRecord != null) {
          if (deviceValues.bloodPressure.entities[0].deviceHealthRecord
              .heartRateCollection.isNotEmpty) {
            if (deviceValues.bloodPressure.entities[0].deviceHealthRecord
                    .heartRateCollection[0].bpm !=
                null) {
              pulseBp = deviceValues.bloodPressure.entities[0]
                  .deviceHealthRecord.heartRateCollection[0].bpm
                  .toString();
            } else {
              pulseBp = '';
            }
            if (deviceValues.bloodPressure.entities[0].deviceHealthRecord
                    .heartRateCollection[0].averageAsOfNow !=
                null) {
              averageForPulForBp = deviceValues
                  .bloodPressure
                  .entities[0]
                  .deviceHealthRecord
                  .heartRateCollection[0]
                  .averageAsOfNow
                  .pulseAverage
                  .toString();
            } else {
              averageForPulForBp = '';
            }
          } else {
            pulseBp = '';
            averageForPulForBp = '';
          }
        } else {
          pulseBp = '';
          averageForPulForBp = '';
        }

        if (deviceValues.bloodPressure.entities[0].averageAsOfNow != null) {
          averageForSys = deviceValues.bloodPressure.entities[0].averageAsOfNow
                      .systolicAverage !=
                  null
              ? deviceValues
                  .bloodPressure.entities[0].averageAsOfNow.systolicAverage
                  .toString()
              : '';
          averageForDia = deviceValues.bloodPressure.entities[0].averageAsOfNow
                      .diastolicAverage !=
                  null
              ? deviceValues
                  .bloodPressure.entities[0].averageAsOfNow.diastolicAverage
                  .toString()
              : '';
        } else {
          averageForSys = '';
          averageForDia = '';
        }
      } catch (e) {
        averageForSys = '';
        averageForDia = '';
        pulseBp = '';
        averageForPulForBp = '';
      }
    } else {
      dateForBp = '';
      devicevalue1ForBp = '';
      devicevalue2ForBp = '';
      sourceForBp = '';
      averageForSys = '';
      averageForDia = '';
      pulseBp = '';
      averageForPulForBp = '';
    }
    if (deviceValues.bloodGlucose.entities.isNotEmpty) {
      dateTimeStampForGulcose =
          deviceValues.bloodGlucose.entities[0].startDateTime;
      dateForGulcose =
          "${DateFormat(parameters.strDateYMD, variable.strenUs).format(dateTimeStampForGulcose)}";
      timeForGulcose =
          "${DateFormat(parameters.strTimeHM, variable.strenUs).format(dateTimeStampForGulcose)}";
      devicevalue1ForGulcose =
          deviceValues.bloodGlucose.entities[0].bloodGlucoseLevel.toString();

      if (deviceValues.bloodGlucose.entities[0].mealContext != null) {
        deviceMealContext =
            deviceValues.bloodGlucose.entities[0].mealContext.name.toString();
      } else {
        deviceMealContext = 'Random';
      }

      deviceMealType = deviceValues.bloodGlucose.entities[0].mealType != null
          ? deviceValues.bloodGlucose.entities[0].mealType.name.toString()
          : '';

      if (deviceValues.bloodGlucose.entities[0].deviceHealthRecord != null) {
        sourceForGluco = deviceValues
            .bloodGlucose.entities[0].deviceHealthRecord.sourceType.code
            .toString();
      }

      try {
        averageForFasting = deviceValues
                    .bloodGlucose.entities[0].averageAsOfNow.fastingAverage !=
                null
            ? deviceValues
                .bloodGlucose.entities[0].averageAsOfNow.fastingAverage
                .toString()
            : '';
        averageForPP =
            deviceValues.bloodGlucose.entities[0].averageAsOfNow.ppAverage !=
                    null
                ? deviceValues.bloodGlucose.entities[0].averageAsOfNow.ppAverage
                    .toString()
                : '';
      } catch (e) {
        averageForFasting = '';
        averageForPP = '';
      }
    } else {
      dateForGulcose = '';
      devicevalue1ForGulcose = '';
      //deviceMealContext = '';
      deviceMealType = '';
      sourceForGluco = '';
      averageForFasting = '';
      averageForPP = '';
    }
    if (deviceValues.oxygenSaturation.entities.isNotEmpty) {
      dateTimeStampForOs =
          deviceValues.oxygenSaturation.entities[0].startDateTime;
      dateForOs =
          "${DateFormat(parameters.strDateYMD, variable.strenUs).format(dateTimeStampForOs)}";
      timeForOs =
          "${DateFormat(parameters.strTimeHM, variable.strenUs).format(dateTimeStampForOs)}";
      devicevalue1ForOs =
          deviceValues.oxygenSaturation.entities[0].oxygenSaturation.toString();
      if (deviceValues.oxygenSaturation.entities[0].deviceHealthRecord !=
          null) {
        sourceForPulse = deviceValues
            .oxygenSaturation.entities[0].deviceHealthRecord.sourceType.code
            .toString();
      }

      try {
        if (deviceValues.oxygenSaturation.entities[0].deviceHealthRecord !=
            null) {
          if (deviceValues.oxygenSaturation.entities[0].deviceHealthRecord
              .heartRateCollection.isNotEmpty) {
            try {
              if (deviceValues.oxygenSaturation.entities[0].deviceHealthRecord
                      .heartRateCollection[0].bpm !=
                  null) {
                prbPMOxi = deviceValues.oxygenSaturation.entities[0]
                    .deviceHealthRecord.heartRateCollection[0].bpm
                    .toString();
              } else {
                prbPMOxi = '';
              }

              if (deviceValues.oxygenSaturation.entities[0].deviceHealthRecord
                      .heartRateCollection[0].averageAsOfNow !=
                  null) {
                if (deviceValues.oxygenSaturation.entities[0].deviceHealthRecord
                        .heartRateCollection[0].averageAsOfNow.pulseAverage !=
                    null) {
                  averageForPRBpm = deviceValues
                      .oxygenSaturation
                      .entities[0]
                      .deviceHealthRecord
                      .heartRateCollection[0]
                      .averageAsOfNow
                      .pulseAverage
                      .toString();
                } else {
                  averageForPRBpm = '';
                }
              } else {
                averageForPRBpm = '';
              }
              averageForPul =
                  deviceValues.oxygenSaturation.entities[0].averageAsOfNow !=
                          null
                      ? deviceValues.oxygenSaturation.entities[0].averageAsOfNow
                          .oxygenLevelAverage
                          .toString()
                      : '';
            } catch (e) {
              averageForPul = '';
              averageForPRBpm = '';
              prbPMOxi = '';
            }
          } else {
            averageForPRBpm = '';
            prbPMOxi = '';
          }
        } else {
          averageForPul = '';
          averageForPRBpm = '';
          prbPMOxi = '';
        }
      } catch (e) {
        averageForPulForBp = '';
        averageForPul = '';
        averageForPRBpm = '';
        prbPMOxi = '';
      }

      /*try {
        if (deviceValues.heartRate.entities.isNotEmpty) {
          try {
            prbPMOxi = deviceValues.heartRate.entities[0].bpm.toString();

            averageForPul = deviceValues
                        .heartRate.entities[0].averageAsOfNow.pulseAverage !=
                    null
                ? deviceValues.heartRate.entities[0].averageAsOfNow.pulseAverage
                    .toString()
                : '';
            averageForPRBpm = deviceValues
                        .heartRate.entities[0].averageAsOfNow.pulseAverage !=
                    null
                ? deviceValues.heartRate.entities[0].averageAsOfNow.pulseAverage
                    .toString()
                : '';
          } catch (e) {
            averageForPul = '';
            averageForPRBpm = '';
            prbPMOxi = '';
          }
        } else {
          averageForPul = '';
          averageForPRBpm = '';
          prbPMOxi = '';
        }
      } catch (e) {
        averageForPulForBp = '';
        averageForPul = '';
        averageForPRBpm = '';
        prbPMOxi = '';
      }*/

      try {
        averageForSPO2 = deviceValues.oxygenSaturation.entities[0]
                    .averageAsOfNow.oxygenLevelAverage !=
                null
            ? deviceValues
                .oxygenSaturation.entities[0].averageAsOfNow.oxygenLevelAverage
                .toString()
            : '';
      } catch (e) {
        averageForSPO2 = '';
      }
    } else {
      dateForOs = '';
      devicevalue1ForOs = '';
      sourceForPulse = '';
      averageForSPO2 = '';
    }
    if (deviceValues.bodyTemperature.entities.isNotEmpty) {
      dateTimeStampForTemp =
          deviceValues.bodyTemperature.entities[0].startDateTime;
      dateForTemp =
          "${DateFormat(parameters.strDateYMD, variable.strenUs).format(dateTimeStampForTemp)}";
      timeForTemp =
          "${DateFormat(parameters.strTimeHM, variable.strenUs).format(dateTimeStampForTemp)}";
      devicevalue1ForTemp =
          deviceValues.bodyTemperature.entities[0].temperature.toString();

      if (deviceValues.bodyTemperature.entities[0].deviceHealthRecord != null) {
        sourceForThermo = deviceValues
            .bodyTemperature.entities[0].deviceHealthRecord.sourceType.code
            .toString();
      }

      try {
        averageForTemp = deviceValues.bodyTemperature.entities[0].averageAsOfNow
                    .temperatureAverage !=
                null
            ? deviceValues
                .bodyTemperature.entities[0].averageAsOfNow.temperatureAverage
                .toString()
            : '';
      } catch (e) {
        averageForTemp = '';
      }
    } else {
      dateForTemp = '';
      devicevalue1ForTemp = '';
      sourceForThermo = '';
      averageForTemp = '';
    }
    if (deviceValues.bodyWeight.entities.isNotEmpty) {
      dateTimeStampForWeight =
          deviceValues.bodyWeight.entities[0].startDateTime;
      dateForWeight =
          "${DateFormat(parameters.strDateYMD, variable.strenUs).format(dateTimeStampForWeight)}";
      timeForWeight =
          "${DateFormat(parameters.strTimeHM, variable.strenUs).format(dateTimeStampForWeight)}";
      devicevalue1ForWeight =
          deviceValues.bodyWeight.entities[0].weight.toString();

      if (deviceValues.bodyWeight.entities[0].deviceHealthRecord != null) {
        sourceForWeigh = deviceValues
            .bodyWeight.entities[0].deviceHealthRecord.sourceType.code
            .toString();
      }

      try {
        averageForWeigh = deviceValues
                    .bodyWeight.entities[0].averageAsOfNow.weightAverage !=
                null
            ? deviceValues.bodyWeight.entities[0].averageAsOfNow.weightAverage
                .toString()
            : '';
      } catch (e) {
        averageForWeigh = '';
      }
    } else {
      dateForWeight = '';
      devicevalue1ForWeight = '';
      sourceForWeigh = '';
      averageForWeigh = '';
    }

    return getDeviceData(
        context,
        dateForBp,
        dateForGulcose,
        dateForOs,
        dateForWeight,
        dateForTemp,
        timeForBp,
        timeForGulcose,
        timeForOs,
        timeForWeight,
        timeForTemp,
        devicevalue1ForBp,
        devicevalue1ForGulcose,
        deviceMealContext,
        deviceMealType,
        devicevalue1ForOs,
        devicevalue1ForWeight,
        devicevalue1ForTemp,
        devicevalue2ForBp);
  }

  void callBackToRefresh() {
    (context as Element).markNeedsBuild();
  }

  Widget _getUserName() {
    var resultWidget = null;
    resultWidget = AnimatedSwitcher(
      duration: Duration(milliseconds: 10),
      child: Row(
        children: <Widget>[
          /*CircleAvatar(
            radius: 20.0.sp,
            backgroundImage: AssetImage("assets/user/profile_pic_ph.png"),
            child: CircleAvatar(
              radius: 20.0.sp,
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(
                myProfile != null && myProfile.toString().isNotEmpty ??
                        myProfile.result != null ??
                        myProfile.result.profilePicThumbnailUrl != null &&
                            myProfile.result.profilePicThumbnailUrl.isNotEmpty
                    ? myProfile.result.profilePicThumbnailUrl
                    : '',
              ),
            ),
          ),*/
          Container(
            width: circleRadius,
            height: circleRadius,
            decoration:
                ShapeDecoration(shape: CircleBorder(), color: Colors.white),
            child: Padding(
              padding: EdgeInsets.all(circleBorderWidth),
              child: ClipOval(child: showProfileImageNew()),
            ),
          ),
          SizedBox(
            width: 15.0.w,
          ),
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    myProfile != null ??
                            myProfile.result.firstName != null &&
                                myProfile.result.firstName != ''
                        ? 'Hey ' +
                            toBeginningOfSentenceCase(
                                myProfile.result.firstName)
                        : 'Hey User',
                    style: TextStyle(
                      fontSize: 18.0.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
    return resultWidget;
  }

  Widget getDeviceData(
      BuildContext context,
      String dateForBp,
      String dateForGulcose,
      String dateForOs,
      String dateForWeight,
      String dateForTemp,
      String timeForBp,
      String timeForGulcose,
      String timeForOs,
      String timeForWeight,
      String timeForTemp,
      String value1ForBp,
      value1ForGulcose,
      mealContext,
      mealType,
      value1ForOs,
      value1ForWeight,
      value1ForTemp,
      String value2ForBp) {
    return Container(
      //height: MediaQuery.of(context).size.height,
      height: MediaQuery.of(context).size.width * 2.0,
      color: Colors.grey[200],
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.width * 0.18,
            decoration: BoxDecoration(
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
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  PreferredSize(
                    preferredSize: Size.fromHeight(1.sh * 0.15),
                    child: Container(
                      decoration: BoxDecoration(
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
                      child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 0.05.sw,
                                  ),
                                  Container(
                                    width: 0.66.sw,
                                    child: _getUserName(),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {});
                                    },
                                    child: Image.asset(
                                      'assets/icons/refresh_dash.png',
                                      height: 26.0,
                                      width: 26.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 0.03.sw,
                                  ),
                                  isFamilyAvail
                                      ? SwitchProfile().buildActions(
                                          context, _key, callBackToRefresh)
                                      : getMaterialPlusIcon(context),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBoxWidget(
            height: 10.0.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBoxWidget(
                width: 0.08.sw,
              ),
              Container(
                child: Text(
                  'Devices',
                  style: TextStyle(
                    fontSize: 16.0.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBoxWidget(
            height: 10.0.h,
          ),
          Visibility(
            visible: bpMonitor,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 12.0.w,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                              create: (context) => DevicesViewModel(),
                              child: EachDeviceValues(
                                sheelaRequestString:
                                    variable.requestSheelaForbp,
                                device_name: strDataTypeBP,
                                device_icon: Devices_BP_Tool,
                                deviceNameForAdding: Constants.STR_BP_MONITOR,
                              ),
                            )),
                  ).then((value){
                    setState(() {});
                  });
                },
                child: Container(
                  // height: 170.0.h,
                  decoration: BoxDecoration(
                    borderRadius: new BorderRadius.only(
                      topLeft: Radius.circular(
                        10.0.sp,
                      ),
                      topRight: Radius.circular(
                        10.0.sp,
                      ),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(
                          10.0.sp,
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBoxWidget(
                                width: 10.0.w,
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          dateForBp != null && dateForBp != ''
                                              ? dateForBp + ', '
                                              : '',
                                          style: TextStyle(
                                            fontSize: 8.0.sp,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          timeForBp != null && timeForBp != ''
                                              ? timeForBp
                                              : '',
                                          style: TextStyle(
                                            fontSize: 8.0.sp,
                                            color: Colors.black,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBoxWidget(
                                      height: 5.0.h,
                                    ),
                                    Image.asset(
                                      'assets/devices/bp_dashboard.png',
                                      height: 48.0.h,
                                      width: 40.0.w,
                                      color: hexToColor('#059192'),
                                    ),
                                    SizedBoxWidget(
                                      height: 5.0.h,
                                    ),
                                    Center(
                                      child: Text(
                                        'Blood Pressure',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 15.0.sp,
                                          fontWeight: FontWeight.w500,
                                          color: hexToColor('#059192'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBoxWidget(
                                width: 10.0.w,
                              ),
                              Center(
                                child: Container(
                                  child: VerticalDivider(
                                    color: hexToColor('#059192'),
                                    indent: 20.0.h,
                                    endIndent: 10.0.h,
                                    width: 2.0.w,
                                  ),
                                ),
                              ),
                              SizedBoxWidget(
                                width: 20.0.w,
                              ),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  children: [
                                    SizedBoxWidget(
                                      height: 10.0.h,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              'Sys',
                                              style: TextStyle(
                                                fontSize: 14.0.sp,
                                                fontWeight: FontWeight.w400,
                                                color: hexToColor('#39c5c2'),
                                              ),
                                            ),
                                            Text(
                                              value1ForBp != ''
                                                  ? value1ForBp.toString()
                                                  : '-',
                                              style: TextStyle(
                                                fontSize: 18.0.sp,
                                                fontWeight: FontWeight.w500,
                                                color: hexToColor('#059192'),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBoxWidget(
                                          width: 15.0.w,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              'Dia',
                                              style: TextStyle(
                                                fontSize: 14.0.sp,
                                                fontWeight: FontWeight.w400,
                                                color: hexToColor('#39c5c2'),
                                              ),
                                            ),
                                            Text(
                                              value2ForBp != ''
                                                  ? value2ForBp.toString()
                                                  : '-',
                                              style: TextStyle(
                                                fontSize: 18.0.sp,
                                                fontWeight: FontWeight.w500,
                                                color: hexToColor('#059192'),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBoxWidget(
                                          width: 15.0.w,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              'Pul',
                                              style: TextStyle(
                                                fontSize: 14.0.sp,
                                                fontWeight: FontWeight.w400,
                                                color: hexToColor('#39c5c2'),
                                              ),
                                            ),
                                            Text(
                                              pulseBp != '' && pulseBp != null
                                                  ? pulseBp.toString()
                                                  : '-',
                                              style: TextStyle(
                                                fontSize: 18.0.sp,
                                                fontWeight: FontWeight.w500,
                                                color: hexToColor('#059192'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBoxWidget(
                                      height: 10.0.h,
                                    ),
                                    Row(
                                      children: [
                                        SizedBoxWidget(width: 2.0.w),
                                        Text(
                                          '7 Days Avg',
                                          style: TextStyle(
                                            fontSize: 8.0.sp,
                                            fontWeight: FontWeight.w400,
                                            color: hexToColor('#afafaf'),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              'Sys',
                                              style: TextStyle(
                                                fontSize: 10.0.sp,
                                                fontWeight: FontWeight.w400,
                                                color: hexToColor('#afafaf'),
                                              ),
                                            ),
                                            Text(
                                              averageForSys != '' &&
                                                      averageForSys != null
                                                  ? averageForSys.toString()
                                                  : '-',
                                              style: TextStyle(
                                                fontSize: 14.0.sp,
                                                fontWeight: FontWeight.w500,
                                                color: hexToColor('#afafaf'),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBoxWidget(
                                          width: 15.0.w,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              'Dia',
                                              style: TextStyle(
                                                fontSize: 10.0.sp,
                                                fontWeight: FontWeight.w400,
                                                color: hexToColor('#afafaf'),
                                              ),
                                            ),
                                            Text(
                                              averageForDia != '' &&
                                                      averageForDia != null
                                                  ? averageForDia.toString()
                                                  : '-',
                                              style: TextStyle(
                                                fontSize: 14.0.sp,
                                                fontWeight: FontWeight.w500,
                                                color: hexToColor('#afafaf'),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBoxWidget(
                                          width: 15.0.w,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              'Pul',
                                              style: TextStyle(
                                                fontSize: 10.0.sp,
                                                fontWeight: FontWeight.w400,
                                                color: hexToColor('#afafaf'),
                                              ),
                                            ),
                                            Text(
                                              averageForPulForBp != '' &&
                                                      averageForPulForBp != null
                                                  ? averageForPulForBp
                                                      .toString()
                                                  : '-',
                                              style: TextStyle(
                                                fontSize: 14.0.sp,
                                                fontWeight: FontWeight.w500,
                                                color: hexToColor('#afafaf'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  sourceForBp != '' && sourceForBp != null
                                      ? TypeIcon(
                                          sourceForBp,
                                          hexToColor('#059192'),
                                        )
                                      : SizedBox(),
                                  /*MaterialButton(
                                    height: 25.0.h,
                                    minWidth: 45.0.w,
                                    onPressed: () {
                                      navigateToDeviceDashboardScreen(
                                          Constants.STR_BP_MONITOR);
                                    },
                                    color: hexToColor('#059192'),
                                    textColor: Colors.white,
                                    child: Icon(
                                      Icons.add,
                                      size: 14.0.sp,
                                    ),
                                    padding: EdgeInsets.all(
                                      2.0.sp,
                                    ),
                                    shape: CircleBorder(),
                                  ),*/
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        color: hexToColor('#059192'),
                        thickness: 2.0.h,
                        height: 2.0.h,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBoxWidget(
            height: 12.0.h,
          ),
          Column(
            children: [
              Container(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  runAlignment: WrapAlignment.start,
                  verticalDirection: VerticalDirection.down,
                  spacing: 8,
                  runSpacing: 10,
                  children: [
                    Visibility(
                      visible: glucoMeter,
                      child: Container(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider(
                                  create: (context) => DevicesViewModel(),
                                  child: EachDeviceValues(
                                    sheelaRequestString:
                                        variable.requestSheelaForglucose,
                                    device_name: strGlusoceLevel,
                                    device_icon: Devices_GL_Tool,
                                    deviceNameForAdding: Constants.STR_GLUCOMETER,
                                  ),
                                ),
                              ),
                            ).then((value) {
                              setState(() {});
                            });
                          },
                          child: Container(
                            width: 190.0.w,
                            // height: Responsive.width(46, context),
                            decoration: BoxDecoration(
                              borderRadius: new BorderRadius.only(
                                  topLeft: Radius.circular(
                                    10.0.sp,
                                  ),
                                  topRight: Radius.circular(
                                    10.0.sp,
                                  )),
                              color: Colors.white,
                            ),
                            child: IntrinsicHeight(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                        10.0.sp,
                                        10.0.sp,
                                        10.0.sp,
                                        0.0.sp,
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          dateForGulcose !=
                                                                      null &&
                                                                  dateForGulcose !=
                                                                      ''
                                                              ? dateForGulcose +
                                                                  ', '
                                                              : '',
                                                          style: TextStyle(
                                                            fontSize: 8.0.sp,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        Text(
                                                          timeForGulcose !=
                                                                      null &&
                                                                  timeForGulcose !=
                                                                      ''
                                                              ? timeForGulcose
                                                              : '',
                                                          style: TextStyle(
                                                            fontSize: 8.0.sp,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              sourceForGluco != null &&
                                                      sourceForGluco != ''
                                                  ? TypeIcon(sourceForGluco,
                                                      hexToColor('#b70a80'))
                                                  : SizedBox()
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Column(
                                                children: [
                                                  Image.asset(
                                                    'assets/devices/gulcose_dashboard.png',
                                                    height: 24.0.h,
                                                    width: 24.0.h,
                                                    color:
                                                        hexToColor('#b70a80'),
                                                  ),
                                                ],
                                              ),
                                              SizedBoxWidget(width: 5.0.w),
                                              Flexible(
                                                child: Text(
                                                  'Glucometer',
                                                  style: TextStyle(
                                                    fontSize: 15.0.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        hexToColor('#b70a80'),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBoxWidget(
                                            height: 1.0.h,
                                          ),
                                          Divider(
                                            color: hexToColor('#b70a80'),
                                            indent: 10.0.w,
                                            endIndent: 10.0.w,
                                            thickness: 1.0.h,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      child: Text(''),
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        '7 Days Avg',
                                                        style: TextStyle(
                                                          fontSize: 8.0.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: hexToColor(
                                                              '#afafaf'),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    child: getMealType(),
                                                  ),
                                                  Container(
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          value1ForGulcose !=
                                                                      '' &&
                                                                  value1ForGulcose !=
                                                                      null
                                                              ? value1ForGulcose
                                                                  .toString()
                                                              : '-',
                                                          style: TextStyle(
                                                            fontSize: 18.0.sp,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: hexToColor(
                                                                '#b70a80'),
                                                          ),
                                                        ),
                                                        Text(
                                                          value1ForGulcose !=
                                                                      '' &&
                                                                  value1ForGulcose !=
                                                                      null
                                                              ? 'mg/dL'
                                                              : '',
                                                          textAlign:
                                                              TextAlign.end,
                                                          style: TextStyle(
                                                            fontSize: 8.0.sp,
                                                            color: hexToColor(
                                                                '#b70a80'),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            'Fasting',
                                                            style: TextStyle(
                                                              fontSize: 10.0.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: hexToColor(
                                                                  '#afafaf'),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                averageForFasting !=
                                                                            '' &&
                                                                        averageForFasting !=
                                                                            null
                                                                    ? averageForFasting
                                                                        .toString()
                                                                    : '-',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.0.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: hexToColor(
                                                                      '#afafaf'),
                                                                ),
                                                              ),
                                                              Text(
                                                                averageForFasting !=
                                                                            '' &&
                                                                        averageForFasting !=
                                                                            null
                                                                    ? 'mg/dL'
                                                                    : '',
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      6.0.sp,
                                                                  color: hexToColor(
                                                                      '#afafaf'),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBoxWidget(
                                                      width: 8.0.w,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            'PP',
                                                            style: TextStyle(
                                                              fontSize: 10.0.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: hexToColor(
                                                                  '#afafaf'),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                averageForPP !=
                                                                            '' &&
                                                                        averageForPP !=
                                                                            null
                                                                    ? averageForPP
                                                                        .toString()
                                                                    : '-',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.0.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: hexToColor(
                                                                      '#afafaf'),
                                                                ),
                                                              ),
                                                              Text(
                                                                averageForPP !=
                                                                            '' &&
                                                                        averageForPP !=
                                                                            null
                                                                    ? 'mg/dL'
                                                                    : '',
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      6.0.sp,
                                                                  color: hexToColor(
                                                                      '#afafaf'),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              /*Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  MaterialButton(
                                                    height: 25.0.h,
                                                    minWidth: 45.0.w,
                                                    onPressed: () {
                                                      navigateToDeviceDashboardScreen(
                                                          Constants
                                                              .STR_GLUCOMETER);
                                                    },
                                                    color:
                                                        hexToColor('#b70a80'),
                                                    textColor: Colors.white,
                                                    child: Icon(
                                                      Icons.add,
                                                      size: 14.0.sp,
                                                    ),
                                                    padding: EdgeInsets.all(
                                                      2.0.sp,
                                                    ),
                                                    shape: CircleBorder(),
                                                  ),
                                                ],
                                              ),*/
                                            ],
                                          ),
                                          SizedBoxWidget(height: 10,),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    color: hexToColor('#b70a80'),
                                    thickness: 2.0.h,
                                    height: 2.0.h,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: thermoMeter,
                      child: Container(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider(
                                  create: (context) => DevicesViewModel(),
                                  child: EachDeviceValues(
                                    sheelaRequestString:
                                        variable.requestSheelaFortemperature,
                                    device_name: strTemperature,
                                    device_icon: Devices_THM_Tool,
                                    deviceNameForAdding: Constants.STR_THERMOMETER,
                                  ),
                                ),
                              ),
                            ).then((value) {
                              setState(() {});
                            });
                          },
                          child: Container(
                            width: 190.0.w,
                            // height: Responsive.width(46, context),
                            decoration: BoxDecoration(
                              borderRadius: new BorderRadius.only(
                                topLeft: Radius.circular(
                                  10.0.sp,
                                ),
                                topRight: Radius.circular(
                                  10.0.sp,
                                ),
                              ),
                              color: Colors.white,
                            ),
                            child: IntrinsicHeight(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                        10.0.sp,
                                        10.0.sp,
                                        10.0.sp,
                                        0.0.sp,
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          dateForTemp != null &&
                                                                  dateForTemp !=
                                                                      ''
                                                              ? dateForTemp +
                                                                  ', '
                                                              : '',
                                                          style: TextStyle(
                                                            fontSize: 8.0.sp,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        Text(
                                                          timeForTemp != null &&
                                                                  timeForTemp !=
                                                                      ''
                                                              ? timeForTemp
                                                              : '',
                                                          style: TextStyle(
                                                            fontSize: 8.0.sp,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              sourceForThermo != '' &&
                                                      sourceForThermo != null
                                                  ? TypeIcon(sourceForThermo,
                                                      hexToColor('#d95523'))
                                                  : SizedBox()
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Column(
                                                children: [
                                                  Image.asset(
                                                    'assets/devices/temp_dashboard.png',
                                                    height: 24.0.h,
                                                    width: 24.0.h,
                                                    color:
                                                        hexToColor('#d95523'),
                                                  ),
                                                ],
                                              ),
                                              SizedBoxWidget(
                                                width: 5.0.w,
                                              ),
                                              Flexible(
                                                child: Text(
                                                  'Thermometer',
                                                  style: TextStyle(
                                                    fontSize: 15.0.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        hexToColor('#d95523'),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBoxWidget(
                                            height: 1.0.h,
                                          ),
                                          Divider(
                                            color: hexToColor('#d95523'),
                                            indent: 10.0.w,
                                            endIndent: 10.0.w,
                                            thickness: 1.0.h,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      child: Text(''),
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        '7 Days Avg',
                                                        style: TextStyle(
                                                          fontSize: 8.0.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: hexToColor(
                                                              '#afafaf'),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    child: Text(
                                                      'Temp',
                                                      style: TextStyle(
                                                        fontSize: 9.0.sp,
                                                        color: hexToColor(
                                                            '#d95523'),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          value1ForTemp != '' &&
                                                                  value1ForTemp !=
                                                                      null
                                                              ? value1ForTemp
                                                                  .toString()
                                                              : '-',
                                                          style: TextStyle(
                                                            fontSize: 18.0.sp,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: hexToColor(
                                                                '#d95523'),
                                                          ),
                                                        ),
                                                        Text(
                                                          value1ForTemp != '' &&
                                                                  value1ForTemp !=
                                                                      null
                                                              ? 'F'
                                                              : '-',
                                                          style: TextStyle(
                                                            fontSize: 10.0.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: hexToColor(
                                                                '#d95523'),
                                                          ),
                                                          textAlign:
                                                              TextAlign.end,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            'Temp',
                                                            style: TextStyle(
                                                              fontSize: 10.0.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: hexToColor(
                                                                  '#afafaf'),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                averageForTemp !=
                                                                            '' &&
                                                                        averageForTemp !=
                                                                            null
                                                                    ? averageForTemp
                                                                        .toString()
                                                                    : '-',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.0.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: hexToColor(
                                                                      '#afafaf'),
                                                                ),
                                                              ),
                                                              Text(
                                                                averageForTemp !=
                                                                            '' &&
                                                                        averageForTemp !=
                                                                            null
                                                                    ? 'F'
                                                                    : '-',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      8.0.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: hexToColor(
                                                                      '#afafaf'),
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              /*Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  MaterialButton(
                                                    height: 25.0.h,
                                                    minWidth: 45.0.w,
                                                    onPressed: () {
                                                      navigateToDeviceDashboardScreen(
                                                          Constants
                                                              .STR_THERMOMETER);
                                                    },
                                                    color:
                                                        hexToColor('#d95523'),
                                                    textColor: Colors.white,
                                                    child: Icon(
                                                      Icons.add,
                                                      size: 14.0.sp,
                                                    ),
                                                    padding: EdgeInsets.all(
                                                      2.0.sp,
                                                    ),
                                                    shape: CircleBorder(),
                                                  ),
                                                ],
                                              ),*/
                                            ],
                                          ),
                                          SizedBoxWidget(height: 10,),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    color: hexToColor('#d95523'),
                                    thickness: 2.0.h,
                                    height: 2.0.h,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: pulseOximeter,
                      child: Container(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChangeNotifierProvider(
                                        create: (context) => DevicesViewModel(),
                                        child: EachDeviceValues(
                                          sheelaRequestString:
                                              variable.requestSheelaForpo,
                                          device_name: strOxgenSaturation,
                                          device_icon: Devices_OxY_Tool,
                                          deviceNameForAdding: Constants.STR_PULSE_OXIMETER,
                                        ),
                                      )),
                            ).then((value) {
                              setState(() {});
                            });
                          },
                          child: Container(
                            width: 190.0.w,
                            // height: Responsive.width(46, context),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                  10.0.sp,
                                ),
                                topRight: Radius.circular(
                                  10.0.sp,
                                ),
                              ),
                              color: Colors.white,
                            ),
                            child: IntrinsicHeight(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                        10.0.sp,
                                        10.0.sp,
                                        10.0.sp,
                                        0.0.sp,
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          dateForOs != null &&
                                                                  dateForOs !=
                                                                      ''
                                                              ? dateForOs + ', '
                                                              : '',
                                                          style: TextStyle(
                                                            fontSize: 8.0.sp,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        Text(
                                                          timeForOs != null &&
                                                                  timeForOs !=
                                                                      ''
                                                              ? timeForOs
                                                              : '',
                                                          style: TextStyle(
                                                            fontSize: 8.0.sp,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              sourceForPulse != '' &&
                                                      sourceForPulse != null
                                                  ? TypeIcon(
                                                      sourceForPulse,
                                                      hexToColor('#8600bd'),
                                                    )
                                                  : SizedBox()
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Image.asset(
                                                'assets/devices/os_dashboard.png',
                                                height: 24.0.h,
                                                width: 24.0.h,
                                                color: hexToColor('#8600bd'),
                                              ),
                                              SizedBoxWidget(
                                                width: 5.0.w,
                                              ),
                                              Flexible(
                                                child: Text(
                                                  'Pulse Oximeter',
                                                  style: TextStyle(
                                                    fontSize: 15.0.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        hexToColor('#8600bd'),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBoxWidget(
                                            height: 1.0.h,
                                          ),
                                          Divider(
                                            color: hexToColor('#8600bd'),
                                            indent: 10.0.w,
                                            endIndent: 10.0.w,
                                            thickness: 1.0.h,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      child: Text(''),
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        '7 Days Avg',
                                                        style: TextStyle(
                                                          fontSize: 8.0.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: hexToColor(
                                                              '#afafaf'),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    child: Text(
                                                      'SPO2',
                                                      style: TextStyle(
                                                        fontSize: 9.0.sp,
                                                        color: hexToColor(
                                                            '#8600bd'),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      value1ForOs != '' &&
                                                              value1ForOs !=
                                                                  null
                                                          ? value1ForOs
                                                              .toString()
                                                          : '-',
                                                      style: TextStyle(
                                                        fontSize: 18.0.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: hexToColor(
                                                            '#8600bd'),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBoxWidget(
                                                width: 5.0.w,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    child: Text(
                                                      'PRBpm',
                                                      style: TextStyle(
                                                        fontSize: 9.0.sp,
                                                        color: hexToColor(
                                                            '#8600bd'),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      prbPMOxi != '' &&
                                                              prbPMOxi != null
                                                          ? prbPMOxi.toString()
                                                          : '-',
                                                      style: TextStyle(
                                                        fontSize: 18.0.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: hexToColor(
                                                            '#8600bd'),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            'SPO2',
                                                            style: TextStyle(
                                                              fontSize: 10.0.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: hexToColor(
                                                                  '#afafaf'),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            averageForSPO2 !=
                                                                        '' &&
                                                                    averageForSPO2 !=
                                                                        null
                                                                ? averageForSPO2
                                                                    .toString()
                                                                : '-',
                                                            style: TextStyle(
                                                              fontSize: 12.0.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: hexToColor(
                                                                  '#afafaf'),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBoxWidget(
                                                      width: 15.0.w,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            'PRBpm',
                                                            style: TextStyle(
                                                              fontSize: 10.0.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: hexToColor(
                                                                  '#afafaf'),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            averageForPRBpm !=
                                                                        '' &&
                                                                    averageForPRBpm !=
                                                                        null
                                                                ? averageForPRBpm
                                                                    .toString()
                                                                : '-',
                                                            style: TextStyle(
                                                              fontSize: 12.0.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: hexToColor(
                                                                  '#afafaf'),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              /*Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  MaterialButton(
                                                    height: 25.0.h,
                                                    minWidth: 45.0.w,
                                                    onPressed: () {
                                                      navigateToDeviceDashboardScreen(
                                                          Constants
                                                              .STR_PULSE_OXIMETER);
                                                    },
                                                    color:
                                                        hexToColor('#8600bd'),
                                                    textColor: Colors.white,
                                                    child: Icon(
                                                      Icons.add,
                                                      size: 14.0.sp,
                                                    ),
                                                    padding: EdgeInsets.all(
                                                      2.0.sp,
                                                    ),
                                                    shape: CircleBorder(),
                                                  ),
                                                ],
                                              ),*/
                                            ],
                                          ),
                                          SizedBoxWidget(height: 10,),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    color: hexToColor('#8600bd'),
                                    thickness: 2.0.h,
                                    height: 2.0.h,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: weighScale,
                      child: Container(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChangeNotifierProvider(
                                        create: (context) => DevicesViewModel(),
                                        child: EachDeviceValues(
                                          sheelaRequestString:
                                              variable.requestSheelaForweight,
                                          device_name: strWeight,
                                          device_icon: Devices_WS_Tool,
                                          deviceNameForAdding: Constants.STR_WEIGHING_SCALE,
                                        ),
                                      )),
                            ).then((value) {
                              setState(() {});
                            });
                          },
                          child: Container(
                            width: 190.0.w,
                            // height: Responsive.width(46, context),
                            decoration: BoxDecoration(
                              borderRadius: new BorderRadius.only(
                                topLeft: Radius.circular(
                                  10.0.sp,
                                ),
                                topRight: Radius.circular(
                                  10.0.sp,
                                ),
                              ),
                              color: Colors.white,
                            ),
                            child: IntrinsicHeight(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                        10.0.sp,
                                        10.0.sp,
                                        10.0.sp,
                                        0.0.sp,
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          dateForWeight !=
                                                                      null &&
                                                                  dateForWeight !=
                                                                      ''
                                                              ? dateForWeight +
                                                                  ', '
                                                              : '',
                                                          style: TextStyle(
                                                            fontSize: 8.0.sp,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        Text(
                                                          timeForWeight !=
                                                                      null &&
                                                                  timeForWeight !=
                                                                      ''
                                                              ? timeForWeight
                                                              : '',
                                                          style: TextStyle(
                                                            fontSize: 8.0.sp,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              sourceForWeigh != '' &&
                                                      sourceForWeigh != null
                                                  ? TypeIcon(sourceForWeigh,
                                                      hexToColor('#1abadd'))
                                                  : SizedBox()
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Column(
                                                children: [
                                                  Image.asset(
                                                    'assets/devices/weight_dashboard.png',
                                                    height: 24.0.h,
                                                    width: 24.0.h,
                                                    color:
                                                        hexToColor('#1abadd'),
                                                  ),
                                                ],
                                              ),
                                              SizedBoxWidget(
                                                width: 5.0.w,
                                              ),
                                              Flexible(
                                                child: Text(
                                                  'Weighing Scale',
                                                  style: TextStyle(
                                                    fontSize: 15.0.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        hexToColor('#1abadd'),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBoxWidget(
                                            height: 1.0.h,
                                          ),
                                          Divider(
                                            color: hexToColor('#1abadd'),
                                            indent: 10.0.w,
                                            endIndent: 10.0.w,
                                            thickness: 1.0.h,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      child: Text(''),
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        '7 Days Avg',
                                                        style: TextStyle(
                                                          fontSize: 8.0.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: hexToColor(
                                                              '#afafaf'),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    child: Text(
                                                      'Weight',
                                                      style: TextStyle(
                                                        fontSize: 9.0.sp,
                                                        color: hexToColor(
                                                            '#1abadd'),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          value1ForWeight !=
                                                                      '' &&
                                                                  value1ForWeight !=
                                                                      null
                                                              ? value1ForWeight
                                                                  .toString()
                                                              : '-',
                                                          style: TextStyle(
                                                            fontSize: 18.0.sp,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: hexToColor(
                                                                '#1abadd'),
                                                          ),
                                                        ),
                                                        Text(
                                                          value1ForWeight !=
                                                                      '' &&
                                                                  value1ForWeight !=
                                                                      null
                                                              ? 'Kg'
                                                              : '',
                                                          style: TextStyle(
                                                            fontSize: 8.0.sp,
                                                            color: hexToColor(
                                                                '#1abadd'),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            'Weight',
                                                            style: TextStyle(
                                                              fontSize: 10.0.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: hexToColor(
                                                                  '#afafaf'),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                averageForWeigh !=
                                                                            '' &&
                                                                        averageForWeigh !=
                                                                            null
                                                                    ? averageForWeigh
                                                                        .toString()
                                                                    : '-',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.0.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: hexToColor(
                                                                      '#afafaf'),
                                                                ),
                                                              ),
                                                              Text(
                                                                averageForWeigh !=
                                                                            '' &&
                                                                        averageForWeigh !=
                                                                            null
                                                                    ? 'Kg'
                                                                    : '',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      8.0.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: hexToColor(
                                                                      '#afafaf'),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              /*Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  MaterialButton(
                                                    height: 25.0.h,
                                                    minWidth: 45.0.w,
                                                    onPressed: () {
                                                      navigateToDeviceDashboardScreen(
                                                          Constants
                                                              .STR_WEIGHING_SCALE);
                                                    },
                                                    color:
                                                        hexToColor('#1abadd'),
                                                    textColor: Colors.white,
                                                    child: Icon(
                                                      Icons.add,
                                                      size: 14.0.sp,
                                                    ),
                                                    padding: EdgeInsets.all(
                                                      2.0.sp,
                                                    ),
                                                    shape: CircleBorder(),
                                                  ),
                                                ],
                                              ),*/
                                            ],
                                          ),
                                          SizedBoxWidget(height: 10,),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    color: hexToColor('#1abadd'),
                                    thickness: 2.0.h,
                                    height: 2.0.h,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: MaterialButton(
                  height: 35.0.h,
                  minWidth: 55.0.w,
                  onPressed: () {
                    toast.getToast('More devices coming soon!', Colors.red);
                  },
                  color: Color(new CommonUtil().getMyPrimaryColor()),
                  textColor: Colors.white,
                  child: Icon(
                    Icons.add,
                    size: 14.0.sp,
                  ),
                  padding: EdgeInsets.all(
                    2.0.sp,
                  ),
                  shape: CircleBorder(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /*getDeviceCards(BuildContext context, List<DeviceData> finalList) {
    List<Widget> deviceCards = [];

    for (int i = 0; i < finalList.length; i++) {
      deviceCards.add(projectWidget(context, finalList[i]));
    }

    return deviceCards;
  }*/

  Color hexToColor(String hexString, {String alphaChannel = 'FF'}) {
    return Color(int.parse(hexString.replaceFirst('#', '0x$alphaChannel')));
  }

  void navigateToDeviceDashboardScreen(String deviceName) {
    Navigator.pushNamed(
      context,
      router.rt_deviceDashboard,
      arguments: DeviceDashboardArguments(deviceName: deviceName),
    ).then((value) {
      setState(() {});
    });
  }

  Widget getMaterialPlusIcon(BuildContext context) {
    return MaterialButton(
      height: 28.0,
      minWidth: 30.0,
      onPressed: () {
        navigateToAddFamily();
      },
      color: Colors.white,
      textColor: Color(new CommonUtil().getMyPrimaryColor()),
      child: Icon(
        Icons.add,
        size: 16,
      ),
      padding: EdgeInsets.all(2),
      shape: CircleBorder(),
    );
  }
}

class Responsive {
  static width(double p, BuildContext context) {
    return MediaQuery.of(context).size.width * (p / 100);
  }

  static height(double p, BuildContext context) {
    return MediaQuery.of(context).size.height * (p / 100);
  }
}

Widget TypeIcon(String type, Color color) {
  if (type == strsourceHK) {
    return Image.asset(
      'assets/devices/fit.png',
      height: 20.0,
      width: 20.0,
    );
  } else if (type == strsourceGoogle) {
    return Image.asset(
      'assets/settings/googlefit.png',
      height: 20.0,
      width: 20.0,
    );
  } else if (type == strsourceSheela) {
    return Image.asset(
      'assets/maya/maya_us_main.png',
      height: 20.0,
      width: 20.0,
    );
  } else {
    return Image.asset(
      'assets/icons/myfhb_source.png',
      height: 18.0,
      width: 18.0,
      color: color,
    );
  }
}
