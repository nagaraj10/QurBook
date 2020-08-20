import 'package:flutter/material.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/device_integration/model/DeviceValue.dart';
import 'package:myfhb/device_integration/view/screens/Device_Card.dart';
import 'package:myfhb/device_integration/view/screens/Device_Data.dart';
import 'package:myfhb/device_integration/view/screens/Show_Devices.dart';
import 'package:myfhb/device_integration/viewModel/Device_model.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/device_integration/viewModel/deviceDataHelper.dart';
import 'dart:io';

class MySettings extends StatefulWidget {
  @override
  _MySettingsState createState() => _MySettingsState();
}

class _MySettingsState extends State<MySettings> {
  bool _isdigitRecognition = true;
  bool _isdeviceRecognition = true;
  bool _isGFActive = false;
  DevicesViewModel _deviceModel;
  DevResult devicesList;
  bool _isHKActive = false;

  bool _isBPActive = false;
  bool _isGLActive = false;
  bool _isOxyActive = false;
  bool _isTHActive = false;
  bool _isWSActive = false;

  // DevicesViewModel _deviceModel;
  // List<DeviceResult> devicesList;
  List<DeviceData> selectedList;
  DeviceDataHelper _deviceDataHelper = DeviceDataHelper();
  @override
  void initState() {
    DevResult _student;
    bool _loaded = false;
    selectedList = List();
    //devicesList = List();
    _deviceModel = new DevicesViewModel();
    /*  loadStudent(_deviceModel).then((s) => setState(() {
          _student = s;
          _loaded = true;
        }));*/
    devicesList = _student;
    print(devicesList);
    loadProduct(_deviceModel);
    //getSelectedDevices(_deviceModel);
    super.initState();
    PreferenceUtil.init();
    setState(() {
      _deviceDataHelper = DeviceDataHelper();
      _isdeviceRecognition =
          PreferenceUtil.getStringValue(Constants.allowDeviceRecognition) ==
                  variable.strFalse
              ? false
              : true;
      _isdigitRecognition =
          PreferenceUtil.getStringValue(Constants.allowDigitRecognition) ==
                  variable.strFalse
              ? false
              : true;
      _isGFActive = PreferenceUtil.getStringValue(Constants.activateGF) ==
              variable.strFalse
          ? false
          : true;
      _isHKActive = PreferenceUtil.getStringValue(Constants.activateHK) ==
              variable.strFalse
          ? false
          : true;
      _isBPActive =
          PreferenceUtil.getStringValue(Constants.bpMon) == variable.strFalse
              ? false
              : true;
      _isGLActive =
          PreferenceUtil.getStringValue(Constants.glMon) == variable.strFalse
              ? false
              : true;
      _isOxyActive =
          PreferenceUtil.getStringValue(Constants.oxyMon) == variable.strFalse
              ? false
              : true;
      _isWSActive =
          PreferenceUtil.getStringValue(Constants.wsMon) == variable.strFalse
              ? false
              : true;
      _isTHActive =
          PreferenceUtil.getStringValue(Constants.thMon) == variable.strFalse
              ? false
              : true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(fhbColors.bgColorContainer),
      appBar: AppBar(
        title: Text(Constants.Settings),
        centerTitle: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
          onPressed: () {
            Navigator.of(context).pop();
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
                            style: TextStyle(fontSize: 10),
                          ),
                          trailing: Transform.scale(
                            scale: 0.8,
                            child: Switch(
                              value: _isdigitRecognition,
                              activeColor:
                                  Color(new CommonUtil().getMyPrimaryColor()),
                              onChanged: (bool newValue) {
                                setState(() {
                                  _isdigitRecognition = newValue;

                                  PreferenceUtil.saveString(
                                      Constants.allowDigitRecognition,
                                      _isdigitRecognition.toString());
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
                            style: TextStyle(fontSize: 10),
                          ),
                          trailing: Transform.scale(
                            scale: 0.8,
                            child: Switch(
                              value: _isdeviceRecognition,
                              activeColor:
                                  Color(new CommonUtil().getMyPrimaryColor()),
                              onChanged: (bool newValue) {
                                setState(() {
                                  _isdeviceRecognition = newValue;

                                  PreferenceUtil.saveString(
                                      Constants.allowDeviceRecognition,
                                      _isdeviceRecognition.toString());
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
                            AssetImage(variable.icon_digit_googleFit),
                            //size: 30,
                            color: Colors.black,
                          ),
                          title: Text(variable.strGoogleFit),
                          subtitle: Text(
                            variable.strAllowGoogle,
                            style: TextStyle(fontSize: 10),
                          ),
                          trailing: Wrap(children: <Widget>[
                            Transform.scale(
                              scale: 0.8,
                              child: IconButton(
                                icon: Icon(Icons.sync),
                                onPressed: () {
                                  _deviceDataHelper.syncGF();
                                },
                              ),
                            ),
                            Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                value: _isGFActive,
                                activeColor:
                                    Color(new CommonUtil().getMyPrimaryColor()),
                                onChanged: (bool newValue) {
                                  newValue == true
                                      ? _deviceDataHelper.activateGF()
                                      : _deviceDataHelper.deactivateGF();
                                  setState(() {
                                    _isGFActive = newValue;

                                    PreferenceUtil.saveString(
                                        Constants.activateGF,
                                        _isGFActive.toString());
                                  });
                                },
                              ),
                            )
                          ])),
                      Container(
                        height: 1,
                        color: Colors.grey[200],
                      ),

                      (Platform.isIOS) ?
                      ListTile(
                          leading: Icon(
                            //AssetImage(variable.icon_digit_appleHealth),
                            //size: 30,
                            //color: Colors.black,
                            Icons.favorite,
                            color: Colors.pink,
                          ),
                          title: Text(variable.strHealthKit),
                          subtitle: Text(
                            variable.strAllowHealth,
                            style: TextStyle(fontSize: 10),
                          ),
                          trailing: Wrap(
                            children: <Widget>[
                              Transform.scale(
                                scale: 0.8,
                                child: IconButton(
                                  icon: Icon(Icons.sync),
                                  onPressed: () {
                                    _deviceDataHelper.syncHKT();
                                  },
                                ),
                              ),
                              Transform.scale(
                                scale: 0.8,
                                child: Switch(
                                  value: _isHKActive,
                                  activeColor: Color(
                                      new CommonUtil().getMyPrimaryColor()),
                                  onChanged: (bool newValue) {
                                    newValue == true
                                        ? _deviceDataHelper.activateHKT()
                                        : _deviceDataHelper.deactivateHKT();
                                    setState(() {
                                      _isHKActive = newValue;

                                      PreferenceUtil.saveString(
                                          Constants.activateHK,
                                          _isHKActive.toString());
                                    });
                                  },
                                ),
                              )
                            ],
                          )):SizedBox.shrink(),

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
                    'Tap to add device widgets to your home screen',
                    style: TextStyle(color: Colors.black, fontSize: 12),
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
                                        switch (i) {
                                          case 0:
                                            _isBPActive = value;
                                            print(
                                                'saving_BpValues :$_isBPActive');
                                            PreferenceUtil.saveString(
                                                Constants.bpMon,
                                                _isBPActive.toString());
                                            break;
                                          case 1:
                                            _isGLActive = value;
                                            PreferenceUtil.saveString(
                                                Constants.glMon,
                                                _isGFActive.toString());

                                            break;
                                          case 2:
                                            _isOxyActive = value;
                                            PreferenceUtil.saveString(
                                                Constants.oxyMon,
                                                _isOxyActive.toString());
                                            break;
                                          case 3:
                                            _isTHActive = value;
                                            PreferenceUtil.saveString(
                                                Constants.thMon,
                                                _isTHActive.toString());
                                            break;
                                          case 4:
                                            _isWSActive = value;
                                            PreferenceUtil.saveString(
                                                Constants.wsMon,
                                                _isWSActive.toString());
                                            break;
                                          default:
                                        }
                                        setState(() {
                                          if (value) {
                                            selectedList.add(snapshot.data[i]);
                                          } else {
                                            selectedList
                                                .remove(snapshot.data[i]);
                                          }
                                        });
                                        print("${snapshot.data[i]} : $value");
                                      },
                                      key: Key(
                                          snapshot.data[i].status.toString()));
                                },
                              ),
                            )
                          : Center(
                              child: CircularProgressIndicator(),
                            );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future loadProduct(DevicesViewModel devicesViewModel) async {
    final jsonResponse = await devicesViewModel.fetchDeviceDetails();
    print(jsonResponse.toString());
    devicesList = jsonResponse;
  }
}
