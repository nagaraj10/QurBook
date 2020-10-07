import 'package:myfhb/telehealth/features/appointments/constants/appointments_parameters.dart'as parameters;

class ResponseInfoResultRefund {
  String id;
  String paymentId;
  String status;
  String type;
  String body;
  String refundAmount;
  String totalAmount;
  String transactionId;
  String creatorName;
  String createdAt;

  ResponseInfoResultRefund(
      {this.id,
        this.paymentId,
        this.status,
        this.type,
        this.body,
        this.refundAmount,
        this.totalAmount,
        this.transactionId,
        this.creatorName,
        this.createdAt});

  ResponseInfoResultRefund.fromJson(Map<String, dynamic> json) {
    id = json[parameters.strId];
    paymentId = json[parameters.strPaymentId];
    status = json[parameters.strStatus];
    type = json[parameters.strtype];
    body = json[parameters.strBody];
    refundAmount = json[parameters.strRefund_amount];
    totalAmount = json[parameters.strTotal_amount];
    transactionId = json[parameters.strTransaction_id];
    creatorName = json[parameters.strCreator_name];
    createdAt = json[parameters.strCreated_at];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strId] = this.id;
    data[parameters.strPaymentId] = this.paymentId;
    data[parameters.strStatus] = this.status;
    data[parameters.strtype] = this.type;
    data[parameters.strBody] = this.body;
    data[parameters.strRefund_amount] = this.refundAmount;
    data[parameters.strTotal_amount] = this.totalAmount;
    data[parameters.strTransaction_id] = this.transactionId;
    data[parameters.strCreator_name] = this.creatorName;
    data[parameters.strCreated_at] = this.createdAt;
    return data;
  }
}