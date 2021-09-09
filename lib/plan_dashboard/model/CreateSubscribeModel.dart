class CreateSubscribeModel {
  bool isSuccess;
  PaymentResult result;

  CreateSubscribeModel({this.isSuccess, this.result});

  CreateSubscribeModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    result =
    json['result'] != null ? PaymentResult.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['isSuccess'] = isSuccess;
    if (result != null) {
      data['result'] = result.toJson();
    }
    return data;
  }
}

class PaymentResult {
  Payment payment;
  PaymentGatewayDetail paymentGatewayDetail;

  PaymentResult({this.payment, this.paymentGatewayDetail});

  PaymentResult.fromJson(Map<String, dynamic> json) {
    payment =
    json['payment'] != null ? Payment.fromJson(json['payment']) : null;
    paymentGatewayDetail = json['paymentGatewayDetail'] != null
        ? PaymentGatewayDetail.fromJson(json['paymentGatewayDetail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (payment != null) {
      data['payment'] = payment.toJson();
    }
    if (paymentGatewayDetail != null) {
      data['paymentGatewayDetail'] = paymentGatewayDetail.toJson();
    }
    return data;
  }
}

class Payment {
  int paidamount;
  String paidby;
  String paidfor;
  String status;
  Metadata metadata;
  String purpose;
  String subscriptionid;
  int id;

  Payment(
      {this.paidamount,
        this.paidby,
        this.paidfor,
        this.status,
        this.metadata,
        this.purpose,
        this.subscriptionid,
        this.id});

  Payment.fromJson(Map<String, dynamic> json) {
    paidamount = json['paidamount'];
    paidby = json['paidby'];
    paidfor = json['paidfor'];
    status = json['status'];
    metadata = json['metadata'] != null
        ? Metadata.fromJson(json['metadata'])
        : null;
    purpose = json['purpose'];
    subscriptionid = json['subscriptionid'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['paidamount'] = paidamount;
    data['paidby'] = paidby;
    data['paidfor'] = paidfor;
    data['status'] = status;
    if (metadata != null) {
      data['metadata'] = metadata.toJson();
    }
    data['purpose'] = purpose;
    data['subscriptionid'] = subscriptionid;
    data['id'] = id;
    return data;
  }
}

class Metadata {
  String paymentGateway;

  Metadata({this.paymentGateway});

  Metadata.fromJson(Map<String, dynamic> json) {
    paymentGateway = json['paymentGateway'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['paymentGateway'] = paymentGateway;
    return data;
  }
}

class PaymentGatewayDetail {
  String sourcecode;
  PaymentMetadata metadata;
  String paymentgatewayrequestid;

  PaymentGatewayDetail(
      {this.sourcecode, this.metadata, this.paymentgatewayrequestid});

  PaymentGatewayDetail.fromJson(Map<String, dynamic> json) {
    sourcecode = json['sourcecode'];
    metadata = json['metadata'] != null
        ? PaymentMetadata.fromJson(json['metadata'])
        : null;
    paymentgatewayrequestid = json['paymentgatewayrequestid'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['sourcecode'] = sourcecode;
    if (metadata != null) {
      data['metadata'] = metadata.toJson();
    }
    data['paymentgatewayrequestid'] = paymentgatewayrequestid;
    return data;
  }
}

class PaymentMetadata {
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
  String shorturl;
  String longurl;
  String redirectUrl;
  String webhook;
  bool allowRepeatedPayments;
  String customerId;
  var createdAt;
  String modifiedAt;
  String paymentGateWay;

  PaymentMetadata(
      {this.id,
        this.phone,
        this.email,
        this.buyerName,
        this.amount,
        this.purpose,
        this.expiresAt,
        this.status,
        this.sendSms,
        this.sendEmail,
        this.shorturl,
        this.longurl,
        this.redirectUrl,
        this.webhook,
        this.allowRepeatedPayments,
        this.customerId,
        this.createdAt,
        this.modifiedAt,
        this.paymentGateWay});

  PaymentMetadata.fromJson(Map<String, dynamic> json) {
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
    final data = <String, dynamic>{};
    data['id'] = id;
    data['phone'] = phone;
    data['email'] = email;
    data['buyer_name'] = buyerName;
    data['amount'] = amount;
    data['purpose'] = purpose;
    data['expires_at'] = expiresAt;
    data['status'] = status;
    data['send_sms'] = sendSms;
    data['send_email'] = sendEmail;
    data['shorturl'] = shorturl;
    data['longurl'] = longurl;
    data['redirect_url'] = redirectUrl;
    data['webhook'] = webhook;
    data['allow_repeated_payments'] = allowRepeatedPayments;
    data['customer_id'] = customerId;
    data['created_at'] = createdAt;
    data['modified_at'] = modifiedAt;
    data['payment_gateway'] = this.paymentGateWay;
    return data;
  }
}