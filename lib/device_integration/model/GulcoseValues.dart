import '../../constants/fhb_parameters.dart';

class GlucoseValues {
  bool isSuccess;
  List<GVResult> result;

  GlucoseValues({this.isSuccess, this.result});

  GlucoseValues.fromJson(Map<String, dynamic> json) {
    isSuccess = json[is_Success];
    if (json[dataResult] != null) {
      result = List<GVResult>();
      json[dataResult].forEach((glucosevalue) {
        result.add(GVResult.fromJson(glucosevalue));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[is_Success] = isSuccess;
    if (result != null) {
      data[dataResult] =
          result.map((glucosevalue) => glucosevalue.toJson()).toList();
    }
    return data;
  }
}

class GVResult {
  String sourceType;
  String startDateTime;
  String endDateTime;
  int bloodGlucoseLevel;
  String bgUnit;
  String mealContext;
  String mealType;
  String deviceId;
  DateTime dateTimeValue;
  GVResult(
      {this.sourceType,
      this.startDateTime,
      this.endDateTime,
      this.bloodGlucoseLevel,
      this.bgUnit,
      this.mealContext,
      this.mealType,
      this.deviceId,
      this.dateTimeValue});

  GVResult.fromJson(Map<String, dynamic> json) {
    sourceType = json[strsourcetype];
    startDateTime = json[strStartTimeStamp];
    endDateTime = json[strEndTimeStamp];
    bloodGlucoseLevel = json[strParamBGLevel];
    bgUnit = json[strParamBGUnit];
    mealContext = json[strParamBGMealContext];
    mealType = json[strParamBGMealType];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data[strsourcetype] = sourceType;
    data[strStartTimeStamp] = startDateTime;
    data[strEndTimeStamp] = endDateTime;
    data[strParamBGLevel] = bloodGlucoseLevel;
    data[strParamBGUnit] = bgUnit;
    data[strParamBGMealContext] = mealContext;
    data[strParamBGMealType] = mealType;
    return data;
  }
}
