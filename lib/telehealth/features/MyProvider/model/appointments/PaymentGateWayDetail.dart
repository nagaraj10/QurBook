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

  PaymentGatewayDetail(
      {this.sourceId,
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
  PaymentRequestResult result;
  bool isSuccess;

  ResponseInfo({this.result, this.isSuccess});

  ResponseInfo.fromJson(Map<String, dynamic> json) {
    result =
    json['result'] != null ? new PaymentRequestResult.fromJson(json['result']) : null;
    isSuccess = json['isSuccess'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    data['isSuccess'] = this.isSuccess;
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