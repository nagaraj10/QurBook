import 'dart:convert';

import 'package:myfhb/constants/fhb_parameters.dart' as param;
import 'RefrenceValueMeta.dart';
import 'BloodPressure.dart';
import 'BloodGlucose.dart';
import 'BodyTemperature.dart';
import 'BodyWeight.dart';
import 'OxygenSaturation.dart';
import 'HeartRate.dart';

DeviceInterval deviceIntervalFromJson(String str) =>
    DeviceInterval.fromJson(json.decode(str));

String deviceIntervalToJson(DeviceInterval data) => json.encode(data.toJson());

class DeviceInterval {
  DeviceInterval({
    this.isSuccess,
    this.result,
  });

  bool isSuccess;
  List<DeviceIntervalData> result;

  factory DeviceInterval.fromJson(Map<String, dynamic> json) => DeviceInterval(
        isSuccess: json[param.is_Success],
        result: List<DeviceIntervalData>.from(
            json[param.dataResult].map((x) => DeviceIntervalData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        param.is_Success: isSuccess,
        param.dataResult: List<dynamic>.from(result.map((x) => x.toJson())),
      };
}

class DeviceIntervalData {
  DeviceIntervalData({
    this.startDateTime,
    this.endDateTime,
    this.lastSyncDateTime,
    this.deviceDataType,
    this.deviceType,
    this.sourceType,
    this.bloodGlucoseCollection,
    this.bloodPressureCollection,
    this.bodyTemperatureCollection,
    this.bodyWeightCollection,
    this.heartRateCollection,
    this.oxygenSaturationCollection,
  });

  DateTime startDateTime;
  DateTime endDateTime;
  DateTime lastSyncDateTime;
  RefrenceValueMeta deviceDataType;
  RefrenceValueMeta deviceType;
  RefrenceValueMeta sourceType;
  List<BloodGlucoseEntity> bloodGlucoseCollection;
  List<BloodPressureEntity> bloodPressureCollection;
  List<BodyTemperatureEntity> bodyTemperatureCollection;
  List<BodyWeightEntity> bodyWeightCollection;
  List<HeartRateEntity> heartRateCollection;
  List<OxygenSaturationEntity> oxygenSaturationCollection;

  factory DeviceIntervalData.fromJson(Map<String, dynamic> json) =>
      DeviceIntervalData(
        startDateTime: DateTime.parse(json[param.strsyncStartDate]),
        endDateTime: DateTime.parse(json[param.strsyncEndDate]),
        lastSyncDateTime: DateTime.parse(json[param.strlastSyncDateTime]),
        deviceDataType:
            RefrenceValueMeta.fromJson(json[param.strdeviceDataType]),
        deviceType: RefrenceValueMeta.fromJson(json[param.strdeviceType]),
        sourceType: RefrenceValueMeta.fromJson(json[param.strdevicesourceName]),
        bloodGlucoseCollection: List<BloodGlucoseEntity>.from(
            json[param.strBloodGlucoseCollection]
                .map((x) => BloodGlucoseEntity.fromJson(x))),
        bloodPressureCollection: List<BloodPressureEntity>.from(
            json[param.strBloodPressureCollection]
                .map((x) => BloodPressureEntity.fromJson(x))),
        bodyTemperatureCollection: List<BodyTemperatureEntity>.from(
            json[param.strBodyTemperatureCollection]
                .map((x) => BodyTemperatureEntity.fromJson(x))),
        bodyWeightCollection: List<BodyWeightEntity>.from(
            json[param.strWeightCollection]
                .map((x) => BodyWeightEntity.fromJson(x))),
        heartRateCollection: List<HeartRateEntity>.from(
            json[param.strHearRateCollection]
                .map((x) => HeartRateEntity.fromJson(x))),
        oxygenSaturationCollection: List<OxygenSaturationEntity>.from(
            json[param.strOxygenCollection]
                .map((x) => OxygenSaturationEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        param.strsyncStartDate: startDateTime.toIso8601String(),
        param.strsyncEndDate: endDateTime.toIso8601String(),
        param.strlastSyncDateTime: lastSyncDateTime.toIso8601String(),
        param.strdeviceDataType: deviceDataType.toJson(),
        param.strdeviceType: deviceType.toJson(),
        param.strdevicesourceName: sourceType.toJson(),
        param.strBloodGlucoseCollection:
            List<dynamic>.from(bloodGlucoseCollection.map((x) => x)),
        param.strBloodPressureCollection: List<BloodPressureEntity>.from(
            bloodPressureCollection.map((x) => x.toJson())),
        param.strBodyTemperatureCollection:
            List<dynamic>.from(bodyTemperatureCollection.map((x) => x)),
        param.strWeightCollection:
            List<dynamic>.from(bodyWeightCollection.map((x) => x)),
        param.strHearRateCollection:
            List<dynamic>.from(heartRateCollection.map((x) => x)),
        param.strHearRateCollection:
            List<dynamic>.from(oxygenSaturationCollection.map((x) => x)),
      };
}
