import 'RefrenceValueMeta.dart';
import '../../constants/fhb_parameters.dart' as param;

class BodyTemperature {
  BodyTemperature({
    this.isSuccess,
    this.entities,
  });

  bool isSuccess;
  List<BodyTemperatureEntity> entities;

  factory BodyTemperature.fromJson(Map<String, dynamic> json) =>
      BodyTemperature(
        isSuccess: json[param.is_Success],
        entities: List<BodyTemperatureEntity>.from(json[param.strentities]
            .map((x) => BodyTemperatureEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        param.is_Success: isSuccess,
        param.strentities: List<dynamic>.from(entities.map((x) => x.toJson())),
      };
}

class BodyTemperatureEntity {
  BodyTemperatureEntity(
      {
      // this.id,
      this.startDateTime,
      this.endDateTime,
      this.temperature,
      this.temperatureUnit,
      this.deviceHealthRecord,
      this.averageAsOfNow});

  // String id;
  DateTime startDateTime;
  DateTime endDateTime;
  dynamic temperature;
  RefrenceValueMeta temperatureUnit;
  DeviceHealthRecord deviceHealthRecord;
  AverageAsOfNow averageAsOfNow;

  factory BodyTemperatureEntity.fromJson(Map<String, dynamic> json) =>
      BodyTemperatureEntity(
        // id: json["id"],
        startDateTime: DateTime.parse(json[param.strsyncStartDate]),
        endDateTime: DateTime.parse(json[param.strsyncEndDate]),
        temperature: json[param.strParamTemp].toString(),
        temperatureUnit:
            RefrenceValueMeta.fromJson(json[param.strParamTempUnit]),
        deviceHealthRecord: json[param.strParamDeviceHealthRecord] != null
            ? DeviceHealthRecord.fromJson(
                json[param.strParamDeviceHealthRecord])
            : null,
        averageAsOfNow: json['averageAsOfNow'] != null
            ? AverageAsOfNow.fromJson(json['averageAsOfNow'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        // "id": id,
        param.strsyncStartDate: startDateTime.toIso8601String(),
        param.strsyncEndDate: endDateTime.toIso8601String(),
        param.strParamTemp: temperature,
        param.strParamTempUnit: temperatureUnit.toJson(),
        param.strParamDeviceHealthRecord: deviceHealthRecord.toJson(),
        param.strParamAverageAsOfNow: averageAsOfNow.toJson(),
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
    final data = Map<String, dynamic>();
    if (sourceType != null) {
      data['sourceType'] = sourceType.toJson();
    }
    data[param.strCreatedOn] = createdOn.toIso8601String();

    return data;
  }
}

class AverageAsOfNow {
  var temperatureAverage;

  AverageAsOfNow({this.temperatureAverage});

  AverageAsOfNow.fromJson(Map<String, dynamic> json) {
    temperatureAverage = json['temperatureAverage'];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['temperatureAverage'] = temperatureAverage;
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
