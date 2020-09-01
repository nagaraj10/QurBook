import 'package:myfhb/constants/fhb_parameters.dart';

class BodyTemperature {
  BodyTemperature({
    this.isSuccess,
    this.entities,
  });

  bool isSuccess;
  List<BodyTemperatureEntity> entities;

  factory BodyTemperature.fromJson(Map<String, dynamic> json) =>
      BodyTemperature(
        isSuccess: json[is_Success],
        entities: List<BodyTemperatureEntity>.from(
            json[strentities].map((x) => BodyTemperatureEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        is_Success: isSuccess,
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
        source: json[strsourcetype],
      );

  Map<String, dynamic> toJson() => {
        strlastSyncDateTime: lastsyncdatetime.toIso8601String(),
        strParamTemp: temperature,
        strParamTempUnit: temperatureunit,
        strsourcetype: source,
      };
}
