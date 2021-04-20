import 'RefrenceValueMeta.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as param;

class BodyWeight {
  BodyWeight({
    this.isSuccess,
    this.entities,
  });

  bool isSuccess;
  List<BodyWeightEntity> entities;
  AverageAsOfNow averageAsOfNow;

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
  BodyWeightEntity(
      {this.id,
      this.startDateTime,
      this.endDateTime,
      this.weight,
      this.weightUnit,
      this.deviceHealthRecord,
      this.averageAsOfNow});

  String id;
  DateTime startDateTime;
  DateTime endDateTime;
  String weight;
  RefrenceValueMeta weightUnit;
  DeviceHealthRecord deviceHealthRecord;
  AverageAsOfNow averageAsOfNow;

  factory BodyWeightEntity.fromJson(Map<String, dynamic> json) =>
      BodyWeightEntity(
          //id: json["id"],
          startDateTime: DateTime.parse(json[param.strsyncStartDate]),
          endDateTime: DateTime.parse(json[param.strsyncEndDate]),
          weight: json[param.strParamWeight],
          weightUnit: json[param.strParamWeightUnit] != null
              ? RefrenceValueMeta.fromJson(json[param.strParamWeightUnit])
              : null,
          deviceHealthRecord: json[param.strParamDeviceHealthRecord] != null
              ? new DeviceHealthRecord.fromJson(
                  json[param.strParamDeviceHealthRecord])
              : null,
          averageAsOfNow: json['averageAsOfNow'] != null
              ? new AverageAsOfNow.fromJson(json['averageAsOfNow'])
              : null);

  Map<String, dynamic> toJson() => {
        //"id": id,
        param.strsyncStartDate: startDateTime.toIso8601String(),
        param.strsyncEndDate: endDateTime.toIso8601String(),
        param.strParamWeight: weight,
        param.strParamWeightUnit: weightUnit.toJson(),
        param.strParamDeviceHealthRecord: deviceHealthRecord.toJson(),
        param.strParamAverageAsOfNow: averageAsOfNow.toJson()
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
  var weightAverage;

  AverageAsOfNow({this.weightAverage});

  AverageAsOfNow.fromJson(Map<String, dynamic> json) {
    weightAverage = json['weightAverage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['weightAverage'] = this.weightAverage;
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
