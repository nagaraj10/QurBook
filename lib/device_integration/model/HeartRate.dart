import 'package:myfhb/constants/fhb_parameters.dart' as param;

class HeartRate {
  HeartRate({
    this.isSuccess,
    this.entities,
  });

  bool isSuccess;
  List<HeartRateEntity> entities;

  factory HeartRate.fromJson(Map<String, dynamic> json) => HeartRate(
        isSuccess: json[param.is_Success],
        entities: List<HeartRateEntity>.from(
            json[param.strentities].map((x) => HeartRateEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        param.is_Success: isSuccess,
        param.strentities: List<dynamic>.from(entities.map((x) => x.toJson())),
      };
}

class HeartRateEntity {
  HeartRateEntity({
    //this.id,
    this.startDateTime,
    this.endDateTime,
    this.bpm,
  });

  //String id;
  DateTime startDateTime;
  DateTime endDateTime;
  int bpm;

  factory HeartRateEntity.fromJson(Map<String, dynamic> json) =>
      HeartRateEntity(
        //id: json["id"],
        startDateTime: DateTime.parse(json[param.strsyncStartDate]),
        endDateTime: DateTime.parse(json[param.strsyncEndDate]),
        bpm: json[param.strParamHeartRate],
      );

  Map<String, dynamic> toJson() => {
        //"id": id,
        param.strsyncStartDate: startDateTime.toIso8601String(),
        param.strsyncEndDate: endDateTime.toIso8601String(),
        param.strParamHeartRate: bpm,
      };
}
