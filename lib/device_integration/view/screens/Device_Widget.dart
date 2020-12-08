import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/sized_box.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/add_family_user_info/services/add_family_user_info_repository.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/device_integration/view/screens/Clipper.dart';
import 'package:myfhb/src/model/GetDeviceSelectionModel.dart';
import 'package:myfhb/src/model/user/MyProfileModel.dart';
import 'package:myfhb/src/resources/repository/health/HealthReportListForUserRepository.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:provider/provider.dart';

import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

import 'package:myfhb/device_integration/view/screens/Device_Data.dart';
import 'package:myfhb/device_integration/view/screens/Device_Value.dart';

import 'package:myfhb/device_integration/viewModel/Device_model.dart';

import 'package:myfhb/device_integration/model/LastMeasureSync.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;

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

  MyProfileModel myProfile;
  AddFamilyUserInfoRepository addFamilyUserInfoRepository =
      AddFamilyUserInfoRepository();

  HealthReportListForUserRepository healthReportListForUserRepository =
      HealthReportListForUserRepository();
  GetDeviceSelectionModel selectionResult;

  @override
  void initState() {
    super.initState();
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
          bpMonitor = selectionResult.result[0].profileSetting.bpMonitor;
          glucoMeter = selectionResult.result[0].profileSetting.glucoMeter;
          pulseOximeter =
              selectionResult.result[0].profileSetting.pulseOximeter;
          thermoMeter = selectionResult.result[0].profileSetting.thermoMeter;
          weighScale = selectionResult.result[0].profileSetting.weighScale;
        }
      }
    });
    return selectionResult;
  }

  Widget getDeviceVisibleValues(BuildContext context) {
    return new FutureBuilder<GetDeviceSelectionModel>(
      future: getDeviceSelectionValues(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SafeArea(
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 1.3,
              child: new Center(
                  child: new CircularProgressIndicator(
                      backgroundColor:
                          Color(new CommonUtil().getMyPrimaryColor()))),
            ),
          );
        } else if (snapshot.hasError) {
          return new Text('Error: ${snapshot.error}');
        } else {
          return getValuesFromSharedPrefernce(context);
        }
      },
    );
  }

  Widget getValuesFromSharedPrefernce(BuildContext context) {
    return new FutureBuilder<MyProfileModel>(
      future: getMyProfile(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SafeArea(
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 1.3,
              child: new Center(
                  child: new CircularProgressIndicator(
                      backgroundColor:
                          Color(new CommonUtil().getMyPrimaryColor()))),
            ),
          );
        } else if (snapshot.hasError) {
          return new Text('Error: ${snapshot.error}');
        } else {
          return getBody(context);
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
              height: MediaQuery.of(context).size.height / 1.3,
              child: new Center(
                  child: new CircularProgressIndicator(
                      backgroundColor:
                          Color(new CommonUtil().getMyPrimaryColor()))),
            );
          }
        });
  }

  Widget projectWidget(BuildContext context) {
    if (deviceValues.toString() == null) {
      print('device Values is empty reload to get data');
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
    } else {
      dateForBp = 'Record not available';
      devicevalue1ForBp = '';
      devicevalue2ForBp = '';
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
      deviceMealContext =
          deviceValues.bloodGlucose.entities[0].mealContext.name.toString();
      deviceMealType = deviceValues.bloodGlucose.entities[0].mealType != null
          ? deviceValues.bloodGlucose.entities[0].mealType.name.toString()
          : '';
    } else {
      dateForGulcose = 'Record not available';
      devicevalue1ForGulcose = '';
      deviceMealContext = '';
      deviceMealType = '';
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
    } else {
      dateForOs = 'Record not available';
      devicevalue1ForOs = '';
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
    } else {
      dateForTemp = 'Record not available';
      devicevalue1ForTemp = '';
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
    } else {
      dateForWeight = 'Record not available';
      devicevalue1ForWeight = '';
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

    /*case parameters.strGlusoceLevel:
        {
          if (deviceValues.bloodGlucose.entities.isNotEmpty) {
            dateTimeStamp = deviceValues.bloodGlucose.entities[0].startDateTime;
            date =
                "${DateFormat(parameters.strDateYMD, variable.strenUs).format(dateTimeStamp)}";
            time =
                "${DateFormat(parameters.strTimeHM, variable.strenUs).format(dateTimeStamp)}";
            devicevalue1 = deviceValues
                .bloodGlucose.entities[0].bloodGlucoseLevel
                .toString();
          } else {
            date = 'Record not available';
            devicevalue1 = '';
          }
          return getDeviceData(
              context, date, time, devicevalue1, '', deviceData);
        }
      case parameters.strOxgenSaturation:
        {
          if (deviceValues.oxygenSaturation.entities.isNotEmpty) {
            dateTimeStamp =
                deviceValues.oxygenSaturation.entities[0].startDateTime;
            date =
                "${DateFormat(parameters.strDateYMD, variable.strenUs).format(dateTimeStamp)}";
            time =
                "${DateFormat(parameters.strTimeHM, variable.strenUs).format(dateTimeStamp)}";
            devicevalue1 = deviceValues
                .oxygenSaturation.entities[0].oxygenSaturation
                .toString();
          } else {
            date = 'Record not available';
            devicevalue1 = '';
          }
          return getDeviceData(
              context, date, time, devicevalue1, '', deviceData);
        }
      case parameters.strTemperature:
        {
          if (deviceValues.bodyTemperature.entities.isNotEmpty) {
            dateTimeStamp =
                deviceValues.bodyTemperature.entities[0].startDateTime;
            date =
                "${DateFormat(parameters.strDateYMD, variable.strenUs).format(dateTimeStamp)}";
            time =
                "${DateFormat(parameters.strTimeHM, variable.strenUs).format(dateTimeStamp)}";
            devicevalue1 =
                deviceValues.bodyTemperature.entities[0].temperature.toString();
          } else {
            date = 'Record not available';
            devicevalue1 = '';
          }
          return getDeviceData(
              context, date, time, devicevalue1, '', deviceData);
        }
      case parameters.strWeight:
        {
          if (deviceValues.bodyWeight.entities.isNotEmpty) {
            dateTimeStamp = deviceValues.bodyWeight.entities[0].startDateTime;
            date =
                "${DateFormat(parameters.strDateYMD, variable.strenUs).format(dateTimeStamp)}";
            time =
                "${DateFormat(parameters.strTimeHM, variable.strenUs).format(dateTimeStamp)}";
            devicevalue1 =
                deviceValues.bodyWeight.entities[0].weight.toString();
          } else {
            date = 'Record not available';
            devicevalue1 = '';
          }
          return getDeviceData(
              context, date, time, devicevalue1, '', deviceData);
        }*/
    //}
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        ClipPath(
          clipper: WaveClipperTwo(),
          child: Container(
            height: 200,
            color: hexToColor('#025FEA'),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SizedBoxWidget(
                      width: 25,
                    ),
                    CircleAvatar(
                      radius: 28,
                      backgroundImage:
                          AssetImage("assets/user/profile_pic_ph.png"),
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(myProfile != null &&
                                    myProfile.toString().isNotEmpty ??
                                myProfile.result != null ??
                                myProfile.result.profilePicThumbnailUrl !=
                                        null &&
                                    myProfile.result.profilePicThumbnailUrl
                                        .isNotEmpty
                            ? myProfile.result.profilePicThumbnailUrl
                            : ''),
                      ),
                    ),
                    SizedBoxWidget(
                      width: 15,
                    ),
                    Text(
                      myProfile != null ?? myProfile.result.firstName != null
                          ? 'Hey ' +
                              toBeginningOfSentenceCase(
                                  myProfile.result.firstName) +
                              ','
                          : ' Hey User',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBoxWidget(height: 20),
              ],
            ),
          ),
        ),
        SizedBoxWidget(
          height: 5,
        ),
        Visibility(
          visible: glucoMeter,
          child: Row(
            children: [
              SizedBoxWidget(
                width: Responsive.width(3, context),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider(
                                create: (context) => DevicesViewModel(),
                                child: EachDeviceValues(
                                  device_name: strGlusoceLevel,
                                  device_icon: Devices_GL_Tool,
                                ),
                              )),
                    );
                  },
                  child: Container(
                    height: Responsive.width(33, context),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: hexToColor('#91268E'),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          STR_LATEST_VALUE,
                                          style: TextStyle(
                                              fontSize: 8, color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          dateForGulcose != null
                                              ? dateForGulcose + ', '
                                              : '',
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          timeForGulcose != null
                                              ? timeForGulcose
                                              : '',
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Blood Glucose Level',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 10),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        value1ForGulcose != ''
                                            ? value1ForGulcose.toString()
                                            : '-',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: value1ForGulcose != ''
                                                ? 22
                                                : 10,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBoxWidget(
                                        width: 2,
                                      ),
                                      Text(
                                        value1ForGulcose != '' ? 'mmol/L' : '',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBoxWidget(
                                    height: value1ForGulcose != '' ? 20 : 40,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Meal Context',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 10),
                                  ),
                                  Text(
                                    deviceMealContext != ''
                                        ? deviceMealContext.toString()
                                        : '-',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  SizedBoxWidget(
                                    height: 2,
                                  ),
                                  Text(
                                    'Meal Type',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 10),
                                  ),
                                  Text(
                                    deviceMealType != ''
                                        ? deviceMealType.toString()
                                        : '-',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Image.asset(
                                    'assets/devices/gulcose_dashboard.png',
                                    height: 45.0,
                                    width: 45.0,
                                    color: Colors.white,
                                  ),
                                ],
                              )
                              /*SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  deviceData.value2 != ''
                                      ? Text(
                                          deviceData.value2,
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 11),
                                        )
                                      : SizedBox(
                                          width: 0,
                                        ),
                                  Text(
                                    value2.toString(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 22),
                                  )
                                ],
                              )*/
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBoxWidget(
                width: Responsive.width(3, context),
              )
            ],
          ),
        ),
        SizedBoxWidget(
          height: 6,
        ),
        Column(
          children: [
            Container(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                runAlignment: WrapAlignment.start,
                verticalDirection: VerticalDirection.down,
                spacing: 6,
                runSpacing: 6,
                /*crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,*/
                children: [
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
                                        device_name: strTemperature,
                                        device_icon: Devices_THM_Tool,
                                      ),
                                    )),
                          );
                        },
                        child: Container(
                          width: Responsive.width(46, context),
                          height: Responsive.width(31, context),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: hexToColor('#4529DE'),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                STR_LATEST_VALUE,
                                                style: TextStyle(
                                                    fontSize: 8,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                dateForTemp != null
                                                    ? dateForTemp + ', '
                                                    : '',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                timeForTemp != null
                                                    ? timeForTemp
                                                    : '',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Temperature',
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 10),
                                        ),
                                        Text(
                                          value1ForTemp != ''
                                              ? value1ForTemp.toString() + 'F'
                                              : '-',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  value1ForTemp != '' ? 22 : 10,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBoxWidget(
                                          height: value1ForTemp != '' ? 0 : 15,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Image.asset(
                                          'assets/devices/temp_dashboard.png',
                                          height: 40.0,
                                          width: 35.0,
                                        ),
                                        SizedBoxWidget(
                                          height: value1ForTemp != '' ? 0 : 10,
                                        ),
                                      ],
                                    )
                                    /* SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        deviceData.value2 != ''
                                            ? Text(
                                                deviceData.value2,
                                                style: TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 11),
                                              )
                                            : SizedBox(
                                                width: 0,
                                              ),
                                        Text(
                                          value2.toString(),
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 22),
                                        )
                                      ],
                                    )*/
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: bpMonitor,
                    child: Container(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider(
                                      create: (context) => DevicesViewModel(),
                                      child: EachDeviceValues(
                                        device_name: strDataTypeBP,
                                        device_icon: Devices_BP_Tool,
                                      ),
                                    )),
                          );
                        },
                        child: Container(
                          width: Responsive.width(46, context),
                          height: Responsive.width(31, context),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: hexToColor('#05ADC7'),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                STR_LATEST_VALUE,
                                                style: TextStyle(
                                                    fontSize: 8,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                dateForBp != null
                                                    ? dateForBp + ', '
                                                    : '',
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                timeForBp != null
                                                    ? timeForBp
                                                    : '',
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Systolic',
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 10),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              value1ForBp != ''
                                                  ? value1ForBp.toString()
                                                  : '-',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: value1ForBp != ''
                                                      ? 22
                                                      : 10,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              value1ForBp != '' ? 'mmHg' : '',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 6),
                                            ),
                                          ],
                                        ),
                                        SizedBoxWidget(
                                          height: value1ForBp != '' ? 0 : 10,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Diastolic',
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 10),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              value2ForBp != ''
                                                  ? value2ForBp.toString()
                                                  : '-',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: value2ForBp != ''
                                                      ? 22
                                                      : 10,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              value2ForBp != '' ? 'mmHg' : '',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 6),
                                            )
                                          ],
                                        ),
                                        SizedBoxWidget(
                                          height: value2ForBp != '' ? 0 : 10,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Image.asset(
                                          'assets/devices/bp_dashboard.png',
                                          height: 32.0,
                                          width: 32.0,
                                          color: Colors.white,
                                        ),
                                        SizedBoxWidget(
                                          height: value2ForBp != '' ? 0 : 10,
                                        ),
                                      ],
                                    ),
                                  ],
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
                                        device_name: strOxgenSaturation,
                                        device_icon: Devices_OxY_Tool,
                                      ),
                                    )),
                          );
                        },
                        child: Container(
                          width: Responsive.width(46, context),
                          height: Responsive.width(31, context),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: hexToColor('#F72B60'),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                STR_LATEST_VALUE,
                                                style: TextStyle(
                                                    fontSize: 8,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                dateForOs != null
                                                    ? dateForOs + ', '
                                                    : '',
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                timeForOs != null
                                                    ? timeForOs
                                                    : '',
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Pulse Oximeter',
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 10),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              value1ForOs != ''
                                                  ? value1ForOs.toString()
                                                  : '-',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: value1ForOs != ''
                                                      ? 22
                                                      : 10,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBoxWidget(
                                              width: 2,
                                            ),
                                            Text(
                                              value1ForWeight != ''
                                                  ? 'bpm'
                                                  : '',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10),
                                            ),
                                            SizedBoxWidget(
                                              height: value1ForWeight != ''
                                                  ? 0
                                                  : 10,
                                            ),
                                          ],
                                        ),
                                        SizedBoxWidget(
                                          height: value1ForOs != '' ? 0 : 10,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Image.asset(
                                          'assets/devices/os_dashboard.png',
                                          height: 32.0,
                                          width: 32.0,
                                          color: Colors.white,
                                        ),
                                        SizedBoxWidget(
                                          height: value1ForOs != '' ? 0 : 10,
                                        ),
                                      ],
                                    )
                                  ],
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
                                        device_name: strWeight,
                                        device_icon: Devices_WS_Tool,
                                      ),
                                    )),
                          );
                        },
                        child: Container(
                          width: Responsive.width(46, context),
                          height: Responsive.width(31, context),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: hexToColor('#FF5733'),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                STR_LATEST_VALUE,
                                                style: TextStyle(
                                                    fontSize: 8,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                dateForWeight != null
                                                    ? dateForWeight + ', '
                                                    : '',
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                timeForWeight != null
                                                    ? timeForWeight
                                                    : '',
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Weight',
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 10),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              value1ForWeight != ''
                                                  ? value1ForWeight.toString()
                                                  : '-',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      value1ForWeight != ''
                                                          ? 22
                                                          : 10,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBoxWidget(
                                              width: 2,
                                            ),
                                            Text(
                                              value1ForWeight != ''
                                                  ? 'kgs'
                                                  : '',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10),
                                            ),
                                            SizedBoxWidget(
                                              height: value1ForWeight != ''
                                                  ? 0
                                                  : 10,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Image.asset(
                                          'assets/devices/weight_dashboard.png',
                                          height: 32.0,
                                          width: 32.0,
                                          color: Colors.white,
                                        ),
                                        SizedBoxWidget(
                                          height:
                                              value1ForWeight != '' ? 0 : 10,
                                        ),
                                      ],
                                    )
                                    /*SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        deviceData.value2 != ''
                                            ? Text(
                                                deviceData.value2,
                                                style: TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 11),
                                              )
                                            : SizedBox(
                                                width: 0,
                                              ),
                                        Text(
                                          value2.toString(),
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 22),
                                        )
                                      ],
                                    )*/
                                  ],
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
          ],
        ),
      ],
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
}

class Responsive {
  static width(double p, BuildContext context) {
    return MediaQuery.of(context).size.width * (p / 100);
  }

  static height(double p, BuildContext context) {
    return MediaQuery.of(context).size.height * (p / 100);
  }
}
