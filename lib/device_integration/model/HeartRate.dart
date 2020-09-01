import 'package:myfhb/constants/fhb_parameters.dart';

class HeartRate {
  HeartRate({
    this.isSuccess,
    this.entities,
  });

  bool isSuccess;
  List<HeartRateEntity> entities;

  factory HeartRate.fromJson(Map<String, dynamic> json) => HeartRate(
        isSuccess: json[is_Success],
        entities: List<HeartRateEntity>.from(
            json[strentities].map((x) => HeartRateEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        is_Success: isSuccess,
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
        lastsyncdatetime: DateTime.parse(json[strlastSyncDateTime]),
        bpm: json[strParamHeartRate],
        source: json[strsourcetype],
      );

  Map<String, dynamic> toJson() => {
        strlastSyncDateTime: lastsyncdatetime.toIso8601String(),
        strParamHeartRate: bpm,
        strsourcetype: source,
      };
}
