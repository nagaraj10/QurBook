import 'dart:convert';

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
        isSuccess: json["isSuccess"],
        result:
            List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
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
        lastSyncDateTime: DateTime.parse(json["lastSyncDateTime"]),
        devicedatatype: json["devicedatatype"],
        devicetype: json["devicetype"],
        sourcetype: json["sourcetype"],
      );

  Map<String, dynamic> toJson() => {
        "lastSyncDateTime": lastSyncDateTime.toIso8601String(),
        "devicedatatype": devicedatatype,
        "devicetype": devicetype,
        "sourcetype": sourcetype,
      };
}
