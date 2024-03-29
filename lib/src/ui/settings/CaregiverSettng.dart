import 'package:flutter/material.dart';
import 'package:gmiwidgetspackage/widgets/FlatButton.dart';
import 'package:provider/provider.dart';

import '../../../colors/fhb_colors.dart' as fhbColors;
import '../../../common/CommonUtil.dart';
import '../../../common/PreferenceUtil.dart';
import '../../../constants/fhb_constants.dart' as Constants;
import '../../../constants/fhb_constants.dart';
import '../../../constants/variable_constant.dart' as variable;
import '../../../device_integration/view/screens/Device_Data.dart';
import '../../../device_integration/viewModel/Device_model.dart';
import '../../../device_integration/viewModel/deviceDataHelper.dart';
import '../../../landing/view_model/landing_view_model.dart';
import '../../../main.dart';
import '../../../widgets/GradientAppBar.dart';
import '../../model/CreateDeviceSelectionModel.dart';
import '../../model/GetDeviceSelectionModel.dart';
import '../../model/UpdatedDeviceModel.dart';
import '../../model/user/Tags.dart';
import '../../resources/repository/health/HealthReportListForUserRepository.dart';
import '../../utils/screenutils/size_extensions.dart';
import '../SheelaAI/Controller/SheelaAIController.dart';

class CareGiverSettings extends StatefulWidget {
  @override
  _CareGiverSettingsState createState() => _CareGiverSettingsState();

  final int? priColor;
  final int? greColor;

  CareGiverSettings({Key? key, this.priColor, this.greColor}) : super(key: key);
}

class _CareGiverSettingsState extends State<CareGiverSettings> {
  bool? _isdigitRecognition = true;
  bool? _isdeviceRecognition = true;
  bool? _sheelaLiveReminders = true;
  bool? _isGFActive;
  DevicesViewModel? _deviceModel;
  bool? _isHKActive = false;
  bool _firstTym = true;
  bool? _isBPActive = true;
  bool? _isGLActive = true;
  bool? _isOxyActive = true;
  bool? _isTHActive = true;
  bool? _isWSActive = true;
  bool _isHealthFirstTime = false;
  String? preferred_language;
  String? qa_subscription;

/**
 * Declare variable neccessary to voice cloning 
 */
  bool voiceCloning = false;
  bool useClonedVoice = false;
  bool providerAllowedVoiceCloningModule = true;
  bool superAdminAllowedVoiceCloningModule = true;
  String voiceCloningStatus = 'Inactive';
  bool showVoiceCloningUI = true;

  int? priColor;
  int? greColor;

  List<DeviceData>? selectedList;
  DeviceDataHelper _deviceDataHelper = DeviceDataHelper();
  HealthReportListForUserRepository healthReportListForUserRepository =
      HealthReportListForUserRepository();
  GetDeviceSelectionModel? selectionResult;
  CreateDeviceSelectionModel? createDeviceSelectionModel;
  UpdateDeviceModel? updateDeviceModel;

  String? userMappingId = '';
  bool isTouched = false;
  List<Tags>? tagsList = <Tags>[];

  bool? allowAppointmentNotification = true;
  bool? allowVitalNotification = true;
  bool? allowSymptomsNotification = true;

  PreferredMeasurement? preferredMeasurement;

  SheelaAIController? sheelaAIcontroller =
      CommonUtil().onInitSheelaAIController();

