import '../../constants/fhb_parameters.dart';

class OxySaturationValues {
  bool isSuccess;
  List<OxyResult> result;

  OxySaturationValues({this.isSuccess, this.result});

  OxySaturationValues.fromJson(Map<String, dynamic> json) {
    isSuccess = json[is_Success];
    if (json[dataResult] != null) {
      result = <OxyResult>[];
      json[dataResult].forEach((oxygenvalue) {
        result.add(OxyResult.fromJson(oxygenvalue));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data[is_Success] = isSuccess;
    if (result != null) {
      data[dataResult] =
          result.map((oxygenvalue) => oxygenvalue.toJson()).toList();
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
    final data = <String, dynamic>{};
    data[strsourcetype] = sourceType;
    data[strStartTimeStamp] = startDateTime;
    data[strEndTimeStamp] = endDateTime;
    data[strParamOxygen] = oxygenSaturation;
    return data;
  }
}
