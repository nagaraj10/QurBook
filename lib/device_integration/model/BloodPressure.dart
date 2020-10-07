import 'package:myfhb/constants/fhb_parameters.dart' as param;

class BloodPressure {
  BloodPressure({
    this.isSuccess,
    this.entities,
  });

  bool isSuccess;
  List<BloodPressureEntity> entities;

  factory BloodPressure.fromJson(Map<String, dynamic> json) => BloodPressure(
        isSuccess: json[param.is_Success],
        entities: List<BloodPressureEntity>.from(
            json[param.strentities].map((x) => BloodPressureEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        param.is_Success: isSuccess,
        param.strentities: List<dynamic>.from(entities.map((x) => x.toJson())),
      };
}

class BloodPressureEntity {
  BloodPressureEntity({
    // this.id,
    this.startDateTime,
    this.endDateTime,
    this.systolic,
    this.diastolic,
  });

  // String id;
  DateTime startDateTime;
  DateTime endDateTime;
  int systolic;
  int diastolic;

  factory BloodPressureEntity.fromJson(Map<String, dynamic> json) =>
      BloodPressureEntity(
        // id: json["id"],
        startDateTime: DateTime.parse(json[param.strsyncStartDate]),
        endDateTime: DateTime.parse(json[param.strsyncEndDate]),
        systolic: json[param.strParamSystolic],
        diastolic: json[param.strParamDiastolic],
      );

  Map<String, dynamic> toJson() => {
        // "id": id,
        param.strsyncStartDate: startDateTime.toIso8601String(),
        param.strsyncEndDate : endDateTime.toIso8601String(),
        param.strParamSystolic: systolic,
        param.strParamDiastolic: diastolic,
      };
}
