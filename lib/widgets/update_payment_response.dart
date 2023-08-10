
import 'package:myfhb/common/CommonUtil.dart';

class UpdatePaymentResponse {
  bool? isSuccess;
  Result? result;

  UpdatePaymentResponse({this.isSuccess, this.result});

  UpdatePaymentResponse.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      result =
              json['result'] != null ? new Result.fromJson(json['result']) : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  SubscribeResponse? subscribeResponse;
  String? paymentId;
  String? paymentOrderId;
  String? paymentRequestId;
  String? paymentStatus;
  String? cartId;
  String? cartUserId;

  Result(
      {this.subscribeResponse,
      this.paymentId,
      this.paymentOrderId,
      this.paymentRequestId,
      this.paymentStatus,
      this.cartId,
      this.cartUserId});

  Result.fromJson(Map<String, dynamic> json) {
    try {
      subscribeResponse = json['subscribeResponse'] != null
              ? new SubscribeResponse.fromJson(json['subscribeResponse'])
              : null;
      paymentId = json['paymentId'];
      paymentOrderId = json['paymentOrderId'];
      paymentRequestId = json['paymentRequestId'];
      paymentStatus = json['paymentStatus'];
      cartId = json['cartId'];
      cartUserId = json['cartUserId'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.subscribeResponse != null) {
      data['subscribeResponse'] = this.subscribeResponse!.toJson();
    }
    data['paymentId'] = this.paymentId;
    data['paymentOrderId'] = this.paymentOrderId;
    data['paymentRequestId'] = this.paymentRequestId;
    data['paymentStatus'] = this.paymentStatus;
    data['cartId'] = this.cartId;
    data['cartUserId'] = this.cartUserId;
    return data;
  }
}

class SubscribeResponse {
  bool? isSuccess;
  List<Payload>? payload;

  SubscribeResponse({this.isSuccess, this.payload});

  SubscribeResponse.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      if (json['payload'] != null) {
            payload = <Payload>[];
            json['payload'].forEach((v) {
              payload!.add(new Payload.fromJson(v));
            });
          }
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.payload != null) {
      data['payload'] = this.payload!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Payload {
  String? result;
  String? planStartDate;
  String? message;
  int? packageid;
  String? price;
  String? docid;

  Payload(
      {this.result,
      this.planStartDate,
      this.message,
      this.packageid,
      this.price,
      this.docid});

  Payload.fromJson(Map<String, dynamic> json) {
    try {
      result = json['Result'];
      planStartDate = json['PlanStartDate'];
      message = json['Message'];
      packageid = json['packageid'];
      price = json['price'];
      docid = json['docid'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
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
