import 'package:myfhb/constants/fhb_parameters.dart';

import 'package:myfhb/device_integration/services/googleSignInHelper.dart';
import 'package:myfhb/device_integration/model/googleFitResponseModel.dart';
import 'dart:async';
import 'dart:convert' show json;

class GoogleFitData {
  GoogleSignInHelper _signInHelper;

  FetchGoogleFitData() {
    _signInHelper = GoogleSignInHelper();
  }

  Future<bool> isSignedIn() async {
    bool signedIn = await _signInHelper.isSignedIn();
    return signedIn;
  }

  Future<void> signIn() async {
    await _signInHelper.handleSignIn();
    await _signInHelper.handleScopes();
  }

  Future<void> signOut() async {
    await _signInHelper.handleSignOut();
  }

  String getDataSourceBody(String startTime, String endTime, String type) {
    Map data = {
      "aggregateBy": [
        {
          "dataTypeName": type,
          "dataSourceId": dataSourceID[type],
        }
      ],
      "startTimeMillis": startTime,
      "endTimeMillis": endTime
    };
    return json.encode(data);
  }

  String getFormatedDateFromMicro(String date) {
    var dateString =
        new DateTime.fromMicrosecondsSinceEpoch(int.parse(date) * 1000);
    return dateString.toIso8601String();
  }

  String getFormatedDateFromNano(String date) {
    var micro = int.parse(date) / 1000;
    var dateString = new DateTime.fromMicrosecondsSinceEpoch(micro.toInt());
    return dateString.toIso8601String();
  }

  Future<String> getWeightSummary(String startTime, String endTime) async {
    String jsonBody = getDataSourceBody(startTime, endTime, gfWeight);
    String response = await _signInHelper.getDataAggregate(jsonBody);

    final responseHandler = ResponseFromJson(response);
    Map<String, dynamic> healthRecord = new Map();

    for (Bucket bucket in responseHandler.bucket) {
      healthRecord[strsyncStartDate] =
          getFormatedDateFromMicro(bucket.startTimeMillis);
      healthRecord[strsyncEndDate] =
          getFormatedDateFromMicro(bucket.endTimeMillis);
      healthRecord[strlastSyncDateTime] =
          getFormatedDateFromMicro(bucket.endTimeMillis);
      healthRecord[strdevicesourceName] = strsourceGoogle;
      healthRecord[strdeviceType] = strWeighingScale;
      healthRecord[strdeviceDataType] = strWeight;

      List<dynamic> dataSet = [];

      for (Dataset dataset in bucket.dataset) {
        for (Point point in dataset.point) {
          Map<String, dynamic> rawData = new Map();
          String timestampString =
              getFormatedDateFromNano(point.startTimeNanos);
          rawData[strStartTimeStamp] = timestampString;
          rawData[strEndTimeStamp] = timestampString;
          rawData[strParamWeight] = point.value[0].fpVal;
          rawData[strParamWeightUnit] = strValueWeightUnit;
          dataSet.add(rawData);
        }
      }
      if (dataSet.isEmpty) return null;
      healthRecord[strRawData] = dataSet;
      String params = json.encode(healthRecord);
      return params;
    }
  }

  Future<String> getBPSummary(String startTime, String endTime) async {
    String jsonBody = getDataSourceBody(startTime, endTime, gfBloodPressure);
    String response = await _signInHelper.getDataAggregate(jsonBody);

    final responseHandler = ResponseFromJson(response);
    Map<String, dynamic> healthRecord = new Map();

    for (Bucket bucket in responseHandler.bucket) {
      healthRecord[strsyncStartDate] =
          getFormatedDateFromMicro(bucket.startTimeMillis);
      healthRecord[strsyncEndDate] =
          getFormatedDateFromMicro(bucket.endTimeMillis);
      healthRecord[strlastSyncDateTime] =
          getFormatedDateFromMicro(bucket.endTimeMillis);
      healthRecord[strdevicesourceName] = strsourceGoogle;
      healthRecord[strdeviceType] = strBPMonitor;
      healthRecord[strdeviceDataType] = strDataTypeBP;

      List<dynamic> dataSet = [];

      for (Dataset dataset in bucket.dataset) {
        for (Point point in dataset.point) {
          Map<String, dynamic> rawData = new Map();
          String timestampString =
              getFormatedDateFromNano(point.startTimeNanos);
          rawData[strStartTimeStamp] = timestampString;
          rawData[strEndTimeStamp] = timestampString;
          rawData[strParamSystolic] = point.value[0].fpVal;
          rawData[strParamDiastolic] = point.value[1].fpVal;
          dataSet.add(rawData);
        }
      }
      if (dataSet.isEmpty) return null;
      healthRecord[strRawData] = dataSet;
      String params = json.encode(healthRecord);
      return params;
    }
  }

  Future<String> getBloodGlucoseSummary(
      String startTime, String endTime) async {
    String jsonBody = getDataSourceBody(startTime, endTime, gfBloodGlucose);
    String response = await _signInHelper.getDataAggregate(jsonBody);

    final responseHandler = ResponseFromJson(response);
    Map<String, dynamic> healthRecord = new Map();

    for (Bucket bucket in responseHandler.bucket) {
      healthRecord[strsyncStartDate] =
          getFormatedDateFromMicro(bucket.startTimeMillis);
      healthRecord[strsyncEndDate] =
          getFormatedDateFromMicro(bucket.endTimeMillis);
      healthRecord[strlastSyncDateTime] =
          getFormatedDateFromMicro(bucket.endTimeMillis);
      healthRecord[strdevicesourceName] = strsourceGoogle;
      healthRecord[strdeviceType] = strGlucometer;
      healthRecord[strdeviceDataType] = strGlusoceLevel;

      List<dynamic> dataSet = [];

      for (Dataset dataset in bucket.dataset) {
        for (Point point in dataset.point) {
          Map<String, dynamic> rawData = new Map();
          String timestampString =
              getFormatedDateFromNano(point.startTimeNanos);
          rawData[strStartTimeStamp] = timestampString;
          rawData[strEndTimeStamp] = timestampString;
          rawData[strParamBGLevel] = point.value[0].fpVal;
          rawData[strParamBGUnit] = point.value[1].fpVal;
          rawData[strParamBGMealContext] = point.value[2].fpVal;
          rawData[strParamBGMealType] = point.value[4].fpVal;
          dataSet.add(rawData);
        }
      }
      if (dataSet.isEmpty) return null;
      healthRecord[strRawData] = dataSet;
      String params = json.encode(healthRecord);
      return params;
    }
  }

