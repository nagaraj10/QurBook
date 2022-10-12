class SheelaBadgeModel {
  bool isSuccess;
  String message;
  SheelaBadgeResult result;

  SheelaBadgeModel({this.isSuccess, this.message, this.result});

  SheelaBadgeModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    result =
    json['result'] != null ? new SheelaBadgeResult.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class SheelaBadgeResult {
  int queueCount;
  //List<QueueDetails>? queueDetails;

  SheelaBadgeResult({this.queueCount/*, this.queueDetails*/});

  SheelaBadgeResult.fromJson(Map<String, dynamic> json) {
    queueCount = json['queueCount'];
   /* if (json['queueDetails'] != null) {
      queueDetails = <QueueDetails>[];
      json['queueDetails'].forEach((v) {
        queueDetails!.add(new QueueDetails.fromJson(v));
      });
    }*/
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['queueCount'] = this.queueCount;
   /* if (this.queueDetails != null) {
      data['queueDetails'] = this.queueDetails!.map((v) => v.toJson()).toList();
    }*/
    return data;
  }
}

class QueueDetails {
  String sheelaQueueId;
  MessageDetails messageDetails;

  QueueDetails({this.sheelaQueueId, this.messageDetails});

  QueueDetails.fromJson(Map<String, dynamic> json) {
    sheelaQueueId = json['sheelaQueueId'];
    messageDetails = json['messageDetails'] != null
        ? new MessageDetails.fromJson(json['messageDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sheelaQueueId'] = this.sheelaQueueId;
    if (this.messageDetails != null) {
      data['messageDetails'] = this.messageDetails.toJson();
    }
    return data;
  }
}

class MessageDetails {
  String source;
  Content content;
  Payload payload;
  Content rawMessage;
  MessageContent messageContent;

  MessageDetails(
      {this.source,
        this.content,
        this.payload,
        this.rawMessage,
        this.messageContent});

  MessageDetails.fromJson(Map<String, dynamic> json) {
    source = json['source'];
    content =
    json['content'] != null ? new Content.fromJson(json['content']) : null;
    payload =
    json['payload'] != null ? new Payload.fromJson(json['payload']) : null;
    rawMessage = json['rawMessage'] != null
        ? new Content.fromJson(json['rawMessage'])
        : null;
    messageContent = json['messageContent'] != null
        ? new MessageContent.fromJson(json['messageContent'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['source'] = this.source;
    if (this.content != null) {
      data['content'] = this.content.toJson();
    }
    if (this.payload != null) {
      data['payload'] = this.payload.toJson();
    }
    if (this.rawMessage != null) {
      data['rawMessage'] = this.rawMessage.toJson();
    }
    if (this.messageContent != null) {
      data['messageContent'] = this.messageContent.toJson();
    }
    return data;
  }
}

class Content {
  String messageBody;
  String messageTitle;

  Content({this.messageBody, this.messageTitle});

  Content.fromJson(Map<String, dynamic> json) {
    messageBody = json['messageBody'];
    messageTitle = json['messageTitle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['messageBody'] = this.messageBody;
    data['messageTitle'] = this.messageTitle;
    return data;
  }
}

class Payload {
  String type;
  String priority;
  String redirectTo;
  String notificationListId;
  String isSheela;

  Payload(
      {this.type,
        this.priority,
        this.redirectTo,
        this.notificationListId,
        this.isSheela});

  Payload.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    priority = json['priority'];
    redirectTo = json['redirectTo'];
    notificationListId = json['notificationListId'];
    isSheela = json['isSheela'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['priority'] = this.priority;
    data['redirectTo'] = this.redirectTo;
    data['notificationListId'] = this.notificationListId;
    data['isSheela'] = this.isSheela;
    return data;
  }
}

class MessageContent {
  String messageBody;
  String messageTitle;
  String rawMessageBody;
  String rawMessageTitle;

  MessageContent(
      {this.messageBody,
        this.messageTitle,
        this.rawMessageBody,
        this.rawMessageTitle});

  MessageContent.fromJson(Map<String, dynamic> json) {
    messageBody = json['messageBody'];
    messageTitle = json['messageTitle'];
    rawMessageBody = json['rawMessageBody'];
    rawMessageTitle = json['rawMessageTitle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['messageBody'] = this.messageBody;
    data['messageTitle'] = this.messageTitle;
    data['rawMessageBody'] = this.rawMessageBody;
    data['rawMessageTitle'] = this.rawMessageTitle;
    return data;
  }
}