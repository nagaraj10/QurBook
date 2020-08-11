class CancelAppointmentModel {
  int status;
  bool success;
  String message;
  Response response;

  CancelAppointmentModel(
      {this.status, this.success, this.message, this.response});

  CancelAppointmentModel.fromJson(Map<String, dynamic> json) {
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
  List<Data> data;

  Response({this.count, this.data});

  Response.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
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

  Data(
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

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
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
    sharedMedicalRecordsId = json['sharedMedicalRecordsId'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    lastModifiedBy = json['lastModifiedBy'];
    isRefunded = json['isRefunded'];
    isFollowUpFee = json['isFollowUpFee'];
    plannedFollowupDate = json['plannedFollowupDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
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
    data['sharedMedicalRecordsId'] = this.sharedMedicalRecordsId;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    data['lastModifiedBy'] = this.lastModifiedBy;
    data['isRefunded'] = this.isRefunded;
    data['isFollowUpFee'] = this.isFollowUpFee;
    data['plannedFollowupDate'] = this.plannedFollowupDate;
    return data;
  }
}