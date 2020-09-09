import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class ResheduleAppointmentInfo {
  ResheduleAppointmentInfo({
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

  ResheduleAppointmentInfo.fromJson(Map<String, dynamic> json) {
    bookingId = json[parameters.strBookingID];
    createdBy = json[parameters.strCreatedBy];
    createdFor = json[parameters.strCreatedFor];
    doctorSessionId = json[parameters.strDoctorSessionId];
    plannedStartDateTime = DateTime.parse(json[parameters.strPlannedStartDateTime]);
    plannedEndDateTime = DateTime.parse(json[parameters.strPlannedEndDateTime]);
    actualStartDateTime = json[parameters.strActualStartDateTime];
    actualEndDateTime = json[parameters.strActualEndDateTime];
    statusId = json[parameters.strStatusId];
    slotNumber = json[parameters.strSlotNumber];
    isMedicalRecordsShared = json[parameters.strIsMedicalRecordsShared];
    sharedMedicalRecordsId = json[parameters.strSharedMedicalRecordsId];
    isActive = json[parameters.strIsActive];
    isFollowUpFee = json[parameters.strIsFollowUpFee];
    createdOn = DateTime.parse(json[parameters.strCreatedOn]);
    lastModifiedOn = DateTime.parse(json[parameters.strLastModifiedOn]);
    lastModifiedBy = json[parameters.strlastModifiedBy];
    id = json[parameters.strId];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strBookingID] = bookingId;
    data[parameters.strCreatedBy] = createdBy;
    data[parameters.strCreatedFor] = createdFor;
    data[parameters.strDoctorSessionId] = doctorSessionId;
    data[parameters.strPlannedStartDateTime] = plannedStartDateTime.toIso8601String();
    data[parameters.strPlannedEndDateTime] = plannedEndDateTime.toIso8601String();
    data[parameters.strActualStartDateTime] = actualStartDateTime;
    data[parameters.strActualEndDateTime] = actualEndDateTime;
    data[parameters.strStatusId] = statusId;
    data[parameters.strSlotNumber] = slotNumber;
    data[parameters.strIsMedicalRecordsShared] = isMedicalRecordsShared;
    data[parameters.strSharedMedicalRecordsId] = sharedMedicalRecordsId;
    data[parameters.strIsActive] = isActive;
    data[parameters.strIsFollowUpFee] = isFollowUpFee;
    data[parameters.strCreatedOn] = createdOn.toIso8601String();
    data[parameters.strLastModifiedOn] = lastModifiedOn.toIso8601String();
    data[parameters.strlastModifiedBy] = lastModifiedBy;
    data[parameters.strId] = id;
    return data;
  }
}

class ReshedulePaymentInfo {
  ReshedulePaymentInfo();

  ReshedulePaymentInfo.fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}
