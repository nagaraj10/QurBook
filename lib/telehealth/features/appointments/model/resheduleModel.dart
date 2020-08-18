

class Reshedule {
  Reshedule({
    this.status,
    this.success,
    this.message,
    this.response,
  });

  int status;
  bool success;
  String message;
  Response response;

  factory Reshedule.fromJson(Map<String, dynamic> json) => Reshedule(
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
    this.appointmentInfo,
    this.paymentInfo,
  });

  AppointmentInfo appointmentInfo;
  PaymentInfo paymentInfo;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    appointmentInfo: AppointmentInfo.fromJson(json["appointmentInfo"]),
    paymentInfo: PaymentInfo.fromJson(json["paymentInfo"]),
  );

  Map<String, dynamic> toJson() => {
    "appointmentInfo": appointmentInfo.toJson(),
    "paymentInfo": paymentInfo.toJson(),
  };
}

class AppointmentInfo {
  AppointmentInfo({
    this.bookingId,
    this.createdBy,
    this.createdFor,
    this.doctorSessionId,
    this.plannedStartDateTime,
    this.plannedEndDateTime,
    this.actualStartDateTime,
    this.actualEndDateTime,
    this.statusId,
    this.slotNumber,
    this.isMedicalRecordsShared,
    this.sharedMedicalRecordsId,
    this.isActive,
    this.isFollowUpFee,
    this.createdOn,
    this.lastModifiedOn,
    this.lastModifiedBy,
    this.id,
  });

  String bookingId;
  String createdBy;
  String createdFor;
  String doctorSessionId;
  DateTime plannedStartDateTime;
  DateTime plannedEndDateTime;
  dynamic actualStartDateTime;
  dynamic actualEndDateTime;
  String statusId;
  String slotNumber;
  bool isMedicalRecordsShared;
  String sharedMedicalRecordsId;
  bool isActive;
  bool isFollowUpFee;
  DateTime createdOn;
  DateTime lastModifiedOn;
  String lastModifiedBy;
  String id;

  factory AppointmentInfo.fromJson(Map<String, dynamic> json) => AppointmentInfo(
    bookingId: json["bookingID"],
    createdBy: json["createdBy"],
    createdFor: json["createdFor"],
    doctorSessionId: json["doctorSessionId"],
    plannedStartDateTime: DateTime.parse(json["plannedStartDateTime"]),
    plannedEndDateTime: DateTime.parse(json["plannedEndDateTime"]),
    actualStartDateTime: json["actualStartDateTime"],
    actualEndDateTime: json["actualEndDateTime"],
    statusId: json["statusId"],
    slotNumber: json["slotNumber"],
    isMedicalRecordsShared: json["isMedicalRecordsShared"],
    sharedMedicalRecordsId: json["sharedMedicalRecordsId"],
    isActive: json["isActive"],
    isFollowUpFee: json["isFollowUpFee"],
    createdOn: DateTime.parse(json["createdOn"]),
    lastModifiedOn: DateTime.parse(json["lastModifiedOn"]),
    lastModifiedBy: json["lastModifiedBy"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "bookingID": bookingId,
    "createdBy": createdBy,
    "createdFor": createdFor,
    "doctorSessionId": doctorSessionId,
    "plannedStartDateTime": plannedStartDateTime.toIso8601String(),
    "plannedEndDateTime": plannedEndDateTime.toIso8601String(),
    "actualStartDateTime": actualStartDateTime,
    "actualEndDateTime": actualEndDateTime,
    "statusId": statusId,
    "slotNumber": slotNumber,
    "isMedicalRecordsShared": isMedicalRecordsShared,
    "sharedMedicalRecordsId": sharedMedicalRecordsId,
    "isActive": isActive,
    "isFollowUpFee": isFollowUpFee,
    "createdOn": createdOn.toIso8601String(),
    "lastModifiedOn": lastModifiedOn.toIso8601String(),
    "lastModifiedBy": lastModifiedBy,
    "id": id,
  };
}

class PaymentInfo {
  PaymentInfo();

  factory PaymentInfo.fromJson(Map<String, dynamic> json) => PaymentInfo(
  );

  Map<String, dynamic> toJson() => {
  };
}
