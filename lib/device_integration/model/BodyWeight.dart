import 'RefrenceValueMeta.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as param;

class BodyWeight {
  BodyWeight({
    this.isSuccess,
    this.entities,
  });

  bool isSuccess;
  List<BodyWeightEntity> entities;

  factory BodyWeight.fromJson(Map<String, dynamic> json) => BodyWeight(
        isSuccess: json[param.is_Success],
        entities: List<BodyWeightEntity>.from(
            json[param.strentities].map((x) => BodyWeightEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        param.is_Success: isSuccess,
        param.strentities: List<dynamic>.from(entities.map((x) => x.toJson())),
      };
}

class BodyWeightEntity {
  BodyWeightEntity({
    this.id,
    this.startDateTime,
    this.endDateTime,
    this.weight,
    this.weightUnit,
  });

  String id;
  DateTime startDateTime;
  DateTime endDateTime;
  String weight;
  RefrenceValueMeta weightUnit;

  factory BodyWeightEntity.fromJson(Map<String, dynamic> json) =>
      BodyWeightEntity(
        //id: json["id"],
        startDateTime: DateTime.parse(json[param.strsyncStartDate]),
        endDateTime: DateTime.parse(json[param.strsyncEndDate]),
        weight: json[param.strParamWeight],
        weightUnit: RefrenceValueMeta.fromJson(json[param.strParamWeightUnit]),
      );

  Map<String, dynamic> toJson() => {
        //"id": id,
        param.strsyncStartDate: startDateTime.toIso8601String(),
        param.strsyncEndDate: endDateTime.toIso8601String(),
        param.strParamWeight: weight,
        param.strParamWeightUnit: weightUnit.toJson(),
      };
}
