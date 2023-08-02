
import 'dart:convert';
import 'package:myfhb/common/CommonUtil.dart';

import '../../constants/fhb_parameters.dart' as param;


LatestSync latestSyncFromJson(String str) => LatestSync.fromJson(json.decode(str));

String latestSyncToJson(LatestSync data) => json.encode(data.toJson());

class LatestSync {
  LatestSync({
    this.isSuccess,
    this.result,
  });

  bool? isSuccess;
  Result? result;

  // factory LatestSync.fromJson(Map<String, dynamic> json) => LatestSync(
  //     isSuccess: json[param.is_Success],
  //     result: Result.fromJson(json[param.dataResult]),
  // );

  LatestSync.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json[param.is_Success];
      if (json[param.dataResult] != null) {
            result:
            Result.fromJson(json[param.dataResult]);
          }
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }

  Map<String, dynamic> toJson() => {
        param.is_Success: isSuccess,
        param.dataResult: result?.toJson(),
      };
}

class Result {
  Result({
    this.startDateTime,
    this.endDateTime,
    this.lastSyncDateTime,
  });

  DateTime? startDateTime;
  DateTime? endDateTime;
  DateTime? lastSyncDateTime;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        startDateTime: DateTime.parse(json[param.strStartTimeStamp]),
        endDateTime: DateTime.parse(json[param.strEndTimeStamp]),
        lastSyncDateTime: DateTime.parse(json[param.strlastSyncDateTime]),
      );

  Map<String, dynamic> toJson() => {
        param.strStartTimeStamp: startDateTime?.toIso8601String(),
        param.strEndTimeStamp: endDateTime?.toIso8601String(),
        param.strlastSyncDateTime: lastSyncDateTime?.toIso8601String(),
      };
}
