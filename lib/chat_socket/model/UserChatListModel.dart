
import 'package:myfhb/common/CommonUtil.dart';

class UserChatListModel {
  bool? isSuccess;
  List<PayloadChat>? payload;

  UserChatListModel({this.isSuccess, this.payload});

  UserChatListModel.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      if (json['payload'] != null) {
            payload = <PayloadChat>[];
            json['payload'].forEach((v) {
              payload!.add(new PayloadChat.fromJson(v));
            });
          }
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.payload != null) {
      data['payload'] = this.payload!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PayloadChat {
  String? id;
  String? peerId;
  String? firstName;
  String? lastName;
  String? profilePicThumbnailURL;
  String? deliveredDateTime;
  String? messageId;
  bool? isRead;
  int? messageType;
  Messages? messages;
  String? documentId;
  String? unReadCount;
  bool? isDisable;
  String? deliveredTimeStamp;
  String? familyUserId;
  String? familyUserFirstName;
  String? familyUserLastName;
  bool? isFamilyUserCareCoordinator;
  bool? isPrimaryCareCoordinator;


  PayloadChat({
    this.id,
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
    this.deliveredTimeStamp,
    this.familyUserId,
    this.familyUserFirstName,
    this.familyUserLastName,
    this.isFamilyUserCareCoordinator,
    this.isPrimaryCareCoordinator,
  });

  PayloadChat.fromJson(Map<String, dynamic> json) {
    try {
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
      isDisable = json['isDisable'] != null ? json['isDisable'] : false;
      deliveredTimeStamp = json['deliveredTimeStamp'];
      familyUserId = json['familyUserId'];
      familyUserFirstName = json['familyUserFirstName'];
      familyUserLastName = json['familyUserLastName'];
      isFamilyUserCareCoordinator = json['isFamilyUserCareCoordinator'] != null
              ? json['isFamilyUserCareCoordinator']
              : false;
      isPrimaryCareCoordinator = json['isPrimaryCareCoordinator'] != null
              ? json['isPrimaryCareCoordinator']
              : false;
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
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
      data['messages'] = this.messages!.toJson();
    }
    data['documentId'] = this.documentId;
    data['unReadCount'] = this.unReadCount;
    data['isDisable'] = this.isDisable;
    data['deliveredTimeStamp'] = this.deliveredTimeStamp;
    data['familyUserId'] = this.familyUserId;
    data['familyUserFirstName'] = this.familyUserFirstName;
    data['familyUserLastName'] = this.familyUserLastName;
    data['isFamilyUserCareCoordinator'] = this.isFamilyUserCareCoordinator;
    data['isPrimaryCareCoordinator'] = this.isPrimaryCareCoordinator;
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

  Messages(
      {this.id,
      this.idTo,
      this.type,
      this.idFrom,
      this.isread,
      this.content,
      this.timestamp});

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
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
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
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_seconds'] = this.sSeconds;
    data['_nanoseconds'] = this.sNanoseconds;
    return data;
  }
}
