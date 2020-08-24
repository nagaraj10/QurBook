import 'package:myfhb/constants/fhb_parameters.dart';

class BloodPressure {
  BloodPressure({
    this.isSuccess,
    this.entities,
  });

  bool isSuccess;
  List<BloodPressureEntity> entities;

  factory BloodPressure.fromJson(Map<String, dynamic> json) => BloodPressure(
        isSuccess: json[is_Success],
        entities: List<BloodPressureEntity>.from(
            json[strentities].map((x) => BloodPressureEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        is_Success: isSuccess,
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
        lastsyncdatetime:
            DateTime.parse(json[strlastSyncDateTime.toLowerCase()]),
        systolic: json[strParamSystolic],
        diastolic: json[strParamDiastolic],
        source: json[strSource],
      );

  Map<String, dynamic> toJson() => {
        strlastSyncDateTime.toLowerCase(): lastsyncdatetime.toIso8601String(),
        strParamSystolic: systolic,
        strParamDiastolic: diastolic,
        strSource: source,
      };
}
