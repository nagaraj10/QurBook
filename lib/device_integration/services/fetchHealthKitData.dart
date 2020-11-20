import 'package:health/health.dart';
import 'dart:async';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'dart:convert' show json;
import 'package:quiver/iterables.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;

class FetchHealthKitData {
  String _userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);
  Future<bool> activateHealthKit() async {
    try {
      bool ret = await Health.requestAuthorization();
      return ret;
    } catch (e) {
      throw "HealthKit activation failed with error $e";
    }
  }

  Future<String> getWeightData(DateTime startDate, DateTime endDate) async {
    if (await Health.requestAuthorization()) {
      try {
        Map<String, dynamic> healthRecord = new Map();

        Map<String, dynamic> userData = new Map();
        userData[strId] = _userID;

        healthRecord[strUser] = userData;

        List<HealthDataPoint> healthData = await Health.getHealthDataFromType(
            startDate, endDate, HealthDataType.WEIGHT);
        if (healthData.isNotEmpty) {
          healthRecord[strsyncStartDate] = startDate.toIso8601String();
          healthRecord[strsyncEndDate] = endDate.toIso8601String();
          healthRecord[strlastSyncDateTime] = endDate.toIso8601String();
          healthRecord[strdevicesourceName] = strsourceHK;
          healthRecord[strdeviceType] = strWeighingScale;
          healthRecord[strdeviceDataType] = strWeight;
          List<dynamic> dataSet = [];
          healthData.forEach((healthData) {
            Map<String, dynamic> rawData = new Map();
            rawData[strStartTimeStamp] = healthData.dateFrom.toIso8601String();
            rawData[strEndTimeStamp] = healthData.dateTo.toIso8601String();
            rawData[strParamWeight] = healthData.value;
            if (healthData.unit == hktWeightUnit) {
              rawData[strParamWeightUnit] = strValueWeightUnit;
            }
            dataSet.add(rawData);
          });
          healthRecord[strRawData] = dataSet;
          String params = json.encode(healthRecord);
          print(params);
          return params;
        }
      } catch (exception) {
        throw "Unable to fetch weight from HealthKit $exception";
      }
    }
  }

  Future<String> getHeartRateData(var startDate, var endDate) async {
    if (await Health.requestAuthorization()) {
      try {
        List<HealthDataPoint> healthData = await Health.getHealthDataFromType(
            startDate, endDate, HealthDataType.HEART_RATE);
        healthData = Health.removeDuplicates(healthData);
        Map<String, dynamic> healthRecord = new Map();

        Map<String, dynamic> userData = new Map();
        userData[strId] = _userID;

        healthRecord[strUser] = userData;

        if (healthData.isNotEmpty) {
          healthRecord[strsyncStartDate] = startDate.toIso8601String();
          healthRecord[strsyncEndDate] = endDate.toIso8601String();
          healthRecord[strlastSyncDateTime] = endDate.toIso8601String();
          healthRecord[strdevicesourceName] = strsourceHK;
          healthRecord[strdeviceType] = strOxymeter;
          healthRecord[strdeviceDataType] = strHeartRate;
          List<dynamic> dataSet = [];
          healthData.forEach((healthData) {
            Map<String, dynamic> rawData = new Map();
            rawData[strStartTimeStamp] = healthData.dateFrom.toIso8601String();
            rawData[strEndTimeStamp] = healthData.dateTo.toIso8601String();
            if (healthData.unit == hktHeartRateUnit) {
              rawData[strParamHeartRate] = healthData.value;
            }
            dataSet.add(rawData);
          });
          healthRecord[strRawData] = dataSet;
          String params = json.encode(healthRecord);
          print(params);
          return params;
        }
      } catch (exception) {
        throw "Unable to fetch Heart rate from HealthKit $exception";
      }
    }
  }

  Future<String> getBloodPressureData(var startDate, var endDate) async {
    if (await Health.requestAuthorization()) {
      try {
        List<HealthDataPoint> systolicData = await Health.getHealthDataFromType(
            startDate, endDate, HealthDataType.BLOOD_PRESSURE_SYSTOLIC);
        List<HealthDataPoint> diastolicData =
            await Health.getHealthDataFromType(
                startDate, endDate, HealthDataType.BLOOD_PRESSURE_DIASTOLIC);
        systolicData = Health.removeDuplicates(systolicData);
        diastolicData = Health.removeDuplicates(diastolicData);

        Map<String, dynamic> healthRecord = new Map();

        Map<String, dynamic> userData = new Map();
        userData[strId] = _userID;

        healthRecord[strUser] = userData;

        if (systolicData.isNotEmpty && diastolicData.isNotEmpty) {
          healthRecord[strsyncStartDate] = startDate.toIso8601String();
          healthRecord[strsyncEndDate] = endDate.toIso8601String();
          healthRecord[strlastSyncDateTime] = endDate.toIso8601String();
          healthRecord[strdevicesourceName] = strsourceHK;
          healthRecord[strdeviceType] = strBPMonitor;
          healthRecord[strdeviceDataType] = strDataTypeBP;
          List<dynamic> dataSet = [];
          for (var pair in zip([systolicData, diastolicData])) {
            if (pair[0].dateFrom == pair[1].dateFrom) {
              Map<String, dynamic> rawData = new Map();
              rawData[strStartTimeStamp] = pair[0].dateFrom.toIso8601String();
              rawData[strEndTimeStamp] = pair[0].dateTo.toIso8601String();
              rawData[strParamSystolic] = pair[0].value;
              rawData[strParamDiastolic] = pair[1].value;

              dataSet.add(rawData);
            }
          }
          healthRecord[strRawData] = dataSet;
          String params = json.encode(healthRecord);
          print(params);
          return params;
        }
      } catch (e) {
        throw "Unable to fetch Blood pressure from HealthKit $e";
      }
    }
  }

  Future<String> getBloodGlucoseData(var startDate, var endDate) async {
    if (await Health.requestAuthorization()) {
      try {
        /// Fetch BloodGlucose data
        List<HealthDataPoint> healthData = await Health.getHealthDataFromType(
            startDate, endDate, HealthDataType.BLOOD_GLUCOSE);
        healthData = Health.removeDuplicates(healthData);

        //healthData.forEach((list) => print("list for GLuecose: $list \n \n"));
        Map<String, dynamic> healthRecord = new Map();

        Map<String, dynamic> userData = new Map();
        userData[strId] = _userID;

        healthRecord[strUser] = userData;

        if (healthData.isNotEmpty) {
          healthRecord[strsyncStartDate] = startDate.toIso8601String();
          healthRecord[strsyncEndDate] = endDate.toIso8601String();
          healthRecord[strlastSyncDateTime] = endDate.toIso8601String();
          healthRecord[strdevicesourceName] = strsourceHK;
          healthRecord[strdeviceType] = strGlucometer;
          healthRecord[strdeviceDataType] = strGlusoceLevel;
          List<dynamic> dataSet = [];
          healthData.forEach((healthData) {
            Map<String, dynamic> rawData = new Map();
            rawData[strStartTimeStamp] = healthData.dateFrom.toIso8601String();
            rawData[strEndTimeStamp] = healthData.dateTo.toIso8601String();
            rawData[strParamBGLevel] = healthData.value;
            if (healthData.unit == hktGlucoseUnit) {
              rawData[strParamBGUnit] = strMGDL;
            }
            dataSet.add(rawData);
          });
          healthRecord[strRawData] = dataSet;
          String params = json.encode(healthRecord);
          return params;
        }
      } catch (exception) {
        throw "Unable to fetch Blood Glucose from HealthKit $exception";
      }
    }
  }

  Future<String> getBloodOxygenData(var startDate, var endDate) async {
    if (await Health.requestAuthorization()) {
      //print("Blood_Oxygen Summary");
      try {
        /// Fetch BloodOxygen data
        List<HealthDataPoint> healthData = await Health.getHealthDataFromType(
            startDate, endDate, HealthDataType.BLOOD_OXYGEN);

        healthData = Health.removeDuplicates(healthData);

        // healthData.forEach((list) => print("list for GLuecose: $list \n \n"));
        Map<String, dynamic> healthRecord = new Map();

        Map<String, dynamic> userData = new Map();
        userData[strId] = _userID;

        healthRecord[strUser] = userData;

        if (healthData.isNotEmpty) {
          healthRecord[strsyncStartDate] = startDate.toIso8601String();
          healthRecord[strsyncEndDate] = endDate.toIso8601String();
          healthRecord[strlastSyncDateTime] = endDate.toIso8601String();
          healthRecord[strdevicesourceName] = strsourceHK;
          healthRecord[strdeviceType] = strOxymeter;
          healthRecord[strdeviceDataType] = strOxgenSaturation;
          List<dynamic> dataSet = [];
          healthData.forEach((healthData) {
            Map<String, dynamic> rawData = new Map();
            rawData[strStartTimeStamp] = healthData.dateFrom.toIso8601String();
            rawData[strEndTimeStamp] = healthData.dateTo.toIso8601String();
            rawData[strParamOxygen] = healthData.value * 100;

            dataSet.add(rawData);
          });
          healthRecord[strRawData] = dataSet;
          String params = json.encode(healthRecord);
          return params;
        }
      } catch (exception) {
        throw "Unable to fetch Oxygen data from HealthKit $exception";
      }
    }
  }

  Future<String> getBodyTemperature(var startDate, var endDate) async {
    if (await Health.requestAuthorization()) {
      //print("Body_Temperature Summary");
      try {
        /// Fetch BodyTemperature data
        List<HealthDataPoint> healthData = await Health.getHealthDataFromType(
            startDate, endDate, HealthDataType.BODY_TEMPERATURE);
        healthData = Health.removeDuplicates(healthData);

        //healthData.forEach((list) => print("list for GLuecose: $list \n \n"));
        Map<String, dynamic> healthRecord = new Map();

        Map<String, dynamic> userData = new Map();
        userData[strId] = _userID;

        healthRecord[strUser] = userData;

        if (healthData.isNotEmpty) {
          healthRecord[strsyncStartDate] = startDate.toIso8601String();
          healthRecord[strsyncEndDate] = endDate.toIso8601String();
          healthRecord[strlastSyncDateTime] = endDate.toIso8601String();
          healthRecord[strdevicesourceName] = strsourceHK;
          healthRecord[strdeviceType] = strThermometer;
          healthRecord[strdeviceDataType] = strTemperature;
          List<dynamic> dataSet = [];
          healthData.forEach((healthData) {
            Map<String, dynamic> rawData = new Map();
            rawData[strStartTimeStamp] = healthData.dateFrom.toIso8601String();
            rawData[strEndTimeStamp] = healthData.dateTo.toIso8601String();
            rawData[strParamTemp] = healthData.value;
            if (healthData.unit == hktTemperatureUnit1) {
              rawData[strParamTempUnit] = strParamUnitCelsius;
            } else if (healthData.unit == hktTemperatureUnit2) {
              rawData[strParamTempUnit] = strParamUnitFarenheit;
            }
            dataSet.add(rawData);
          });
          healthRecord[strRawData] = dataSet;
          String params = json.encode(healthRecord);
          print(params);
        }
      } catch (exception) {
        throw "Unable to fetch Body Temperature from HealthKit $exception";
      }
    }
  }
}
