
import 'package:myfhb/common/CommonUtil.dart';

class TotalCountModel {
  bool? isSuccess;
  List<Payload>? payload;

  TotalCountModel({this.isSuccess, this.payload});

  TotalCountModel.fromJson(Map<String, dynamic> json) {
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