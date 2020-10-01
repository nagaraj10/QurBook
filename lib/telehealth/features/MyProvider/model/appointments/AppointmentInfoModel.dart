import 'package:myfhb/constants/fhb_parameters.dart';

class AppointmentInfoModel {
  bool isFollowUp;
  String slotNumber;
  DoctorSession doctorSession;
  bool isActive;
  DoctorSession lastModifiedBy;
  DoctorSession bookedFor;
  DoctorSession createdBy;
  DoctorSession bookedBy;
  String bookingId;
  String plannedStartDateTime;
  String plannedEndDateTime;
  DoctorSession status;
  String doctorSessionId;
  String actualStartDateTime;
  String actualEndDateTime;
  String plannedFollowupDate;
  bool isFollowup;
  String lastModifiedOn;
  String id;
  bool isHealthRecordShared;
  bool isRefunded;
  bool isFollowupFee;
  String createdOn;

  AppointmentInfoModel(
      {this.isFollowUp,
        this.slotNumber,
        this.doctorSession,
        this.isActive,
        this.lastModifiedBy,
        this.bookedFor,
        this.createdBy,
        this.bookedBy,
        this.bookingId,
        this.plannedStartDateTime,
        this.plannedEndDateTime,
        this.status,
        this.doctorSessionId,
        this.actualStartDateTime,
        this.actualEndDateTime,
        this.plannedFollowupDate,
        this.isFollowup,
        this.lastModifiedOn,
        this.id,
        this.isHealthRecordShared,
        this.isRefunded,
        this.isFollowupFee,
        this.createdOn});

  AppointmentInfoModel.fromJson(Map<String, dynamic> json) {
    isFollowUp = json[strIsFollowUp_C];
    slotNumber = json[strSlotNumber];
    doctorSession = json[strDoctorSession] != null
        ? new DoctorSession.fromJson(json[strDoctorSession])
        : null;
    isActive = json[strIsActive];
    lastModifiedBy = json[strlastModifiedBy] != null
        ? new DoctorSession.fromJson(json[strlastModifiedBy])
        : null;
    bookedFor = json[strBookedFor] != null
        ? new DoctorSession.fromJson(json[strBookedFor])
        : null;
    createdBy = json[strCreatedBy] != null
        ? new DoctorSession.fromJson(json[strCreatedBy])
        : null;
    bookedBy = json[strBookedBy] != null
        ? new DoctorSession.fromJson(json[strBookedBy])
        : null;
    bookingId = json[strBookingId_S];
    plannedStartDateTime = json[strPlannedStartDateTime];
    plannedEndDateTime = json[strPlannedEndDateTime];
    status = json[strStatus] != null
        ? new DoctorSession.fromJson(json[strStatus])
        : null;
    doctorSessionId = json[strDoctorSessionId];
    actualStartDateTime = json[strActualStartDateTime];
    actualEndDateTime = json[strActualEndDateTime];
    plannedFollowupDate = json[strPlannedFollowupDate];
    isFollowup = json[strIsFollowUp_S];
    lastModifiedOn = json[strLastModifiedOn];
    id = json[strId];
    isHealthRecordShared = json[strIsHealthRecordShared];
    isRefunded = json[strIsRefunded];
    isFollowupFee = json[strIsFollowUpFee];
    createdOn = json[strCreatedOn];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[strIsFollowUp_C] = this.isFollowUp;
    data[strSlotNumber] = this.slotNumber;
    if (this.doctorSession != null) {
      data[strDoctorSession] = this.doctorSession.toJson();
    }
    data[strIsActive] = this.isActive;
    if (this.lastModifiedBy != null) {
      data[strlastModifiedBy] = this.lastModifiedBy.toJson();
    }
    if (this.bookedFor != null) {
      data[strBookedFor] = this.bookedFor.toJson();
    }
    if (this.createdBy != null) {
      data[strCreatedBy] = this.createdBy.toJson();
    }
    if (this.bookedBy != null) {
      data[strBookedBy] = this.bookedBy.toJson();
    }
    data[strBookingId_S] = this.bookingId;
    data[strPlannedStartDateTime] = this.plannedStartDateTime;
    data[strPlannedEndDateTime] = this.plannedEndDateTime;
    if (this.status != null) {
      data[strStatus] = this.status.toJson();
    }
    data[strDoctorSessionId] = this.doctorSessionId;
    data[strActualStartDateTime] = this.actualStartDateTime;
    data[strActualEndDateTime] = this.actualEndDateTime;
    data[strPlannedFollowupDate] = this.plannedFollowupDate;
    data[strIsFollowUp_S] = this.isFollowup;
    data[strLastModifiedOn] = this.lastModifiedOn;
    data[strId] = this.id;
    data[strIsHealthRecordShared] = this.isHealthRecordShared;
    data[strIsRefunded] = this.isRefunded;
    data[strIsFollowUpFee] = this.isFollowupFee;
    data[strCreatedOn] = this.createdOn;
    return data;
  }
}

class DoctorSession {
  String id;

  DoctorSession({this.id});

  DoctorSession.fromJson(Map<String, dynamic> json) {
    id = json[strId];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[strId] = this.id;
    return data;
  }
}