import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/device_integration/model/BPValues.dart';
import 'package:myfhb/device_integration/model/GulcoseValues.dart';
import 'package:myfhb/device_integration/model/OxySaturationValues.dart';
import 'package:myfhb/device_integration/model/TemperatureValues.dart';
import 'package:myfhb/device_integration/model/Values_Screen.dart';
import 'package:myfhb/device_integration/model/WeightValues.dart';
import 'package:myfhb/device_integration/model/HeartRateValues.dart';
import 'package:myfhb/device_integration/view/screens/Device_Data.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/device_integration/viewModel/getGFDataFromFHBRepo.dart';
import 'package:myfhb/device_integration/model/DeviceValue.dart';
import 'package:flutter/services.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

Future<String> _loadDeviceDataAsset() async {
  return await rootBundle.loadString('assets/devices.json');
}

class DevicesViewModel with ChangeNotifier {
  GetGFDataFromFHBRepo _helper = GetGFDataFromFHBRepo();
  List<DeviceData> deviceList;
  List<Values> valuesList;

  List<DeviceData> getDeviceValues() {
    List<DeviceData> devicelist = new List<DeviceData>();
    devicelist.add(DeviceData(
        title: Constants.STR_BP_MONITOR,
        icon: Constants.Devices_BP,
        status: 0,
        isSelected: false,
        value_name: parameters.strDataTypeBP,
        value1: 'SYS',
        value2: 'DIS',
        color: [Colors.teal, Colors.tealAccent]));

    devicelist.add(DeviceData(
        title: Constants.STR_GLUCOMETER,
        icon: Constants.Devices_GL,
        status: 0,
        isSelected: false,
        value_name: parameters.strGlusoceLevel,
        value1: 'GL',
        value2: '',
        color: [Colors.red, Colors.redAccent]));
    devicelist.add(DeviceData(
        title: Constants.STR_PULSE_OXIMETER,
        icon: Constants.Devices_OxY,
        status: 0,
        isSelected: false,
        value_name: parameters.strOxgenSaturation,
        value1: 'OS',
        value2: '',
        color: [Colors.blue, Colors.blueAccent]));
    devicelist.add(DeviceData(
        title: Constants.STR_THERMOMETER,
        icon: Constants.Devices_THM,
        status: 0,
        isSelected: false,
        value_name: parameters.strTemperature,
        value1: 'TEMP',
        value2: '',
        color: [Colors.pink, Colors.pinkAccent]));
    devicelist.add(DeviceData(
        title: Constants.STR_WEIGHING_SCALE,
        icon: Constants.Devices_WS,
        status: 0,
        isSelected: false,
        value_name: parameters.strWeight,
        value1: 'WT',
        value2: '',
        color: [Colors.indigo, Colors.indigoAccent]));
    return devicelist;
  }

  Future<List<DeviceData>> getDevices() async {
    deviceList = [];
    deviceList = await getDeviceValues();
    return deviceList;
  }

  Future<DevResult> fetchDeviceDetails() async {
    try {
      final resp = await _helper.getLatestDeviceHealthRecord();
      String res = json.encode(resp);
      DeviceValue devValue = deviceValueFromJson(res);
      DevResult result = devValue.result;

      //notifyListeners();
      return result;
    } catch (e) {}
  }

  Future<List<BPResult>> fetchBPDetails() async {
    try {
      final resp = await _helper.getBPData();
      if (resp == null) {
        return [];
      }
      final parsed1 = json.decode(resp.toString())[dataResult] as List;
      List<BPResult> ret = parsed1.map((i) => BPResult.fromJson(i)).toList();
      return ret;
    } catch (e) {}
  }

  Future<List<GVResult>> fetchGLDetails() async {
    try {
      final resp = await _helper.getBloodGlucoseData();
      if (resp == null) {
        return [];
      }
      final parsed1 = json.decode(resp.toString())[dataResult] as List;
      List<GVResult> ret = parsed1.map((i) => GVResult.fromJson(i)).toList();
      return ret;
    } catch (e) {}
  }

  Future<List<OxyResult>> fetchOXYDetails(String response) async {
    try {
      final resp = await _helper.getOxygenSaturationData();
      if (resp == null) {
        return [];
      }
      final parsed1 = json.decode(resp.toString())[dataResult] as List;
      List<OxyResult> ret = parsed1.map((i) => OxyResult.fromJson(i)).toList();
      return ret;
    } catch (e) {}
  }

  Future<List<TMPResult>> fetchTMPDetails() async {
    try {
      final resp = await _helper.getBodyTemperatureData();
      if (resp == null) {
        return [];
      }
      final parsed1 = json.decode(resp.toString())[dataResult] as List;
      List<TMPResult> ret = parsed1.map((i) => TMPResult.fromJson(i)).toList();
      return ret;
    } catch (e) {}
  }

  Future<List<WVResult>> fetchWVDetails(String response) async {
    try {
      final resp = await _helper.getWeightData();
      if (resp == null) {
        return [];
      }
      final parsed1 = json.decode(resp.toString())[dataResult] as List;
      List<WVResult> ret = parsed1.map((i) => WVResult.fromJson(i)).toList();
      return ret;
    } catch (e) {}
  }

  Future<List<HRResult>> fetchHeartRateDetails(String response) async {
    try {
      final resp = await _helper.getHeartRateData();
      if (resp == null) {
        return [];
      }
      final parsed1 = json.decode(resp.toString())[dataResult] as List;
      List<HRResult> ret = parsed1.map((i) => HRResult.fromJson(i)).toList();
      return ret;
    } catch (e) {}
  }

  Future<List<Values>> getBPValuesList() async {
    valuesList = [];

    return valuesList;
  }

  Future<List<Values>> getSugRValuesList() async {
    valuesList = [];

    //notifyListeners();
    return valuesList;
  }

  Future<List<Values>> getGValuesList() async {
    valuesList = [];

    //notifyListeners();
    return valuesList;
  }

  Future<List<Values>> getWeightValuesList() async {
    valuesList = [];

//notifyListeners();
    return valuesList;
  }

  Future<List<Values>> getFeverValuesList() async {
    valuesList = [];

    //notifyListeners();
    return valuesList;
  }
}
