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
  bool isActive;
  String lastModifiedBy;
  String id;
  bool isFollowUpFee;
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
        this.isActive,
        this.lastModifiedBy,
        this.id,
        this.isFollowUpFee,
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

class PaymentInfo {
  Payment payment;
  String paymentAppointmentMappingId;
  String paymentGatewayDetailId;
  String paymentRequestId;
  String longurl;
  String redirect;

  PaymentInfo(
      {this.payment,
        this.paymentAppointmentMappingId,
        this.paymentGatewayDetailId,
        this.paymentRequestId,
        this.longurl,
        this.redirect});

  PaymentInfo.fromJson(Map<String, dynamic> json) {
    payment =
    json['payment'] != null ? new Payment.fromJson(json['payment']) : null;
    paymentAppointmentMappingId = json['paymentAppointmentMappingId'];
    paymentGatewayDetailId = json['paymentGatewayDetailId'];
    paymentRequestId = json['paymentRequestId'];
    longurl = json['longurl'];
    redirect = json['redirect'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.payment != null) {
      data['payment'] = this.payment.toJson();
    }
    data['paymentAppointmentMappingId'] = this.paymentAppointmentMappingId;
    data['paymentGatewayDetailId'] = this.paymentGatewayDetailId;
    data['paymentRequestId'] = this.paymentRequestId;
    data['longurl'] = this.longurl;
    data['redirect'] = this.redirect;
    return data;
  }
}

class Payment {
  String transactionDateTime;
  String paidAmount;
  String paidBy;
  String paidTo;
  String purpose;
  String moduleId;
  String paymentStatusId;
  String createdOn;
  String lastModifiedOn;
  String lastModifiedBy;
  String createdBy;
  bool isActive;
  Null paidDate;
  String id;
  Null receiptURL;

  Payment(
      {this.transactionDateTime,
        this.paidAmount,
        this.paidBy,
        this.paidTo,
        this.purpose,
        this.moduleId,
        this.paymentStatusId,
        this.createdOn,
        this.lastModifiedOn,
        this.lastModifiedBy,
        this.createdBy,
        this.isActive,
        this.paidDate,
        this.id,
        this.receiptURL});

  Payment.fromJson(Map<String, dynamic> json) {
    transactionDateTime = json['transactionDateTime'];
    paidAmount = json['paidAmount'];
    paidBy = json['paidBy'];
    paidTo = json['paidTo'];
    purpose = json['purpose'];
    moduleId = json['moduleId'];
    paymentStatusId = json['paymentStatusId'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    lastModifiedBy = json['lastModifiedBy'];
    createdBy = json['createdBy'];
    isActive = json['isActive'];
    paidDate = json['paidDate'];
    id = json['id'];
    receiptURL = json['receiptURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transactionDateTime'] = this.transactionDateTime;
    data['paidAmount'] = this.paidAmount;
    data['paidBy'] = this.paidBy;
    data['paidTo'] = this.paidTo;
    data['purpose'] = this.purpose;
    data['moduleId'] = this.moduleId;
    data['paymentStatusId'] = this.paymentStatusId;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    data['lastModifiedBy'] = this.lastModifiedBy;
    data['createdBy'] = this.createdBy;
    data['isActive'] = this.isActive;
    data['paidDate'] = this.paidDate;
    data['id'] = this.id;
    data['receiptURL'] = this.receiptURL;
    return data;
  }
}