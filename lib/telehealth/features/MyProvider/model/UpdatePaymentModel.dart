class UpdatePaymentModel {
  int status;
  bool success;
  String message;
  Response response;

  UpdatePaymentModel({this.status, this.success, this.message, this.response});

  UpdatePaymentModel.fromJson(Map<String, dynamic> json) {
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
  String appointmentId;
  String bookingId;
  String paymentId;
  String paymentOrderId;
  String paymentRequestId;
  AppointmentStatus appointmentStatus;
  AppointmentStatus paymentStatus;

  Data(
      {this.appointmentId,
        this.bookingId,
        this.paymentId,
        this.paymentOrderId,
        this.paymentRequestId,
        this.appointmentStatus,
        this.paymentStatus});

  Data.fromJson(Map<String, dynamic> json) {
    appointmentId = json['appointmentId'];
    bookingId = json['bookingId'];
    paymentId = json['paymentId'];
    paymentOrderId = json['paymentOrderId'];
    paymentRequestId = json['paymentRequestId'];
    appointmentStatus = json['appointmentStatus'] != null
        ? new AppointmentStatus.fromJson(json['appointmentStatus'])
        : null;
    paymentStatus = json['paymentStatus'] != null
        ? new AppointmentStatus.fromJson(json['paymentStatus'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appointmentId'] = this.appointmentId;
    data['bookingId'] = this.bookingId;
    data['paymentId'] = this.paymentId;
    data['paymentOrderId'] = this.paymentOrderId;
    data['paymentRequestId'] = this.paymentRequestId;
    if (this.appointmentStatus != null) {
      data['appointmentStatus'] = this.appointmentStatus.toJson();
    }
    if (this.paymentStatus != null) {
      data['paymentStatus'] = this.paymentStatus.toJson();
    }
    return data;
  }
}

class AppointmentStatus {
  String code;

  AppointmentStatus({this.code});

  AppointmentStatus.fromJson(Map<String, dynamic> json) {
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    return data;
  }
}