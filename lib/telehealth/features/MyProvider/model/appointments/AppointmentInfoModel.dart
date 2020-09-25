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
  String isFollowup;
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
    isFollowUp = json['isFollowUp'];
    slotNumber = json['slotNumber'];
    doctorSession = json['doctorSession'] != null
        ? new DoctorSession.fromJson(json['doctorSession'])
        : null;
    isActive = json['isActive'];
    lastModifiedBy = json['lastModifiedBy'] != null
        ? new DoctorSession.fromJson(json['lastModifiedBy'])
        : null;
    bookedFor = json['bookedFor'] != null
        ? new DoctorSession.fromJson(json['bookedFor'])
        : null;
    createdBy = json['createdBy'] != null
        ? new DoctorSession.fromJson(json['createdBy'])
        : null;
    bookedBy = json['bookedBy'] != null
        ? new DoctorSession.fromJson(json['bookedBy'])
        : null;
    bookingId = json['bookingId'];
    plannedStartDateTime = json['plannedStartDateTime'];
    plannedEndDateTime = json['plannedEndDateTime'];
    status = json['status'] != null
        ? new DoctorSession.fromJson(json['status'])
        : null;
    doctorSessionId = json['doctorSessionId'];
    actualStartDateTime = json['actualStartDateTime'];
    actualEndDateTime = json['actualEndDateTime'];
    plannedFollowupDate = json['plannedFollowupDate'];
    isFollowup = json['isFollowup'];
    lastModifiedOn = json['lastModifiedOn'];
    id = json['id'];
    isHealthRecordShared = json['isHealthRecordShared'];
    isRefunded = json['isRefunded'];
    isFollowupFee = json['isFollowupFee'];
    createdOn = json['createdOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isFollowUp'] = this.isFollowUp;
    data['slotNumber'] = this.slotNumber;
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
    data['isHealthRecordShared'] = this.isHealthRecordShared;
    data['isRefunded'] = this.isRefunded;
    data['isFollowupFee'] = this.isFollowupFee;
    data['createdOn'] = this.createdOn;
    return data;
  }
}

class DoctorSession {
  String id;

  DoctorSession({this.id});

  DoctorSession.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}