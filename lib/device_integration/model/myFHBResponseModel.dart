import 'dart:convert';

LastSync lastSyncFromJson(String str) => LastSync.fromJson(json.decode(str));

String lastSyncToJson(LastSync data) => json.encode(data.toJson());

class LastSync {
  LastSync({
    this.status,
    this.success,
    this.message,
    this.response,
  });

  int status;
  bool success;
  String message;
  Response response;

  factory LastSync.fromJson(Map<String, dynamic> json) => LastSync(
        status: json["status"],
        success: json["success"],
        message: json["message"],
        response: Response.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "success": success,
        "message": message,
        "response": response.toJson(),
      };
}

class Response {
  Response({
    this.count,
    this.data,
  });

  int count;
  Data data;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        count: json["count"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.count,
    this.healthRecordInfo,
  });

  int count;
  List<HealthRecordInfo> healthRecordInfo;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        count: json["count"],
        healthRecordInfo: List<HealthRecordInfo>.from(
            json["healthRecordInfo"].map((x) => HealthRecordInfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "healthRecordInfo":
            List<dynamic>.from(healthRecordInfo.map((x) => x.toJson())),
      };
}

class HealthRecordInfo {
  HealthRecordInfo({
    this.lastSyncDateTime,
    this.sourcetype,
    this.devicetype,
    this.devicedatatype,
  });

  DateTime lastSyncDateTime;
  String sourcetype;
  String devicetype;
  String devicedatatype;

  factory HealthRecordInfo.fromJson(Map<String, dynamic> json) =>
      HealthRecordInfo(
        lastSyncDateTime: DateTime.parse(json["lastSyncDateTime"]),
        sourcetype: json["sourcetype"],
        devicetype: json["devicetype"],
        devicedatatype: json["devicedatatype"],
      );

  Map<String, dynamic> toJson() => {
        "lastSyncDateTime": lastSyncDateTime.toIso8601String(),
        "sourcetype": sourcetype,
        "devicetype": devicetype,
        "devicedatatype": devicedatatype,
      };
}
