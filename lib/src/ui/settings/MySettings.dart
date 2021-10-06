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


class MySettings extends StatefulWidget {
  @override
  _MySettingsState createState() => _MySettingsState();

  final int priColor;
  final int greColor;

  MySettings({Key key, this.priColor, this.greColor}) : super(key: key);
}

class _MySettingsState extends State<MySettings> {
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
  List<Tags> tagsList =
  new List<Tags>();
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
    await healthReportListForUserRepository.getDeviceSelection().then((value) {
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
            greColor,tagsList)
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
            greColor,tagsList)
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

      tagsList=getDeviceSelectionModel
          .result[0].tags!=null && getDeviceSelectionModel
          .result[0].tags.length>0?getDeviceSelectionModel
          .result[0].tags:new List();
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
          title: Text(Constants.Settings),
          centerTitle: false,
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
                            leading: ImageIcon(
                              AssetImage(variable.icon_digit_reco),
                              //size: 30,
                              color: Colors.black,
                            ),
                            title: Text(variable.strAllowDigit),
                            subtitle: Text(
                              variable.strScanDevices,
                              style: TextStyle(fontSize: 12.0.sp),
                            ),
                            trailing: Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                value: _isdigitRecognition,
                                activeColor:
                                    Color(new CommonUtil().getMyPrimaryColor()),
                                onChanged: (bool newValue) {
                                  setState(() {
                                    isTouched = true;
                                    _isdigitRecognition = newValue;

                                    /*PreferenceUtil.saveString(
                                        Constants.allowDigitRecognition,
                                        _isdigitRecognition.toString());*/
                                  });
                                },
                              ),
                            )),
                        Container(
                          height: 1,
                          color: Colors.grey[200],
                        ),
                        ListTile(
                            leading: ImageIcon(
                              AssetImage(variable.icon_device_recon),
                              //size: 30,
                              color: Colors.black,
                            ),
                            title: Text(variable.strAllowDevice),
                            subtitle: Text(
                              variable.strScanAuto,
                              style: TextStyle(fontSize: 12.0.sp),
                            ),
                            trailing: Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                value: _isdeviceRecognition,
                                activeColor:
                                    Color(new CommonUtil().getMyPrimaryColor()),
                                onChanged: (bool newValue) {
                                  setState(() {
                                    isTouched = true;
                                    _isdeviceRecognition = newValue;

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
                        FutureBuilder(
                            future: _handleGoogleFit(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ListTile(
                                  leading: ImageIcon(
                                    AssetImage(variable.icon_digit_googleFit),
                                    //size: 30,
                                    color: Colors.black,
                                  ),
                                  title: Text(variable.strGoogleFit),
                                  subtitle: Text(
                                    variable.strAllowGoogle,
                                    style: TextStyle(fontSize: 12.0.sp),
                                  ),
                                  trailing: Wrap(
                                    children: <Widget>[
                                      Transform.scale(
                                        scale: 0.8,
                                        child: IconButton(
                                          icon: Icon(Icons.sync),
                                          onPressed: () {
                                            _deviceDataHelper.syncGoogleFit();
                                          },
                                        ),
                                      ),
                                      Transform.scale(
                                        scale: 0.8,
                                        child: Switch(
                                          value: _isGFActive,
                                          activeColor: Color(new CommonUtil()
                                              .getMyPrimaryColor()),
                                          onChanged: (bool newValue) {
                                            setState(() {
                                              //isTouched = true;
                                              _isGFActive = newValue;
                                            });
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            }),
                        Container(
                          height: 1,
                          color: Colors.grey[200],
                        ),
                        (Platform.isIOS)
                            ? ListTile(
                                leading: Icon(
                                  Icons.favorite,
                                  color: Colors.pink,
                                ),
                                title: Text(variable.strHealthKit),
                                subtitle: Text(
                                  variable.strAllowHealth,
                                  style: TextStyle(fontSize: 12.0.sp),
                                ),
                                trailing: Wrap(
                                  children: <Widget>[
                                    Transform.scale(
                                      scale: 0.8,
                                      child: IconButton(
                                        icon: Icon(Icons.sync),
                                        onPressed: () {
                                          _deviceDataHelper.syncHealthKit();
                                        },
                                      ),
                                    ),
                                    Transform.scale(
                                      scale: 0.8,
                                      child: Switch(
                                        value: _isHKActive,
                                        activeColor: Color(new CommonUtil()
                                            .getMyPrimaryColor()),
                                        onChanged: (bool newValue) {
                                          isTouched = true;
                                          if (_isHealthFirstTime) {
                                            _isHealthFirstTime = false;
                                            PreferenceUtil.saveString(
                                                Constants.isHealthFirstTime,
                                                _isHealthFirstTime.toString());

                                            newValue == true
                                                ? _deviceDataHelper
                                                    .activateHealthKit()
                                                : _deviceDataHelper
                                                    .deactivateHealthKit();
                                          } else {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HealthApp()),
                                            );
                                          }
                                          setState(() {
                                            _isHKActive = newValue;

                                            /*PreferenceUtil.saveString(
                                                Constants.activateHK,
                                                _isHKActive.toString());*/
                                          });
                                        },
                                      ),
                                    )
                                  ],
                                ))
                            : SizedBox.shrink(),
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
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(
                      variable.strAddDevice,
                      style: TextStyle(color: Colors.black, fontSize: 14.0.sp),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FutureBuilder<List<DeviceData>>(
                      future: _deviceModel.getDevices(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          for (int i = 0; i <= snapshot.data.length; i++) {
                            switch (i) {
                              case 0:
                                snapshot.data[i].isSelected = _isBPActive;
                                break;
                              case 1:
                                snapshot.data[i].isSelected = _isGLActive;
                                break;
                              case 2:
                                snapshot.data[i].isSelected = _isOxyActive;
                                break;
                              case 3:
                                snapshot.data[i].isSelected = _isTHActive;
                                break;
                              case 4:
                                snapshot.data[i].isSelected = _isWSActive;
                                break;

                              default:
                            }
                          }
                        }
                        return snapshot.hasData
                            ? Container(
                                height: 75,
                                color: Colors.white,
                                child: new ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, i) {
                                    return DeviceCard(
                                        deviceData: snapshot.data[i],
                                        isSelected: (bool value) {
                                          isTouched = true;
                                          switch (i) {
                                            case 0:
                                              _isBPActive = value;
                                              /* PreferenceUtil.saveString(
                                                  Constants.bpMon,
                                                  _isBPActive.toString());*/
                                              break;
                                            case 1:
                                              _isGLActive = value;
                                              /*PreferenceUtil.saveString(
                                                  Constants.glMon,
                                                  _isGLActive.toString());*/

                                              break;
                                            case 2:
                                              _isOxyActive = value;
                                              /*PreferenceUtil.saveString(
                                                  Constants.oxyMon,
                                                  _isOxyActive.toString());*/
                                              break;
                                            case 3:
                                              _isTHActive = value;
                                              /*PreferenceUtil.saveString(
                                                  Constants.thMon,
                                                  _isTHActive.toString());*/
                                              break;
                                            case 4:
                                              _isWSActive = value;
                                              /*PreferenceUtil.saveString(
                                                  Constants.wsMon,
                                                  _isWSActive.toString());*/
                                              break;
                                            default:
                                          }
                                          setState(() {
                                            if (value) {
                                              selectedList
                                                  .add(snapshot.data[i]);
                                            } else {
                                              selectedList
                                                  .remove(snapshot.data[i]);
                                            }
                                          });
                                        },
                                        key: Key(snapshot.data[i].status
                                            .toString()));
                                  },
                                ),
                              )
                            : CommonCircularIndicator();
                      },
                    ),
                  ],
                ),
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
