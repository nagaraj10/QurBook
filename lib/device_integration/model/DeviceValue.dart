// To parse this JSON data, do
//
//     final deviceValues = deviceValuesFromJson(jsonString);

import 'dart:convert';
import 'package:myfhb/constants/fhb_parameters.dart';

DeviceValue deviceValueFromJson(String str) =>
    DeviceValue.fromJson(json.decode(str));

String deviceValueToJson(DeviceValue data) => json.encode(data.toJson());

class DeviceValue {
  DeviceValue({
    this.isSuccess,
    this.result,
  });

  bool isSuccess;
  DevResult result;

  factory DeviceValue.fromJson(Map<String, dynamic> json) => DeviceValue(
        isSuccess: json[strisSuccess],
        result: DevResult.fromJson(json[strresult]),
      );

  Map<String, dynamic> toJson() => {
        strisSuccess: isSuccess,
        strresult: result.toJson(),
      };
}

class DevResult {
  DevResult({
    this.bloodGlucose,
    this.bloodPressure,
    this.bodyTemperature,
    this.bodyWeight,
    this.heartRate,
    this.oxygenSaturation,
  });

  BloodGlucose bloodGlucose;
  BloodPressure bloodPressure;
  BodyTemperature bodyTemperature;
  BodyWeight bodyWeight;
  HeartRate heartRate;
  OxygenSaturation oxygenSaturation;

  factory DevResult.fromJson(Map<String, dynamic> json) => DevResult(
        bloodGlucose: BloodGlucose.fromJson(json[strBGlucose]),
        bloodPressure: BloodPressure.fromJson(json[strBP]),
        bodyTemperature: BodyTemperature.fromJson(json[strTemp]),
        bodyWeight: BodyWeight.fromJson(json[strWeight]),
        heartRate: HeartRate.fromJson(json[strHRate]),
        oxygenSaturation: OxygenSaturation.fromJson(json[strOxygen]),
      );

  Map<String, dynamic> toJson() => {
        strBGlucose: bloodGlucose.toJson(),
        strBP: bloodPressure.toJson(),
        strTemp: bodyTemperature.toJson(),
        strWeight: bodyWeight.toJson(),
        strHRate: heartRate.toJson(),
        strOxygen: oxygenSaturation.toJson(),
      };
}

class BloodGlucose {
  BloodGlucose({
    this.isSuccess,
    this.entities,
  });

  bool isSuccess;
  List<BloodGlucoseEntity> entities;

