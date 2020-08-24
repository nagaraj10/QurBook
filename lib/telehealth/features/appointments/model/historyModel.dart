import 'package:myfhb/telehealth/features/appointments/model/healthRecord.dart';

class History {
  History({
    this.appointmentId,
    this.createdOn,
    this.createdBy,
    this.lastModifiedBy,
    this.healthRecord,
    this.plannedStartDateTime,
    this.plannedEndDateTime,
    this.slotNumber,
    this.isRefunded,
    this.bookingId,
    this.sharedMedicalRecordsId,
    this.isMedicalRecordsShared,
    this.specialization,
    this.location,
    this.doctorPic,
    this.doctorName,
    this.doctorId,
    this.doctorSessionId,
    this.patientId,
    this.actualStartDateTime,
    this.actualEndDateTime,
    this.followupDate,
    this.followupFee,
    this.status,
  });

  String appointmentId;
  String createdOn;
  String createdBy;
  String lastModifiedBy;
  HealthRecord healthRecord;
  String plannedStartDateTime;
  String plannedEndDateTime;
  int slotNumber;
  bool isRefunded;
  String bookingId;
  String sharedMedicalRecordsId;
  bool isMedicalRecordsShared;
  String specialization;
  String location;
  int doctorPic;
  String doctorName;
  String doctorId;
  String doctorSessionId;
  String patientId;
  String actualStartDateTime;
  String actualEndDateTime;
  String followupDate;
  String followupFee;
  String status;

  History.fromJson(Map<String, dynamic> json) {
    appointmentId = json["appointmentId"];
    createdOn = json["createdOn"];
    createdBy = json["createdBy"];
    lastModifiedBy = json["lastModifiedBy"];
    healthRecord = json["healthRecord"] == null
        ? null
        : HealthRecord.fromJson(json["healthRecord"]);
    plannedStartDateTime = json["plannedStartDateTime"];
    plannedEndDateTime = json["plannedEndDateTime"];
    slotNumber = json["slotNumber"];
    isRefunded = json["isRefunded"];
    bookingId = json["bookingID"];
    sharedMedicalRecordsId = json["sharedMedicalRecordsId"];
    isMedicalRecordsShared = json["isMedicalRecordsShared"];
    specialization = json["specialization"];
    location = json["location"];
    doctorPic = json["doctorPic"];
    doctorName = json["doctorName"];
    doctorId = json["doctorId"];
    doctorSessionId = json["doctorSessionId"];
    patientId = json["patientId"];
    actualStartDateTime = json["actualStartDateTime"];
    actualEndDateTime = json["actualEndDateTime"];
    followupDate = json["followupDate"];
    followupFee = json["followupFee"];
    status = json["status"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["appointmentId"] = this.appointmentId;
    data["createdOn"] = this.createdOn;
    data["createdBy"] = this.createdBy;
    data["lastModifiedBy"] = this.lastModifiedBy;
//    if (this.healthRecord != null) {
//      data["healthRecord"] =
//      List<dynamic>.from(healthRecord.map((x) => x.toJson()));
//    }
    data["plannedStartDateTime"] = this.plannedStartDateTime;
    data["plannedEndDateTime"] = this.plannedEndDateTime;
    data["slotNumber"] = this.slotNumber;
    data["isRefunded"] = this.isRefunded;
    data["bookingID"] = this.bookingId;
    data["sharedMedicalRecordsId"] = this.sharedMedicalRecordsId;
    data["isMedicalRecordsShared"] = this.isMedicalRecordsShared;
    data["specialization"] = this.specialization;
    data["location"] = this.location;
    data["doctorPic"] = this.doctorPic;
    data["doctorName"] = this.doctorName;
    data["doctorId"] = this.doctorId;
    data["doctorSessionId"] = this.doctorSessionId;
    data["patientId"] = this.patientId;
    data["actualStartDateTime"] = this.actualStartDateTime;
    data["actualEndDateTime"] = this.actualEndDateTime;
    data["followupDate"] = this.followupDate;
    data["followupFee"] = this.followupFee;
    data["status"] = this.status;
    return data;
  }
}
