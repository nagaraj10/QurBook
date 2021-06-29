class CreateSubscribeModel {
  bool isSuccess;
  PaymentResult result;

  CreateSubscribeModel({this.isSuccess, this.result});

  CreateSubscribeModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    result =
    json['result'] != null ? new PaymentResult.fromJson(json['result']) : null;
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

class PaymentResult {
  Payment payment;
  PaymentGatewayDetail paymentGatewayDetail;

  PaymentResult({this.payment, this.paymentGatewayDetail});

  PaymentResult.fromJson(Map<String, dynamic> json) {
    payment =
    json['payment'] != null ? new Payment.fromJson(json['payment']) : null;
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
        ? new Metadata.fromJson(json['metadata'])
        : null;
    purpose = json['purpose'];
    subscriptionid = json['subscriptionid'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paidamount'] = this.paidamount;
    data['paidby'] = this.paidby;
    data['paidfor'] = this.paidfor;
    data['status'] = this.status;
    if (this.metadata != null) {
      data['metadata'] = this.metadata.toJson();
    }
    data['purpose'] = this.purpose;
    data['subscriptionid'] = this.subscriptionid;
    data['id'] = this.id;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paymentGateway'] = this.paymentGateway;
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
        ? new PaymentMetadata.fromJson(json['metadata'])
        : null;
    paymentgatewayrequestid = json['paymentgatewayrequestid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sourcecode'] = this.sourcecode;
    if (this.metadata != null) {
      data['metadata'] = this.metadata.toJson();
    }
    data['paymentgatewayrequestid'] = this.paymentgatewayrequestid;
    return data;
  }
}

class PaymentMetadata {
  String id;
  String phone;
  String email;
  String buyerName;
  String amount;
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
  String createdAt;
  String modifiedAt;

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
        this.modifiedAt});

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
    shorturl = json['shorturl'];
    longurl = json['longurl'];
    redirectUrl = json['redirect_url'];
    webhook = json['webhook'];
    allowRepeatedPayments = json['allow_repeated_payments'];
    customerId = json['customer_id'];
    createdAt = json['created_at'];
    modifiedAt = json['modified_at'];
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
    data['shorturl'] = this.shorturl;
    data['longurl'] = this.longurl;
    data['redirect_url'] = this.redirectUrl;
    data['webhook'] = this.webhook;
    data['allow_repeated_payments'] = this.allowRepeatedPayments;
    data['customer_id'] = this.customerId;
    data['created_at'] = this.createdAt;
    data['modified_at'] = this.modifiedAt;
    return data;
  }
}