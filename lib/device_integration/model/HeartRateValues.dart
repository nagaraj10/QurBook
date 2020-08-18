import 'package:myfhb/constants/fhb_parameters.dart';

class HeartRateValues {
  bool isSuccess;
  List<HRResult> result;

  HeartRateValues({this.isSuccess, this.result});

  HeartRateValues.fromJson(Map<String, dynamic> json) {
    isSuccess = json[strisSuccess];
    if (json[strresult] != null) {
      result = new List<HRResult>();
      json[strresult].forEach((v) {
        result.add(new HRResult.fromJson(v));
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

class HRResult {
  String sourceType;
  String startDateTime;
  String endDateTime;
  int bpm;

  HRResult({this.sourceType, this.startDateTime, this.endDateTime, this.bpm});

  HRResult.fromJson(Map<String, dynamic> json) {
    sourceType = json[strsourcetype];
    startDateTime = json[strStartTimeStamp];
    endDateTime = json[strEndTimeStamp];
    bpm = json[strParamHeartRate];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[strsourcetype] = this.sourceType;
    data[strStartTimeStamp] = this.startDateTime;
    data[strEndTimeStamp] = this.endDateTime;
    data[strParamHeartRate] = this.bpm;
    return data;
  }
}
