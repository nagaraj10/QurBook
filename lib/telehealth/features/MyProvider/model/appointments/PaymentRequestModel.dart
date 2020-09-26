class PaymentRequestModel {
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
  String smsStatus;
  String emailStatus;
  String shorturl;
  String longurl;
  String redirectUrl;
  String webhook;
  bool allowRepeatedPayments;
  String customerId;
  String createdAt;
  String modifiedAt;

  PaymentRequestModel(
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
        this.smsStatus,
        this.emailStatus,
        this.shorturl,
        this.longurl,
        this.redirectUrl,
        this.webhook,
        this.allowRepeatedPayments,
        this.customerId,
        this.createdAt,
        this.modifiedAt});

  PaymentRequestModel.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}