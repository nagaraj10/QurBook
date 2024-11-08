import 'package:myfhb/common/CommonUtil.dart';

import '../../constants/fhb_parameters.dart';
import '../../src/resources/repository/deviceHealthRecords/DeviceHealthRecordRepository.dart';
import 'dart:convert' show json;

class GetGFDataFromFHBRepo {
  DeviceHealthRecord? _deviceHealthRecord;
  Map<String, dynamic> body = {};

  Future<dynamic> _getDataByDataType(String params,
      {String filter = '',String? userId}) async {
    try {
      _deviceHealthRecord = DeviceHealthRecord();
      print(params);
      var response = await _deviceHealthRecord!
          .queryBydeviceInterval(params, filter: filter,userId: userId);
      return response;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Future<dynamic> getBPData({String filter = '',String? userId}) async {
    body.clear();
    var now = DateTime.now();
    final currentdate = DateTime(now.year, now.month, now.day + 1);
    final startT =
        DateTime(now.year, now.month, now.day - 20, now.hour, now.minute);

    body[strStartTimeStamp] = startT.toIso8601String();
    body[strEndTimeStamp] = currentdate.toIso8601String();
    body[strdeviceDataType] = strDataTypeBP;
    final params = json.encode(body);
    try {
      final response = await _getDataByDataType(params, filter: filter,userId: userId);
      final res = json.encode(response);
      return res;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Future<dynamic> getHeartRateData() async {
    body.clear();
    var now = DateTime.now();
    final currentdate = DateTime(now.year, now.month, now.day + 1);
    final startT =
        DateTime(now.year, now.month, now.day - 20, now.hour, now.minute);

    body[strStartTimeStamp] = startT.toIso8601String();
    body[strEndTimeStamp] = currentdate.toIso8601String();
    body[strdeviceDataType] = strHeartRate;
    final params = json.encode(body).toString();
    try {
      final response = await _getDataByDataType(params);
      final res = json.encode(response);
      return res;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Future<dynamic> getOxygenSaturationData({String filter = '',String? userId}) async {
    body.clear();
    var now = DateTime.now();
    final currentdate = DateTime(now.year, now.month, now.day + 1);
    final startT =
        DateTime(now.year, now.month, now.day - 20, now.hour, now.minute);

    body[strStartTimeStamp] = startT.toIso8601String();
    body[strEndTimeStamp] = currentdate.toIso8601String();
    body[strdeviceDataType] = strOxgenSaturation;
    final params = json.encode(body);
    try {
      final response = await _getDataByDataType(params, filter: filter,userId: userId);
      var res = json.encode(response);
      return res;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Future<dynamic> getWeightData({String filter = '',String? userId}) async {
    body.clear();
    var now = DateTime.now();
    final currentdate = DateTime(now.year, now.month, now.day + 1);
    final startT =
        DateTime(now.year, now.month, now.day - 20, now.hour, now.minute);

    body[strStartTimeStamp] = startT.toIso8601String();
    body[strEndTimeStamp] = currentdate.toIso8601String();
    body[strdeviceDataType] = strWeight;
    var params = json.encode(body);
    try {
      final response = await _getDataByDataType(params, filter: filter,userId: userId);
      var res = json.encode(response);
      return res;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Future<dynamic> getBloodGlucoseData({String filter = '',String? userId}) async {
    body.clear();
    var now = DateTime.now();
    final currentdate = DateTime(now.year, now.month, now.day + 1);
    final startT =
        DateTime(now.year, now.month, now.day - 20, now.hour, now.minute);

    body[strStartTimeStamp] = startT.toIso8601String();
    body[strEndTimeStamp] = currentdate.toIso8601String();
    body[strdeviceDataType] = strGlusoceLevel;
    var params = json.encode(body);
    try {
      final response = await _getDataByDataType(params, filter: filter,userId: userId);
      final res = json.encode(response);
      return res;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Future<dynamic> getBodyTemperatureData({String filter = '',String? userId}) async {
    body.clear();
    var now = DateTime.now();
    final currentdate = DateTime(now.year, now.month, now.day + 1);
    final startT =
        DateTime(now.year, now.month, now.day - 20, now.hour, now.minute);

    body[strStartTimeStamp] = startT.toIso8601String();
    body[strEndTimeStamp] = currentdate.toIso8601String();
    body[strdeviceDataType] = strTemperature;
    final params = json.encode(body);
    try {
      final response = await _getDataByDataType(params, filter: filter,userId: userId);
      final res = json.encode(response);
      return res;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Future<dynamic> getLatestDeviceHealthRecord({String? userId}) async {
    try {
      if (_deviceHealthRecord == null) {
        _deviceHealthRecord = DeviceHealthRecord();
      }
      final response = await _deviceHealthRecord!.getlastMeasureSync(userId:userId);
      return response;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }
}
