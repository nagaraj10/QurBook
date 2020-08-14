import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myfhb/colors/fhb_colors.dart' as fhbColors;
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/device_integration/model/Device_Values.dart';
import 'package:myfhb/device_integration/model/Selected_Device.dart';
import 'package:myfhb/device_integration/view/screens/Device_Card.dart';
import 'package:myfhb/device_integration/view/screens/Device_Data.dart';
import 'package:myfhb/device_integration/view/screens/Show_Devices.dart';
import 'package:myfhb/device_integration/viewModel/Device_model.dart';
import 'package:myfhb/widgets/GradientAppBar.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:myfhb/constants/variable_constant.dart' as variable;
import 'package:myfhb/device_integration/viewModel/deviceDataHelper.dart';

Future<String> _loadDeviceDataAsset() async {
  return await rootBundle.loadString('assets/devices.json');
}

class MySettings extends StatefulWidget {
  @override
  _MySettingsState createState() => _MySettingsState();
}

class _MySettingsState extends State<MySettings> {
  bool _isdigitRecognition = true;
  bool _isdeviceRecognition = true;
  bool _isGFActive = false;
  DevicesViewModel _deviceModel;
  List<DeviceResult> devicesList;
  bool _isHKActive = false;
  List<DeviceData> selectedList;
  DeviceDataHelper _deviceDataHelper = DeviceDataHelper();
  @override
  void initState() {
    List<DeviceResult> _student;
    bool _loaded = false;
    selectedList = List();
    devicesList = List();
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
        actions: [
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              size: 20,
            ),
            onPressed: () {
              if (!selectedList.isEmpty) {
                print(selectedList.length);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                            create: (context) => DevicesViewModel(),
                            child: ShowDevices(
                              lists1: selectedList,
                              lists2: devicesList,
                            ),
                          )),
                );
              }
            },
          ),
        ],
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
    String jsonProduct = await _loadDeviceDataAsset();
    final jsonResponse = devicesViewModel.fetchDeviceDetails(jsonProduct);
    print(jsonResponse.toString());
    print(jsonResponse[0].bloodGlucose.entities[0].lastsyncdatetime);
    devicesList = jsonResponse;
    print(devicesList.length);
  }
  /*Future<List<DeviceResult>> loadStudent(
      DevicesViewModel devicesViewModel) async {
    var rsss;
    String jsonString = await _loadDeviceDataAsset();
    final jsonResponse = devicesViewModel.fetchTranscationDetails(jsonString);
    return devicesList = jsonResponse;
    */ /* return */ /* */ /*parsed
        .map<DeviceResult>((json) => new DeviceResult.fromJson(json))
        .toList();*/ /* */ /*
        parsed.map((i) => DeviceResult.fromJson(i)).toList();
*/ /*
    // return new DeviceResult.fromJson(jsonResponse);
  }*/

  getSelectedDevices(DevicesViewModel devicesViewModel) {
    FutureBuilder(
        future:
            DefaultAssetBundle.of(context).loadString('assets/devices.json'),
        builder: (context, snapshot) {
          List<DeviceResult> translist =
              devicesViewModel.fetchDeviceDetails(snapshot.data.toString());
          devicesList = translist;
          print('Came Here');
          print(devicesList);
          print(devicesList[2].bloodGlucose.entities[0].bloodGlucoseLevel);
          return !translist.isEmpty
              ? ''
              /*ListView.builder(
            shrinkWrap: true,
            itemCount: translist.length,
            itemBuilder: (context, i) {
            },
          )*/
              : new Center(child: new CircularProgressIndicator());
        });
  }
}
/*projectWidget(BuildContext contextt) {
    return Container(
      child: FutureBuilder(
        future:
            DefaultAssetBundle.of(contextt).loadString('assets/devices.json'),
        builder: (contextt, snapshot) {
          List<DeviceResult> translist =
              _deviceModel.fetchTranscationDetails(snapshot.data.toString());
          print(snapshot.data.toString());
          print(translist.length);
          devicesList = translist;
          print(devicesList.length);
          */ /* return translist.isEmpty
              ? devicesList = translist
              : new Center(child: new CircularProgressIndicator());*/ /*
        },
      ),
    );
  }*/
