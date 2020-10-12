import 'package:myfhb/telehealth/features/appointments/constants/appointments_parameters.dart'
    as parameters;
import 'package:myfhb/telehealth/features/appointments/model/createdBy.dart';

class ResheduleAppointmentInfo {
  bool isFollowUp;
  String slotNumber;
  bool isHealthRecordShared;
  Null sharedHealthRecordMetadata;
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
  Null actualStartDateTime;
  Null actualEndDateTime;
  Null plannedFollowupDate;
  Null isFollowup;
  Null lastModifiedOn;
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
    isFollowUp = json['isFollowUp'];
    slotNumber = json['slotNumber'];
    isHealthRecordShared = json['isHealthRecordShared'];
    sharedHealthRecordMetadata = json['sharedHealthRecordMetadata'];
    doctorSession = json['doctorSession'] != null
        ? new CreatedBy.fromJson(json['doctorSession'])
        : null;
    isActive = json['isActive'];
    lastModifiedBy = json['lastModifiedBy'] != null
        ? new CreatedBy.fromJson(json['lastModifiedBy'])
        : null;
    bookedFor = json['bookedFor'] != null
        ? new CreatedBy.fromJson(json['bookedFor'])
        : null;
    createdBy = json['createdBy'] != null
        ? new CreatedBy.fromJson(json['createdBy'])
        : null;
    bookedBy = json['bookedBy'] != null
        ? new CreatedBy.fromJson(json['bookedBy'])
        : null;
    bookingId = json['bookingId'];
    plannedStartDateTime = json['plannedStartDateTime'];
    plannedEndDateTime = json['plannedEndDateTime'];
    status =
        json['status'] != null ? new CreatedBy.fromJson(json['status']) : null;
    doctorSessionId = json['doctorSessionId'];
    actualStartDateTime = json['actualStartDateTime'];
    actualEndDateTime = json['actualEndDateTime'];
    plannedFollowupDate = json['plannedFollowupDate'];
    isFollowup = json['isFollowup'];
    lastModifiedOn = json['lastModifiedOn'];
    id = json['id'];
    isRefunded = json['isRefunded'];
    isFollowupFee = json['isFollowupFee'];
    createdOn = json['createdOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isFollowUp'] = this.isFollowUp;
    data['slotNumber'] = this.slotNumber;
    data['isHealthRecordShared'] = this.isHealthRecordShared;
    data['sharedHealthRecordMetadata'] = this.sharedHealthRecordMetadata;
    if (this.doctorSession != null) {
      data['doctorSession'] = this.doctorSession.toJson();
    }
    data['isActive'] = this.isActive;
    if (this.lastModifiedBy != null) {
      data['lastModifiedBy'] = this.lastModifiedBy.toJson();
    }
    if (this.bookedFor != null) {
      data['bookedFor'] = this.bookedFor.toJson();
    }
    if (this.createdBy != null) {
      data['createdBy'] = this.createdBy.toJson();
    }
    if (this.bookedBy != null) {
      data['bookedBy'] = this.bookedBy.toJson();
    }
    data['bookingId'] = this.bookingId;
    data['plannedStartDateTime'] = this.plannedStartDateTime;
    data['plannedEndDateTime'] = this.plannedEndDateTime;
    if (this.status != null) {
      data['status'] = this.status.toJson();
    }
    data['doctorSessionId'] = this.doctorSessionId;
    data['actualStartDateTime'] = this.actualStartDateTime;
    data['actualEndDateTime'] = this.actualEndDateTime;
    data['plannedFollowupDate'] = this.plannedFollowupDate;
    data['isFollowup'] = this.isFollowup;
    data['lastModifiedOn'] = this.lastModifiedOn;
    data['id'] = this.id;
    data['isRefunded'] = this.isRefunded;
    data['isFollowupFee'] = this.isFollowupFee;
    data['createdOn'] = this.createdOn;
    return data;
  }
}
