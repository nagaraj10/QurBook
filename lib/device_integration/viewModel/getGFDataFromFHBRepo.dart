import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/src/resources/repository/deviceHealthRecords/DeviceHealthRecordRepository.dart';
import 'dart:convert' show json;

class GetGFDataFromFHBRepo {
  DeviceHealthRecord _deviceHealthRecord;
  Map<String, dynamic> body = new Map();

  
  Future<dynamic> _getDataByDataType(String params) async {
    try {
      _deviceHealthRecord = DeviceHealthRecord();
      print(params);
      final response = await _deviceHealthRecord.queryBydeviceInterval(params);
      return response;
    } catch (e) {
    }
  }

  Future<dynamic> getBPData() async {
    body.clear();
    var currentdate = DateTime.now();
    var startT = new DateTime(currentdate.year, currentdate.month - 1,
        currentdate.day, currentdate.hour, currentdate.minute);

    body[strStartTimeStamp] = startT.toIso8601String();
    body[strEndTimeStamp] = currentdate.toIso8601String();
    body[strdeviceDataType] = strDataTypeBP;
    String params = json.encode(body);
    try {
      var response = await _getDataByDataType(params);
      String res = json.encode(response);
      return res;
    } catch (e) {
    }
  }

  Future<dynamic> getHeartRateData() async {
    body.clear();
    var currentdate = DateTime.now();
    var startT = new DateTime(currentdate.year, currentdate.month,
        currentdate.day - 10, currentdate.hour, currentdate.minute);

    body[strStartTimeStamp] = startT.toIso8601String();
    body[strEndTimeStamp] = currentdate.toIso8601String();
    body[strdeviceDataType] = strHeartRate;
    String params = json.encode(body).toString();
    try {
      var response = await _getDataByDataType(params);
      String res = json.encode(response);
      return res;
    } catch (e) {
    }
  }

  Future<dynamic> getOxygenSaturationData() async {
    body.clear();
    var currentdate = DateTime.now();
    var startT = new DateTime(currentdate.year, currentdate.month,
        currentdate.day - 2, currentdate.hour, currentdate.minute);

    body[strStartTimeStamp] = startT.toIso8601String();
    body[strEndTimeStamp] = currentdate.toIso8601String();
    body[strdeviceDataType] = strOxgenSaturation;
    String params = json.encode(body);
    try {
      var response = await _getDataByDataType(params);
      String res = json.encode(response);
      return res;
    } catch (e) {
    }
  }

  Future<dynamic> getWeightData() async {
    body.clear();
    var currentdate = DateTime.now();
    var startT = new DateTime(currentdate.year, currentdate.month,
        currentdate.day - 10, currentdate.hour, currentdate.minute);

    body[strStartTimeStamp] = startT.toIso8601String();
    body[strEndTimeStamp] = currentdate.toIso8601String();
    body[strdeviceDataType] = strWeight;
    String params = json.encode(body);
    try {
      var response = await _getDataByDataType(params);
      String res = json.encode(response);
      return res;
    } catch (e) {
    }
  }

  Future<dynamic> getBloodGlucoseData() async {
    body.clear();
    var currentdate = DateTime.now();
    var startT = new DateTime(currentdate.year, currentdate.month,
        currentdate.day - 10, currentdate.hour, currentdate.minute);

    body[strStartTimeStamp] = startT.toIso8601String();
    body[strEndTimeStamp] = currentdate.toIso8601String();
    body[strdeviceDataType] = strGlusoceLevel;
    String params = json.encode(body);
    try {
      var response = await _getDataByDataType(params);
      String res = json.encode(response);
      return res;
    } catch (e) {
    }
  }

  Future<dynamic> getBodyTemperatureData() async {
    body.clear();
    var currentdate = DateTime.now();
    var startT = new DateTime(currentdate.year, currentdate.month,
        currentdate.day - 10, currentdate.hour, currentdate.minute);

    body[strStartTimeStamp] = startT.toIso8601String();
    body[strEndTimeStamp] = currentdate.toIso8601String();
    body[strdeviceDataType] = strTemperature;
    String params = json.encode(body);
    try {
      var response = await _getDataByDataType(params);
      String res = json.encode(response);
      return res;
    } catch (e) {
    }
  }

  Future<dynamic> getLatestDeviceHealthRecord() async {
    try {
      if (_deviceHealthRecord == null)
        _deviceHealthRecord = DeviceHealthRecord();
      var response = await _deviceHealthRecord.getlastMeasureSync();
      return response;
    } catch (e) {
    }
  }
}