  Future<String> getBodyTempSummary(String startTime, String endTime) async {
    String jsonBody = getDataSourceBody(startTime, endTime, gfBodyTemperature);
    String response = await _signInHelper.getDataAggregate(jsonBody);

    final responseHandler = ResponseFromJson(response);
    Map<String, dynamic> healthRecord = new Map();

    for (Bucket bucket in responseHandler.bucket) {
      healthRecord[strsyncStartDate] =
          getFormatedDateFromMicro(bucket.startTimeMillis);
      healthRecord[strsyncEndDate] =
          getFormatedDateFromMicro(bucket.endTimeMillis);
      healthRecord[strlastSyncDateTime] =
          getFormatedDateFromMicro(bucket.endTimeMillis);
      healthRecord[strdevicesourceName] = strsourceGoogle;
      healthRecord[strdeviceType] = strThermometer;
      healthRecord[strdeviceDataType] = strTemperature;

      List<dynamic> dataSet = [];

      for (Dataset dataset in bucket.dataset) {
        for (Point point in dataset.point) {
          Map<String, dynamic> rawData = new Map();
          String timestampString =
              getFormatedDateFromNano(point.startTimeNanos);
          rawData[strStartTimeStamp] = timestampString;
          rawData[strEndTimeStamp] = timestampString;
          rawData[strParamTemp] = point.value[0].fpVal;
          rawData[strParamTempUnit] = point.value[1].fpVal;
          dataSet.add(rawData);
        }
      }
      if (dataSet.isEmpty) return null;
      healthRecord[strRawData] = dataSet;
      String params = json.encode(healthRecord);
      return params;
    }
  }

  Future<String> getOxygenSaturationSummary(
      String startTime, String endTime) async {
    String jsonBody = getDataSourceBody(startTime, endTime, gfOxygenSaturation);
    String response = await _signInHelper.getDataAggregate(jsonBody);

    final responseHandler = ResponseFromJson(response);
    Map<String, dynamic> healthRecord = new Map();

    for (Bucket bucket in responseHandler.bucket) {
      healthRecord[strsyncStartDate] =
          getFormatedDateFromMicro(bucket.startTimeMillis);
      healthRecord[strsyncEndDate] =
          getFormatedDateFromMicro(bucket.endTimeMillis);
      healthRecord[strlastSyncDateTime] =
          getFormatedDateFromMicro(bucket.endTimeMillis);
      healthRecord[strdevicesourceName] = strsourceGoogle;
      healthRecord[strdeviceType] = strOxymeter;
      healthRecord[strdeviceDataType] = strOxgenSaturation;

      List<dynamic> dataSet = [];

      for (Dataset dataset in bucket.dataset) {
        for (Point point in dataset.point) {
          Map<String, dynamic> rawData = new Map();
          String timestampString =
              getFormatedDateFromNano(point.startTimeNanos);
          rawData[strStartTimeStamp] = timestampString;
          rawData[strEndTimeStamp] = timestampString;
          rawData[strParamSystolic] = point.value[0].fpVal;
          rawData[strParamDiastolic] = point.value[1].fpVal;
          dataSet.add(rawData);
        }
      }
      if (dataSet.isEmpty) return null;
      healthRecord[strRawData] = dataSet;
      String params = json.encode(healthRecord);
      return (params);
    }
  }

  Future<String> getHeartRateSummary(String startTime, String endTime) async {
    String jsonBody = getDataSourceBody(startTime, endTime, gfHeartRate);
    String response = await _signInHelper.getDataAggregate(jsonBody);

    final responseHandler = ResponseFromJson(response);
    Map<String, dynamic> healthRecord = new Map();

    for (Bucket bucket in responseHandler.bucket) {
      healthRecord[strsyncStartDate] =
          getFormatedDateFromMicro(bucket.startTimeMillis);
      healthRecord[strsyncEndDate] =
          getFormatedDateFromMicro(bucket.endTimeMillis);
      healthRecord[strlastSyncDateTime] =
          getFormatedDateFromMicro(bucket.endTimeMillis);
      healthRecord[strdevicesourceName] = strsourceGoogle;
      healthRecord[strdeviceType] = strOxymeter;
      healthRecord[strdeviceDataType] = strHeartRate;

      List<dynamic> dataSet = [];

      for (Dataset dataset in bucket.dataset) {
        for (Point point in dataset.point) {
          Map<String, dynamic> rawData = new Map();
          String timestampString =
              getFormatedDateFromNano(point.startTimeNanos);
          rawData[strStartTimeStamp] = timestampString;
          rawData[strEndTimeStamp] = timestampString;
          rawData[strParamHeartRate] = point.value[0].fpVal;
          dataSet.add(rawData);
        }
      }
      if (dataSet.isEmpty) return null;
      healthRecord[strRawData] = dataSet;
      String params = json.encode(healthRecord);
      return params;
    }
  }
}
