
import 'package:myfhb/common/CommonUtil.dart';

class MessageContent {
  String? messageBody;
  String? messageTitle;

  MessageContent({this.messageBody, this.messageTitle});

  MessageContent.fromJson(Map<String, dynamic> json) {
    try {
      messageBody = json['messageBody'];
      messageTitle = json['messageTitle'];
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['messageBody'] = this.messageBody;
    data['messageTitle'] = this.messageTitle;
    return data;
  }
}