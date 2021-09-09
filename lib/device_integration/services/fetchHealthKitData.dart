import 'package:health/health.dart';
import 'dart:async';
import '../../constants/fhb_parameters.dart';
import 'dart:convert' show json;
import 'package:quiver/iterables.dart';
import '../../common/PreferenceUtil.dart';
import '../../constants/fhb_constants.dart' as Constants;

class FetchHealthKitData {
  final String _userID = PreferenceUtil.getStringValue(Constants.KEY_USERID);

  HealthFactory Health = HealthFactory();
  List<HealthDataType> types = [
    HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
    HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
    HealthDataType.WEIGHT,
    HealthDataType.HEIGHT,
    HealthDataType.BLOOD_GLUCOSE,
    HealthDataType.BLOOD_OXYGEN,
    HealthDataType.BODY_TEMPERATURE,
  ];

  Future<bool> activateHealthKit() async {
    try {
      var ret = await Health.requestAuthorization(types);
      return ret;
    } catch (e) {
      throw 'HealthKit activation failed with error $e';
    }
  }

  Future<String> getWeightData(DateTime startDate, DateTime endDate) async {
    if (await Health.requestAuthorization(types)) {
      try {
        final Map<String, dynamic> healthRecord = {};

        final Map<String, dynamic> userData = {};
        userData[strId] = _userID;

        healthRecord[strUser] = userData;

        var healthData = await Health.getHealthDataFromTypes(
            startDate, endDate, [HealthDataType.WEIGHT]);
        healthData = HealthFactory.removeDuplicates(healthData);
        if (healthData.isNotEmpty) {
          healthRecord[strsyncStartDate] = startDate.toIso8601String();
          healthRecord[strsyncEndDate] = endDate.toIso8601String();
          healthRecord[strlocalTime] = DateTime.now().toLocal();
          healthRecord[strlastSyncDateTime] = endDate.toIso8601String();
          healthRecord[strdevicesourceName] = strsourceHK;
          healthRecord[strdeviceType] = strWeighingScale;
          healthRecord[strdeviceDataType] = strWeight;
          var dataSet = <dynamic>[];
          healthData.forEach((healthData) {
            print('----------------------health data -------------------');
            print(healthData.unit);
            final Map<String, dynamic> rawData = {};
            rawData[strStartTimeStamp] = healthData.dateFrom.toIso8601String();
            rawData[strEndTimeStamp] = healthData.dateTo.toIso8601String();
            rawData[strStartTimeStampNano] =
                healthData.dateFrom.microsecondsSinceEpoch.abs() * 1000;
            rawData[strEndTimeStampNano] =
                healthData.dateTo.microsecondsSinceEpoch.abs() * 1000;
            rawData[strParamWeight] = healthData.value;
            if (healthData.unitString == hktWeightUnit) {
              rawData[strParamWeightUnit] = strValueWeightUnit;
            }
            dataSet.add(rawData);
          });
          healthRecord[strRawData] = dataSet;
          var params = json.encode(healthRecord);
          print(
              '-------------------------weight-------------------------------------');
          print(params);
          return params;
        }
      } catch (exception) {
        throw 'Unable to fetch weight from HealthKit $exception';
      }
    }
  }

  Future<String> getHeartRateData(var startDate, var endDate) async {
    if (await Health.requestAuthorization(types)) {
      try {
        var healthData = await Health.getHealthDataFromTypes(
            startDate, endDate, [HealthDataType.HEART_RATE]);
        healthData = HealthFactory.removeDuplicates(healthData);
        final healthRecord = Map<String, dynamic>();

        final userData = Map<String, dynamic>();
        userData[strId] = _userID;

        healthRecord[strUser] = userData;

        if (healthData.isNotEmpty) {
          healthRecord[strsyncStartDate] = startDate.toIso8601String();
          healthRecord[strsyncEndDate] = endDate.toIso8601String();
          healthRecord[strlocalTime] = DateTime.now().toLocal();
          healthRecord[strlastSyncDateTime] = endDate.toIso8601String();
          healthRecord[strdevicesourceName] = strsourceHK;
          healthRecord[strdeviceType] = strOxymeter;
          healthRecord[strdeviceDataType] = strHeartRate;
          final dataSet = <dynamic>[];
          healthData.forEach((healthData) {
            final Map<String, dynamic> rawData = {};
            rawData[strStartTimeStamp] = healthData.dateFrom.toIso8601String();
            rawData[strEndTimeStamp] = healthData.dateTo.toIso8601String();
            rawData[strStartTimeStampNano] =
                healthData.dateFrom.microsecondsSinceEpoch.abs() * 1000;
            rawData[strEndTimeStampNano] =
                healthData.dateTo.microsecondsSinceEpoch.abs() * 1000;
            if (healthData.unitString == hktHeartRateUnit) {
              rawData[strParamHeartRate] = healthData.value;
            }
            dataSet.add(rawData);
          });
          healthRecord[strRawData] = dataSet;
          var params = json.encode(healthRecord);
          print(params);
          return params;
        }
      } catch (exception) {
        throw 'Unable to fetch Heart rate from HealthKit $exception';
      }
    }
  }

