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
    this.deviceHealthRecord,
    this.averageAsOfNow
  });

  //String id;
  DateTime startDateTime;
  DateTime endDateTime;
  int bpm;
  DeviceHealthRecord deviceHealthRecord;
  AverageAsOfNow averageAsOfNow;

  factory HeartRateEntity.fromJson(Map<String, dynamic> json) =>
      HeartRateEntity(
        //id: json["id"],
        startDateTime: DateTime.parse(json[param.strsyncStartDate]),
        endDateTime: DateTime.parse(json[param.strsyncEndDate]),
        bpm: json[param.strParamHeartRate],
          deviceHealthRecord: json[param.strParamDeviceHealthRecord] != null
              ? new DeviceHealthRecord.fromJson(json[param.strParamDeviceHealthRecord])
              : null,
        averageAsOfNow: json['averageAsOfNow'] != null
            ? new AverageAsOfNow.fromJson(json['averageAsOfNow'])
            : null
      );

  Map<String, dynamic> toJson() => {
        //"id": id,
        param.strsyncStartDate: startDateTime.toIso8601String(),
        param.strsyncEndDate: endDateTime.toIso8601String(),
        param.strParamHeartRate: bpm,
        param.strParamDeviceHealthRecord:deviceHealthRecord.toJson(),
        param.strParamAverageAsOfNow:averageAsOfNow.toJson(),
      };
}

class DeviceHealthRecord {
  SourceType sourceType;

  DeviceHealthRecord({this.sourceType});

  DeviceHealthRecord.fromJson(Map<String, dynamic> json) {
    sourceType = json['sourceType'] != null
        ? new SourceType.fromJson(json['sourceType'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sourceType != null) {
      data['sourceType'] = this.sourceType.toJson();
    }
    return data;
  }
}

class AverageAsOfNow {
  var pulseAverage;

  AverageAsOfNow({this.pulseAverage});

  AverageAsOfNow.fromJson(Map<String, dynamic> json) {
    pulseAverage = json['pulseAverage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pulseAverage'] = this.pulseAverage;
    return data;
  }
}

class SourceType {
  String code;

  SourceType({this.code});

  SourceType.fromJson(Map<String, dynamic> json) {
    code = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.code;
    return data;
  }
}
