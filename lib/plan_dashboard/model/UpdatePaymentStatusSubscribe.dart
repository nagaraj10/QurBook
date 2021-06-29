class UpdatePaymentStatusSubscribe {
  bool isSuccess;
  PaymentSubscribeResult result;

  UpdatePaymentStatusSubscribe({this.isSuccess, this.result});

  UpdatePaymentStatusSubscribe.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    result =
    json['result'] != null ? new PaymentSubscribeResult.fromJson(json['result']) : null;
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
        ? new PlanPackage.fromJson(json['planPackage'])
        : null;
    paymentId = json['paymentId'];
    paymentOrderId = json['paymentOrderId'];
    paymentRequestId = json['paymentRequestId'];
    paymentStatus = json['paymentStatus'];
    pdfGenResult = json['pdfGenResult'] != null
        ? new PdfGenResult.fromJson(json['pdfGenResult'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.planPackage != null) {
      data['planPackage'] = this.planPackage.toJson();
    }
    data['paymentId'] = this.paymentId;
    data['paymentOrderId'] = this.paymentOrderId;
    data['paymentRequestId'] = this.paymentRequestId;
    data['paymentStatus'] = this.paymentStatus;
    if (this.pdfGenResult != null) {
      data['pdfGenResult'] = this.pdfGenResult.toJson();
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
        ? new Providers.fromJson(json['providers'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['packageid'] = this.packageid;
    data['providerid'] = this.providerid;
    data['packcatid'] = this.packcatid;
    data['careteamid'] = this.careteamid;
    data['title'] = this.title;
    data['description'] = this.description;
    data['price'] = this.price;
    data['issubscription'] = this.issubscription;
    data['ispublic'] = this.ispublic;
    data['html'] = this.html;
    data['packageDuration'] = this.packageDuration;
    data['billingCycle'] = this.billingCycle;
    data['ts'] = this.ts;
    data['deleted'] = this.deleted;
    data['docid'] = this.docid;
    if (this.providers != null) {
      data['providers'] = this.providers.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['providerid'] = this.providerid;
    data['title'] = this.title;
    data['description'] = this.description;
    data['metadata'] = this.metadata;
    data['deleted'] = this.deleted;
    data['linkid'] = this.linkid;
    data['ts'] = this.ts;
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
    json['payload'] != null ? new Payload.fromJson(json['payload']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.payload != null) {
      data['payload'] = this.payload.toJson();
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
        ? new ResponseMetadata.fromJson(json['ResponseMetadata'])
        : null;
    mD5OfMessageBody = json['MD5OfMessageBody'];
    messageId = json['MessageId'];
    sequenceNumber = json['SequenceNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.responseMetadata != null) {
      data['ResponseMetadata'] = this.responseMetadata.toJson();
    }
    data['MD5OfMessageBody'] = this.mD5OfMessageBody;
    data['MessageId'] = this.messageId;
    data['SequenceNumber'] = this.sequenceNumber;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RequestId'] = this.requestId;
    return data;
  }
}