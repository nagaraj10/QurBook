import 'package:myfhb/constants/fhb_parameters.dart';

class OxygenSaturation {
  OxygenSaturation({
    this.isSuccess,
    this.entities,
  });

  bool isSuccess;
  List<OxygenSaturationEntity> entities;

  factory OxygenSaturation.fromJson(Map<String, dynamic> json) =>
      OxygenSaturation(
        isSuccess: json[is_Success],
        entities: List<OxygenSaturationEntity>.from(
            json[strentities].map((x) => OxygenSaturationEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        is_Success: isSuccess,
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
        lastsyncdatetime:
            DateTime.parse(json[strlastSyncDateTime.toLowerCase()]),
        oxygenSaturation: json[strParamOxygen],
        source: json[strSource],
      );

  Map<String, dynamic> toJson() => {
        strlastSyncDateTime.toLowerCase(): lastsyncdatetime.toIso8601String(),
        strParamOxygen: oxygenSaturation,
        strSource: source,
      };
}
