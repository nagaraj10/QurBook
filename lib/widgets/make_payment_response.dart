class MakePaymentResponse {
  bool isSuccess;
  Result result;
  String message;

  MakePaymentResponse({this.isSuccess, this.result, this.message});

  MakePaymentResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json.containsKey('result')) {
      result =
          json['result'] != null ? new Result.fromJson(json['result']) : null;
    }
    if (json.containsKey('message')) {
      message = json['message'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Result {
  String orderId;
  List<SubscribeResponse> subscribeResponse;
  Payment payment;
  PaymentGatewayDetail paymentGatewayDetail;

  Result(
      {this.orderId,
      this.subscribeResponse,
      this.payment,
      this.paymentGatewayDetail});

  Result.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    if (json['subscribeResponse'] != null) {
      subscribeResponse = new List<SubscribeResponse>();
      json['subscribeResponse'].forEach((v) {
        subscribeResponse.add(new SubscribeResponse.fromJson(v));
      });
    }
    payment =
        json['payment'] != null ? new Payment.fromJson(json['payment']) : null;
    paymentGatewayDetail = json['paymentGatewayDetail'] != null
        ? new PaymentGatewayDetail.fromJson(json['paymentGatewayDetail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    if (this.subscribeResponse != null) {
      data['subscribeResponse'] =
          this.subscribeResponse.map((v) => v.toJson()).toList();
    }
    if (this.payment != null) {
      data['payment'] = this.payment.toJson();
    }
    if (this.paymentGatewayDetail != null) {
      data['paymentGatewayDetail'] = this.paymentGatewayDetail.toJson();
    }
    return data;
  }
}

class SubscribeResponse {
  String result;
  String planStartDate;
  String message;
  int packageid;
  String price;
  String docid;

  SubscribeResponse(
      {this.result,
      this.planStartDate,
      this.message,
      this.packageid,
      this.price,
      this.docid});

  SubscribeResponse.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    planStartDate = json['PlanStartDate'];
    message = json['Message'];
    packageid = json['packageid'];
    price = json['price'];
    docid = json['docid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Result'] = this.result;
    data['PlanStartDate'] = this.planStartDate;
    data['Message'] = this.message;
    data['packageid'] = this.packageid;
    data['price'] = this.price;
    data['docid'] = this.docid;
    return data;
  }
}

class Payment {
  String id;
  PaymentStatus paymentStatus;
  PaymentStatus paymentGateway;
  String paidTo;
  String paidBy;
  String createdBy;
  String createdOn;
  bool isActive;
  String purpose;
  int paidAmount;
  String transactionDateTime;
  Metadata metadata;
  Cart cart;
  String paymentReference;
  String paidDate;
  String receiptUrl;
  String lastModifiedOn;
  bool isDiscount;
  String discountDetails;

  Payment(
      {this.id,
      this.paymentStatus,
      this.paymentGateway,
      this.paidTo,
      this.paidBy,
      this.createdBy,
      this.createdOn,
      this.isActive,
      this.purpose,
      this.paidAmount,
      this.transactionDateTime,
      this.metadata,
      this.cart,
      this.paymentReference,
      this.paidDate,
      this.receiptUrl,
      this.lastModifiedOn,
      this.isDiscount,
      this.discountDetails});

  Payment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    paymentStatus = json['paymentStatus'] != null
        ? new PaymentStatus.fromJson(json['paymentStatus'])
        : null;
    paymentGateway = json['paymentGateway'] != null
        ? new PaymentStatus.fromJson(json['paymentGateway'])
        : null;
    paidTo = json['paidTo'];
    paidBy = json['paidBy'];
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    isActive = json['isActive'];
    purpose = json['purpose'];
    paidAmount = json['paidAmount'];
    transactionDateTime = json['transactionDateTime'];
    metadata = json['metadata'] != null
        ? new Metadata.fromJson(json['metadata'])
        : null;
    cart = json['cart'] != null ? new Cart.fromJson(json['cart']) : null;
    paymentReference = json['paymentReference'];
    paidDate = json['paidDate'];
    receiptUrl = json['receiptUrl'];
    lastModifiedOn = json['lastModifiedOn'];
    isDiscount = json['isDiscount'];
    discountDetails = json['discountDetails'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.paymentStatus != null) {
      data['paymentStatus'] = this.paymentStatus.toJson();
    }
    if (this.paymentGateway != null) {
      data['paymentGateway'] = this.paymentGateway.toJson();
    }
    data['paidTo'] = this.paidTo;
    data['paidBy'] = this.paidBy;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['isActive'] = this.isActive;
    data['purpose'] = this.purpose;
    data['paidAmount'] = this.paidAmount;
    data['transactionDateTime'] = this.transactionDateTime;
    if (this.metadata != null) {
      data['metadata'] = this.metadata.toJson();
    }
    if (this.cart != null) {
      data['cart'] = this.cart.toJson();
    }
    data['paymentReference'] = this.paymentReference;
    data['paidDate'] = this.paidDate;
    data['receiptUrl'] = this.receiptUrl;
    data['lastModifiedOn'] = this.lastModifiedOn;
    data['isDiscount'] = this.isDiscount;
    data['discountDetails'] = this.discountDetails;
    return data;
  }
}

class PaymentStatus {
  String id;
  String code;
  String name;
  String description;
  int sortOrder;
  bool isActive;
  String createdBy;
  String createdOn;
  String lastModifiedOn;
  ReferenceData referenceData;

  PaymentStatus(
      {this.id,
      this.code,
      this.name,
      this.description,
      this.sortOrder,
      this.isActive,
      this.createdBy,
      this.createdOn,
      this.lastModifiedOn,
      this.referenceData});

  PaymentStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    description = json['description'];
    sortOrder = json['sortOrder'];
    isActive = json['isActive'];
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    referenceData = json['referenceData'] != null
        ? new ReferenceData.fromJson(json['referenceData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['description'] = this.description;
    data['sortOrder'] = this.sortOrder;
    data['isActive'] = this.isActive;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    if (this.referenceData != null) {
      data['referenceData'] = this.referenceData.toJson();
    }
    return data;
  }
}

class ReferenceData {
  String id;
  String code;
  String name;
  String description;
  bool isActive;
  String createdBy;
  String createdOn;
  String lastModifiedOn;

  ReferenceData(
      {this.id,
      this.code,
      this.name,
      this.description,
      this.isActive,
      this.createdBy,
      this.createdOn,
      this.lastModifiedOn});

  ReferenceData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    description = json['description'];
    isActive = json['isActive'];
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['description'] = this.description;
    data['isActive'] = this.isActive;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
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

class Cart {
  String id;

  Cart({this.id});

  Cart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}

class PaymentGatewayDetail {
  String sourceId;
  String sourceCode;
  ResponseInfo responseInfo;
  String createdBy;
  String createdOn;
  bool isActive;
  String paymentGatewayRequestId;
  String lastModifiedOn;
  String id;

  PaymentGatewayDetail(
      {this.sourceId,
      this.sourceCode,
      this.responseInfo,
      this.createdBy,
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
    createdBy = json['createdBy'];
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
    data['createdBy'] = this.createdBy;
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

  ResponseInfo(
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
