import 'package:myfhb/constants/fhb_parameters.dart';

class TemperatureValues {
  bool isSuccess;
  List<TMPResult> result;

  TemperatureValues({this.isSuccess, this.result});

  TemperatureValues.fromJson(Map<String, dynamic> json) {
    isSuccess = json[is_Success];
    if (json[dataResult] != null) {
      result = new List<TMPResult>();
      json[dataResult].forEach((tempaturevalue) {
        result.add(new TMPResult.fromJson(tempaturevalue));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[is_Success] = this.isSuccess;
    if (this.result != null) {
      data[dataResult] =
          this.result.map((tempaturevalue) => tempaturevalue.toJson()).toList();
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

  TMPResult(
      {this.sourceType,
      this.startDateTime,
      this.endDateTime,
      this.temperature,
      this.temperatureUnit});

  TMPResult.fromJson(Map<String, dynamic> json) {
    sourceType = json[strsourcetype];
    startDateTime = json[strStartTimeStamp];
    endDateTime = json[strEndTimeStamp];
    temperature = json[strParamTemp];
    temperatureUnit = json[strParamTempUnit];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[strsourcetype] = this.sourceType;
    data[strStartTimeStamp] = this.startDateTime;
    data[strEndTimeStamp] = this.endDateTime;
    data[strParamTemp] = this.temperature;
    data[strParamTempUnit] = this.temperatureUnit;
    return data;
  }
}
