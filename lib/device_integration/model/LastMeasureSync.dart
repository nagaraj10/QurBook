import 'dart:convert';
import '../../constants/fhb_parameters.dart' as param;
import 'BloodGlucose.dart';
import 'BloodPressure.dart';
import 'BodyTemperature.dart';
import 'BodyWeight.dart';
import 'HeartRate.dart';
import 'OxygenSaturation.dart';

LastMeasureSync lastMeasureSyncFromJson(String str) => LastMeasureSync.fromJson(json.decode(str));

String lastMeasureSyncToJson(LastMeasureSync data) => json.encode(data.toJson());

class LastMeasureSync {
    LastMeasureSync({
        this.isSuccess,
        this.result,
    });

    bool isSuccess;
    LastMeasureSyncValues result;

    factory LastMeasureSync.fromJson(Map<String, dynamic> json) =>
        LastMeasureSync(
            isSuccess: json[param.is_Success],
            result: json.containsKey(param.dataResult)
                ? LastMeasureSyncValues.fromJson(json[param.dataResult])
                : null,
        );

    Map<String, dynamic> toJson() => {
        param.is_Success: isSuccess,
        param.dataResult: result.toJson(),
    };
}

class LastMeasureSyncValues {
    LastMeasureSyncValues({
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

    factory LastMeasureSyncValues.fromJson(Map<String, dynamic> json) => LastMeasureSyncValues(
        bloodGlucose: BloodGlucose.fromJson(json[param.strBGlucose]),
        bloodPressure: BloodPressure.fromJson(json[param.strBP]),
        bodyTemperature: BodyTemperature.fromJson(json[param.strTemp]),
        bodyWeight: BodyWeight.fromJson(json[param.strWgt]),
        heartRate: HeartRate.fromJson(json[param.strHRate]),
        oxygenSaturation: OxygenSaturation.fromJson(json[param.strOxygen]),
    );

    Map<String, dynamic> toJson() => {
        param.strBGlucose: bloodGlucose.toJson(),
        param.strBP: bloodPressure.toJson(),
        param.strTemp: bodyTemperature.toJson(),
        param.strWgt: bodyWeight.toJson(),
        param.strHRate: heartRate.toJson(),
        param.strOxygen: oxygenSaturation.toJson(),
    };
}


