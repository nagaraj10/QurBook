import '../../constants/fhb_parameters.dart' as param;

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
  var bpm;
  DeviceHealthRecord deviceHealthRecord;
  AverageAsOfNow averageAsOfNow;

  factory HeartRateEntity.fromJson(Map<String, dynamic> json) =>
      HeartRateEntity(
        //id: json["id"],
        startDateTime: DateTime.parse(json[param.strsyncStartDate]),
        endDateTime: DateTime.parse(json[param.strsyncEndDate]),
        bpm: json[param.strParamHeartRate],
          deviceHealthRecord: json[param.strParamDeviceHealthRecord] != null
              ? DeviceHealthRecord.fromJson(json[param.strParamDeviceHealthRecord])
              : null,
        averageAsOfNow: json['averageAsOfNow'] != null
            ? AverageAsOfNow.fromJson(json['averageAsOfNow'])
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
  DateTime createdOn;


  DeviceHealthRecord({this.sourceType,this.createdOn});

  DeviceHealthRecord.fromJson(Map<String, dynamic> json) {
    sourceType = json['sourceType'] != null
        ? SourceType.fromJson(json['sourceType'])
        : null;
    createdOn = DateTime.parse(json[param.strCreatedOn]);

  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (sourceType != null) {
      data['sourceType'] = sourceType.toJson();
    }
    data[param.strCreatedOn] = createdOn.toIso8601String();

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
    final data = Map<String, dynamic>();
    data['pulseAverage'] = pulseAverage;
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
    final data = <String, dynamic>{};
    data['name'] = code;
    return data;
  }
}
