
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/keysofmodel.dart';

class Content {
  String? messageTitle;
  String? messageBody;

  Content({this.messageTitle, this.messageBody});

  Content.fromJson(Map<String, dynamic> json) {
    try {
      messageTitle = json[c_messageTitle];
      messageBody = json[c_messageBody];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data[c_messageTitle] = this.messageTitle;
    data[c_messageBody] = this.messageBody;
    return data;
  }
}
