import 'package:myfhb/constants/fhb_parameters.dart';

class GlucoseValues {
  bool isSuccess;
  List<GVResult> result;

  GlucoseValues({this.isSuccess, this.result});

  GlucoseValues.fromJson(Map<String, dynamic> json) {
    isSuccess = json[is_Success];
    if (json[dataResult] != null) {
      result = new List<GVResult>();
      json[dataResult].forEach((glucosevalue) {
        result.add(new GVResult.fromJson(glucosevalue));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[is_Success] = this.isSuccess;
    if (this.result != null) {
      data[dataResult] =
          this.result.map((glucosevalue) => glucosevalue.toJson()).toList();
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
  GVResult(
      {this.sourceType,
      this.startDateTime,
      this.endDateTime,
      this.bloodGlucoseLevel,
      this.bgUnit,
      this.mealContext,
      this.mealType,
      this.deviceId});

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[strsourcetype] = this.sourceType;
    data[strStartTimeStamp] = this.startDateTime;
    data[strEndTimeStamp] = this.endDateTime;
    data[strParamBGLevel] = this.bloodGlucoseLevel;
    data[strParamBGUnit] = this.bgUnit;
    data[strParamBGMealContext] = this.mealContext;
    data[strParamBGMealType] = this.mealType;
    return data;
  }
}
