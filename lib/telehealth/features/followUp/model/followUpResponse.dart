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

  FollowOnDate.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    success = json["success"];
    message = json["message"];
    response =
        json["response"] == null ? null : Response.fromJson(json["response"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["status"] = status;
    data["success"] = success;
    data["message"] = message;
    data["response"] = response.toJson();
    return data;
  }
}

class Response {
  Response({
    this.count,
    this.data,
  });

  int count;
  Data data;

  Response.fromJson(Map<String, dynamic> json) {
    count = json["count"];
    data = json["data"] == null ? null : Data.fromJson(json["data"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["count"] = count;
    data["data"] = this.data.toJson();
    return data;
  }
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

  Data.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    bookingId = json["bookingID"];
    createdBy = json["createdBy"];
    createdFor = json["createdFor"];
    doctorSessionId = json["doctorSessionId"];
    plannedStartDateTime = DateTime.parse(json["plannedStartDateTime"]);
    plannedEndDateTime = DateTime.parse(json["plannedEndDateTime"]);
    plannedFollowupDate = DateTime.parse(json["plannedFollowupDate"]);
    actualStartDateTime = json["actualStartDateTime"];
    actualEndDateTime = json["actualEndDateTime"];
    statusId = json["statusId"];
    slotNumber = json["slotNumber"];
    isMedicalRecordsShared = json["isMedicalRecordsShared"];
    sharedMedicalRecordsId = json["sharedMedicalRecordsId"];
    isActive = json["isActive"];
    isFollowUpFee = json["isFollowUpFee"];
    isFollowUp = json["isFollowUp"];
    createdOn = DateTime.parse(json["createdOn"]);
    lastModifiedOn = DateTime.parse(json["lastModifiedOn"]);
    lastModifiedBy = json["lastModifiedBy"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = id;
    data["bookingID"] = bookingId;
    data["createdBy"] = createdBy;
    data["createdFor"] = createdFor;
    data["doctorSessionId"] = doctorSessionId;
    data["plannedStartDateTime"] = plannedStartDateTime.toIso8601String();
    data["plannedEndDateTime"] = plannedEndDateTime.toIso8601String();
    data["plannedFollowupDate"] = plannedFollowupDate.toIso8601String();
    data["actualStartDateTime"] = actualStartDateTime;
    data["actualEndDateTime"] = actualEndDateTime;
    data["statusId"] = statusId;
    data["slotNumber"] = slotNumber;
    data["isMedicalRecordsShared"] = isMedicalRecordsShared;
    data["sharedMedicalRecordsId"] = sharedMedicalRecordsId;
    data["isActive"] = isActive;
    data["isFollowUpFee"] = isFollowUpFee;
    data["isFollowUp"] = isFollowUp;
    data["createdOn"] = createdOn.toIso8601String();
    data["lastModifiedOn"] = lastModifiedOn.toIso8601String();
    data["lastModifiedBy"] = lastModifiedBy;
    return data;
  }
}
