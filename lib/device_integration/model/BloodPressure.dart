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
    this.deviceHealthRecord,
    this.averageAsOfNow
  });

  // String id;
  DateTime startDateTime;
  DateTime endDateTime;
  int systolic;
  int diastolic;
  DeviceHealthRecord deviceHealthRecord;
  AverageAsOfNow averageAsOfNow;

  factory BloodPressureEntity.fromJson(Map<String, dynamic> json) =>
      BloodPressureEntity(
        // id: json["id"],
        startDateTime: DateTime.parse(json[param.strsyncStartDate]),
        endDateTime: DateTime.parse(json[param.strsyncEndDate]),
        systolic: json[param.strParamSystolic],
        diastolic: json[param.strParamDiastolic],
        deviceHealthRecord: json[param.strParamDeviceHealthRecord] != null
            ? new DeviceHealthRecord.fromJson(json[param.strParamDeviceHealthRecord])
            : null,
        averageAsOfNow: json['averageAsOfNow'] != null
            ? new AverageAsOfNow.fromJson(json['averageAsOfNow'])
            : null,

      );

  Map<String, dynamic> toJson() => {
        // "id": id,
        param.strsyncStartDate: startDateTime.toIso8601String(),
        param.strsyncEndDate : endDateTime.toIso8601String(),
        param.strParamSystolic: systolic,
        param.strParamDiastolic: diastolic,
        param.strParamDeviceHealthRecord:deviceHealthRecord.toJson(),
        param.strParamAverageAsOfNow:averageAsOfNow.toJson(),

      };
}

class DeviceHealthRecord {
  SourceType sourceType;
  List<HeartRateCollection> heartRateCollection;

  DeviceHealthRecord({this.sourceType,this.heartRateCollection});

  DeviceHealthRecord.fromJson(Map<String, dynamic> json) {
    sourceType = json['sourceType'] != null
        ? new SourceType.fromJson(json['sourceType'])
        : null;
    if (json['heartRateCollection'] != null) {
      heartRateCollection = new List<HeartRateCollection>();
      json['heartRateCollection'].forEach((v) {
        heartRateCollection.add(new HeartRateCollection.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sourceType != null) {
      data['sourceType'] = this.sourceType.toJson();
    }
    if (this.heartRateCollection != null) {
      data['heartRateCollection'] =
          this.heartRateCollection.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class HeartRateCollection {
  String id;
  String startDateTime;
  String endDateTime;
  int bpm;
  AverageAsOfNowPulse averageAsOfNow;

  HeartRateCollection(
      {this.id,
        this.startDateTime,
        this.endDateTime,
        this.bpm,
        this.averageAsOfNow});

  HeartRateCollection.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startDateTime = json['startDateTime'];
    endDateTime = json['endDateTime'];
    bpm = json['bpm'];
    averageAsOfNow = json['averageAsOfNow'] != null
        ? new AverageAsOfNowPulse.fromJson(json['averageAsOfNow'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['startDateTime'] = this.startDateTime;
    data['endDateTime'] = this.endDateTime;
    data['bpm'] = this.bpm;
    if (this.averageAsOfNow != null) {
      data['averageAsOfNow'] = this.averageAsOfNow.toJson();
    }
    return data;
  }
}

class AverageAsOfNowPulse {
  var pulseAverage;

  AverageAsOfNowPulse({this.pulseAverage});

  AverageAsOfNowPulse.fromJson(Map<String, dynamic> json) {
    pulseAverage = json['pulseAverage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pulseAverage'] = this.pulseAverage;
    return data;
  }
}

class AverageAsOfNow {
  var systolicAverage;
  var diastolicAverage;

  AverageAsOfNow({this.systolicAverage, this.diastolicAverage});

  AverageAsOfNow.fromJson(Map<String, dynamic> json) {
    systolicAverage = json['systolicAverage'];
    diastolicAverage = json['diastolicAverage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['systolicAverage'] = this.systolicAverage;
    data['diastolicAverage'] = this.diastolicAverage;
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
