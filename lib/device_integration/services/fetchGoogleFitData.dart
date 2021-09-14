import '../../constants/fhb_parameters.dart';

import 'googleSignInHelper.dart';
import '../model/googleFitResponseModel.dart';
import '../model/googleFitDataset.dart';
import '../model/googleFitPoint.dart';
import '../model/googleFitBucket.dart';
import 'dart:async';
import 'dart:convert' show json;
import '../../common/PreferenceUtil.dart';
import '../../constants/fhb_constants.dart' as Constants;

class GoogleFitData {
  GoogleSignInHelper _signInHelper;
  final String _userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

  GoogleFitData() {
    _signInHelper = GoogleSignInHelper();
  }

  Future<bool> isSignedIn() async {
    final signedIn = await _signInHelper.isSignedIn();
    return signedIn;
  }

  Future<bool> signInSilently() async {
    final signedIn = await _signInHelper.signInSilently();
    return signedIn;
  }

  Future<bool> signIn() async {
    var ret = false;

    /*if (await isSignedIn()) {
      return await _signInHelper.handleScopes();
    }*/
    ret = await _signInHelper.handleSignIn();
    if (ret) {
      ret = await _signInHelper.handleScopes();
    }
    return ret;
  }

  Future<bool> signOut() async {
    return await _signInHelper.handleSignOut();
  }

  String getDataSourceBody(String startTime, String endTime, String type) {
    final Map data = {
      'aggregateBy': [
        {
          'dataTypeName': type,
          'dataSourceId': dataSourceID[type],
        }
      ],
      'startTimeMillis': startTime,
      'endTimeMillis': endTime
    };
    return json.encode(data);
  }

  String getFormatedDateFromMicro(String date) {
    final dateString =
        DateTime.fromMicrosecondsSinceEpoch(int.parse(date) * 1000);
    return dateString.toIso8601String();
  }

  String getFormatedDateFromNano(String date) {
    final micro = int.parse(date) / 1000;
    final dateString = DateTime.fromMicrosecondsSinceEpoch(micro.toInt());
    return dateString.toIso8601String();
  }

  Future<String> getWeightSummary(String startTime, String endTime) async {
    try {
      var jsonBody = getDataSourceBody(startTime, endTime, gfWeight);
      final String response = await _signInHelper.getDataAggregate(jsonBody);

      var responseHandler = ResponseFromJson(response);
      final healthRecord = Map<String, dynamic>();

      final Map<String, dynamic> userData = {};
      userData[strId] = _userID;

      healthRecord[strUser] = userData;

      for (final bucket in responseHandler.bucket) {
        healthRecord[strsyncStartDate] =
            getFormatedDateFromMicro(bucket.startTimeMillis);
        healthRecord[strsyncEndDate] =
            getFormatedDateFromMicro(bucket.endTimeMillis);
        healthRecord[strlocalTime] = DateTime.now().toLocal().toString();
        healthRecord[strlastSyncDateTime] =
            getFormatedDateFromMicro(bucket.endTimeMillis);
        healthRecord[strdevicesourceName] = strsourceGoogle;
        healthRecord[strdeviceType] = strWeighingScale;
        healthRecord[strdeviceDataType] = strWeight;

        var dataSet = <dynamic>[];

        for (var dataset in bucket.dataset) {
          for (var point in dataset.point) {
            final Map<String, dynamic> rawData = {};
            final timestampString =
                getFormatedDateFromNano(point.startTimeNanos);
            rawData[strStartTimeStamp] = timestampString;
            rawData[strEndTimeStamp] = timestampString;
            rawData[strStartTimeStampNano] = point.startTimeNanos;
            rawData[strEndTimeStampNano] = point.startTimeNanos;
            healthRecord[strsyncEndDate] = timestampString;
            healthRecord[strlastSyncDateTime] = timestampString;
            rawData[strParamWeight] = point.value[0].fpVal;
            rawData[strParamWeightUnit] = strValueWeightUnit;
            dataSet.add(rawData);
          }
        }
        if (dataSet.isEmpty) return null;
        healthRecord[strRawData] = dataSet;
        var params = json.encode(healthRecord);
        return params;
      }
    } catch (e) {
      return strWeight;
    }
  }

