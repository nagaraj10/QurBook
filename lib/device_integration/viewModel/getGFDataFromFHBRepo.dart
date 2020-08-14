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
      var response = await _deviceHealthRecord.queryBydeviceInterval(params);
      print("response from querty $response");
      return response;
    } catch (e) {
      print("unable to post the data $e");
    }
  }

  /*Future<void> getLatestData(String dataType) async {
    String startTime = "1596911400000";
    String endTime = "1597084200000";

    if (dataType == strDataTypeBP) {
      getBPData(startTime, endTime, strsourceGoogle);
    } else if (dataType == strGlusoceLevel) {
      getBloodGlucoseData(startTime, endTime, strsourceGoogle);
    } else if (dataType == strWeight) {
      getWeightData(startTime, endTime, strsourceGoogle);
    } else if (dataType == strHeartRate) {
      getHeartRateData(startTime, endTime, strsourceGoogle);
    } else if (dataType == strTemperature) {
      getBodyTemperatureData(startTime, endTime, strsourceGoogle);
    }
  }*/

  Future<String> getBPData(
      /*String startDate, String endDate, String source*/) async {
    body.clear();
    var currentdate = DateTime.now();
    var startT = new DateTime(currentdate.year, currentdate.month - 1,
        currentdate.day, currentdate.hour, currentdate.minute);

    body[strStartTimeStamp] = startT.toIso8601String();
    body[strEndTimeStamp] = currentdate.toIso8601String();
    //body[strdevicesourceName] = source;
    //body[strdeviceType] = strBPMonitor;
    body[strdeviceDataType] = strDataTypeBP;
    String params = json.encode(body);
    try {
      print("db query to get BP Data $params");
      var response = await _getDataByDataType(params);
      print("response for BPData $response");
    } catch (e) {}
  }

  Future<String> getHeartRateData(
      /*String startDate, String endDate, String source*/) async {
    body.clear();
    var currentdate = DateTime.now();
    var startT = new DateTime(currentdate.year, currentdate.month - 2,
        currentdate.day, currentdate.hour, currentdate.minute);

    body[strStartTimeStamp] = startT.toIso8601String();
    body[strEndTimeStamp] = currentdate.toIso8601String();
    //body[strdevicesourceName] = source;
    //body[strdeviceType] = strOxymeter;
    body[strdeviceDataType] = strHeartRate;
    String params = json.encode(body).toString();
    try {
      print("db query to get HeartRate Data $params");
      var response = await _getDataByDataType(params);
    } catch (e) {}
  }

  Future<String> getOxygenSaturationData(
      /*String startDate, String endDate, String source*/) async {
    body.clear();
    var currentdate = DateTime.now();
    var startT = new DateTime(currentdate.year, currentdate.month - 2,
        currentdate.day, currentdate.hour, currentdate.minute);

    body[strStartTimeStamp] = startT.toIso8601String();
    body[strEndTimeStamp] = currentdate.toIso8601String();
    //body[strdevicesourceName] = source;
    //body[strdeviceType] = strBPMonitor;
    body[strdeviceDataType] = strDataTypeBP;
    String params = json.encode(body);
    try {
      print("db query to get Oxygen Saturation Data $params");
      var response = await _getDataByDataType(params);
    } catch (e) {}
  }

  Future<String> getWeightData(
      /*String startDate, String endDate, String source*/) async {
    body.clear();
    var currentdate = DateTime.now();
    var startT = new DateTime(currentdate.year, currentdate.month - 2,
        currentdate.day, currentdate.hour, currentdate.minute);

    body[strStartTimeStamp] = startT.toIso8601String();
    body[strEndTimeStamp] = currentdate.toIso8601String();
    //body[strdevicesourceName] = source;
    //body[strdeviceType] = strWeighingScale;
    body[strdeviceDataType] = strWeight;
    String params = json.encode(body);
    try {
      print("db query to get weight Data $params");
      var response = await _getDataByDataType(params);
    } catch (e) {}
  }

  Future<String> getBloodGlucoseData(
      /*String startDate, String endDate, String source*/) async {
    body.clear();
    var currentdate = DateTime.now();
    var startT = new DateTime(currentdate.year, currentdate.month - 2,
        currentdate.day, currentdate.hour, currentdate.minute);

    body[strStartTimeStamp] = startT.toIso8601String();
    body[strEndTimeStamp] = currentdate.toIso8601String();
    //body[strdevicesourceName] = source;
    //body[strdeviceType] = strGlucometer;
    body[strdeviceDataType] = strGlusoceLevel;
    String params = json.encode(body);
    try {
      print("db query to get Blood Glucose Data $params");
      var response = await _getDataByDataType(params);
    } catch (e) {}
  }

  Future<String> getBodyTemperatureData(
      /*String startDate, String endDate, String source*/) async {
    body.clear();
    var currentdate = DateTime.now();
    var startT = new DateTime(currentdate.year, currentdate.month - 2,
        currentdate.day, currentdate.hour, currentdate.minute);

    body[strStartTimeStamp] = startT.toIso8601String();
    body[strEndTimeStamp] = currentdate.toIso8601String();
    //body[strdevicesourceName] = source;
    //body[strdeviceType] = strThermometer;
    body[strdeviceDataType] = strTemperature;
    String params = json.encode(body);
    try {
      print("db query to get Body Temperature Data $params");
      var response = await _getDataByDataType(params);
    } catch (e) {}
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
