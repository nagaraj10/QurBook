import 'package:myfhb/constants/fhb_parameters.dart';

class BodyWeight {
  BodyWeight({
    this.isSuccess,
    this.entities,
  });

  bool isSuccess;
  List<BodyWeightEntity> entities;

  factory BodyWeight.fromJson(Map<String, dynamic> json) => BodyWeight(
        isSuccess: json[is_Success],
        entities: List<BodyWeightEntity>.from(
            json[strentities].map((x) => BodyWeightEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        is_Success: isSuccess,
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
        source: json[strsourcetype],
      );

  Map<String, dynamic> toJson() => {
        strlastSyncDateTime: lastsyncdatetime.toIso8601String(),
        strParamWeight: weight,
        strParamWeightUnit: weightunit,
        strsourcetype: source,
      };
}
