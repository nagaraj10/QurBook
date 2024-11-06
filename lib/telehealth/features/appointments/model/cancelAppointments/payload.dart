
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/telehealth/features/appointments/model/cancelAppointments/paymentGatewayDetail.dart';
import 'package:myfhb/telehealth/features/appointments/model/cancelAppointments/refund.dart';
import 'package:myfhb/telehealth/features/appointments/constants/appointments_parameters.dart'as parameters;

class Payload {
  Refund? refund;
  PaymentGatewayDetail? paymentGatewayDetail;

  Payload({this.refund, this.paymentGatewayDetail});

  Payload.fromJson(Map<String, dynamic> json) {
    try {
      refund = json[parameters.strRefund] != null
              ? Refund.fromJson(json[parameters.strRefund])
              : null;
      paymentGatewayDetail = json[parameters.strPaymentGatewayDetail] != null
              ? PaymentGatewayDetail.fromJson(
                  json[parameters.strPaymentGatewayDetail])
              : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.refund != null) {
      data[parameters.strRefund] = this.refund!.toJson();
    }
    if (this.paymentGatewayDetail != null) {
      data[parameters.strPaymentGatewayDetail] =
          this.paymentGatewayDetail!.toJson();
    }
    return data;
  }
}