  Future<String> getBPSummary(String startTime, String endTime) async {
    try {
      final jsonBody = getDataSourceBody(startTime, endTime, gfBloodPressure);
      final String response = await _signInHelper.getDataAggregate(jsonBody);

      var responseHandler = ResponseFromJson(response);
      final Map<String, dynamic> healthRecord = {};
      final Map<String, dynamic> userData = {};
      userData[strId] = _userID;

      healthRecord[strUser] = userData;

      for (var bucket in responseHandler.bucket) {
        healthRecord[strsyncStartDate] =
            getFormatedDateFromMicro(bucket.startTimeMillis);
        healthRecord[strsyncEndDate] =
            getFormatedDateFromMicro(bucket.endTimeMillis);
        healthRecord[strlocalTime] = DateTime.now().toLocal().toString();
        healthRecord[strlastSyncDateTime] =
            getFormatedDateFromMicro(bucket.endTimeMillis);
        healthRecord[strdevicesourceName] = strsourceGoogle;
        healthRecord[strdeviceType] = strBPMonitor;
        healthRecord[strdeviceDataType] = strDataTypeBP;

        var dataSet = <dynamic>[];

        for (final dataset in bucket.dataset) {
          for (var point in dataset.point) {
            final rawData = Map<String, dynamic>();
            final timestampString =
                getFormatedDateFromNano(point.startTimeNanos);
            rawData[strStartTimeStamp] = timestampString;
            rawData[strEndTimeStamp] = timestampString;
            healthRecord[strsyncEndDate] = timestampString;
            healthRecord[strlastSyncDateTime] = timestampString;
            rawData[strStartTimeStampNano] = point.startTimeNanos;
            rawData[strEndTimeStampNano] = point.startTimeNanos;
            rawData[strParamSystolic] = point.value[0].fpVal;
            rawData[strParamDiastolic] = point.value[1].fpVal;
            dataSet.add(rawData);
          }
        }
        if (dataSet.isEmpty) return null;
        healthRecord[strRawData] = dataSet;
        var params = json.encode(healthRecord);
        return params;
      }
    } catch (e) {
      return strDataTypeBP;
    }
  }

  Future<String> getBloodGlucoseSummary(
      String startTime, String endTime) async {
    try {
      final jsonBody = getDataSourceBody(startTime, endTime, gfBloodGlucose);
      final String response = await _signInHelper.getDataAggregate(jsonBody);

      var responseHandler = ResponseFromJson(response);
      final Map<String, dynamic> healthRecord = {};

      var userData = Map<String, dynamic>();
      userData[strId] = _userID;

      healthRecord[strUser] = userData;

      for (final bucket in responseHandler.bucket) {
        healthRecord[strsyncStartDate] =
            getFormatedDateFromMicro(bucket.startTimeMillis);
        healthRecord[strsyncEndDate] =
            getFormatedDateFromMicro(bucket.endTimeMillis);
        healthRecord[strlocalTime] = DateTime.now().toLocal().toString();
        healthRecord[strlastSyncDateTime] =
            getFormatedDateFromMicro(bucket.endTimeMillis);
        healthRecord[strdevicesourceName] = strsourceGoogle;
        healthRecord[strdeviceType] = strGlucometer;
        healthRecord[strdeviceDataType] = strGlusoceLevel;

        final dataSet = <dynamic>[];

        for (var dataset in bucket.dataset) {
          for (final point in dataset.point) {
            final rawData = Map<String, dynamic>();
            var timestampString = getFormatedDateFromNano(point.startTimeNanos);
            rawData[strStartTimeStamp] = timestampString;
            rawData[strEndTimeStamp] = timestampString;
            rawData[strStartTimeStampNano] = point.startTimeNanos;
            rawData[strEndTimeStampNano] = point.startTimeNanos;
            healthRecord[strsyncEndDate] = timestampString;
            healthRecord[strlastSyncDateTime] = timestampString;
            rawData[strParamBGLevel] = point.value[0].fpVal;
            rawData[strParamBGUnit] = point.value[1].fpVal;
            rawData[strParamBGMealContext] = point.value[2].fpVal;
            rawData[strParamBGMealType] = point.value[4].fpVal;
            dataSet.add(rawData);
          }
        }
        if (dataSet.isEmpty) return null;
        healthRecord[strRawData] = dataSet;
        final params = json.encode(healthRecord);
        return params;
      }
    } catch (e) {
      return strGlusoceLevel;
    }
  }

  Future<String> getBodyTempSummary(String startTime, String endTime) async {
    try {
      var jsonBody = getDataSourceBody(startTime, endTime, gfBodyTemperature);
      final String response = await _signInHelper.getDataAggregate(jsonBody);

      var responseHandler = ResponseFromJson(response);
      final Map<String, dynamic> healthRecord = {};

      final userData = Map<String, dynamic>();
      userData[strId] = _userID;

      healthRecord[strUser] = userData;

      for (final bucket in responseHandler.bucket) {
        healthRecord[strsyncStartDate] =
            getFormatedDateFromMicro(bucket.startTimeMillis);
        healthRecord[strsyncEndDate] =
            getFormatedDateFromMicro(bucket.endTimeMillis);
        healthRecord[strlocalTime] = DateTime.now().toLocal().toString();
        healthRecord[strlastSyncDateTime] =
            getFormatedDateFromMicro(bucket.endTimeMillis);
        healthRecord[strdevicesourceName] = strsourceGoogle;
        healthRecord[strdeviceType] = strThermometer;
        healthRecord[strdeviceDataType] = strTemperature;

        var dataSet = <dynamic>[];

        for (var dataset in bucket.dataset) {
          for (var point in dataset.point) {
            var rawData = Map<String, dynamic>();
            var timestampString = getFormatedDateFromNano(point.startTimeNanos);
            rawData[strStartTimeStamp] = timestampString;
            rawData[strEndTimeStamp] = timestampString;
            rawData[strStartTimeStampNano] = point.startTimeNanos;
            rawData[strEndTimeStampNano] = point.startTimeNanos;
            healthRecord[strsyncEndDate] = timestampString;
            healthRecord[strlastSyncDateTime] = timestampString;
            rawData[strParamTemp] = point.value[0].fpVal;
            rawData[strParamTempUnit] = point.value[1].fpVal;
            dataSet.add(rawData);
          }
        }
        if (dataSet.isEmpty) return null;
        healthRecord[strRawData] = dataSet;
        final params = json.encode(healthRecord);
        return params;
      }
    } catch (e) {
      return strTemperature;
    }
  }

