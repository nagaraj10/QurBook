import 'package:myfhb/telehealth/features/Notifications/model/messageDetails.dart';
import 'package:myfhb/telehealth/features/Notifications/model/notificationResponseText.dart';
import 'package:myfhb/telehealth/features/Notifications/model/recipientUser.dart';

class NotificationResult {
  String id;
  MessageDetails messageDetails;
  String transportMedium;
  var responseText;
  String deliveredDateTime;
  String createdOn;
  var recipientUserDetails;
  RecipientUser recipientUser;
  var scheduler;
  RecipientUser senderUser;
  bool isActionDone;
  bool isUnread;

  NotificationResult(
      {this.id,
      this.messageDetails,
      this.transportMedium,
      this.responseText,
      this.deliveredDateTime,
      this.createdOn,
      this.recipientUserDetails,
      this.recipientUser,
      this.scheduler,
      this.senderUser,
      this.isActionDone,
      this.isUnread});

  NotificationResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    messageDetails = json['messageDetails'] != null
        ? new MessageDetails.fromJson(json['messageDetails'])
        : null;
    transportMedium = json['transportMedium'];
    responseText = json['responseText'] != null ? (json['responseText']) : null;
    deliveredDateTime = json['deliveredDateTime'];
    createdOn = json['createdOn'];
    recipientUserDetails = json['recipientUserDetails'];
    recipientUser = json['recipientUser'] != null
        ? new RecipientUser.fromJson(json['recipientUser'])
        : null;
    scheduler = json['scheduler'];
    senderUser = json['senderUser'] != null
        ? RecipientUser.fromJson(json['senderUser'])
        : null;
    isActionDone = json['isActionDone'];
    isUnread = json['isUnread'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.messageDetails != null) {
      data['messageDetails'] = this.messageDetails.toJson();
    }
    data['transportMedium'] = this.transportMedium;
    if (this.responseText != null) {
      data['responseText'] = this.responseText;
    }
    data['deliveredDateTime'] = this.deliveredDateTime;
    data['createdOn'] = this.createdOn;
    data['recipientUserDetails'] = this.recipientUserDetails;
    if (this.recipientUser != null) {
      data['recipientUser'] = this.recipientUser.toJson();
    }
    data['scheduler'] = this.scheduler;
    if (this.senderUser != null) {
      data['senderUser'] = this.senderUser.toJson();
    }
    data['isActionDone'] = this.isActionDone;
    data['isUnread'] = this.isUnread;
    return data;
  }
}
