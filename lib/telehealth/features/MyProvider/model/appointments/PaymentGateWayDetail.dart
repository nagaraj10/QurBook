import 'package:myfhb/telehealth/features/MyProvider/model/appointments/PaymentRequestModel.dart';

class PaymentGatewayDetail {
  String sourceId;
  String sourceCode;
  ResponseInfo responseInfo;
  String createdOn;
  bool isActive;
  String paymentGatewayRequestId;
  String lastModifiedOn;
  String id;

  PaymentGatewayDetail({this.sourceId,
    this.sourceCode,
    this.responseInfo,
    this.createdOn,
    this.isActive,
    this.paymentGatewayRequestId,
    this.lastModifiedOn,
    this.id});

  PaymentGatewayDetail.fromJson(Map<String, dynamic> json) {
    sourceId = json['sourceId'];
    sourceCode = json['sourceCode'];
    responseInfo = json['responseInfo'] != null
        ? new ResponseInfo.fromJson(json['responseInfo'])
        : null;
    createdOn = json['createdOn'];
    isActive = json['isActive'];
    paymentGatewayRequestId = json['paymentGatewayRequestId'];
    lastModifiedOn = json['lastModifiedOn'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sourceId'] = this.sourceId;
    data['sourceCode'] = this.sourceCode;
    if (this.responseInfo != null) {
      data['responseInfo'] = this.responseInfo.toJson();
    }
    data['createdOn'] = this.createdOn;
    data['isActive'] = this.isActive;
    data['paymentGatewayRequestId'] = this.paymentGatewayRequestId;
    data['lastModifiedOn'] = this.lastModifiedOn;
    data['id'] = this.id;
    return data;
  }
}

class ResponseInfo {
  String id;
  String phone;
  String email;
  String buyerName;
  var amount;
  String purpose;
  String expiresAt;
  String status;
  bool sendSms;
  bool sendEmail;
  String smsStatus;
  String emailStatus;
  String shorturl;
  String longurl;
  String redirectUrl;
  String webhook;
  bool allowRepeatedPayments;
  String customerId;
  var createdAt;
  String modifiedAt;
  String paymentGateWay;

  ResponseInfo({this.id,
    this.phone,
    this.email,
    this.buyerName,
    this.amount,
    this.purpose,
    this.expiresAt,
    this.status,
    this.sendSms,
    this.sendEmail,
    this.smsStatus,
    this.emailStatus,
    this.shorturl,
    this.longurl,
    this.redirectUrl,
    this.webhook,
    this.allowRepeatedPayments,
    this.customerId,
    this.createdAt,
    this.modifiedAt,
    this.paymentGateWay});

  ResponseInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phone = json['phone'];
    email = json['email'];
    buyerName = json['buyer_name'];
    amount = json['amount'];
    purpose = json['purpose'];
    expiresAt = json['expires_at'];
    status = json['status'];
    sendSms = json['send_sms'];
    sendEmail = json['send_email'];
    smsStatus = json['sms_status'];
    emailStatus = json['email_status'];
    shorturl = json['short_url'];
    longurl = json['longurl'];
    redirectUrl = json['redirect_url'];
    webhook = json['webhook'];
    allowRepeatedPayments = json['allow_repeated_payments'];
    customerId = json['customer_id'];
    createdAt = json['created_at'];
    modifiedAt = json['modified_at'];
    paymentGateWay = json['payment_gateway'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['buyer_name'] = this.buyerName;
    data['amount'] = this.amount;
    data['purpose'] = this.purpose;
    data['expires_at'] = this.expiresAt;
    data['status'] = this.status;
    data['send_sms'] = this.sendSms;
    data['send_email'] = this.sendEmail;
    data['sms_status'] = this.smsStatus;
    data['email_status'] = this.emailStatus;
    data['shorturl'] = this.shorturl;
    data['longurl'] = this.longurl;
    data['redirect_url'] = this.redirectUrl;
    data['webhook'] = this.webhook;
    data['allow_repeated_payments'] = this.allowRepeatedPayments;
    data['customer_id'] = this.customerId;
    data['created_at'] = this.createdAt;
    data['modified_at'] = this.modifiedAt;
    data['payment_gateway'] = this.paymentGateWay;
    return data;
  }
}

class PaymentRequestResult {
  bool success;
  PaymentRequestModel paymentRequest;

  PaymentRequestResult({this.success, this.paymentRequest});

  PaymentRequestResult.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    paymentRequest = json['payment_request'] != null
        ? new PaymentRequestModel.fromJson(json['payment_request'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.paymentRequest != null) {
      data['payment_request'] = this.paymentRequest.toJson();
    }
    return data;
  }
}
