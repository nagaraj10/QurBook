

import 'dart:convert';

FollowOnDate followOnDateFromJson(String str) => FollowOnDate.fromJson(json.decode(str));

String followOnDateToJson(FollowOnDate data) => json.encode(data.toJson());

class FollowOnDate {
  FollowOnDate({
    this.status,
    this.success,
    this.message,
    this.response,
  });

  int status;
  bool success;
  String message;
  Response response;

  factory FollowOnDate.fromJson(Map<String, dynamic> json) => FollowOnDate(
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
    this.id,
    this.bookingId,
    this.createdBy,
    this.createdFor,
    this.doctorSessionId,
    this.plannedStartDateTime,
    this.plannedEndDateTime,
    this.plannedFollowupDate,
    this.actualStartDateTime,
    this.actualEndDateTime,
    this.statusId,
    this.slotNumber,
    this.isMedicalRecordsShared,
    this.sharedMedicalRecordsId,
    this.isActive,
    this.isFollowUpFee,
    this.isFollowUp,
    this.createdOn,
    this.lastModifiedOn,
    this.lastModifiedBy,
  });

  String id;
  String bookingId;
  String createdBy;
  String createdFor;
  String doctorSessionId;
  DateTime plannedStartDateTime;
  DateTime plannedEndDateTime;
  DateTime plannedFollowupDate;
  dynamic actualStartDateTime;
  dynamic actualEndDateTime;
  String statusId;
  int slotNumber;
  bool isMedicalRecordsShared;
  dynamic sharedMedicalRecordsId;
  bool isActive;
  bool isFollowUpFee;
  bool isFollowUp;
  DateTime createdOn;
  DateTime lastModifiedOn;
  String lastModifiedBy;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    bookingId: json["bookingID"],
    createdBy: json["createdBy"],
    createdFor: json["createdFor"],
    doctorSessionId: json["doctorSessionId"],
    plannedStartDateTime: DateTime.parse(json["plannedStartDateTime"]),
    plannedEndDateTime: DateTime.parse(json["plannedEndDateTime"]),
    plannedFollowupDate: DateTime.parse(json["plannedFollowupDate"]),
    actualStartDateTime: json["actualStartDateTime"],
    actualEndDateTime: json["actualEndDateTime"],
    statusId: json["statusId"],
    slotNumber: json["slotNumber"],
    isMedicalRecordsShared: json["isMedicalRecordsShared"],
    sharedMedicalRecordsId: json["sharedMedicalRecordsId"],
    isActive: json["isActive"],
    isFollowUpFee: json["isFollowUpFee"],
    isFollowUp: json["isFollowUp"],
    createdOn: DateTime.parse(json["createdOn"]),
    lastModifiedOn: DateTime.parse(json["lastModifiedOn"]),
    lastModifiedBy: json["lastModifiedBy"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "bookingID": bookingId,
    "createdBy": createdBy,
    "createdFor": createdFor,
    "doctorSessionId": doctorSessionId,
    "plannedStartDateTime": plannedStartDateTime.toIso8601String(),
    "plannedEndDateTime": plannedEndDateTime.toIso8601String(),
    "plannedFollowupDate": plannedFollowupDate.toIso8601String(),
    "actualStartDateTime": actualStartDateTime,
    "actualEndDateTime": actualEndDateTime,
    "statusId": statusId,
    "slotNumber": slotNumber,
    "isMedicalRecordsShared": isMedicalRecordsShared,
    "sharedMedicalRecordsId": sharedMedicalRecordsId,
    "isActive": isActive,
    "isFollowUpFee": isFollowUpFee,
    "isFollowUp": isFollowUp,
    "createdOn": createdOn.toIso8601String(),
    "lastModifiedOn": lastModifiedOn.toIso8601String(),
    "lastModifiedBy": lastModifiedBy,
  };
}
