
import 'package:myfhb/common/CommonUtil.dart';

class SheelaQueueModel {
  bool? isSuccess;
  String? message;
  SheelaInsertResult? result;

  SheelaQueueModel({this.isSuccess, this.message, this.result});

  SheelaQueueModel.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      message = json['message'];
      result =
          json['result'] != null ? new SheelaInsertResult.fromJson(json['result']) : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class SheelaInsertResult {
  String? sheelaQueueId;
  int? queueCount;

  SheelaInsertResult({this.sheelaQueueId, this.queueCount});

  SheelaInsertResult.fromJson(Map<String, dynamic> json) {
    try {
      sheelaQueueId = json['sheelaQueueId'];
      queueCount = json['queueCount'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sheelaQueueId'] = this.sheelaQueueId;
    data['queueCount'] = this.queueCount;
    return data;
  }
}