  Future<String> getBloodPressureData(var startDate, var endDate) async {
    if (await Health.requestAuthorization(types)) {
      try {
        var systolicData = await Health.getHealthDataFromTypes(
            startDate, endDate, [HealthDataType.BLOOD_PRESSURE_SYSTOLIC]);
        var diastolicData = await Health.getHealthDataFromTypes(
            startDate, endDate, [HealthDataType.BLOOD_PRESSURE_DIASTOLIC]);
        systolicData = HealthFactory.removeDuplicates(systolicData);
        diastolicData = HealthFactory.removeDuplicates(diastolicData);

        final healthRecord = Map<String, dynamic>();

        var userData = Map<String, dynamic>();
        userData[strId] = _userID;

        healthRecord[strUser] = userData;

        if (systolicData.isNotEmpty && diastolicData.isNotEmpty) {
          healthRecord[strsyncStartDate] = startDate.toIso8601String();
          healthRecord[strsyncEndDate] = endDate.toIso8601String();
          healthRecord[strlocalTime] = DateTime.now().toLocal();
          healthRecord[strlastSyncDateTime] = endDate.toIso8601String();
          healthRecord[strdevicesourceName] = strsourceHK;
          healthRecord[strdeviceType] = strBPMonitor;
          healthRecord[strdeviceDataType] = strDataTypeBP;
          var dataSet = <dynamic>[];
          for (final pair in zip([systolicData, diastolicData])) {
            if (pair[0].dateFrom == pair[1].dateFrom) {
              final rawData = Map<String, dynamic>();
              rawData[strStartTimeStamp] = pair[0].dateFrom.toIso8601String();
              rawData[strEndTimeStamp] = pair[0].dateTo.toIso8601String();
              rawData[strStartTimeStampNano] =
                  pair[0].dateFrom.microsecondsSinceEpoch.abs() * 1000;
              rawData[strEndTimeStampNano] =
                  pair[0].dateTo.microsecondsSinceEpoch.abs() * 1000;
              rawData[strParamSystolic] = pair[0].value;
              rawData[strParamDiastolic] = pair[1].value;

              dataSet.add(rawData);
            }
          }
          healthRecord[strRawData] = dataSet;
          final params = json.encode(healthRecord);
          print(
              '-------------------------Bp-------------------------------------');
          print(params);
          return params;
        }
      } catch (e) {
        throw 'Unable to fetch Blood pressure from HealthKit $e';
      }
    }
  }

  Future<String> getBloodGlucoseData(var startDate, var endDate) async {
    if (await Health.requestAuthorization(types)) {
      try {
        /// Fetch BloodGlucose data
        var healthData = await Health.getHealthDataFromTypes(
            startDate, endDate, [HealthDataType.BLOOD_GLUCOSE]);
        healthData = HealthFactory.removeDuplicates(healthData);

        //healthData.forEach((list) => print("list for GLuecose: $list \n \n"));
        final Map<String, dynamic> healthRecord = {};

        final userData = Map<String, dynamic>();
        userData[strId] = _userID;

        healthRecord[strUser] = userData;

        if (healthData.isNotEmpty) {
          healthRecord[strsyncStartDate] = startDate.toIso8601String();
          healthRecord[strsyncEndDate] = endDate.toIso8601String();
          healthRecord[strlocalTime] = DateTime.now().toLocal();
          healthRecord[strlastSyncDateTime] = endDate.toIso8601String();
          healthRecord[strdevicesourceName] = strsourceHK;
          healthRecord[strdeviceType] = strGlucometer;
          healthRecord[strdeviceDataType] = strGlusoceLevel;
          final dataSet = <dynamic>[];
          healthData.forEach((healthData) {
            final Map<String, dynamic> rawData = {};
            rawData[strStartTimeStamp] = healthData.dateFrom.toIso8601String();
            rawData[strEndTimeStamp] = healthData.dateTo.toIso8601String();
            rawData[strStartTimeStampNano] =
                healthData.dateFrom.microsecondsSinceEpoch.abs() * 1000;
            rawData[strEndTimeStampNano] =
                healthData.dateTo.microsecondsSinceEpoch.abs() * 1000;
            rawData[strParamBGLevel] = healthData.value;
            if (healthData.unitString == hktGlucoseUnit) {
              rawData[strParamBGUnit] = strMGDL;
            }
            dataSet.add(rawData);
          });
          healthRecord[strRawData] = dataSet;
          var params = json.encode(healthRecord);
          return params;
        }
      } catch (exception) {
        throw 'Unable to fetch Blood Glucose from HealthKit $exception';
      }
    }
  }

