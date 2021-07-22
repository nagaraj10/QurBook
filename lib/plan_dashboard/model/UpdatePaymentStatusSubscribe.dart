class UpdatePaymentStatusSubscribe {
  bool isSuccess;
  PaymentSubscribeResult result;

  UpdatePaymentStatusSubscribe({this.isSuccess, this.result});

  UpdatePaymentStatusSubscribe.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    result =
    json['result'] != null ? PaymentSubscribeResult.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['isSuccess'] = isSuccess;
    if (result != null) {
      data['result'] = result.toJson();
    }
    return data;
  }
}

class PaymentSubscribeResult {
  PlanPackage planPackage;
  String paymentId;
  String paymentOrderId;
  String paymentRequestId;
  String paymentStatus;
  PdfGenResult pdfGenResult;

  PaymentSubscribeResult(
      {this.planPackage,
        this.paymentId,
        this.paymentOrderId,
        this.paymentRequestId,
        this.paymentStatus,
        this.pdfGenResult});

  PaymentSubscribeResult.fromJson(Map<String, dynamic> json) {
    planPackage = json['planPackage'] != null
        ? PlanPackage.fromJson(json['planPackage'])
        : null;
    paymentId = json['paymentId'];
    paymentOrderId = json['paymentOrderId'];
    paymentRequestId = json['paymentRequestId'];
    paymentStatus = json['paymentStatus'];
    pdfGenResult = json['pdfGenResult'] != null
        ? PdfGenResult.fromJson(json['pdfGenResult'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    if (planPackage != null) {
      data['planPackage'] = planPackage.toJson();
    }
    data['paymentId'] = paymentId;
    data['paymentOrderId'] = paymentOrderId;
    data['paymentRequestId'] = paymentRequestId;
    data['paymentStatus'] = paymentStatus;
    if (pdfGenResult != null) {
      data['pdfGenResult'] = pdfGenResult.toJson();
    }
    return data;
  }
}

class PlanPackage {
  int packageid;
  int providerid;
  int packcatid;
  int careteamid;
  String title;
  String description;
  String price;
  int issubscription;
  int ispublic;
  String html;
  int packageDuration;
  int billingCycle;
  String ts;
  int deleted;
  int docid;
  Providers providers;

  PlanPackage(
      {this.packageid,
        this.providerid,
        this.packcatid,
        this.careteamid,
        this.title,
        this.description,
        this.price,
        this.issubscription,
        this.ispublic,
        this.html,
        this.packageDuration,
        this.billingCycle,
        this.ts,
        this.deleted,
        this.docid,
        this.providers});

  PlanPackage.fromJson(Map<String, dynamic> json) {
    packageid = json['packageid'];
    providerid = json['providerid'];
    packcatid = json['packcatid'];
    careteamid = json['careteamid'];
    title = json['title'];
    description = json['description'];
    price = json['price'];
    issubscription = json['issubscription'];
    ispublic = json['ispublic'];
    html = json['html'];
    packageDuration = json['packageDuration'];
    billingCycle = json['billingCycle'];
    ts = json['ts'];
    deleted = json['deleted'];
    docid = json['docid'];
    providers = json['providers'] != null
        ? Providers.fromJson(json['providers'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['packageid'] = packageid;
    data['providerid'] = providerid;
    data['packcatid'] = packcatid;
    data['careteamid'] = careteamid;
    data['title'] = title;
    data['description'] = description;
    data['price'] = price;
    data['issubscription'] = issubscription;
    data['ispublic'] = ispublic;
    data['html'] = html;
    data['packageDuration'] = packageDuration;
    data['billingCycle'] = billingCycle;
    data['ts'] = ts;
    data['deleted'] = deleted;
    data['docid'] = docid;
    if (providers != null) {
      data['providers'] = providers.toJson();
    }
    return data;
  }
}

class Providers {
  int providerid;
  String title;
  String description;
  String metadata;
  int deleted;
  String linkid;
  String ts;

  Providers(
      {this.providerid,
        this.title,
        this.description,
        this.metadata,
        this.deleted,
        this.linkid,
        this.ts});

  Providers.fromJson(Map<String, dynamic> json) {
    providerid = json['providerid'];
    title = json['title'];
    description = json['description'];
    metadata = json['metadata'];
    deleted = json['deleted'];
    linkid = json['linkid'];
    ts = json['ts'];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['providerid'] = providerid;
    data['title'] = title;
    data['description'] = description;
    data['metadata'] = metadata;
    data['deleted'] = deleted;
    data['linkid'] = linkid;
    data['ts'] = ts;
    return data;
  }
}

class PdfGenResult {
  bool isSuccess;
  Payload payload;

  PdfGenResult({this.isSuccess, this.payload});

  PdfGenResult.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    payload =
    json['payload'] != null ? Payload.fromJson(json['payload']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['isSuccess'] = isSuccess;
    if (payload != null) {
      data['payload'] = payload.toJson();
    }
    return data;
  }
}

class Payload {
  ResponseMetadata responseMetadata;
  String mD5OfMessageBody;
  String messageId;
  String sequenceNumber;

  Payload(
      {this.responseMetadata,
        this.mD5OfMessageBody,
        this.messageId,
        this.sequenceNumber});

  Payload.fromJson(Map<String, dynamic> json) {
    responseMetadata = json['ResponseMetadata'] != null
        ? ResponseMetadata.fromJson(json['ResponseMetadata'])
        : null;
    mD5OfMessageBody = json['MD5OfMessageBody'];
    messageId = json['MessageId'];
    sequenceNumber = json['SequenceNumber'];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    if (responseMetadata != null) {
      data['ResponseMetadata'] = responseMetadata.toJson();
    }
    data['MD5OfMessageBody'] = mD5OfMessageBody;
    data['MessageId'] = messageId;
    data['SequenceNumber'] = sequenceNumber;
    return data;
  }
}

class ResponseMetadata {
  String requestId;

  ResponseMetadata({this.requestId});

  ResponseMetadata.fromJson(Map<String, dynamic> json) {
    requestId = json['RequestId'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['RequestId'] = requestId;
    return data;
  }
}