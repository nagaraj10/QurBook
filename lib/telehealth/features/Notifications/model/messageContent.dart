
import 'package:myfhb/common/CommonUtil.dart';

class MessageContent {
  String? messageBody;
  String? messageTitle;

  MessageContent({this.messageBody, this.messageTitle});

  MessageContent.fromJson(Map<String, dynamic> json) {
    try {
      messageBody = json['messageBody'];
      messageTitle = json['messageTitle'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['messageBody'] = this.messageBody;
    data['messageTitle'] = this.messageTitle;
    return data;
  }
}