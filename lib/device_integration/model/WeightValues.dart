import 'package:myfhb/constants/fhb_parameters.dart';

class WeightValues {
  bool isSuccess;
  List<WVResult> result;

  WeightValues({this.isSuccess, this.result});

  WeightValues.fromJson(Map<String, dynamic> json) {
    isSuccess = json[is_Success];
    if (json[dataResult] != null) {
      result = new List<WVResult>();
      json[dataResult].forEach((wgtvalue) {
        result.add(new WVResult.fromJson(wgtvalue));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[is_Success] = this.isSuccess;
    if (this.result != null) {
      data[dataResult] =
          this.result.map((wgtvalue) => wgtvalue.toJson()).toList();
    }
    return data;
  }
}

class WVResult {
  String sourceType;
  String startDateTime;
  String endDateTime;
  String weight;
  String weightUnit;

  WVResult(
      {this.sourceType,
      this.startDateTime,
      this.endDateTime,
      this.weight,
      this.weightUnit});

  WVResult.fromJson(Map<String, dynamic> json) {
    sourceType = json[strsourcetype];
    startDateTime = json[strStartTimeStamp];
    endDateTime = json[strEndTimeStamp];
    weight = json[strParamWeight];
    weightUnit = json[strParamWeightUnit];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[strsourcetype] = this.sourceType;
    data[strStartTimeStamp] = this.startDateTime;
    data[strEndTimeStamp] = this.endDateTime;
    data[strParamWeight] = this.weight;
    data[strParamWeightUnit] = this.weightUnit;
    return data;
  }
}
