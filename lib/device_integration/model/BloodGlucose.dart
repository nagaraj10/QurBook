import 'package:myfhb/constants/fhb_parameters.dart';

class BloodGlucose {
  BloodGlucose({
    this.isSuccess,
    this.entities,
  });

  bool isSuccess;
  List<BloodGlucoseEntity> entities;

  factory BloodGlucose.fromJson(Map<String, dynamic> json) => BloodGlucose(
        isSuccess: json[is_Success],
        entities: List<BloodGlucoseEntity>.from(
            json[strentities].map((x) => BloodGlucoseEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        is_Success: isSuccess,
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
        lastsyncdatetime:
            DateTime.parse(json[strlastSyncDateTime.toLowerCase()]),
        bloodGlucoseLevel: json[strParamBGLevel],
        bgunit: json[strParamBGUnit],
        source: json[strSource],
      );

  Map<String, dynamic> toJson() => {
        strlastSyncDateTime.toLowerCase(): lastsyncdatetime.toIso8601String(),
        strParamBGLevel: bloodGlucoseLevel,
        strParamBGUnit: bgunit,
        source: source,
      };
}
