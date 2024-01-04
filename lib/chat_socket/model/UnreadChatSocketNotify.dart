
import 'package:myfhb/common/CommonUtil.dart';

class UnreadChatSocketNotify {
  String? idFrom;
  String? idTo;
  Result? result;

  UnreadChatSocketNotify({this.idFrom, this.idTo, this.result});

  UnreadChatSocketNotify.fromJson(Map<String, dynamic> json) {
    try {
      idFrom = json['idFrom'];
      idTo = json['idTo'];
      result =
          json['result'] != null ? Result.fromJson(json['result']) : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['idFrom'] = this.idFrom;
    data['idTo'] = this.idTo;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  bool? isSuccess;
  List<Payload>? payload;

  Result({this.isSuccess, this.payload});

  Result.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      if (json['payload'] != null) {
            payload = <Payload>[];
            json['payload'].forEach((v) {
              payload!.add(Payload.fromJson(v));
            });
          }
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.payload != null) {
      data['payload'] = this.payload!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Payload {
  String? count;

  Payload({this.count});

  Payload.fromJson(Map<String, dynamic> json) {
    try {
      count = json['count'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['count'] = this.count;
    return data;
  }
}