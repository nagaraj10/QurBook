import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/device_integration/model/BPValues.dart';
import 'package:myfhb/device_integration/model/GulcoseValues.dart';
import 'package:myfhb/device_integration/model/HeartRate.dart';
import 'package:myfhb/device_integration/model/OxySaturationValues.dart';
import 'package:myfhb/device_integration/model/TemperatureValues.dart';
import 'package:myfhb/device_integration/model/WeightValues.dart';
import 'package:myfhb/device_integration/model/HeartRateValues.dart';
import 'package:myfhb/device_integration/view/screens/Device_Data.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/device_integration/viewModel/getGFDataFromFHBRepo.dart';
import 'package:flutter/services.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import '../model/LastMeasureSync.dart';
import '../model/DeviceIntervalData.dart';
import 'package:myfhb/common/CommonUtil.dart';

Future<String> _loadDeviceDataAsset() async {
  return await rootBundle.loadString('assets/devices.json');
}

class DevicesViewModel with ChangeNotifier {
  GetGFDataFromFHBRepo _helper = GetGFDataFromFHBRepo();
  List<DeviceData> deviceList;

  List<DeviceData> getDeviceValues() {
    List<DeviceData> devicelist = new List<DeviceData>();
    devicelist.add(DeviceData(
        title: Constants.STR_BP_MONITOR,
        icon: Constants.Devices_BP,
        icon_new: Constants.Devices_BP_Tool,
        status: 0,
        isSelected: false,
        value_name: parameters.strDataTypeBP,
        value1: 'SYS',
        value2: 'DIS',
        color: [Colors.teal, Colors.tealAccent]));

    devicelist.add(DeviceData(
        title: Constants.STR_GLUCOMETER,
        icon: Constants.Devices_GL,
        icon_new: Constants.Devices_GL_Tool,
        status: 0,
        isSelected: false,
        value_name: parameters.strGlusoceLevel,
        value1: 'GL',
        value2: '',
        color: [Colors.red, Colors.redAccent]));
    devicelist.add(DeviceData(
        title: Constants.STR_PULSE_OXIMETER,
        icon: Constants.Devices_OxY,
        icon_new: Constants.Devices_OxY_Tool,
        status: 0,
        isSelected: false,
        value_name: parameters.strOxgenSaturation,
        value1: 'OS',
        value2: '',
        color: [Color(new CommonUtil().getMyPrimaryColor()), Color(new CommonUtil().getMyPrimaryColor())]));
    devicelist.add(DeviceData(
        title: Constants.STR_THERMOMETER,
        icon: Constants.Devices_THM,
        icon_new: Constants.Devices_THM_Tool,
        status: 0,
        isSelected: false,
        value_name: parameters.strTemperature,
        value1: 'TEMP',
        value2: '',
        color: [Colors.pink, Colors.pinkAccent]));
    devicelist.add(DeviceData(
        title: Constants.STR_WEIGHING_SCALE,
        icon: Constants.Devices_WS,
        icon_new: Constants.Devices_WS_Tool,
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

  Future<LastMeasureSyncValues> fetchDeviceDetails() async {
    try {
      final resp = await _helper.getLatestDeviceHealthRecord();
      String res = json.encode(resp);
      LastMeasureSync response = lastMeasureSyncFromJson(res);
      LastMeasureSyncValues result = response.result;

      //notifyListeners();
      return result;
    } catch (e) {}
  }

  Future<List<dynamic>> fetchBPDetails() async {
    try {
      final resp = await _helper.getBPData();
      if (resp == null) {
        return [];
      }
      final parsedResponse = json.decode(resp.toString())[dataResult] as List;
      List<DeviceIntervalData> deviceIntervalData =
          parsedResponse.map((e) => DeviceIntervalData.fromJson(e)).toList();
      List<dynamic> finalResult;
      List<BPResult> ret = new List();
      //List<HeartRateEntity> heartRate = new List();
      deviceIntervalData.forEach((dataElement) {
        if (dataElement.bloodPressureCollection.isEmpty) {
          return [];
        }
        dataElement.bloodPressureCollection.forEach((bpElement) {
          final bpList = BPResult(
              sourceType: dataElement.sourceType.description,
              startDateTime: bpElement.startDateTime.toIso8601String(),
              endDateTime: bpElement.endDateTime.toIso8601String(),
              systolic: bpElement.systolic,
              diastolic: bpElement.diastolic);
          ret.add(bpList);
        });

        /*dataElement.heartRateCollection.forEach((element) {
          final heartRateList = HeartRateEntity(bpm: element.bpm);
          heartRate.add(heartRateList);
        });*/

      });

      if(deviceIntervalData.length==0 || deviceIntervalData==null){
        deviceIntervalData =[];
      }

      if(ret.length==0 || ret==null){
        ret =[];
      }

      finalResult = [ret,deviceIntervalData];

      return finalResult;
    } catch (e) {}
  }

  Future<List<dynamic>> fetchGLDetails() async {
    try {
      final resp = await _helper.getBloodGlucoseData();
      if (resp == null) {
        return [];
      }
      final parsedResponse = json.decode(resp.toString())[dataResult] as List;
      List<DeviceIntervalData> deviceIntervalData =
          parsedResponse.map((e) => DeviceIntervalData.fromJson(e)).toList();
      List<dynamic> finalResult;
      List<GVResult> ret = new List();
      deviceIntervalData.forEach((dataElement) {
        if (dataElement.bloodGlucoseCollection.isEmpty) {
          return [];
        }
        dataElement.bloodGlucoseCollection.forEach((bgValue) {
          final bgList = GVResult(
              sourceType: dataElement.sourceType.description,
              startDateTime: bgValue.startDateTime.toIso8601String(),
              endDateTime: bgValue.endDateTime.toIso8601String(),
              bloodGlucoseLevel: bgValue.bloodGlucoseLevel,
              bgUnit:
                  (bgValue.bgUnit == null) ? null : bgValue.bgUnit.description,
              mealContext: (bgValue.mealContext == null)
                  ? null
                  : bgValue.mealContext.description,
              mealType: (bgValue.mealType == null)
                  ? null
                  : bgValue.mealType.description);
          ret.add(bgList);
        });
      });
      if(deviceIntervalData.length==0 || deviceIntervalData==null){
        deviceIntervalData =[];
      }

      if(ret.length==0 || ret==null){
        ret =[];
      }

      finalResult = [ret,deviceIntervalData];

      return finalResult;
    } catch (e) {}
  }

  Future<List<dynamic>> fetchOXYDetails(String response) async {
    try {
      final resp = await _helper.getOxygenSaturationData();
      if (resp == null) {
        return [];
      }
      final parsedResponse = json.decode(resp.toString())[dataResult] as List;
      List<DeviceIntervalData> deviceIntervalData =
          parsedResponse.map((e) => DeviceIntervalData.fromJson(e)).toList();
      List<dynamic> finalResult;
      List<OxyResult> ret = new List();
      //List<HeartRateEntity> heartRate = new List();
      deviceIntervalData.forEach((dataElement) {
        if (dataElement.oxygenSaturationCollection.isEmpty && dataElement.heartRateCollection.isEmpty) {
          return [];
        }
        dataElement.oxygenSaturationCollection.forEach((oxyValue) {
          final oxyList = OxyResult(
              sourceType: dataElement.sourceType.description,
              startDateTime: oxyValue.startDateTime.toIso8601String(),
              endDateTime: oxyValue.endDateTime.toIso8601String(),
              oxygenSaturation: oxyValue.oxygenSaturation);
          ret.add(oxyList);
        });
       /* dataElement.heartRateCollection.forEach((element) {
          final heartRateList = HeartRateEntity(bpm: element.bpm);
          heartRate.add(heartRateList);
        });*/
      });

      if(deviceIntervalData.length==0 || deviceIntervalData==null){
        deviceIntervalData =[];
      }

      if(ret.length==0 || ret==null){
        ret =[];
      }

      finalResult = [ret,deviceIntervalData];

      return finalResult;
    } catch (e) {}
  }

  Future<List<dynamic>> fetchTMPDetails() async {
    try {
      final resp = await _helper.getBodyTemperatureData();
      if (resp == null) {
        return [];
      }
      final parsedResponse = json.decode(resp.toString())[dataResult] as List;
      List<DeviceIntervalData> deviceIntervalData =
          parsedResponse.map((e) => DeviceIntervalData.fromJson(e)).toList();
      List<TMPResult> ret = new List();
      List<dynamic> finalResult;
      deviceIntervalData.forEach((dataElement) {
        if (dataElement.bodyTemperatureCollection.isEmpty) {
          return [];
        }
        dataElement.bodyTemperatureCollection.forEach((tempValue) {
          final tempList = TMPResult(
              sourceType: dataElement.sourceType.description,
              startDateTime: tempValue.startDateTime.toIso8601String(),
              endDateTime: tempValue.endDateTime.toIso8601String(),
              temperature: tempValue.temperature,
              temperatureUnit: tempValue.temperatureUnit.description);
          ret.add(tempList);
        });
      });
      if(deviceIntervalData.length==0 || deviceIntervalData==null){
        deviceIntervalData =[];
      }

      if(ret.length==0 || ret==null){
        ret =[];
      }

      finalResult = [ret,deviceIntervalData];

      return finalResult;
    } catch (e) {}
  }

  Future<List<dynamic>> fetchWVDetails(String response) async {
    try {
      final resp = await _helper.getWeightData();
      if (resp == null) {
        return [];
      }
      final parsedResponse = json.decode(resp.toString())[dataResult] as List;
      List<DeviceIntervalData> deviceIntervalData =
          parsedResponse.map((e) => DeviceIntervalData.fromJson(e)).toList();
      List<WVResult> ret = new List();
      List<dynamic> finalResult;
      deviceIntervalData.forEach((dataElement) {
        if (dataElement.bodyWeightCollection.isEmpty) {
          return [];
        }
        dataElement.bodyWeightCollection.forEach((weightValue) {
          final weightList = WVResult(
              sourceType: dataElement.sourceType.description,
              startDateTime: weightValue.startDateTime.toIso8601String(),
              endDateTime: weightValue.endDateTime.toIso8601String(),
              weight: weightValue.weight,
              weightUnit: weightValue.weightUnit.description);
          ret.add(weightList);
        });
      });
      if(deviceIntervalData.length==0 || deviceIntervalData==null){
        deviceIntervalData =[];
      }

      if(ret.length==0 || ret==null){
        ret =[];
      }

      finalResult = [ret,deviceIntervalData];

      return finalResult;
    } catch (e) {}
  }

  Future<List<HRResult>> fetchHeartRateDetails(String response) async {
    try {
      final resp = await _helper.getHeartRateData();
      if (resp == null) {
        return [];
      }
      final parsedResponse = json.decode(resp.toString())[dataResult] as List;
      List<DeviceIntervalData> deviceIntervalData =
          parsedResponse.map((e) => DeviceIntervalData.fromJson(e)).toList();
      List<HRResult> ret = new List();

      deviceIntervalData.forEach((dataElement) {
        if (dataElement.heartRateCollection.isEmpty) {
          return [];
        }
        dataElement.heartRateCollection.forEach((hearRateValue) {
          final heartRateList = HRResult(
              sourceType: dataElement.sourceType.description,
              startDateTime: hearRateValue.startDateTime.toIso8601String(),
              endDateTime: hearRateValue.endDateTime.toIso8601String(),
              bpm: hearRateValue.bpm);
          ret.add(heartRateList);
        });
      });
      return ret;
    } catch (e) {}
  }
}
