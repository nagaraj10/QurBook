import 'package:myfhb/common/keysofmodel.dart';

class Content {
  String messageTitle;
  String messageBody;

  Content({this.messageTitle, this.messageBody});

  Content.fromJson(Map<String, dynamic> json) {
    messageTitle = json[c_messageTitle];
    messageBody = json[c_messageBody];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[c_messageTitle] = this.messageTitle;
    data[c_messageBody] = this.messageBody;
    return data;
  }
}
