class BookAppointmentModel {
  int status;
  bool success;
  String message;
  Response response;

  BookAppointmentModel(
      {this.status, this.success, this.message, this.response});

  BookAppointmentModel.fromJson(Map<String, dynamic> json) {
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
  AppointmentInfo appointmentInfo;
  PaymentInfo paymentInfo;

  Data({this.appointmentInfo, this.paymentInfo});

  Data.fromJson(Map<String, dynamic> json) {
    appointmentInfo = json['appointmentInfo'] != null
        ? new AppointmentInfo.fromJson(json['appointmentInfo'])
        : null;
    paymentInfo = json['paymentInfo'] != null
        ? new PaymentInfo.fromJson(json['paymentInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.appointmentInfo != null) {
      data['appointmentInfo'] = this.appointmentInfo.toJson();
    }
    if (this.paymentInfo != null) {
      data['paymentInfo'] = this.paymentInfo.toJson();
    }
    return data;
  }
}

class AppointmentInfo {
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
  String sharedMedicalRecordsId;
  bool isFollowUpFee;
  String lastModifiedBy;
  String id;
  String createdOn;
  String lastModifiedOn;

  AppointmentInfo(
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
        this.sharedMedicalRecordsId,
        this.isFollowUpFee,
        this.lastModifiedBy,
        this.id,
        this.createdOn,
        this.lastModifiedOn});

  AppointmentInfo.fromJson(Map<String, dynamic> json) {
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
    isFollowUpFee = json['isFollowUpFee'];
    lastModifiedBy = json['lastModifiedBy'];
    id = json['id'];
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
    data['sharedMedicalRecordsId'] = this.sharedMedicalRecordsId;
    data['isFollowUpFee'] = this.isFollowUpFee;
    data['lastModifiedBy'] = this.lastModifiedBy;
    data['id'] = this.id;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    return data;
  }
}

class PaymentInfo {
  String paymentId;
  String paymentAppointmentMappingId;
  String paymentGatewayDetailId;
  String longurl;
  String redirectUrl;
  Null webhook;

  PaymentInfo(
      {this.paymentId,
        this.paymentAppointmentMappingId,
        this.paymentGatewayDetailId,
        this.longurl,
        this.redirectUrl,
        this.webhook});

  PaymentInfo.fromJson(Map<String, dynamic> json) {
    paymentId = json['paymentId'];
    paymentAppointmentMappingId = json['paymentAppointmentMappingId'];
    paymentGatewayDetailId = json['paymentGatewayDetailId'];
    longurl = json['longurl'];
    redirectUrl = json['redirect_url'];
    webhook = json['webhook'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paymentId'] = this.paymentId;
    data['paymentAppointmentMappingId'] = this.paymentAppointmentMappingId;
    data['paymentGatewayDetailId'] = this.paymentGatewayDetailId;
    data['longurl'] = this.longurl;
    data['redirect_url'] = this.redirectUrl;
    data['webhook'] = this.webhook;
    return data;
  }
}