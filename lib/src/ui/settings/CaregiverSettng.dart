import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/device_integration/view/screens/Device_Card.dart';
import 'package:myfhb/device_integration/view/screens/Device_Data.dart';
import 'package:myfhb/device_integration/viewModel/Device_model.dart';
import 'package:myfhb/device_integration/viewModel/deviceDataHelper.dart';
import 'package:myfhb/landing/view_model/landing_view_model.dart';
import 'package:myfhb/src/model/CreateDeviceSelectionModel.dart';
import 'package:myfhb/src/model/GetDeviceSelectionModel.dart';
import 'package:myfhb/src/model/UpdatedDeviceModel.dart';
import 'package:myfhb/src/resources/repository/health/HealthReportListForUserRepository.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:provider/provider.dart';
import 'package:myfhb/common/common_circular_indicator.dart';

import 'AppleHealthSettings.dart';
import 'package:myfhb/src/model/user/Tags.dart';

class CareGiverSettings extends StatefulWidget {
  @override
  _CareGiverSettingsState createState() => _CareGiverSettingsState();

  final int priColor;
  final int greColor;

  CareGiverSettings({Key key, this.priColor, this.greColor}) : super(key: key);
}

class _CareGiverSettingsState extends State<CareGiverSettings> {
  bool _isdigitRecognition = true;
  bool _isdeviceRecognition = true;
  bool _isGFActive;
  DevicesViewModel _deviceModel;
  bool _isHKActive = false;
  bool _firstTym = true;
  bool _isBPActive = true;
  bool _isGLActive = true;
  bool _isOxyActive = true;
  bool _isTHActive = true;
  bool _isWSActive = true;
  bool _isHealthFirstTime = false;
  String preferred_language;
  String qa_subscription;

  int priColor;
  int greColor;

  List<DeviceData> selectedList;
  DeviceDataHelper _deviceDataHelper = DeviceDataHelper();
  HealthReportListForUserRepository healthReportListForUserRepository =
  HealthReportListForUserRepository();
  GetDeviceSelectionModel selectionResult;
  CreateDeviceSelectionModel createDeviceSelectionModel;
  UpdateDeviceModel updateDeviceModel;

  var userMappingId = '';
  bool isTouched = false;
  PreferredMeasurement preferredMeasurement;
  List<Tags> tagsList = new List<Tags>();

  bool allowAppointmentNotification=true;
  bool allowVitalNotification=true;
  bool allowSymptomsNotification=true;

  @override
  void initState() {
    mInitialTime = DateTime.now();
    selectedList = List();
    _deviceModel = new DevicesViewModel();
    super.initState();

    getDeviceSelectionValues();
    PreferenceUtil.init();

    priColor = widget.priColor;
    greColor = widget.greColor;

    _firstTym =
    PreferenceUtil.getStringValue(Constants.isFirstTym) == variable.strFalse
        ? false
        : true;
    _isHealthFirstTime =
    PreferenceUtil.getStringValue(Constants.isHealthFirstTime) ==
        variable.strFalse
        ? false
        : true;

    _isGFActive =
    PreferenceUtil.getStringValue(Constants.activateGF) == variable.strFalse
        ? false
        : true;

    if (_firstTym) {
      _firstTym = false;
      _isGFActive = false;
      PreferenceUtil.saveString(Constants.activateGF, _firstTym.toString());
      PreferenceUtil.saveString(Constants.isFirstTym, _isGFActive.toString());
    }
    if (_isHealthFirstTime) {
      _isHKActive = false;
      //PreferenceUtil.saveString(Constants.activateHK, _isHKActive.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
    fbaLog(eveName: 'qurbook_screen_event', eveParams: {
      'eventTime': '${DateTime.now()}',
      'pageName': 'Settings Screen',
      'screenSessionTime':
      '${DateTime.now().difference(mInitialTime).inSeconds} secs'
    });
  }

  Future<GetDeviceSelectionModel> getDeviceSelectionValues() async {
    var userId = PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);

    await healthReportListForUserRepository.getDeviceSelection(userIdFromBloc: userId).then((value) {
      selectionResult = value;
      if (selectionResult.isSuccess) {
        if (selectionResult.result != null) {
          setValues(selectionResult);
          userMappingId = selectionResult.result[0].id;
        } else {
          userMappingId = '';
          _isdeviceRecognition = true;
          _isHKActive = false;
          _firstTym = true;
          _isBPActive = true;
          _isGLActive = true;
          _isOxyActive = true;
          _isTHActive = true;
          _isWSActive = true;
          _isHealthFirstTime = false;
          allowAppointmentNotification=true;
          allowSymptomsNotification=true;
          allowVitalNotification=true;
        }
      } else {
        userMappingId = '';
        _isdigitRecognition = true;
        _isdeviceRecognition = true;
        _isHKActive = false;
        _firstTym = true;
        _isBPActive = true;
        _isGLActive = true;
        _isOxyActive = true;
        _isTHActive = true;
        _isWSActive = true;
        _isHealthFirstTime = false;
        allowAppointmentNotification=true;
        allowSymptomsNotification=true;
        allowVitalNotification=true;
      }
    });
    return selectionResult;
  }

