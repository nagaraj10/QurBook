import 'ChatHistoryModel.dart';

class EmitAckResponse {
  //List<ChatList> chatList;
  ChatHistoryResult lastSentMessageInfo;

  EmitAckResponse({/*this.chatList,*/ this.lastSentMessageInfo});

  EmitAckResponse.fromJson(Map<String, dynamic> json) {
    /*if (json['chatList'] != null) {
      chatList = new List<ChatList>();
      json['chatList'].forEach((v) {
        chatList.add(new ChatList.fromJson(v));
      });
    }*/
    lastSentMessageInfo = json['lastSentMessageInfo'] != null
        ? new ChatHistoryResult.fromJson(json['lastSentMessageInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
   /* if (this.chatList != null) {
      data['chatList'] = this.chatList.map((v) => v.toJson()).toList();
    }*/
    if (this.lastSentMessageInfo != null) {
      data['lastSentMessageInfo'] = this.lastSentMessageInfo.toJson();
    }
    return data;
  }
}

/*class ChatList {
  String id;
  String peerId;
  String firstName;
  String lastName;
  String profilePicThumbnailURL;
  String deliveredDateTime;
  String messageId;
  bool isRead;
  int messageType;
  Messages messages;
  String documentId;
  int unReadCount;
  String specialization;

  ChatList(
      {this.id,
        this.peerId,
        this.firstName,
        this.lastName,
        this.profilePicThumbnailURL,
        this.deliveredDateTime,
        this.messageId,
        this.isRead,
        this.messageType,
        this.messages,
        this.documentId,
        this.unReadCount,
        this.specialization});

  ChatList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    peerId = json['peerId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    profilePicThumbnailURL = json['profilePicThumbnailURL'];
    deliveredDateTime = json['deliveredDateTime'];
    messageId = json['messageId'];
    isRead = json['isRead'];
    messageType = json['messageType'];
    messages = json['messages'] != null
        ? new Messages.fromJson(json['messages'])
        : null;
    documentId = json['documentId'];
    unReadCount = json['unReadCount'];
    specialization = json['specialization'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['peerId'] = this.peerId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['profilePicThumbnailURL'] = this.profilePicThumbnailURL;
    data['deliveredDateTime'] = this.deliveredDateTime;
    data['messageId'] = this.messageId;
    data['isRead'] = this.isRead;
    data['messageType'] = this.messageType;
    if (this.messages != null) {
      data['messages'] = this.messages.toJson();
    }
    data['documentId'] = this.documentId;
    data['unReadCount'] = this.unReadCount;
    data['specialization'] = this.specialization;
    return data;
  }
}

class Messages {
  String id;
  String idTo;
  int type;
  String idFrom;
  bool isread;
  String content;
  Timestamp timestamp;

  Messages(
      {this.id,
        this.idTo,
        this.type,
        this.idFrom,
        this.isread,
        this.content,
        this.timestamp});

  Messages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idTo = json['idTo'];
    type = json['type'];
    idFrom = json['idFrom'];
    isread = json['isread'];
    content = json['content'];
    timestamp = json['timestamp'] != null
        ? new Timestamp.fromJson(json['timestamp'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idTo'] = this.idTo;
    data['type'] = this.type;
    data['idFrom'] = this.idFrom;
    data['isread'] = this.isread;
    data['content'] = this.content;
    if (this.timestamp != null) {
      data['timestamp'] = this.timestamp.toJson();
    }
    return data;
  }
}

class Timestamp {
  int iSeconds;
  int iNanoseconds;

  Timestamp({this.iSeconds, this.iNanoseconds});

  Timestamp.fromJson(Map<String, dynamic> json) {
    iSeconds = json['_seconds'];
    iNanoseconds = json['_nanoseconds'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_seconds'] = this.iSeconds;
    data['_nanoseconds'] = this.iNanoseconds;
    return data;
  }
}*/

/*
class LastSentMessageInfo {
  String id;
  String deliveredOn;
  bool isRead;
  int type;
  Messages messages;
  int documentId;
  String createdOn;
  String lastModifiedOn;
  String chatFileUrl;

  LastSentMessageInfo(
      {this.id,
        this.deliveredOn,
        this.isRead,
        this.type,
        this.messages,
        this.documentId,
        this.createdOn,
        this.lastModifiedOn,
        this.chatFileUrl});

  LastSentMessageInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    deliveredOn = json['deliveredOn'];
    isRead = json['isRead'];
    type = json['type'];
    messages = json['messages'] != null
        ? new Messages.fromJson(json['messages'])
        : null;
    documentId = json['documentId'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    chatFileUrl = json['chatFileUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['deliveredOn'] = this.deliveredOn;
    data['isRead'] = this.isRead;
    data['type'] = this.type;
    if (this.messages != null) {
      data['messages'] = this.messages.toJson();
    }
    data['documentId'] = this.documentId;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    data['chatFileUrl'] = this.chatFileUrl;
    return data;
  }
}*/
