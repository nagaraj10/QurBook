import '../../constants/fhb_parameters.dart';

class TemperatureValues {
  bool isSuccess;
  List<TMPResult> result;

  TemperatureValues({this.isSuccess, this.result});

  TemperatureValues.fromJson(Map<String, dynamic> json) {
    isSuccess = json[is_Success];
    if (json[dataResult] != null) {
      result = <TMPResult>[];
      json[dataResult].forEach((tempaturevalue) {
        result.add(TMPResult.fromJson(tempaturevalue));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data[is_Success] = isSuccess;
    if (result != null) {
      data[dataResult] =
          result.map((tempaturevalue) => tempaturevalue.toJson()).toList();
    }
    return data;
  }
}

class TMPResult {
  String sourceType;
  String startDateTime;
  String endDateTime;
  String temperature;
  String temperatureUnit;
  String deviceId;
  DateTime dateTimeValue;
  TMPResult(
      {this.sourceType,
      this.startDateTime,
      this.endDateTime,
      this.temperature,
      this.temperatureUnit,
      this.deviceId,
      this.dateTimeValue});

  TMPResult.fromJson(Map<String, dynamic> json) {
    sourceType = json[strsourcetype];
    startDateTime = json[strStartTimeStamp];
    endDateTime = json[strEndTimeStamp];
    temperature = json[strParamTemp];
    temperatureUnit = json[strParamTempUnit];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[strsourcetype] = sourceType;
    data[strStartTimeStamp] = startDateTime;
    data[strEndTimeStamp] = endDateTime;
    data[strParamTemp] = temperature;
    data[strParamTempUnit] = temperatureUnit;
    return data;
  }
}
