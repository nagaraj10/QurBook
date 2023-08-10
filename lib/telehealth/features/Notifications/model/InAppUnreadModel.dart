
import 'package:myfhb/common/CommonUtil.dart';

class InAppUnReadModel {
  bool? isSuccess;
  String? message;
  String? result;

  InAppUnReadModel({this.isSuccess, this.message, this.result});

  InAppUnReadModel.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      message = json['message'];
      result = json['result'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    data['result'] = this.result;
    return data;
  }
}