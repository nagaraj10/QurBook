import 'package:myfhb/constants/fhb_parameters.dart';

class OxySaturationValues {
  bool isSuccess;
  List<OxyResult> result;

  OxySaturationValues({this.isSuccess, this.result});

  OxySaturationValues.fromJson(Map<String, dynamic> json) {
    isSuccess = json[is_Success];
    if (json[dataResult] != null) {
      result = new List<OxyResult>();
      json[dataResult].forEach((oxygenvalue) {
        result.add(new OxyResult.fromJson(oxygenvalue));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[is_Success] = this.isSuccess;
    if (this.result != null) {
      data[dataResult] =
          this.result.map((oxygenvalue) => oxygenvalue.toJson()).toList();
    }
    return data;
  }
}

class OxyResult {
  String sourceType;
  String startDateTime;
  String endDateTime;
  int oxygenSaturation;
  String deviceId;
  DateTime dateTimeValue;
  String bpm;
  OxyResult(
      {this.sourceType,
      this.startDateTime,
      this.endDateTime,
      this.oxygenSaturation,
      this.deviceId,
      this.dateTimeValue,
      this.bpm});

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