  Future<String> getOxygenSaturationSummary(
      String startTime, String endTime) async {
    try {
      var jsonBody = getDataSourceBody(startTime, endTime, gfOxygenSaturation);
      final String response = await _signInHelper.getDataAggregate(jsonBody);

      var responseHandler = ResponseFromJson(response);
      final healthRecord = Map<String, dynamic>();

      final userData = Map<String, dynamic>();
      userData[strId] = _userID;

      healthRecord[strUser] = userData;

      for (var bucket in responseHandler.bucket) {
        healthRecord[strsyncStartDate] =
            getFormatedDateFromMicro(bucket.startTimeMillis);
        healthRecord[strsyncEndDate] =
            getFormatedDateFromMicro(bucket.endTimeMillis);
        healthRecord[strlocalTime] = DateTime.now().toLocal().toString();
        healthRecord[strlastSyncDateTime] =
            getFormatedDateFromMicro(bucket.endTimeMillis);
        healthRecord[strdevicesourceName] = strsourceGoogle;
        healthRecord[strdeviceType] = strOxymeter;
        healthRecord[strdeviceDataType] = strOxgenSaturation;

        var dataSet = <dynamic>[];

        for (final dataset in bucket.dataset) {
          for (var point in dataset.point) {
            final Map<String, dynamic> rawData = {};
            final timestampString =
                getFormatedDateFromNano(point.startTimeNanos);
            rawData[strStartTimeStamp] = timestampString;
            rawData[strEndTimeStamp] = timestampString;
            rawData[strStartTimeStampNano] = point.startTimeNanos;
            rawData[strEndTimeStampNano] = point.startTimeNanos;
            healthRecord[strsyncEndDate] = timestampString;
            healthRecord[strlastSyncDateTime] = timestampString;
            rawData[strParamSystolic] = point.value[0].fpVal;
            rawData[strParamDiastolic] = point.value[1].fpVal;
            dataSet.add(rawData);
          }
        }
        if (dataSet.isEmpty) return null;
        healthRecord[strRawData] = dataSet;
        var params = json.encode(healthRecord);
        return params;
      }
    } catch (e) {
      return strOxgenSaturation;
    }
  }

  Future<String> getHeartRateSummary(String startTime, String endTime) async {
    try {
      final jsonBody = getDataSourceBody(startTime, endTime, gfHeartRate);
      final String response = await _signInHelper.getDataAggregate(jsonBody);

      var responseHandler = ResponseFromJson(response);
      final Map<String, dynamic> healthRecord = {};

      final Map<String, dynamic> userData = {};
      userData[strId] = _userID;

      healthRecord[strUser] = userData;

      for (final bucket in responseHandler.bucket) {
        healthRecord[strsyncStartDate] =
            getFormatedDateFromMicro(bucket.startTimeMillis);
        healthRecord[strsyncEndDate] =
            getFormatedDateFromMicro(bucket.endTimeMillis);
        healthRecord[strlocalTime] = DateTime.now().toLocal().toString();
        healthRecord[strlastSyncDateTime] =
            getFormatedDateFromMicro(bucket.endTimeMillis);
        healthRecord[strdevicesourceName] = strsourceGoogle;
        healthRecord[strdeviceType] = strOxymeter;
        healthRecord[strdeviceDataType] = strHeartRate;

        var dataSet = <dynamic>[];

        for (var dataset in bucket.dataset) {
          for (final point in dataset.point) {
            final Map<String, dynamic> rawData = {};
            final timestampString =
                getFormatedDateFromNano(point.startTimeNanos);
            rawData[strStartTimeStamp] = timestampString;
            rawData[strEndTimeStamp] = timestampString;
            rawData[strStartTimeStampNano] = point.startTimeNanos;
            rawData[strEndTimeStampNano] = point.startTimeNanos;
            healthRecord[strsyncEndDate] = timestampString;
            healthRecord[strlastSyncDateTime] = timestampString;
            rawData[strParamHeartRate] = point.value[0].fpVal;
            dataSet.add(rawData);
          }
        }
        if (dataSet.isEmpty) return null;
        healthRecord[strRawData] = dataSet;
        var params = json.encode(healthRecord);
        return params;
      }
    } catch (e) {
      return strHeartRate;
    }
  }
}
