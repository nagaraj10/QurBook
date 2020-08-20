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
        title: 'BP Monitor',
        icon: 'assets/devices/bp_m.png',
        status: 0,
        isSelected: false,
        value_name: 'bloodPressure',
        value1: 'SYS',
        value2: 'DIS',
        color: Colors.redAccent));
    devicelist.add(DeviceData(
        title: 'Glucometer',
        icon: 'assets/devices/gulco.png',
        status: 0,
        isSelected: false,
        value_name: 'bloodGlucose',
        value1: 'GL',
        value2: '',
        color: Colors.orange));
    devicelist.add(DeviceData(
        title: 'Pulse Oximeter',
        icon: 'assets/devices/pulse_oxim.png',
        status: 0,
        isSelected: false,
        value_name: 'oxygenSaturation',
        value1: 'OS',
        value2: '',
        color: Colors.blueAccent));
    devicelist.add(DeviceData(
        title: 'Thermometer',
        icon: 'assets/devices/fever.png',
        status: 0,
        isSelected: false,
        value_name: 'bodyTemperature',
        value1: 'TEMP',
        value2: '',
        color: Colors.deepOrangeAccent));
    devicelist.add(DeviceData(
        title: 'Weighing Scale',
        icon: 'assets/devices/weight.png',
        status: 0,
        isSelected: false,
        value_name: 'bodyWeight',
        value1: 'WT',
        value2: '',
        color: Colors.lightGreen));
    return devicelist;
  }

  Future<List<DeviceData>> getDevices() async {
    deviceList = [];
    deviceList = await getDeviceValues();
    //notifyListeners();
    return deviceList;
  }

  Future<DevResult> fetchDeviceDetails() async {
    try {
      final resp = await _helper.getLatestDeviceHealthRecord();
      print("Resp is $resp");

      String res = json.encode(resp);
      DeviceValue devValue = deviceValueFromJson(res);
      DevResult result = devValue.result;

      notifyListeners();
      return result;
    } catch (e) {
      throw 'Failed to get latest device health record from myFHB DB $e';
    }
  }

  Future<List<BPResult>> fetchBPDetails() async {
    try {
      final resp = await _helper.getBPData();
      print("response Retunred is ------------ $resp");

      if (resp == null) {
        print("didn't recieved data as expected");
        return [];
      }
      //final parsed = resp['result']; // as List;
      //final pars1 = json.decode(resp.toString());
      final parsed1 = json.decode(resp.toString())[strresult] as List;
      List<BPResult> ret = parsed1.map((i) => BPResult.fromJson(i)).toList();

      //notifyListeners();
      return ret;
    } catch (e) {
      throw 'Failed to fetch BP record summary from myFHB db $e';
    }
  }

  Future<List<GVResult>> fetchGLDetails() async {
    try {
      final resp = await _helper.getBloodGlucoseData();
      print("response Retunred is ------------ $resp");
      if (resp == null) {
        print("didn't recieved data as expected");
        return [];
      }
      final parsed1 = json.decode(resp.toString())[strresult] as List;
      //notifyListeners();
      List<GVResult> ret = parsed1.map((i) => GVResult.fromJson(i)).toList();
      return ret;
    } catch (e) {
      throw 'Failed to fetch Glucose record summary from myFHB db $e';
    }
  }

  Future<List<OxyResult>> fetchOXYDetails(String response) async {
    if (response == null) {
      // return [];
    }
    final resp = await _helper.getOxygenSaturationData();
    print("response Retunred is ------------ $resp");
    if (resp == null) {
      print("didn't recieved data as expected");
      return [];
    }
    final parsed1 = json.decode(resp.toString())[strresult] as List;
    //notifyListeners();
    List<OxyResult> ret = parsed1.map((i) => OxyResult.fromJson(i)).toList();
    return ret;
  }

  Future<List<TMPResult>> fetchTMPDetails() async {
    try {
      final resp = await _helper.getBodyTemperatureData();
      print("response Retunred is ------------ $resp");
      if (resp == null) {
        print("didn't recieved data as expected");
        return [];
      }
      final parsed1 = json.decode(resp.toString())[strresult] as List;
      //notifyListeners();
      List<TMPResult> ret = parsed1.map((i) => TMPResult.fromJson(i)).toList();
      return ret;
    } catch (e) {
      throw 'Failed to fetch temperature record summary from myFHB db $e';
    }
  }

  Future<List<WVResult>> fetchWVDetails(String response) async {
    try {
      final resp = await _helper.getWeightData();
      print("response Retunred is ------------ $resp");
      if (resp == null) {
        print("didn't recieved data as expected");
        return [];
      }
      final parsed1 = json.decode(resp.toString())[strresult] as List;
      //notifyListeners();
      List<WVResult> ret = parsed1.map((i) => WVResult.fromJson(i)).toList();
      return ret;
    } catch (e) {
      throw 'Failed to fetch Weight record summary from myFHB db $e';
    }
  }

  Future<List<HRResult>> fetchHeartRateDetails(String response) async {
    try {
      final resp = await _helper.getHeartRateData();
      print("response Retunred is ------------ $resp");
      if (resp == null) {
        print("didn't recieved data as expected");
        return [];
      }
      final parsed1 = json.decode(resp.toString())[strresult] as List;
      //notifyListeners();
      List<HRResult> ret = parsed1.map((i) => HRResult.fromJson(i)).toList();
      return ret;
    } catch (e) {
      throw 'Failed to fetch Heart Rate record summary from myFHB db $e';
    }
  }

  Future<List<Values>> getBPValuesList() async {
    valuesList = [];

    //notifyListeners();
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
