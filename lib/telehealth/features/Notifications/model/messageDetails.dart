
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/telehealth/features/Notifications/model/RawMessage.dart';
import 'package:myfhb/telehealth/features/Notifications/model/content.dart';
import 'package:myfhb/telehealth/features/Notifications/model/messageContent.dart';
import 'package:myfhb/telehealth/features/Notifications/model/payload.dart';

class MessageDetails {
  RawMessage? rawMessage;
  Content? content;
  Payload? payload;
  MessageContent? messageContent;
  bool? isAccepted;

  MessageDetails(
      {this.content, this.payload, this.messageContent, this.rawMessage});

  MessageDetails.fromJson(Map<String, dynamic> json) {
    try {
      content =
              json['content'] != null ? Content.fromJson(json['content']) : null;
      rawMessage = json['rawMessage'] != null
              ? RawMessage.fromJson(json['rawMessage'])
              : null;
      payload =
              json['payload'] != null ? Payload.fromJson(json['payload']) : null;
      messageContent = json['messageContent'] != null
              ? MessageContent.fromJson(json['messageContent'])
              : null;
      isAccepted=json['isAccepted'] != null
              ? json['isAccepted']
              : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.content != null) {
      data['content'] = this.content!.toJson();
    }
    if (this.rawMessage != null) {
      data['rawMessage'] = this.rawMessage!.toJson();
    }
    if (this.payload != null) {
      data['payload'] = this.payload!.toJson();
    }
    if (this.messageContent != null) {
      data['messageContent'] = this.messageContent!.toJson();
    }
    return data;
  }

  void setAccepted(bool bool) {
    isAccepted=bool;
  }
}
