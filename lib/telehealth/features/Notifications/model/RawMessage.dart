
import 'package:myfhb/common/CommonUtil.dart';

class RawMessage {
  String? messageTitle;
  String? messageBody;

  RawMessage({this.messageTitle, this.messageBody});

  RawMessage.fromJson(Map<String, dynamic> json) {
    try {
      messageTitle = json['messageTitle'];
      messageBody = json['messageBody'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['messageTitle'] = this.messageTitle;
    data['messageBody'] = this.messageBody;
    return data;
  }
}