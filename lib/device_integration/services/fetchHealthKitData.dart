import 'package:health/health.dart';
import 'dart:async';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'dart:convert' show json;
import 'package:quiver/iterables.dart';



class FetchHealthKitData {
  Future<bool> activateHKT() async {
    try {
      return await Health.requestAuthorization();
    } catch (e) {
      throw "Authorization failed with error $e";
    }
  }

Future<String> getWeightData(DateTime startDate, DateTime endDate) async {

    if (await Health.requestAuthorization()) {
      try {
        Map<String, dynamic> healthRecord = new Map();
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
            if (healthData.unit == "KILOGRAMS") {
              rawData[strParamWeightUnit] = strValueWeightUnit;
            }
            dataSet.add(rawData);
          });
          healthRecord[strRawData] = dataSet;
          String params = json.encode(healthRecord);
          print(params);
        }
      } catch (exception) {
        throw "Unable to fetch weight from Hk $exception";
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
            if (healthData.unit == "BEATS_PER_MINUTE") {
              rawData[strParamHeartRate] = healthData.value;
            }
            dataSet.add(rawData);
          });
          healthRecord[strRawData] = dataSet;
          String params = json.encode(healthRecord);
          print(params);
        }
      } catch (exception) {
        print(exception.toString());
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
            } else {
              print("dates not same ignoring");
            }
          }
          healthRecord[strRawData] = dataSet;
          String params = json.encode(healthRecord);
          print(params);
        }
      } catch (e) {
        print(e.toString());
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
            if (healthData.unit == "MILLIGRAM_PER_DECILITER") {
              rawData[strParamBGUnit] = strMGDL;
            }
            dataSet.add(rawData);
          });
          healthRecord[strRawData] = dataSet;
          String params = json.encode(healthRecord);
          print(params);
        }
      } catch (exception) {
        print(exception.toString());
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
          print(params);
        }
      } catch (exception) {
        print(exception.toString());
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
            if (healthData.unit == "DEGREE_CELSIUS") {
              rawData[strParamTempUnit] = strParamUnitCelsius;
            } else if (healthData.unit == "FARENHEIT") {
              rawData[strParamTempUnit] = strParamUnitFarenheit;
            }
            dataSet.add(rawData);
          });
          healthRecord[strRawData] = dataSet;
          String params = json.encode(healthRecord);
          print(params);
        }
      } catch (exception) {
        print(exception.toString());
      }
    }
  }
}
