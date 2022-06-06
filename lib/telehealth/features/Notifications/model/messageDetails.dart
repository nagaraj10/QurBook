import 'package:myfhb/telehealth/features/Notifications/model/RawMessage.dart';
import 'package:myfhb/telehealth/features/Notifications/model/content.dart';
import 'package:myfhb/telehealth/features/Notifications/model/messageContent.dart';
import 'package:myfhb/telehealth/features/Notifications/model/payload.dart';

class MessageDetails {
  RawMessage rawMessage;
  Content content;
  Payload payload;
  MessageContent messageContent;

  MessageDetails(
      {this.content, this.payload, this.messageContent, this.rawMessage});

  MessageDetails.fromJson(Map<String, dynamic> json) {
    content =
        json['content'] != null ? new Content.fromJson(json['content']) : null;
    rawMessage = json['rawMessage'] != null
        ? new RawMessage.fromJson(json['rawMessage'])
        : null;
    payload =
        json['payload'] != null ? new Payload.fromJson(json['payload']) : null;
    messageContent = json['messageContent'] != null
        ? new MessageContent.fromJson(json['messageContent'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.content != null) {
      data['content'] = this.content.toJson();
    }
    if (this.rawMessage != null) {
      data['rawMessage'] = this.rawMessage.toJson();
    }
    if (this.payload != null) {
      data['payload'] = this.payload.toJson();
    }
    if (this.messageContent != null) {
      data['messageContent'] = this.messageContent.toJson();
    }
    return data;
  }
}
