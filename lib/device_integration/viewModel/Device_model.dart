import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myfhb/device_integration/model/BPValues_Screen.dart';
import 'package:myfhb/device_integration/model/Device_Values.dart';
import 'package:myfhb/device_integration/model/GulcoseValues_Screen.dart';
import 'package:myfhb/device_integration/model/OxySaturation_Values.dart';
import 'package:myfhb/device_integration/model/TemperatureValues.dart';
import 'package:myfhb/device_integration/model/Values_Screen.dart';
import 'package:myfhb/device_integration/model/WeightValues.dart';
import 'package:myfhb/device_integration/view/screens/Device_Data.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;

class DevicesViewModel with ChangeNotifier {
  List<DeviceData> deviceList;
  List<Values> valuesList;
  Future<List<DeviceData>> getDevices() async {
    deviceList = [];
    deviceList = await Constants.getDeviceValues();
    notifyListeners();
    return deviceList;
  }

  List<DeviceResult> fetchDeviceDetails(String response) {
    if (response == null) {
      return [];
    }

    final parsed = json.decode(response.toString())['result'] as List;
    return parsed.map((i) => DeviceResult.fromJson(i)).toList();
  }

  List<BPResult> fetchBPDetails(String response) {
    if (response == null) {
      return [];
    }
    final parsed = json.decode(response.toString())['result'] as List;
    return parsed.map((i) => BPResult.fromJson(i)).toList();
  }

  List<GVResult> fetchGLDetails(String response) {
    if (response == null) {
      return [];
    }
    final parsed = json.decode(response.toString())['result'] as List;
    return parsed.map((i) => GVResult.fromJson(i)).toList();
  }

  List<OxyResult> fetchOXYDetails(String response) {
    if (response == null) {
      return [];
    }
    final parsed = json.decode(response.toString())['result'] as List;
    return parsed.map((i) => OxyResult.fromJson(i)).toList();
  }

  List<TMPResult> fetchTMPDetails(String response) {
    if (response == null) {
      return [];
    }
    final parsed = json.decode(response.toString())['result'] as List;
    return parsed.map((i) => TMPResult.fromJson(i)).toList();
  }

  List<WVResult> fetchWVDetails(String response) {
    if (response == null) {
      return [];
    }
    final parsed = json.decode(response.toString())['result'] as List;
    return parsed.map((i) => WVResult.fromJson(i)).toList();
  }

  Future<List<Values>> getBPValuesList() async {
    valuesList = [];
    valuesList = await Constants.getBPValues();
    notifyListeners();
    return valuesList;
  }

  Future<List<Values>> getSugRValuesList() async {
    valuesList = [];
    valuesList = await Constants.getSugarValues();
    notifyListeners();
    return valuesList;
  }

  Future<List<Values>> getGValuesList() async {
    valuesList = [];
    valuesList = await Constants.getGlucoseValues();
    notifyListeners();
    return valuesList;
  }

  Future<List<Values>> getWeightValuesList() async {
    valuesList = [];
    valuesList = await Constants.getWeightValues();
    notifyListeners();
    return valuesList;
  }

  Future<List<Values>> getFeverValuesList() async {
    valuesList = [];
    valuesList = await Constants.getFeverValues();
    notifyListeners();
    return valuesList;
  }
}
