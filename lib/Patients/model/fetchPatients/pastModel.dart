import 'package:myfhb/Patients/constants/patients_parameters.dart'
    as parameters;

class Past {
  Past({
    this.id,
    this.bookingId,
    this.doctorSessionId,
    this.plannedStartDateTime,
    this.plannedEndDateTime,
    this.actualStartDateTime,
    this.actualEndDateTime,
    this.slotNumber,
    this.isHealthRecordShared,
    this.plannedFollowupDate,
    this.isRefunded,
    this.isFollowupFee,
    this.isFollowup,
    this.isActive,
    this.createdOn,
    this.lastModifiedOn,
  });

  String id;
  String bookingId;
  String doctorSessionId;
  String plannedStartDateTime;
  String plannedEndDateTime;
  String actualStartDateTime;
  String actualEndDateTime;
  int slotNumber;
  bool isHealthRecordShared;
  String plannedFollowupDate;
  bool isRefunded;
  bool isFollowupFee;
  bool isFollowup;
  bool isActive;
  String createdOn;
  String lastModifiedOn;

  Past.fromJson(Map<String, dynamic> json) {
    id = json[parameters.strId];
    bookingId = json[parameters.strBookingId];
    doctorSessionId = json[parameters.strDoctorSessionId];
    plannedStartDateTime = json[parameters.strPlannedStartDateTime] != null
        ? json[parameters.strPlannedStartDateTime]
        : null;
    plannedEndDateTime = json[parameters.strPlannedEndDateTime] != null
        ? json[parameters.strPlannedEndDateTime]
        : null;
    actualStartDateTime = json[parameters.strActualStartDateTime] == null
        ? null
        : json[parameters.strActualStartDateTime];
    actualEndDateTime = json[parameters.strActualEndDateTime] == null
        ? null
        : json[parameters.strActualEndDateTime];
    isHealthRecordShared = json[parameters.strIsHealthRecordShared];
    slotNumber = json[parameters.strSlotNumber];
    plannedFollowupDate = json[parameters.strPlannedFollowupDate];
    isActive = json[parameters.strIsActive];
    createdOn = json[parameters.strCreatedOn] != null
        ? json[parameters.strCreatedOn]
        : null;
    lastModifiedOn = json[parameters.strLastModifiedOn] != null
        ? json[parameters.strLastModifiedOn]
        : null;
    isRefunded = json[parameters.strIsRefunded];
    isFollowupFee = json[parameters.strIsFollowUpFee];
    isFollowup = json[parameters.strIsFollowUp];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strId] = id;
    data[parameters.strBookingId] = bookingId;
    data[parameters.strDoctorSessionId] = doctorSessionId;
    data[parameters.strPlannedStartDateTime] =
        plannedStartDateTime != null ? plannedStartDateTime : null;
    data[parameters.strPlannedEndDateTime] =
        plannedEndDateTime != null ? plannedEndDateTime : null;
    data[parameters.strActualStartDateTime] =
        actualStartDateTime == null ? null : actualStartDateTime;
    data[parameters.strActualEndDateTime] =
        actualEndDateTime == null ? null : actualEndDateTime;
    data[parameters.strIsHealthRecordShared] = isHealthRecordShared;
    data[parameters.strPlannedFollowupDate] = plannedFollowupDate;
    data[parameters.strSlotNumber] = slotNumber;
    data[parameters.strIsActive] = isActive;
    data[parameters.strCreatedOn] = createdOn != null ? createdOn : null;
    data[parameters.strLastModifiedOn] =
        lastModifiedOn != null ? lastModifiedOn : null;
    data[parameters.strIsRefunded] = isRefunded;
    data[parameters.strIsFollowUpFee] = isFollowupFee;
    data[parameters.strIsFollowUp] = isFollowup;
    return data;
  }
}
