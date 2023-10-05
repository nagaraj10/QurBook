
import 'package:myfhb/common/CommonUtil.dart';

class ChatHistoryModel {
  bool? isSuccess;
  List<ChatHistoryResult?>? result;

  ChatHistoryModel({this.isSuccess, this.result});

  ChatHistoryModel.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      if (json['result'] != null) {
            result = <ChatHistoryResult?>[];
            json['result'].forEach((v) {
              result!.add(new ChatHistoryResult.fromJson(v));
            });
          }
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v!.toJson()).toList();
    }
    return data;
  }
}

class ChatHistoryResult {
  String? id;
  String? chatListId;
  String? deliveredDateTime;
  bool? isRead;
  bool? isCommonContent;

  //int messageType;
  Messages? messages;
  var documentId;

  ChatHistoryResult(
      {this.id,
      this.chatListId,
      this.deliveredDateTime,
      this.isRead,
      this.isCommonContent,
      //this.messageType,
      this.messages,
      this.documentId});

  ChatHistoryResult.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      chatListId = json['chatListId'];
      deliveredDateTime = json['deliveredDateTime'];
      isRead = json['isRead'];
      isCommonContent =
              json['isCommonContent'] != null ? json['isCommonContent'] : false;
      //messageType = json['type'];
      messages = json['messages'] != null
              ? new Messages.fromJson(json['messages'])
              : null;
      documentId = json['documentId'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['chatListId'] = this.chatListId;
    data['deliveredDateTime'] = this.deliveredDateTime;
    data['isRead'] = this.isRead;
    data['isCommonContent'] = this.isCommonContent;
    //data['messageType'] = this.messageType;
    if (this.messages != null) {
      data['messages'] = this.messages!.toJson();
    }
    data['documentId'] = this.documentId;
    return data;
  }
}

class Messages {
  String? id;
  String? idTo;
  int? type;
  String? idFrom;
  bool? isread;
  String? content;
  Timestamp? timestamp;
  bool? isSentViaSheela;

  Messages(
      {this.id,
      this.idTo,
      this.type,
      this.idFrom,
      this.isread,
      this.content,
      this.timestamp,this.isSentViaSheela});


  Messages.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      idTo = json['idTo'];
      type = json['type'];
      idFrom = json['idFrom'];
      isread = json['isread'];
      content = json['content'];
      timestamp = json['timestamp'] != null
              ? new Timestamp.fromJson(json['timestamp'])
              : null;
      isSentViaSheela = (json['isSentViaSheela']??false);
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
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
      data['timestamp'] = this.timestamp!.toJson();
    }
    data['isSentViaSheela'] = this.isSentViaSheela;
    return data;
  }
}

class Timestamp {
  String? sSeconds;
  String? sNanoseconds;

  Timestamp({this.sSeconds, this.sNanoseconds});

  Timestamp.fromJson(Map<String, dynamic> json) {
    try {
      sSeconds = json['_seconds'];
      sNanoseconds = json['_nanoseconds'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_seconds'] = this.sSeconds;
    data['_nanoseconds'] = this.sNanoseconds;
    return data;
  }
}
