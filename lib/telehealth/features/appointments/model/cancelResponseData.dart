import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class CancelResponseData {
  String id;
  String bookingID;
  String createdBy;
  String createdFor;
  String doctorSessionId;
  String plannedStartDateTime;
  String plannedEndDateTime;
  Null actualStartDateTime;
  Null actualEndDateTime;
  String statusId;
  int slotNumber;
  bool isMedicalRecordsShared;
  Null sharedMedicalRecordsId;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  String lastModifiedBy;
  bool isRefunded;
  bool isFollowUpFee;
  Null plannedFollowupDate;

  CancelResponseData(
      {this.id,
        this.bookingID,
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
        this.createdOn,
        this.lastModifiedOn,
        this.lastModifiedBy,
        this.isRefunded,
        this.isFollowUpFee,
        this.plannedFollowupDate});

  CancelResponseData.fromJson(Map<String, dynamic> json) {
    id = json[parameters.strId];
    bookingID = json[parameters.strBookingID];
    createdBy = json[parameters.strCreatedBy];
    createdFor = json[parameters.strCreatedFor];
    doctorSessionId = json[parameters.strDoctorSessionId];
    plannedStartDateTime = json[parameters.strPlannedStartDateTime];
    plannedEndDateTime = json[parameters.strPlannedEndDateTime];
    actualStartDateTime = json[parameters.strActualStartDateTime];
    actualEndDateTime = json[parameters.strActualEndDateTime];
    statusId = json[parameters.strStatusId];
    slotNumber = json[parameters.strSlotNumber];
    isMedicalRecordsShared = json[parameters.strIsMedicalRecordsShared];
    sharedMedicalRecordsId = json[parameters.strSharedMedicalRecordsId];
    isActive = json[parameters.strIsActive];
    createdOn = json[parameters.strCreatedOn];
    lastModifiedOn = json[parameters.strLastModifiedOn];
    lastModifiedBy = json[parameters.strlastModifiedBy];
    isRefunded = json[parameters.strIsRefunded];
    isFollowUpFee = json[parameters.strIsFollowUpFee];
    plannedFollowupDate = json[parameters.strPlannedFollowupDate];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strId] = this.id;
    data[parameters.strBookingID] = this.bookingID;
    data[parameters.strCreatedBy] = this.createdBy;
    data[parameters.strCreatedFor] = this.createdFor;
    data[parameters.strDoctorSessionId] = this.doctorSessionId;
    data[parameters.strPlannedStartDateTime] = this.plannedStartDateTime;
    data[parameters.strPlannedEndDateTime] = this.plannedEndDateTime;
    data[parameters.strActualStartDateTime] = this.actualStartDateTime;
    data[parameters.strActualEndDateTime] = this.actualEndDateTime;
    data[parameters.strStatusId] = this.statusId;
    data[parameters.strSlotNumber] = this.slotNumber;
    data[parameters.strIsMedicalRecordsShared] = this.isMedicalRecordsShared;
    data[parameters.strSharedMedicalRecordsId] = this.sharedMedicalRecordsId;
    data[parameters.strIsActive] = this.isActive;
    data[parameters.strCreatedOn] = this.createdOn;
    data[parameters.strLastModifiedOn] = this.lastModifiedOn;
    data[parameters.strlastModifiedBy] = this.lastModifiedBy;
    data[parameters.strIsRefunded] = this.isRefunded;
    data[parameters.strIsFollowUpFee] = this.isFollowUpFee;
    data[parameters.strPlannedFollowupDate] = this.plannedFollowupDate;
    return data;
  }
}
