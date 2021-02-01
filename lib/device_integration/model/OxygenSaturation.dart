import 'package:myfhb/constants/fhb_parameters.dart' as param;

class OxygenSaturation {
    OxygenSaturation({
        this.isSuccess,
        this.entities,
    });

    bool isSuccess;
    List<OxygenSaturationEntity> entities;

    factory OxygenSaturation.fromJson(Map<String, dynamic> json) => OxygenSaturation(
        isSuccess: json[param.is_Success],
        entities: List<OxygenSaturationEntity>.from(json[param.strentities].map((x) => OxygenSaturationEntity.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        param.is_Success: isSuccess,
        param.strentities: List<dynamic>.from(entities.map((x) => x.toJson())),
    };
}

class OxygenSaturationEntity {
    OxygenSaturationEntity({
        //this.id,
        this.startDateTime,
        this.endDateTime,
        this.oxygenSaturation,
        this.deviceHealthRecord,
        this.averageAsOfNow
    });

    //String id;
    DateTime startDateTime;
    DateTime endDateTime;
    int oxygenSaturation;
    DeviceHealthRecord deviceHealthRecord;
    AverageAsOfNow averageAsOfNow;

    factory OxygenSaturationEntity.fromJson(Map<String, dynamic> json) => OxygenSaturationEntity(
        //id: json["id"],
        startDateTime: DateTime.parse(json[param.strsyncStartDate]),
        endDateTime: DateTime.parse(json[param.strsyncEndDate]),
        oxygenSaturation: json[param.strParamOxygen],
        deviceHealthRecord: json[param.strParamDeviceHealthRecord] != null
            ? new DeviceHealthRecord.fromJson(json[param.strParamDeviceHealthRecord])
            : null,
        averageAsOfNow: json['averageAsOfNow'] != null
            ? new AverageAsOfNow.fromJson(json['averageAsOfNow'])
            : null
    );

    Map<String, dynamic> toJson() => {
        // "id": id,
        param.strsyncStartDate: startDateTime.toIso8601String(),
        param.strsyncEndDate: endDateTime.toIso8601String(),
        param.strParamOxygen: oxygenSaturation,
        param.strParamDeviceHealthRecord:deviceHealthRecord.toJson(),
        param.strParamAverageAsOfNow:averageAsOfNow.toJson()
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
    var oxygenLevelAverage;

    AverageAsOfNow({this.oxygenLevelAverage});

    AverageAsOfNow.fromJson(Map<String, dynamic> json) {
        oxygenLevelAverage = json['oxygenLevelAverage'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['oxygenLevelAverage'] = this.oxygenLevelAverage;
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