  Future<CreateDeviceSelectionModel> createDeviceSelection() async {
    var userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    await healthReportListForUserRepository
        .createDeviceSelection(
        _isdigitRecognition,
        _isdeviceRecognition,
        _isGFActive,
        _isHKActive,
        _isBPActive,
        _isGLActive,
        _isOxyActive,
        _isTHActive,
        _isWSActive,
        userId,
        preferred_language,
        qa_subscription,
        priColor,
        greColor,
        tagsList,allowAppointmentNotification,allowVitalNotification,allowSymptomsNotification)
        .then((value) {
      Provider.of<LandingViewModel>(context, listen: false)
          .getQurPlanDashBoard();
      createDeviceSelectionModel = value;
      if (createDeviceSelectionModel.isSuccess) {
        closeDialog();
      } else {
        if (createDeviceSelectionModel.message ==
            STR_USER_PROFILE_SETTING_ALREADY) {
          updateDeviceSelectionModel();
        }
      }
    });
    return createDeviceSelectionModel;
  }

  Future<UpdateDeviceModel> updateDeviceSelectionModel() async {
    await healthReportListForUserRepository
        .updateDeviceModel(
        userMappingId,
        _isdigitRecognition,
        _isdeviceRecognition,
        _isGFActive,
        _isHKActive,
        _isBPActive,
        _isGLActive,
        _isOxyActive,
        _isTHActive,
        _isWSActive,
        preferred_language,
        qa_subscription,
        priColor,
        greColor,preferredMeasurement,
        tagsList,allowAppointmentNotification,allowVitalNotification,allowSymptomsNotification)
        .then((value) {
      updateDeviceModel = value;
      if (updateDeviceModel.isSuccess) {
        closeDialog();
      }
    });
    return updateDeviceModel;
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
            onPressed: () => createDeviceSelection(),
            child: Text('Yes'),
          ),
        ],
      ),
    ) ??
        false;
  }

  closeDialog() {
    Navigator.of(context).pop();
    Navigator.of(context).pop(true);
  }

  setValues(GetDeviceSelectionModel getDeviceSelectionModel) {
    setState(() {
      _deviceDataHelper = DeviceDataHelper();
      _isdeviceRecognition = getDeviceSelectionModel
          .result[0].profileSetting.allowDevice !=
          null &&
          getDeviceSelectionModel.result[0].profileSetting.allowDevice != ''
          ? getDeviceSelectionModel.result[0].profileSetting.allowDevice
          : true;
      _isdigitRecognition =
      getDeviceSelectionModel.result[0].profileSetting.allowDigit != null &&
          getDeviceSelectionModel.result[0].profileSetting.allowDigit !=
              ''
          ? getDeviceSelectionModel.result[0].profileSetting.allowDigit
          : true;
      /*_isGFActive =
          getDeviceSelectionModel.result[0].profileSetting.googleFit != null &&
                  getDeviceSelectionModel.result[0].profileSetting.googleFit !=
                      ''
              ? getDeviceSelectionModel.result[0].profileSetting.googleFit
              : false;*/
      _isHKActive =
      getDeviceSelectionModel.result[0].profileSetting.healthFit != null &&
          getDeviceSelectionModel.result[0].profileSetting.healthFit !=
              ''
          ? getDeviceSelectionModel.result[0].profileSetting.healthFit
          : false;
      _isBPActive =
      getDeviceSelectionModel.result[0].profileSetting.bpMonitor != null &&
          getDeviceSelectionModel.result[0].profileSetting.bpMonitor !=
              ''
          ? getDeviceSelectionModel.result[0].profileSetting.bpMonitor
          : true;
      _isGLActive =
      getDeviceSelectionModel.result[0].profileSetting.glucoMeter != null &&
          getDeviceSelectionModel.result[0].profileSetting.glucoMeter !=
              ''
          ? getDeviceSelectionModel.result[0].profileSetting.glucoMeter
          : true;
      _isOxyActive = getDeviceSelectionModel
          .result[0].profileSetting.pulseOximeter !=
          null &&
          getDeviceSelectionModel.result[0].profileSetting.pulseOximeter !=
              ''
          ? getDeviceSelectionModel.result[0].profileSetting.pulseOximeter
          : true;
      _isWSActive =
      getDeviceSelectionModel.result[0].profileSetting.weighScale != null &&
          getDeviceSelectionModel.result[0].profileSetting.weighScale !=
              ''
          ? getDeviceSelectionModel.result[0].profileSetting.weighScale
          : true;
      _isTHActive = getDeviceSelectionModel
          .result[0].profileSetting.thermoMeter !=
          null &&
          getDeviceSelectionModel.result[0].profileSetting.thermoMeter != ''
          ? getDeviceSelectionModel.result[0].profileSetting.thermoMeter
          : true;

      preferred_language = getDeviceSelectionModel
          .result[0].profileSetting.preferred_language !=
          null &&
          getDeviceSelectionModel
              .result[0].profileSetting.preferred_language !=
              ''
          ? getDeviceSelectionModel.result[0].profileSetting.preferred_language
          : 'undef';

      qa_subscription =
      getDeviceSelectionModel.result[0].profileSetting.qa_subscription !=
          null &&
          getDeviceSelectionModel
              .result[0].profileSetting.qa_subscription !=
              ''
          ? getDeviceSelectionModel.result[0].profileSetting.qa_subscription
          : 'Y';

      preferredMeasurement = getDeviceSelectionModel
          .result[0].profileSetting.preferredMeasurement !=
          null &&
          getDeviceSelectionModel
              .result[0].profileSetting.preferredMeasurement !=
              ''
          ? getDeviceSelectionModel.result[0].profileSetting.preferredMeasurement
          : null;

      tagsList = getDeviceSelectionModel.result[0].tags != null &&
          getDeviceSelectionModel.result[0].tags.length > 0
          ? getDeviceSelectionModel.result[0].tags
          : new List();


      allowAppointmentNotification =
      getDeviceSelectionModel.result[0].profileSetting.caregiverCommunicationSetting != null &&
          getDeviceSelectionModel.result[0].profileSetting.caregiverCommunicationSetting !=
              ''
          ? getDeviceSelectionModel.result[0].profileSetting.caregiverCommunicationSetting?.appointments
          : true;


      allowVitalNotification =
      getDeviceSelectionModel.result[0].profileSetting.caregiverCommunicationSetting != null &&
          getDeviceSelectionModel.result[0].profileSetting.caregiverCommunicationSetting !=
              ''
          ? getDeviceSelectionModel.result[0].profileSetting.caregiverCommunicationSetting?.vitals
          : true;


      allowSymptomsNotification =
      getDeviceSelectionModel.result[0].profileSetting.caregiverCommunicationSetting != null &&
          getDeviceSelectionModel.result[0].profileSetting.caregiverCommunicationSetting !=
              ''
          ? getDeviceSelectionModel.result[0].profileSetting.caregiverCommunicationSetting?.symptoms
          : true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (isTouched) {
          _onWillPop();
        } else {
          Navigator.pop(context, false);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(fhbColors.bgColorContainer),
        appBar: AppBar(
          centerTitle: false,
          titleSpacing: 0.0,
          title:  Transform(
            // you can forcefully translate values left side using Transform
            transform:  Matrix4.translationValues(-20.0, 0.0, 0.0),
            child: Text(Constants.careGiver,style: TextStyle(fontSize: 20.sp),),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 24.0.sp,
            ),
            onPressed: () {
              isTouched ? _onWillPop() : Navigator.of(context).pop();
            },
          ),
          flexibleSpace: GradientAppBar(),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(10),
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[

                        ListTile(

                            title: Text(variable.strAllowVitals),

                            trailing: Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                value: allowVitalNotification,
                                activeColor:
                                Color(new CommonUtil().getMyPrimaryColor()),
                                onChanged: (bool newValue) {
                                  setState(() {
                                    isTouched = true;
                                    allowVitalNotification = newValue;

                                    /*PreferenceUtil.saveString(
                                        Constants.allowDeviceRecognition,
                                        _isdeviceRecognition.toString());*/
                                  });
                                },
                              ),
                            )),
                        Container(
                          height: 1,
                          color: Colors.grey[200],
                        ),
                        ListTile(

                            title: Text(variable.strAllowSymptoms),

                            trailing: Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                value: allowSymptomsNotification,
                                activeColor:
                                Color(new CommonUtil().getMyPrimaryColor()),
                                onChanged: (bool newValue) {
                                  setState(() {
                                    isTouched = true;
                                    allowSymptomsNotification = newValue;


                                  });
                                },
                              ),
                            )),
                        Container(
                          height: 1,
                          color: Colors.grey[200],
                        ),
                        ListTile(
                            title: Text(variable.strAllowAppointments),

                            trailing: Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                value: allowAppointmentNotification,
                                activeColor:
                                Color(new CommonUtil().getMyPrimaryColor()),
                                onChanged: (bool newValue) {
                                  setState(() {
                                    isTouched = true;
                                    allowAppointmentNotification = newValue;


                                  });
                                },
                              ),
                            )),
                        Container(
                          height: 1,
                          color: Colors.grey[200],
                        ),

                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _handleGoogleFit() async {
    bool ret = false;
    bool _isSignedIn = await _deviceDataHelper.isGoogleFitSignedIn();
    if (_isGFActive == _isSignedIn) {
      ret = _isGFActive;
    } else {
      if (_isGFActive) {
        _isGFActive = await _deviceDataHelper.activateGoogleFit();
      } else {
        _isGFActive = !await _deviceDataHelper.deactivateGoogleFit();
      }
    }
    PreferenceUtil.saveString(Constants.activateGF, _isGFActive.toString());
    return ret;
  }
}