  factory BloodGlucose.fromJson(Map<String, dynamic> json) => BloodGlucose(
        isSuccess: json[strisSuccess],
        entities: List<BloodGlucoseEntity>.from(
            json[strentities].map((x) => BloodGlucoseEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        strisSuccess: isSuccess,
        strentities: List<dynamic>.from(entities.map((x) => x.toJson())),
      };
}

class BloodGlucoseEntity {
  BloodGlucoseEntity({
    this.lastsyncdatetime,
    this.bloodGlucoseLevel,
    this.bgunit,
    this.source,
  });

  DateTime lastsyncdatetime;
  int bloodGlucoseLevel;
  String bgunit;
  String source;

  factory BloodGlucoseEntity.fromJson(Map<String, dynamic> json) =>
      BloodGlucoseEntity(
        lastsyncdatetime: DateTime.parse(json[strlastSyncDateTime]),
        bloodGlucoseLevel: json[strParamBGLevel],
        bgunit: json[strParamBGUnit],
        source: json[strSource],
      );

  Map<String, dynamic> toJson() => {
        strlastSyncDateTime: lastsyncdatetime.toIso8601String(),
        strParamBGLevel: bloodGlucoseLevel,
        strParamBGUnit: bgunit,
        source: source,
      };
}

class BloodPressure {
  BloodPressure({
    this.isSuccess,
    this.entities,
  });

  bool isSuccess;
  List<BloodPressureEntity> entities;

  factory BloodPressure.fromJson(Map<String, dynamic> json) => BloodPressure(
        isSuccess: json[strisSuccess],
        entities: List<BloodPressureEntity>.from(
            json[strentities].map((x) => BloodPressureEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        strisSuccess: isSuccess,
        strentities: List<dynamic>.from(entities.map((x) => x.toJson())),
      };
}

class BloodPressureEntity {
  BloodPressureEntity({
    this.lastsyncdatetime,
    this.systolic,
    this.diastolic,
    this.source,
  });

  DateTime lastsyncdatetime;
  int systolic;
  int diastolic;
  String source;

  factory BloodPressureEntity.fromJson(Map<String, dynamic> json) =>
      BloodPressureEntity(
        lastsyncdatetime: DateTime.parse(json[strlastSyncDateTime]),
        systolic: json[strParamSystolic],
        diastolic: json[strParamDiastolic],
        source: json[strSource],
      );

  Map<String, dynamic> toJson() => {
        strlastSyncDateTime: lastsyncdatetime.toIso8601String(),
        strParamSystolic: systolic,
        strParamDiastolic: diastolic,
        strSource: source,
      };
}

class BodyTemperature {
  BodyTemperature({
    this.isSuccess,
    this.entities,
  });

  bool isSuccess;
  List<BodyTemperatureEntity> entities;

  factory BodyTemperature.fromJson(Map<String, dynamic> json) =>
      BodyTemperature(
        isSuccess: json[strisSuccess],
        entities: List<BodyTemperatureEntity>.from(
            json[strentities].map((x) => BodyTemperatureEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        strisSuccess: isSuccess,
        strentities: List<dynamic>.from(entities.map((x) => x.toJson())),
      };
}

class BodyTemperatureEntity {
  BodyTemperatureEntity({
    this.lastsyncdatetime,
    this.temperature,
    this.temperatureunit,
    this.source,
  });

  DateTime lastsyncdatetime;
  String temperature;
  String temperatureunit;
  String source;

  factory BodyTemperatureEntity.fromJson(Map<String, dynamic> json) =>
      BodyTemperatureEntity(
        lastsyncdatetime: DateTime.parse(json[strlastSyncDateTime]),
        temperature: json[strParamTemp],
        temperatureunit: json[strParamTempUnit],
        source: json[strSource],
      );

  Map<String, dynamic> toJson() => {
        strlastSyncDateTime: lastsyncdatetime.toIso8601String(),
        strParamTemp: temperature,
        strParamTempUnit: temperatureunit,
        strSource: source,
      };
}

class BodyWeight {
  BodyWeight({
    this.isSuccess,
    this.entities,
  });

  bool isSuccess;
  List<BodyWeightEntity> entities;

  factory BodyWeight.fromJson(Map<String, dynamic> json) => BodyWeight(
        isSuccess: json[strisSuccess],
        entities: List<BodyWeightEntity>.from(
            json[strentities].map((x) => BodyWeightEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        strisSuccess: isSuccess,
        strentities: List<dynamic>.from(entities.map((x) => x.toJson())),
      };
}

class BodyWeightEntity {
  BodyWeightEntity({
    this.lastsyncdatetime,
    this.weight,
    this.weightunit,
    this.source,
  });

  DateTime lastsyncdatetime;
  String weight;
  String weightunit;
  String source;

  factory BodyWeightEntity.fromJson(Map<String, dynamic> json) =>
      BodyWeightEntity(
        lastsyncdatetime: DateTime.parse(json[strlastSyncDateTime]),
        weight: json[strParamWeight],
        weightunit: json[strParamWeightUnit],
        source: json[strSource],
      );

  Map<String, dynamic> toJson() => {
        strlastSyncDateTime: lastsyncdatetime.toIso8601String(),
        strParamWeight: weight,
        strParamWeightUnit: weightunit,
        strSource: source,
      };
}

class HeartRate {
  HeartRate({
    this.isSuccess,
    this.entities,
  });

  bool isSuccess;
  List<HeartRateEntity> entities;

  factory HeartRate.fromJson(Map<String, dynamic> json) => HeartRate(
        isSuccess: json[strisSuccess],
        entities: List<HeartRateEntity>.from(
            json[strentities].map((x) => HeartRateEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        strisSuccess: isSuccess,
        strentities: List<dynamic>.from(entities.map((x) => x.toJson())),
      };
}

class HeartRateEntity {
  HeartRateEntity({
    this.lastsyncdatetime,
    this.bpm,
    this.source,
  });

  DateTime lastsyncdatetime;
  int bpm;
  String source;

  factory HeartRateEntity.fromJson(Map<String, dynamic> json) =>
      HeartRateEntity(
        lastsyncdatetime: DateTime.parse(json[strlastSyncDateTime]),
        bpm: json[strParamHeartRate],
        source: json[strSource],
      );

  Map<String, dynamic> toJson() => {
        strlastSyncDateTime: lastsyncdatetime.toIso8601String(),
        strParamHeartRate: bpm,
        strSource: source,
      };
}

class OxygenSaturation {
  OxygenSaturation({
    this.isSuccess,
    this.entities,
  });

  bool isSuccess;
  List<OxygenSaturationEntity> entities;

  factory OxygenSaturation.fromJson(Map<String, dynamic> json) =>
      OxygenSaturation(
        isSuccess: json[strisSuccess],
        entities: List<OxygenSaturationEntity>.from(
            json[strentities].map((x) => OxygenSaturationEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        strisSuccess: isSuccess,
        strentities: List<dynamic>.from(entities.map((x) => x.toJson())),
      };
}

class OxygenSaturationEntity {
  OxygenSaturationEntity({
    this.lastsyncdatetime,
    this.oxygenSaturation,
    this.source,
  });

  DateTime lastsyncdatetime;
  int oxygenSaturation;
  String source;

  factory OxygenSaturationEntity.fromJson(Map<String, dynamic> json) =>
      OxygenSaturationEntity(
        lastsyncdatetime: DateTime.parse(json[strlastSyncDateTime]),
        oxygenSaturation: json[strParamOxygen],
        source: json[strSource],
      );

  Map<String, dynamic> toJson() => {
        strlastSyncDateTime: lastsyncdatetime.toIso8601String(),
        strParamOxygen: oxygenSaturation,
        strSource: source,
      };
}
