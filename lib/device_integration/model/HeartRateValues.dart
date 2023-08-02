
import 'package:myfhb/common/CommonUtil.dart';

import '../../constants/fhb_parameters.dart';

class HeartRateValues {
  bool? isSuccess;
  List<HRResult>? result;

  HeartRateValues({this.isSuccess, this.result});

  HeartRateValues.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json[is_Success];
      if (json[dataResult] != null) {
            result = <HRResult>[];
            json[dataResult].forEach((hrtvalue) {
              result!.add(HRResult.fromJson(hrtvalue));
            });
          }
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[is_Success] = isSuccess;
    if (result != null) {
      data[dataResult] =
          result!.map((hrtvalue) => hrtvalue.toJson()).toList();
    }
    return data;
  }
}

class HRResult {
  String? sourceType;
  String? startDateTime;
  String? endDateTime;
  int? bpm;

  HRResult({this.sourceType, this.startDateTime, this.endDateTime, this.bpm});

  HRResult.fromJson(Map<String, dynamic> json) {
    try {
      sourceType = json[strsourcetype];
      startDateTime = json[strStartTimeStamp];
      endDateTime = json[strEndTimeStamp];
      bpm = json[strParamHeartRate];
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[strsourcetype] = sourceType;
    data[strStartTimeStamp] = startDateTime;
    data[strEndTimeStamp] = endDateTime;
    data[strParamHeartRate] = bpm;
    return data;
  }
}
