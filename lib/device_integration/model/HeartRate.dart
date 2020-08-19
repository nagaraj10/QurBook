import 'package:myfhb/constants/fhb_parameters.dart';

class HeartRate {
  HeartRate({
    this.isSuccess,
    this.entities,
  });

  bool isSuccess;
  List<HeartRateEntity> entities;

  factory HeartRate.fromJson(Map<String, dynamic> json) => HeartRate(
        isSuccess: json[strisSuccess],
        entities: List<HeartRateEntity>.from(
            json[strentities].map((x) => HeartRateEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        strisSuccess: isSuccess,
        strentities: List<dynamic>.from(entities.map((x) => x.toJson())),
      };
}

class HeartRateEntity {
  HeartRateEntity({
    this.lastsyncdatetime,
    this.bpm,
    this.source,
  });

  DateTime lastsyncdatetime;
  int bpm;
  String source;

  factory HeartRateEntity.fromJson(Map<String, dynamic> json) =>
      HeartRateEntity(
        lastsyncdatetime:
            DateTime.parse(json[strlastSyncDateTime.toLowerCase()]),
        bpm: json[strParamHeartRate],
        source: json[strSource],
      );

  Map<String, dynamic> toJson() => {
        strlastSyncDateTime.toLowerCase(): lastsyncdatetime.toIso8601String(),
        strParamHeartRate: bpm,
        strSource: source,
      };
}
