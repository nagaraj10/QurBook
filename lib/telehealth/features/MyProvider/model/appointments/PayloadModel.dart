import 'package:myfhb/telehealth/features/MyProvider/model/appointments/PaymentGateWayDetail.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/appointments/PaymentModel.dart';

class PayloadModel {
  PaymentModel payment;
  PaymentGatewayDetail paymentGatewayDetail;

  PayloadModel({this.payment, this.paymentGatewayDetail});

  PayloadModel.fromJson(Map<String, dynamic> json) {
    payment =
    json['payment'] != null ? new PaymentModel.fromJson(json['payment']) : null;
    paymentGatewayDetail = json['paymentGatewayDetail'] != null
        ? new PaymentGatewayDetail.fromJson(json['paymentGatewayDetail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.payment != null) {
      data['payment'] = this.payment.toJson();
    }
    if (this.paymentGatewayDetail != null) {
      data['paymentGatewayDetail'] = this.paymentGatewayDetail.toJson();
    }
    return data;
  }
}