  @override
  void initState() {
    selectedList = [];
    _deviceModel = DevicesViewModel();
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
    }
  }

  Future<GetDeviceSelectionModel?> getDeviceSelectionValues() async {
    var userId = PreferenceUtil.getStringValue(Constants.KEY_USERID_MAIN);

    await healthReportListForUserRepository
        .getDeviceSelection(userIdFromBloc: userId)
        .then((value) {
      selectionResult = value;
      if (selectionResult!.isSuccess!) {
        if (selectionResult!.result != null) {
          setValues(selectionResult);
          userMappingId = selectionResult!.result![0].id;
        } else {
          userMappingId = '';
          _isdeviceRecognition = true;
          _sheelaLiveReminders = true;
          _isHKActive = false;
          _firstTym = true;
          _isBPActive = true;
          _isGLActive = true;
          _isOxyActive = true;
          _isTHActive = true;
          _isWSActive = true;
          _isHealthFirstTime = false;
          allowAppointmentNotification = true;
          allowSymptomsNotification = true;
          allowVitalNotification = true;
        }
      } else {
        userMappingId = '';
        _isdigitRecognition = true;
        _isdeviceRecognition = true;
        _sheelaLiveReminders = true;
        _isHKActive = false;
        _firstTym = true;
        _isBPActive = true;
        _isGLActive = true;
        _isOxyActive = true;
        _isTHActive = true;
        _isWSActive = true;
        _isHealthFirstTime = false;
        allowAppointmentNotification = true;
        allowSymptomsNotification = true;
        allowVitalNotification = true;
      }
    });
    return selectionResult;
  }

  Future<CreateDeviceSelectionModel?> createDeviceSelection() async {
    var userId = PreferenceUtil.getStringValue(Constants.KEY_USERID);
    await healthReportListForUserRepository
        .createDeviceSelection(
            _isdigitRecognition,
            _isdeviceRecognition,
            _sheelaLiveReminders,
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
            tagsList,
            allowAppointmentNotification,
            allowVitalNotification,
            allowSymptomsNotification,
            voiceCloning,
           useClonedVoice)
        .then((value) {
      Provider.of<LandingViewModel>(context, listen: false)
          .getQurPlanDashBoard();
      createDeviceSelectionModel = value;
      if (createDeviceSelectionModel!.isSuccess!) {
        closeDialog();
      } else {
        if (createDeviceSelectionModel!.message ==
            STR_USER_PROFILE_SETTING_ALREADY) {
          updateDeviceSelectionModel();
        }
      }
    });
    return createDeviceSelectionModel;
  }

  Future<UpdateDeviceModel?> updateDeviceSelectionModel() async {
    await healthReportListForUserRepository
        .updateDeviceModel(
            userMappingId,
            _isdigitRecognition,
            _isdeviceRecognition,
            _sheelaLiveReminders,
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
            greColor,
            tagsList,
            allowAppointmentNotification,
            allowVitalNotification,
            allowSymptomsNotification,
            preferredMeasurement,
            voiceCloning,null,useClonedVoice)
        .then((value) {
      updateDeviceModel = value;
      if (updateDeviceModel!.isSuccess!) {
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
          FlatButtonWidget(
            bgColor: Colors.transparent,
            isSelected: true,
            onPress: () => closeDialog(),
            title: 'No',
          ),
          FlatButtonWidget(
            bgColor: Colors.transparent,
            isSelected: true,
            onPress: () => createDeviceSelection(),
            title: 'Yes',
          ),
        ],
      ),
    ).then((value) => value as bool);
  }

  closeDialog() {
    Navigator.of(context).pop();
    Navigator.of(context).pop(true);
  }

  setValues(GetDeviceSelectionModel? getDeviceSelectionModel) {
    setState(() {
      _deviceDataHelper = DeviceDataHelper();
      _isdeviceRecognition = getDeviceSelectionModel!
                      .result![0].profileSetting!.allowDevice !=
                  null &&
              getDeviceSelectionModel.result![0].profileSetting!.allowDevice !=
                  ''
          ? getDeviceSelectionModel.result![0].profileSetting!.allowDevice
          : true;
      _isdigitRecognition = getDeviceSelectionModel
                      .result![0].profileSetting!.allowDigit !=
                  null &&
              getDeviceSelectionModel.result![0].profileSetting!.allowDigit !=
                  ''
          ? getDeviceSelectionModel.result![0].profileSetting!.allowDigit
          : true;
      _sheelaLiveReminders = getDeviceSelectionModel
                      .result![0].profileSetting!.sheelaLiveReminders !=
                  null &&
              getDeviceSelectionModel
                      .result![0].profileSetting!.sheelaLiveReminders !=
                  ''
          ? getDeviceSelectionModel
              .result![0].profileSetting!.sheelaLiveReminders
          : true;
      sheelaAIcontroller?.isAllowSheelaLiveReminders =
          _sheelaLiveReminders ?? false;
      /*_isGFActive =
          getDeviceSelectionModel.result[0].profileSetting.googleFit != null &&
                  getDeviceSelectionModel.result[0].profileSetting.googleFit !=
                      ''
              ? getDeviceSelectionModel.result[0].profileSetting.googleFit
              : false;*/
      _isHKActive = getDeviceSelectionModel
                      .result![0].profileSetting!.healthFit !=
                  null &&
              getDeviceSelectionModel.result![0].profileSetting!.healthFit != ''
          ? getDeviceSelectionModel.result![0].profileSetting!.healthFit
          : false;
      _isBPActive = getDeviceSelectionModel
                      .result![0].profileSetting!.bpMonitor !=
                  null &&
              getDeviceSelectionModel.result![0].profileSetting!.bpMonitor != ''
          ? getDeviceSelectionModel.result![0].profileSetting!.bpMonitor
          : true;
      _isGLActive = getDeviceSelectionModel
                      .result![0].profileSetting!.glucoMeter !=
                  null &&
              getDeviceSelectionModel.result![0].profileSetting!.glucoMeter !=
                  ''
          ? getDeviceSelectionModel.result![0].profileSetting!.glucoMeter
          : true;
      _isOxyActive =
          getDeviceSelectionModel.result![0].profileSetting!.pulseOximeter !=
                      null &&
                  getDeviceSelectionModel
                          .result![0].profileSetting!.pulseOximeter !=
                      ''
              ? getDeviceSelectionModel.result![0].profileSetting!.pulseOximeter
              : true;
      _isWSActive = getDeviceSelectionModel
                      .result![0].profileSetting!.weighScale !=
                  null &&
              getDeviceSelectionModel.result![0].profileSetting!.weighScale !=
                  ''
          ? getDeviceSelectionModel.result![0].profileSetting!.weighScale
          : true;
      _isTHActive = getDeviceSelectionModel
                      .result![0].profileSetting!.thermoMeter !=
                  null &&
              getDeviceSelectionModel.result![0].profileSetting!.thermoMeter !=
                  ''
          ? getDeviceSelectionModel.result![0].profileSetting!.thermoMeter
          : true;

      preferred_language = getDeviceSelectionModel
                      .result![0].profileSetting!.preferred_language !=
                  null &&
              getDeviceSelectionModel
                      .result![0].profileSetting!.preferred_language !=
                  ''
          ? getDeviceSelectionModel
              .result![0].profileSetting!.preferred_language
          : 'undef';

      qa_subscription = getDeviceSelectionModel
                      .result![0].profileSetting!.qa_subscription !=
                  null &&
              getDeviceSelectionModel
                      .result![0].profileSetting!.qa_subscription !=
                  ''
          ? getDeviceSelectionModel.result![0].profileSetting!.qa_subscription
          : 'Y';

      tagsList = getDeviceSelectionModel.result![0].tags != null &&
              getDeviceSelectionModel.result![0].tags!.length > 0
          ? getDeviceSelectionModel.result![0].tags
          : [];

      allowAppointmentNotification = getDeviceSelectionModel.result![0]
                      .profileSetting!.caregiverCommunicationSetting !=
                  null &&
              getDeviceSelectionModel.result![0].profileSetting!
                      .caregiverCommunicationSetting !=
                  ''
          ? getDeviceSelectionModel.result![0].profileSetting!
              .caregiverCommunicationSetting?.appointments
          : true;

      allowVitalNotification = getDeviceSelectionModel.result![0]
                      .profileSetting!.caregiverCommunicationSetting !=
                  null &&
              getDeviceSelectionModel.result![0].profileSetting!
                      .caregiverCommunicationSetting !=
                  ''
          ? getDeviceSelectionModel
              .result![0].profileSetting!.caregiverCommunicationSetting?.vitals
          : true;

      allowSymptomsNotification = getDeviceSelectionModel.result![0]
                      .profileSetting!.caregiverCommunicationSetting !=
                  null &&
              getDeviceSelectionModel.result![0].profileSetting!
                      .caregiverCommunicationSetting !=
                  ''
          ? getDeviceSelectionModel.result![0].profileSetting!
              .caregiverCommunicationSetting?.symptoms
          : true;

      preferredMeasurement =
          getDeviceSelectionModel.result![0].profileSetting != null
              ? getDeviceSelectionModel
                  .result![0].profileSetting!.preferredMeasurement
              : null;

      voiceCloning =
          getDeviceSelectionModel.result![0].profileSetting!.voiceCloning ??
              false;
      useClonedVoice =
          getDeviceSelectionModel.result![0].profileSetting!.useClonedVoice ??
              false;

      providerAllowedVoiceCloningModule = getDeviceSelectionModel
              .result![0]
              .primaryProvider
              ?.additionalInfo
              ?.providerAllowedVoiceCloningModule ??
          true;
      superAdminAllowedVoiceCloningModule = getDeviceSelectionModel
              .result![0]
              .primaryProvider
              ?.additionalInfo
              ?.superAdminAllowedVoiceCloningModule ??
          true;
      voiceCloningStatus = superAdminAllowedVoiceCloningModule
          ? providerAllowedVoiceCloningModule
              ? getDeviceSelectionModel
                      .result![0].profileSetting!.voiceCloningStatus ??
                  "InActive"
              : "InActive"
          : "InActive";
      showVoiceCloningUI = superAdminAllowedVoiceCloningModule
          ? providerAllowedVoiceCloningModule
              ? true
              : false
          : false;
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
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: const Color(fhbColors.bgColorContainer),
        appBar: AppBar(
          centerTitle: false,
          titleSpacing: 0.0,
          title: Transform(
            // you can forcefully translate values left side using Transform
            transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
            child: Text(
              Constants.careGiver,
              style: TextStyle(fontSize: 20.sp),
            ),
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
                                value: allowVitalNotification!,
                                activeColor:
                                    mAppThemeProvider.primaryColor,
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
                                value: allowSymptomsNotification!,
                                activeColor:
                                    mAppThemeProvider.primaryColor,
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
                                value: allowAppointmentNotification!,
                                activeColor:
                                    mAppThemeProvider.primaryColor,
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

  Future<bool?> _handleGoogleFit() async {
    bool? ret = false;
    bool _isSignedIn = await _deviceDataHelper.isGoogleFitSignedIn();
    if (_isGFActive == _isSignedIn) {
      ret = _isGFActive;
    } else {
      if (_isGFActive!) {
        _isGFActive = await _deviceDataHelper.activateGoogleFit();
      } else {
        _isGFActive = !await _deviceDataHelper.deactivateGoogleFit();
      }
    }
    PreferenceUtil.saveString(Constants.activateGF, _isGFActive.toString());
    return ret;
  }
}
