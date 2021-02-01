import 'RefrenceValueMeta.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as param;

class BloodGlucose {
  BloodGlucose({
    this.isSuccess,
    this.entities,
  });

  bool isSuccess;
  List<BloodGlucoseEntity> entities;

  factory BloodGlucose.fromJson(Map<String, dynamic> json) => BloodGlucose(
        isSuccess: json[param.is_Success],
        entities: List<BloodGlucoseEntity>.from(
            json[param.strentities].map((x) => BloodGlucoseEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        param.is_Success: isSuccess,
        param.strentities: List<dynamic>.from(entities.map((x) => x.toJson())),
      };
}

class BloodGlucoseEntity {
  BloodGlucoseEntity({
    //this.id,
    this.startDateTime,
    this.endDateTime,
    this.bloodGlucoseLevel,
    this.bgUnit,
    this.mealContext,
    this.mealType,
    this.deviceHealthRecord
  });

  //String id;
  DateTime startDateTime;
  DateTime endDateTime;
  int bloodGlucoseLevel;
  RefrenceValueMeta bgUnit;
  RefrenceValueMeta mealContext;
  RefrenceValueMeta mealType;
  DeviceHealthRecord deviceHealthRecord;

  factory BloodGlucoseEntity.fromJson(Map<String, dynamic> json) =>
      BloodGlucoseEntity(
        //id: json["id"],
        startDateTime: DateTime.parse(json[param.strsyncStartDate]),
        endDateTime: DateTime.parse(json[param.strsyncEndDate]),
        bloodGlucoseLevel: json[param.strParamBGLevel],
        bgUnit: RefrenceValueMeta.fromJson(json[param.strParamBGUnit]),
        mealContext: (json[param.strParamBGMealContext] == null)
            ? null
            : RefrenceValueMeta.fromJson(json[param.strParamBGMealContext]),
        mealType: (json[param.strParamBGMealType] == null)
            ? null
            : RefrenceValueMeta.fromJson(json[param.strParamBGMealType]),
        deviceHealthRecord: json[param.strParamDeviceHealthRecord] != null
            ? new DeviceHealthRecord.fromJson(json[param.strParamDeviceHealthRecord])
            : null
      );

  Map<String, dynamic> toJson() => {
        //"id": id,
        param.strsyncStartDate: startDateTime.toIso8601String(),
        param.strsyncEndDate: endDateTime.toIso8601String(),
        param.strParamBGLevel: bloodGlucoseLevel,
        param.strParamBGUnit: bgUnit.toJson(),
        param.strParamBGMealContext: mealContext.toJson(),
        param.strParamBGMealType: mealType.toJson(),
        param.strParamDeviceHealthRecord:deviceHealthRecord.toJson(),
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
