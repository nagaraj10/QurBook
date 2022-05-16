import '../../constants/fhb_parameters.dart';

class WeightValues {
  bool isSuccess;
  List<WVResult> result;

  WeightValues({this.isSuccess, this.result});

  WeightValues.fromJson(Map<String, dynamic> json) {
    isSuccess = json[is_Success];
    if (json[dataResult] != null) {
      result = <WVResult>[];
      json[dataResult].forEach((wgtvalue) {
        result.add(WVResult.fromJson(wgtvalue));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data[is_Success] = isSuccess;
    if (result != null) {
      data[dataResult] = result.map((wgtvalue) => wgtvalue.toJson()).toList();
    }
    return data;
  }
}

class WVResult {
  String sourceType;
  String startDateTime;
  String endDateTime;
  dynamic weight;
  String weightUnit;
  String deviceId;
  DateTime dateTimeValue;
  WVResult(
      {this.sourceType,
      this.startDateTime,
      this.endDateTime,
      this.weight,
      this.weightUnit,
      this.deviceId,
      this.dateTimeValue});

  WVResult.fromJson(Map<String, dynamic> json) {
    sourceType = json[strsourcetype];
    startDateTime = json[strStartTimeStamp];
    endDateTime = json[strEndTimeStamp];
    weight = json[strParamWeight];
    weightUnit = json[strParamWeightUnit];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[strsourcetype] = sourceType;
    data[strStartTimeStamp] = startDateTime;
    data[strEndTimeStamp] = endDateTime;
    data[strParamWeight] = weight;
    data[strParamWeightUnit] = weightUnit;
    return data;
  }
}
