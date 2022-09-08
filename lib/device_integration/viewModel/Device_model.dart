import 'dart:convert';

import 'package:flutter/material.dart';
import '../../constants/fhb_parameters.dart';
import '../model/BPValues.dart';
import '../model/GulcoseValues.dart';
import '../model/HeartRate.dart';
import '../model/OxySaturationValues.dart';
import '../model/TemperatureValues.dart';
import '../model/WeightValues.dart';
import '../model/HeartRateValues.dart';
import '../view/screens/Device_Data.dart';
import '../../constants/fhb_constants.dart' as Constants;
import 'getGFDataFromFHBRepo.dart';
import 'package:flutter/services.dart';
import '../../constants/fhb_parameters.dart' as parameters;
import '../model/LastMeasureSync.dart';
import '../model/DeviceIntervalData.dart';
import '../../common/CommonUtil.dart';

Future<String> _loadDeviceDataAsset() async {
  return await rootBundle.loadString('assets/devices.json');
}

class DevicesViewModel with ChangeNotifier {
  final GetGFDataFromFHBRepo _helper = GetGFDataFromFHBRepo();
  List<DeviceData> deviceList;

  List<DeviceData> getDeviceValues() {
    var devicelist = List<DeviceData>();
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
        color: [
          Color(CommonUtil().getMyPrimaryColor()),
          Color(CommonUtil().getMyPrimaryColor())
        ]));
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
    deviceList = getDeviceValues();
    return deviceList;
  }

  Future<LastMeasureSyncValues> fetchDeviceDetails() async {
    try {
      var resp = await _helper.getLatestDeviceHealthRecord();
      final res = json.encode(resp);
      final response = lastMeasureSyncFromJson(res);
      final result = response.result;

      //notifyListeners();
      return result;
    } catch (e) {}
  }

  Future<List<dynamic>> fetchBPDetails() async {
    try {
      var resp = await _helper.getBPData();
      if (resp == null) {
        return [];
      }
      var response = json.decode(resp.toString())[is_Success];
      if (!(response ?? false)) {
        return [];
      }
      var parsedResponse = json.decode(resp.toString())[dataResult] as List;
      var deviceIntervalData =
          parsedResponse.map((e) => DeviceIntervalData.fromJson(e)).toList();
      List<dynamic> finalResult;
      List<BPResult> ret = [];
      //List<HeartRateEntity> heartRate = new List();
      deviceIntervalData.forEach((dataElement) {
        if (dataElement.bloodPressureCollection.isEmpty) {
          return [];
        }
        dataElement.bloodPressureCollection.forEach((bpElement) {
          var bpList = BPResult(
              sourceType: dataElement.sourceType.description,
              startDateTime: bpElement.startDateTime.toIso8601String(),
              endDateTime: bpElement.endDateTime.toIso8601String(),
              systolic: bpElement.systolic,
              diastolic: bpElement.diastolic,
              bpm: dataElement.heartRateCollection.isNotEmpty
                  ? dataElement.heartRateCollection[0].bpm ?? null
                  : null,
              deviceId: dataElement.deviceId,
              dateTimeValue: bpElement.startDateTime);
          ret.add(bpList);
        });

        /*dataElement.heartRateCollection.forEach((element) {
          final heartRateList = HeartRateEntity(bpm: element.bpm);
          heartRate.add(heartRateList);
        });*/
      });

      if (deviceIntervalData.isEmpty || deviceIntervalData == null) {
        deviceIntervalData = [];
      }

      if (ret.isEmpty || ret == null) {
        ret = [];
      }

      finalResult = [ret, deviceIntervalData];

      return finalResult;
    } catch (e) {}
  }

  Future<List<dynamic>> fetchGLDetails() async {
    try {
      var resp = await _helper.getBloodGlucoseData();
      if (resp == null) {
        return [];
      }
      var response = json.decode(resp.toString())[is_Success];
      if (!(response ?? false)) {
        return [];
      }
      var parsedResponse = json.decode(resp.toString())[dataResult] as List;
      var deviceIntervalData =
          parsedResponse.map((e) => DeviceIntervalData.fromJson(e)).toList();
      List<dynamic> finalResult;
      var ret = List<GVResult>();
      deviceIntervalData.forEach((dataElement) {
        if (dataElement.bloodGlucoseCollection.isEmpty) {
          return [];
        }
        dataElement.bloodGlucoseCollection.forEach((bgValue) {
          var bgList = GVResult(
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
                  : bgValue.mealType.description,
              deviceId: dataElement.deviceId,
              dateTimeValue: bgValue.startDateTime);
          ret.add(bgList);
        });
      });
      if (deviceIntervalData.isEmpty || deviceIntervalData == null) {
        deviceIntervalData = [];
      }

      if (ret.isEmpty || ret == null) {
        ret = [];
      }

      finalResult = [ret, deviceIntervalData];

      return finalResult;
    } catch (e) {}
  }

  Future<List<dynamic>> fetchOXYDetails(String response) async {
    try {
      var resp = await _helper.getOxygenSaturationData();
      if (resp == null) {
        return [];
      }
      var response = json.decode(resp.toString())[is_Success];
      if (!(response ?? false)) {
        return [];
      }
      var parsedResponse = json.decode(resp.toString())[dataResult] as List;
      var deviceIntervalData =
          parsedResponse.map((e) => DeviceIntervalData.fromJson(e)).toList();
      List<dynamic> finalResult;
      var ret = <OxyResult>[];
      //List<HeartRateEntity> heartRate = new List();
      deviceIntervalData.forEach((dataElement) {
        if (dataElement.oxygenSaturationCollection.isEmpty &&
            dataElement.heartRateCollection.isEmpty) {
          return [];
        }
        dataElement.oxygenSaturationCollection.forEach((oxyValue) {
          var oxyList = OxyResult(
            sourceType: dataElement.sourceType.description,
            startDateTime: oxyValue.startDateTime.toIso8601String(),
            endDateTime: oxyValue.endDateTime.toIso8601String(),
            oxygenSaturation: oxyValue.oxygenSaturation,
            deviceId: dataElement.deviceId,
            dateTimeValue: oxyValue.startDateTime,
            bpm: dataElement.heartRateCollection.isEmpty
                ? ''
                : dataElement.heartRateCollection[0].bpm != null
                    ? dataElement.heartRateCollection[0].bpm.toString()
                    : '',
          );
          ret.add(oxyList);
        });
        /* dataElement.heartRateCollection.forEach((element) {
          final heartRateList = HeartRateEntity(bpm: element.bpm);
          heartRate.add(heartRateList);
        });*/
      });

      if (deviceIntervalData.isEmpty || deviceIntervalData == null) {
        deviceIntervalData = [];
      }

      if (ret.isEmpty || ret == null) {
        ret = [];
      }

      finalResult = [ret, deviceIntervalData];

      return finalResult;
    } catch (e) {}
  }

  Future<List<dynamic>> fetchTMPDetails() async {
    try {
      var resp = await _helper.getBodyTemperatureData();
      if (resp == null) {
        return [];
      }
      var response = json.decode(resp.toString())[is_Success];
      if (!(response ?? false)) {
        return [];
      }
      var parsedResponse = json.decode(resp.toString())[dataResult] as List;
      var deviceIntervalData =
          parsedResponse.map((e) => DeviceIntervalData.fromJson(e)).toList();
      List<TMPResult> ret = [];
      List<dynamic> finalResult;
      deviceIntervalData.forEach((dataElement) {
        if (dataElement.bodyTemperatureCollection.isEmpty) {
          return [];
        }
        dataElement.bodyTemperatureCollection.forEach((tempValue) {
          var tempList = TMPResult(
              sourceType: dataElement.sourceType.description,
              startDateTime: tempValue.startDateTime.toIso8601String(),
              endDateTime: tempValue.endDateTime.toIso8601String(),
              temperature: tempValue.temperature.toString(),
              temperatureUnit:
                  tempValue.temperatureUnit.code.capitalizeFirstofEach,
              deviceId: dataElement.deviceId,
              dateTimeValue: tempValue.startDateTime);
          ret.add(tempList);
        });
      });
      if (deviceIntervalData.isEmpty || deviceIntervalData == null) {
        deviceIntervalData = [];
      }

      if (ret.isEmpty || ret == null) {
        ret = [];
      }

      finalResult = [ret, deviceIntervalData];

      return finalResult;
    } catch (e) {
      print(e);
    }
  }

  Future<List<dynamic>> fetchWVDetails(String response) async {
    try {
      var resp = await _helper.getWeightData();
      if (resp == null) {
        return [];
      }
      var response = json.decode(resp.toString())[is_Success];
      if (!(response ?? false)) {
        return [];
      }
      var parsedResponse = json.decode(resp.toString())[dataResult] as List;
      var deviceIntervalData =
          parsedResponse.map((e) => DeviceIntervalData.fromJson(e)).toList();
      List<WVResult> ret = [];
      List<dynamic> finalResult;
      deviceIntervalData.forEach((dataElement) {
        if (dataElement.bodyWeightCollection.isEmpty) {
          return [];
        }
        dataElement.bodyWeightCollection.forEach((weightValue) {
          var weightList = WVResult(
              sourceType: dataElement.sourceType.description,
              startDateTime: weightValue.startDateTime.toIso8601String(),
              endDateTime: weightValue.endDateTime.toIso8601String(),
              weight: weightValue.weight.toString(),
              weightUnit: weightValue.weightUnit != null
                  ? weightValue.weightUnit.code
                  : 'kg',
              deviceId: dataElement.deviceId,
              dateTimeValue: weightValue.startDateTime);
          ret.add(weightList);
        });
      });
      if (deviceIntervalData.isEmpty || deviceIntervalData == null) {
        deviceIntervalData = [];
      }

      if (ret.isEmpty || ret == null) {
        ret = [];
      }

      finalResult = [ret, deviceIntervalData];

      return finalResult;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<HRResult>> fetchHeartRateDetails(String response) async {
    try {
      var resp = await _helper.getHeartRateData();
      if (resp == null) {
        return [];
      }
      var response = json.decode(resp.toString())[is_Success];
      if (!(response ?? false)) {
        return [];
      }
      var parsedResponse = json.decode(resp.toString())[dataResult] as List;
      final deviceIntervalData =
          parsedResponse.map((e) => DeviceIntervalData.fromJson(e)).toList();
      var ret = List<HRResult>();

      deviceIntervalData.forEach((dataElement) {
        if (dataElement.heartRateCollection.isEmpty) {
          return [];
        }
        dataElement.heartRateCollection.forEach((hearRateValue) {
          var heartRateList = HRResult(
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
