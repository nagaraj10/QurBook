import 'dart:convert';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/device_integration/model/BloodGlucose.dart';
import 'package:myfhb/device_integration/model/BloodPressure.dart';
import 'package:myfhb/device_integration/model/BodyTemperature.dart';
import 'package:myfhb/device_integration/model/BodyWeight.dart';
import 'package:myfhb/device_integration/model/HeartRate.dart';
import 'package:myfhb/device_integration/model/OxygenSaturation.dart';

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
        isSuccess: json[is_Success],
        result: DevResult.fromJson(json[dataResult]),
      );

  Map<String, dynamic> toJson() => {
        is_Success: isSuccess,
        dataResult: result.toJson(),
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
        bodyWeight: BodyWeight.fromJson(json[strWgt]),
        heartRate: HeartRate.fromJson(json[strHRate]),
        oxygenSaturation: OxygenSaturation.fromJson(json[strOxygen]),
      );

  Map<String, dynamic> toJson() => {
        strBGlucose: bloodGlucose.toJson(),
        strBP: bloodPressure.toJson(),
        strTemp: bodyTemperature.toJson(),
        strWgt: bodyWeight.toJson(),
        strHRate: heartRate.toJson(),
        strOxygen: oxygenSaturation.toJson(),
      };
}
