
import 'package:myfhb/common/CommonUtil.dart';

class NotificationResponseText {
  String? code;
  String? message;

  NotificationResponseText({this.code, this.message});

  NotificationResponseText.fromJson(Map<String, dynamic> json) {
    try {
      code = json['code'];
      message = json['message'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    return data;
  }
}