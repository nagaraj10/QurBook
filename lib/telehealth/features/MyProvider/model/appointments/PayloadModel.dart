import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/appointments/PaymentGateWayDetail.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/appointments/PaymentModel.dart';

class PayloadModel {
  PaymentModel payment;
  PaymentGatewayDetail paymentGatewayDetail;

  PayloadModel({this.payment, this.paymentGatewayDetail});

  PayloadModel.fromJson(Map<String, dynamic> json) {
    payment =
    json[strPayment] != null ? new PaymentModel.fromJson(json[strPayment]) : null;
    paymentGatewayDetail = json[strPaymentGateWayDetail] != null
        ? new PaymentGatewayDetail.fromJson(json[strPaymentGateWayDetail])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.payment != null) {
      data[strPayment] = this.payment.toJson();
    }
    if (this.paymentGatewayDetail != null) {
      data[strPaymentGateWayDetail] = this.paymentGatewayDetail.toJson();
    }
    return data;
  }
}