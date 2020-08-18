import 'package:myfhb/constants/fhb_parameters.dart';

class OxySaturationValues {
  bool isSuccess;
  List<OxyResult> result;

  OxySaturationValues({this.isSuccess, this.result});

  OxySaturationValues.fromJson(Map<String, dynamic> json) {
    isSuccess = json[strisSuccess];
    if (json[strresult] != null) {
      result = new List<OxyResult>();
      json[strresult].forEach((v) {
        result.add(new OxyResult.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[strisSuccess] = this.isSuccess;
    if (this.result != null) {
      data[strresult] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OxyResult {
  String sourceType;
  String startDateTime;
  String endDateTime;
  int oxygenSaturation;

  OxyResult(
      {this.sourceType,
      this.startDateTime,
      this.endDateTime,
      this.oxygenSaturation});

  OxyResult.fromJson(Map<String, dynamic> json) {
    sourceType = json[strsourcetype];
    startDateTime = json[strStartTimeStamp];
    endDateTime = json[strEndTimeStamp];
    oxygenSaturation = json[strParamOxygen];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[strsourcetype] = this.sourceType;
    data[strStartTimeStamp] = this.startDateTime;
    data[strEndTimeStamp] = this.endDateTime;
    data[strParamOxygen] = this.oxygenSaturation;
    return data;
  }
}
