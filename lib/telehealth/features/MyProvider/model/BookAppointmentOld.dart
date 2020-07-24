class BookAppointmentOld {
  int status;
  bool success;
  String message;
  Response response;

  BookAppointmentOld({this.status, this.success, this.message, this.response});

  BookAppointmentOld.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    message = json['message'];
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.response != null) {
      data['response'] = this.response.toJson();
    }
    return data;
  }
}

class Response {
  int count;
  Data data;

  Response({this.count, this.data});

  Response.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String bookingID;
  String createdBy;
  String createdFor;
  String doctorSessionId;
  String plannedStartDateTime;
  String plannedEndDateTime;
  Null actualStartDateTime;
  Null actualEndDateTime;
  String statusId;
  String slotNumber;
  bool isMedicalRecordsShared;
  bool isActive;
  String lastModifiedBy;
  String id;
  bool isFollowUpFee;
  String createdOn;
  String lastModifiedOn;

  Data(
      {this.bookingID,
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
        this.isActive,
        this.lastModifiedBy,
        this.id,
        this.isFollowUpFee,
        this.createdOn,
        this.lastModifiedOn});

  Data.fromJson(Map<String, dynamic> json) {
    bookingID = json['bookingID'];
    createdBy = json['createdBy'];
    createdFor = json['createdFor'];
    doctorSessionId = json['doctorSessionId'];
    plannedStartDateTime = json['plannedStartDateTime'];
    plannedEndDateTime = json['plannedEndDateTime'];
    actualStartDateTime = json['actualStartDateTime'];
    actualEndDateTime = json['actualEndDateTime'];
    statusId = json['statusId'];
    slotNumber = json['slotNumber'];
    isMedicalRecordsShared = json['isMedicalRecordsShared'];
    isActive = json['isActive'];
    lastModifiedBy = json['lastModifiedBy'];
    id = json['id'];
    isFollowUpFee = json['isFollowUpFee'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookingID'] = this.bookingID;
    data['createdBy'] = this.createdBy;
    data['createdFor'] = this.createdFor;
    data['doctorSessionId'] = this.doctorSessionId;
    data['plannedStartDateTime'] = this.plannedStartDateTime;
    data['plannedEndDateTime'] = this.plannedEndDateTime;
    data['actualStartDateTime'] = this.actualStartDateTime;
    data['actualEndDateTime'] = this.actualEndDateTime;
    data['statusId'] = this.statusId;
    data['slotNumber'] = this.slotNumber;
    data['isMedicalRecordsShared'] = this.isMedicalRecordsShared;
    data['isActive'] = this.isActive;
    data['lastModifiedBy'] = this.lastModifiedBy;
    data['id'] = this.id;
    data['isFollowUpFee'] = this.isFollowUpFee;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    return data;
  }
}