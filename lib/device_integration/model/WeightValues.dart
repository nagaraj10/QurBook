

import 'package:myfhb/common/CommonUtil.dart';

import '../../constants/fhb_parameters.dart';

class WeightValues {
  bool? isSuccess;
  List<WVResult>? result;

  WeightValues({this.isSuccess, this.result});

  WeightValues.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json[is_Success];
      if (json[dataResult] != null) {
            result = <WVResult>[];
            json[dataResult].forEach((wgtvalue) {
              result!.add(WVResult.fromJson(wgtvalue));
            });
          }
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data[is_Success] = isSuccess;
    if (result != null) {
      data[dataResult] =
          result!.map((wgtvalue) => wgtvalue.toJson()).toList();
    }
    return data;
  }
}

class WVResult {
  String? sourceType;
  String? startDateTime;
  String? endDateTime;
  String? weight;
  String? weightUnit;
  String? deviceId;
  DateTime? dateTimeValue;
  WVResult(
      {this.sourceType,
      this.startDateTime,
      this.endDateTime,
      this.weight,
      this.weightUnit,
      this.deviceId,
      this.dateTimeValue});

  WVResult.fromJson(Map<String, dynamic> json) {
    try {
      sourceType = json[strsourcetype];
      startDateTime = json[strStartTimeStamp];
      endDateTime = json[strEndTimeStamp];
      weight = json[strParamWeight];
      weightUnit = json[strParamWeightUnit];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
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
