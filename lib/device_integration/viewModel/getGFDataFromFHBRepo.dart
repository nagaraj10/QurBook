//import 'dart:html';
//import 'package:myfhb/device_integration/google_fit/services/gfDataBaseHelper.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/src/resources/repository/deviceHealthRecords/DeviceHealthRecordRepository.dart';
import 'dart:convert' show json;

class GetGFDataFromFHBRepo {
  DeviceHealthRecord _deviceHealthRecord;
  Map<String, dynamic> body = new Map();

  String getFormatedDateFromMillis(String date) {
    var dateString =
        new DateTime.fromMicrosecondsSinceEpoch(int.parse(date) * 1000);
    return dateString.toIso8601String();
  }

  Future<dynamic> _getDataByDataType(String params) async {
    try {
      print("trying to query");
      _deviceHealthRecord = DeviceHealthRecord();
      print(params);
      final response = await _deviceHealthRecord.queryBydeviceInterval(params);
      return response;
    } catch (e) {
      print("unable to post the data $e");
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
      print("db query to get BP Data $params");
      var response = await _getDataByDataType(params);
      print("response for BPData $response");
      String res = json.encode(response);
      return res;
    } catch (e) {
      throw "Failed to retrieve BP data $e";
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
      print("db query to get HeartRate Data $params");
      var response = await _getDataByDataType(params);
      String res = json.encode(response);
      return res;
    } catch (e) {
      throw "Failed to retrieve Heart Rate data $e";
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
      print("db query to get Oxygen Saturation Data $params");
      var response = await _getDataByDataType(params);
      String res = json.encode(response);
      return res;
    } catch (e) {
      throw "Failed to retrieve Oxyegen Saturation data $e";
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
      print("db query to get weight Data $params");
      var response = await _getDataByDataType(params);
      String res = json.encode(response);
      return res;
    } catch (e) {
      throw "Failed to retrieve Weight data $e";
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
      print("db query to get Blood Glucose Data $params");
      var response = await _getDataByDataType(params);
      String res = json.encode(response);
      return res;
    } catch (e) {
      throw "Failed to retrieve Blood Glucose data $e";
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
      print("db query to get Body Temperature Data $params");
      var response = await _getDataByDataType(params);
      String res = json.encode(response);
      return res;
    } catch (e) {
      throw "Failed to retrieve Temperature data $e";
    }
  }

  Future<dynamic> getLatestDeviceHealthRecord() async {
    try {
      if (_deviceHealthRecord == null)
        _deviceHealthRecord = DeviceHealthRecord();
      var response = await _deviceHealthRecord.getlastMeasureSync();
      print("response from getLatestDeviceHealthRecord $response");
      return response;
    } catch (e) {
      throw "Get latest device record from FHB Backend Failed $e";
    }
  }
}
