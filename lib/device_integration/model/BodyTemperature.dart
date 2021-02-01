import 'RefrenceValueMeta.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as param;

class BodyTemperature {
    BodyTemperature({
        this.isSuccess,
        this.entities,
    });

    bool isSuccess;
    List<BodyTemperatureEntity> entities;

    factory BodyTemperature.fromJson(Map<String, dynamic> json) => BodyTemperature(
        isSuccess: json[param.is_Success],
        entities: List<BodyTemperatureEntity>.from(json[param.strentities].map((x) => BodyTemperatureEntity.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        param.is_Success: isSuccess,
        param.strentities: List<dynamic>.from(entities.map((x) => x.toJson())),
    };
}

class BodyTemperatureEntity {
    BodyTemperatureEntity({
        // this.id,
        this.startDateTime,
        this.endDateTime,
        this.temperature,
        this.temperatureUnit,
        this.deviceHealthRecord,
        this.averageAsOfNow
    });

    // String id;
    DateTime startDateTime;
    DateTime endDateTime;
    String temperature;
    RefrenceValueMeta temperatureUnit;
    DeviceHealthRecord deviceHealthRecord;
    AverageAsOfNow averageAsOfNow;

    factory BodyTemperatureEntity.fromJson(Map<String, dynamic> json) => BodyTemperatureEntity(
        // id: json["id"],
        startDateTime: DateTime.parse(json[param.strsyncStartDate]),
        endDateTime: DateTime.parse(json[param.strsyncEndDate]),
        temperature: json[param.strParamTemp],
        temperatureUnit: RefrenceValueMeta.fromJson(json[param.strParamTempUnit]),
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
        param.strsyncEndDate: endDateTime.toIso8601String(),
        param.strParamTemp : temperature,
        param.strParamTempUnit : temperatureUnit.toJson(),
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
    var temperatureAverage;

    AverageAsOfNow({this.temperatureAverage});

    AverageAsOfNow.fromJson(Map<String, dynamic> json) {
        temperatureAverage = json['temperatureAverage'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['temperatureAverage'] = this.temperatureAverage;
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
