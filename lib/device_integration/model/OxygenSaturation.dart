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
    });

    //String id;
    DateTime startDateTime;
    DateTime endDateTime;
    int oxygenSaturation;

    factory OxygenSaturationEntity.fromJson(Map<String, dynamic> json) => OxygenSaturationEntity(
        //id: json["id"],
        startDateTime: DateTime.parse(json[param.strsyncStartDate]),
        endDateTime: DateTime.parse(json[param.strsyncEndDate]),
        oxygenSaturation: json[param.strParamOxygen],
    );

    Map<String, dynamic> toJson() => {
        // "id": id,
        param.strsyncStartDate: startDateTime.toIso8601String(),
        param.strsyncEndDate: endDateTime.toIso8601String(),
        param.strParamOxygen: oxygenSaturation,
    };
}
