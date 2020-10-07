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
  });

  //String id;
  DateTime startDateTime;
  DateTime endDateTime;
  int bloodGlucoseLevel;
  RefrenceValueMeta bgUnit;
  RefrenceValueMeta mealContext;
  RefrenceValueMeta mealType;

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
      );

  Map<String, dynamic> toJson() => {
        //"id": id,
        param.strsyncStartDate: startDateTime.toIso8601String(),
        param.strsyncEndDate: endDateTime.toIso8601String(),
        param.strParamBGLevel: bloodGlucoseLevel,
        param.strParamBGUnit: bgUnit.toJson(),
        param.strParamBGMealContext : mealContext.toJson(),
        param.strParamBGMealType : mealType.toJson(),
      };
}
