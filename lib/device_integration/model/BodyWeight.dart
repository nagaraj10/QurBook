import 'RefrenceValueMeta.dart';
import '../../constants/fhb_parameters.dart' as param;

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
  dynamic weight;
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
              ? DeviceHealthRecord.fromJson(
                  json[param.strParamDeviceHealthRecord])
              : null,
          averageAsOfNow: json['averageAsOfNow'] != null
              ? AverageAsOfNow.fromJson(json['averageAsOfNow'])
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
  DateTime createdOn;

  DeviceHealthRecord({this.sourceType, this.createdOn});

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
  var weightAverage;

  AverageAsOfNow({this.weightAverage});

  AverageAsOfNow.fromJson(Map<String, dynamic> json) {
    weightAverage = json['weightAverage'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['weightAverage'] = weightAverage;
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
