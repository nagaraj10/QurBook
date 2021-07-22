import 'RefrenceValueMeta.dart';
import '../../constants/fhb_parameters.dart' as param;

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
  BloodGlucoseEntity(
      {
      //this.id,
      this.startDateTime,
      this.endDateTime,
      this.bloodGlucoseLevel,
      this.bgUnit,
      this.mealContext,
      this.mealType,
      this.deviceHealthRecord,
      this.averageAsOfNow});

  //String id;
  DateTime startDateTime;
  DateTime endDateTime;
  int bloodGlucoseLevel;
  RefrenceValueMeta bgUnit;
  RefrenceValueMeta mealContext;
  RefrenceValueMeta mealType;
  DeviceHealthRecord deviceHealthRecord;
  AverageAsOfNow averageAsOfNow;

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
            ? DeviceHealthRecord.fromJson(
                json[param.strParamDeviceHealthRecord])
            : null,
        averageAsOfNow: json['averageAsOfNow'] != null
            ? AverageAsOfNow.fromJson(json['averageAsOfNow'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        //"id": id,
        param.strsyncStartDate: startDateTime.toIso8601String(),
        param.strsyncEndDate: endDateTime.toIso8601String(),
        param.strParamBGLevel: bloodGlucoseLevel,
        param.strParamBGUnit: bgUnit.toJson(),
        param.strParamBGMealContext: mealContext.toJson(),
        param.strParamBGMealType: mealType.toJson(),
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
    final data = <String, dynamic>{};
    if (sourceType != null) {
      data['sourceType'] = sourceType.toJson();
    }
    data[param.strCreatedOn] = createdOn.toIso8601String();

    return data;
  }
}

class AverageAsOfNow {
  var ppAverage;
  var fastingAverage;

  AverageAsOfNow({this.ppAverage, this.fastingAverage});

  AverageAsOfNow.fromJson(Map<String, dynamic> json) {
    ppAverage = json['ppAverage'];
    fastingAverage = json['fastingAverage'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['ppAverage'] = ppAverage;
    data['fastingAverage'] = fastingAverage;
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
    final data = Map<String, dynamic>();
    data['name'] = code;
    return data;
  }
}