  Future<String> getBloodOxygenData(var startDate, var endDate) async {
    if (await Health.requestAuthorization(types)) {
      //print("Blood_Oxygen Summary");
      try {
        /// Fetch BloodOxygen data
        var healthData = await Health.getHealthDataFromTypes(
            startDate, endDate, [HealthDataType.BLOOD_OXYGEN]);

        // healthData = Health.removeDuplicates(healthData);

        // healthData.forEach((list) => print("list for GLuecose: $list \n \n"));
        final healthRecord = Map<String, dynamic>();

        final Map<String, dynamic> userData = {};
        userData[strId] = _userID;

        healthRecord[strUser] = userData;

        if (healthData.isNotEmpty) {
          healthRecord[strsyncStartDate] = startDate.toIso8601String();
          healthRecord[strsyncEndDate] = endDate.toIso8601String();
          healthRecord[strlocalTime] = DateTime.now().toLocal();
          healthRecord[strlastSyncDateTime] = endDate.toIso8601String();
          healthRecord[strdevicesourceName] = strsourceHK;
          healthRecord[strdeviceType] = strOxymeter;
          healthRecord[strdeviceDataType] = strOxgenSaturation;
          final dataSet = <dynamic>[];
          healthData.forEach((healthData) {
            var rawData = Map<String, dynamic>();
            rawData[strStartTimeStamp] = healthData.dateFrom.toIso8601String();
            rawData[strEndTimeStamp] = healthData.dateTo.toIso8601String();
            rawData[strStartTimeStampNano] =
                healthData.dateFrom.microsecondsSinceEpoch.abs() * 1000;
            rawData[strEndTimeStampNano] =
                healthData.dateTo.microsecondsSinceEpoch.abs() * 1000;
            rawData[strParamOxygen] = healthData.value * 100;

            dataSet.add(rawData);
          });
          healthRecord[strRawData] = dataSet;
          var params = json.encode(healthRecord);
          return params;
        }
      } catch (exception) {
        throw 'Unable to fetch Oxygen data from HealthKit $exception';
      }
    }
  }

  Future<String> getBodyTemperature(var startDate, var endDate) async {
    if (await Health.requestAuthorization(types)) {
      //print("Body_Temperature Summary");
      try {
        /// Fetch BodyTemperature data
        var healthData = await Health.getHealthDataFromTypes(
            startDate, endDate, [HealthDataType.BODY_TEMPERATURE]);
        healthData = HealthFactory.removeDuplicates(healthData);

        //healthData.forEach((list) => print("list for GLuecose: $list \n \n"));
        final healthRecord = Map<String, dynamic>();

        final Map<String, dynamic> userData = {};
        userData[strId] = _userID;

        healthRecord[strUser] = userData;

        if (healthData.isNotEmpty) {
          healthRecord[strsyncStartDate] = startDate.toIso8601String();
          healthRecord[strsyncEndDate] = endDate.toIso8601String();
          healthRecord[strlocalTime] = DateTime.now().toLocal();

          healthRecord[strlastSyncDateTime] = endDate.toIso8601String();
          healthRecord[strdevicesourceName] = strsourceHK;
          healthRecord[strdeviceType] = strThermometer;
          healthRecord[strdeviceDataType] = strTemperature;
          final dataSet = <dynamic>[];
          healthData.forEach((healthData) {
            var rawData = Map<String, dynamic>();
            rawData[strStartTimeStamp] = healthData.dateFrom.toIso8601String();
            rawData[strEndTimeStamp] = healthData.dateTo.toIso8601String();
            rawData[strStartTimeStampNano] =
                healthData.dateFrom.microsecondsSinceEpoch.abs() * 1000;
            rawData[strEndTimeStampNano] =
                healthData.dateTo.microsecondsSinceEpoch.abs() * 1000;
            rawData[strParamTemp] = healthData.value;
            if (healthData.unitString == hktTemperatureUnit1) {
              rawData[strParamTempUnit] = strParamUnitCelsius;
            } else if (healthData.unitString == hktTemperatureUnit2) {
              rawData[strParamTempUnit] = strParamUnitFarenheit;
            }
            dataSet.add(rawData);
          });
          healthRecord[strRawData] = dataSet;
          final params = json.encode(healthRecord);
          print(
              '-------------------------Temp-------------------------------------');
          print(params);
          return params;
        }
      } catch (exception) {
        throw 'Unable to fetch Body Temperature from HealthKit $exception';
      }
    }
  }
}
