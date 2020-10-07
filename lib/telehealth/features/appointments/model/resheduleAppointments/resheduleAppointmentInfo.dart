import 'package:myfhb/telehealth/features/appointments/constants/appointments_parameters.dart'as parameters;
import 'package:myfhb/telehealth/features/appointments/model/createdBy.dart';

class ResheduleAppointmentInfo {
  bool isFollowUp;
  String slotNumber;
  bool isHealthRecordShared;
  dynamic sharedHealthRecordMetadata;
  CreatedBy doctorSession;
  bool isActive;
  CreatedBy lastModifiedBy;
  CreatedBy bookedFor;
  CreatedBy createdBy;
  CreatedBy bookedBy;
  String bookingId;
  String plannedStartDateTime;
  String plannedEndDateTime;
  CreatedBy status;
  String doctorSessionId;
  dynamic actualStartDateTime;
  dynamic actualEndDateTime;
  dynamic plannedFollowupDate;
  dynamic isFollowup;
  dynamic lastModifiedOn;
  String id;
  bool isRefunded;
  bool isFollowupFee;
  String createdOn;

  ResheduleAppointmentInfo(
      {this.isFollowUp,
        this.slotNumber,
        this.isHealthRecordShared,
        this.sharedHealthRecordMetadata,
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
        this.isRefunded,
        this.isFollowupFee,
        this.createdOn});

  ResheduleAppointmentInfo.fromJson(Map<String, dynamic> json) {
    isFollowUp = json[parameters.strIsFollowUp];
    slotNumber = json[parameters.strSlotNumber];
    isHealthRecordShared = json[parameters.strIsHealthRecordShared];
    sharedHealthRecordMetadata = json[parameters.strSharedHealthRecordMetadata];
    doctorSession = json[parameters.strDoctorSessionId] != null
        ? new CreatedBy.fromJson(json[parameters.strDoctorSessionId])
        : null;
    isActive = json[parameters.strIsActive];
    lastModifiedBy = json[parameters.strlastModifiedBy] != null
        ? new CreatedBy.fromJson(json[parameters.strlastModifiedBy])
        : null;
    bookedFor = json[parameters.strBookedFor] != null
        ? new CreatedBy.fromJson(json[parameters.strBookedFor])
        : null;
    createdBy = json[parameters.strCreatedBy] != null
        ? new CreatedBy.fromJson(json[parameters.strCreatedBy])
        : null;
    bookedBy = json[parameters.strBookedBy] != null
        ? new CreatedBy.fromJson(json[parameters.strBookedBy])
        : null;
    bookingId = json[parameters.strBookingId];
    plannedStartDateTime = json[parameters.strPlannedStartDateTime];
    plannedEndDateTime = json[parameters.strPlannedEndDateTime];
    status = json[parameters.strStatus] != null
        ? new CreatedBy.fromJson(json[parameters.strStatus])
        : null;
    doctorSessionId = json[parameters.strDoctorSessionId];
    actualStartDateTime = json[parameters.strActualStartDateTime];
    actualEndDateTime = json[parameters.strActualEndDateTime];
    plannedFollowupDate = json[parameters.strPlannedFollowupDate];
    isFollowup = json[parameters.strIsFollowup];
    lastModifiedOn = json[parameters.strLastModifiedOn];
    id = json[parameters.strId];
    isRefunded = json[parameters.strIsRefunded];
    isFollowupFee = json[parameters.strIsFollowUpFee];
    createdOn = json[parameters.strCreatedOn];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strIsFollowUp] = this.isFollowUp;
    data[parameters.strSlotNumber] = this.slotNumber;
    data[parameters.strIsHealthRecordShared] = this.isHealthRecordShared;
    data[parameters.strSharedHealthRecordMetadata] = this.sharedHealthRecordMetadata;
    if (this.doctorSession != null) {
      data[parameters.strDoctorSessionId] = this.doctorSession.toJson();
    }
    data[parameters.strIsActive] = this.isActive;
    if (this.lastModifiedBy != null) {
      data[parameters.strlastModifiedBy] = this.lastModifiedBy.toJson();
    }
    if (this.bookedFor != null) {
      data[parameters.strBookedFor] = this.bookedFor.toJson();
    }
    if (this.createdBy != null) {
      data[parameters.strCreatedBy] = this.createdBy.toJson();
    }
    if (this.bookedBy != null) {
      data[parameters.strBookedBy] = this.bookedBy.toJson();
    }
    data[parameters.strBookingId] = this.bookingId;
    data[parameters.strPlannedStartDateTime] = this.plannedStartDateTime;
    data[parameters.strPlannedEndDateTime] = this.plannedEndDateTime;
    if (this.status != null) {
      data[parameters.strStatus] = this.status.toJson();
    }
    data[parameters.strDoctorSessionId] = this.doctorSessionId;
    data[parameters.strActualStartDateTime] = this.actualStartDateTime;
    data[parameters.strPlannedEndDateTime] = this.actualEndDateTime;
    data[parameters.strPlannedFollowupDate] = this.plannedFollowupDate;
    data[parameters.strIsFollowup] = this.isFollowup;
    data[parameters.strLastModifiedOn] = this.lastModifiedOn;
    data[parameters.strId] = this.id;
    data[parameters.strIsRefunded] = this.isRefunded;
    data[parameters.strIsFollowUpFee] = this.isFollowupFee;
    data[parameters.strCreatedOn] = this.createdOn;
    return data;
  }
}