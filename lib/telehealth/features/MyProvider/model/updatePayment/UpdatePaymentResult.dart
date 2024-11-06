
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/updatePayment/AppointmentStatus.dart';

class UpdatePaymentResult {
  String? appointmentId;
  String? bookingId;
  String? paymentId;
  String? paymentOrderId;
  String? paymentRequestId;
  AppointmentStatus? appointmentStatus;
  AppointmentStatus? paymentStatus;

  UpdatePaymentResult(
      {this.appointmentId,
        this.bookingId,
        this.paymentId,
        this.paymentOrderId,
        this.paymentRequestId,
        this.appointmentStatus,
        this.paymentStatus});

  UpdatePaymentResult.fromJson(Map<String, dynamic> json) {
    try {
      appointmentId = json['appointmentId'];
      bookingId = json['bookingId'];
      paymentId = json['paymentId'];
      paymentOrderId = json['paymentOrderId'];
      paymentRequestId = json['paymentRequestId'];
      appointmentStatus = json['appointmentStatus'] != null
              ? AppointmentStatus.fromJson(json['appointmentStatus'])
              : null;
      paymentStatus = json['paymentStatus'] != null
              ? AppointmentStatus.fromJson(json['paymentStatus'])
              : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['appointmentId'] = this.appointmentId;
    data['bookingId'] = this.bookingId;
    data['paymentId'] = this.paymentId;
    data['paymentOrderId'] = this.paymentOrderId;
    data['paymentRequestId'] = this.paymentRequestId;
    if (this.appointmentStatus != null) {
      data['appointmentStatus'] = this.appointmentStatus!.toJson();
    }
    if (this.paymentStatus != null) {
      data['paymentStatus'] = this.paymentStatus!.toJson();
    }
    return data;
  }
}