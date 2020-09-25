class UpdatePaymentModel {
  bool isSuccess;
  Result result;

  UpdatePaymentModel({this.isSuccess, this.result});

  UpdatePaymentModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class Result {
  String appointmentId;
  String bookingId;
  String paymentId;
  String paymentOrderId;
  String paymentRequestId;
  AppointmentStatus appointmentStatus;
  AppointmentStatus paymentStatus;

  Result(
      {this.appointmentId,
        this.bookingId,
        this.paymentId,
        this.paymentOrderId,
        this.paymentRequestId,
        this.appointmentStatus,
        this.paymentStatus});

  Result.fromJson(Map<String, dynamic> json) {
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
  String name;
  String description;

  AppointmentStatus({this.code, this.name, this.description});

  AppointmentStatus.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    data['description'] = this.description;
    return data;
  }
}