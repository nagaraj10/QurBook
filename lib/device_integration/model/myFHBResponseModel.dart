import 'dart:convert';

import 'package:myfhb/constants/fhb_parameters.dart';

LastSync lastSyncFromJson(String str) => LastSync.fromJson(json.decode(str));

String lastSyncToJson(LastSync data) => json.encode(data.toJson());

class LastSync {
  LastSync({
    this.isSuccess,
    this.result,
  });

  bool isSuccess;
  List<Result> result;

  factory LastSync.fromJson(Map<String, dynamic> json) => LastSync(
        isSuccess: json[strisSuccess],
        result:
            List<Result>.from(json[strresult].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        strisSuccess: isSuccess,
        strresult: List<dynamic>.from(result.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    this.lastSyncDateTime,
    this.devicedatatype,
    this.devicetype,
    this.sourcetype,
  });

  DateTime lastSyncDateTime;
  String devicedatatype;
  String devicetype;
  String sourcetype;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        lastSyncDateTime: DateTime.parse(json[strlastSyncDateTime]),
        devicedatatype: json[strdeviceDataType.toLowerCase()],
        devicetype: json[strdeviceType.toLowerCase()],
        sourcetype: json[strsourcetype],
      );

  Map<String, dynamic> toJson() => {
        strlastSyncDateTime: lastSyncDateTime.toIso8601String(),
        strdeviceDataType.toLowerCase(): devicedatatype,
        strdeviceType.toLowerCase(): devicetype,
        strsourcetype: sourcetype,
      };
}
