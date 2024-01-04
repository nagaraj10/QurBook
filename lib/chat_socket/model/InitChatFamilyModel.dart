
import 'package:myfhb/common/CommonUtil.dart';

class InitChatFamilyModel {
  bool? isSuccess;
  Result? result;

  InitChatFamilyModel({this.isSuccess, this.result});

  InitChatFamilyModel.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      result =
          json['result'] != null ? Result.fromJson(json['result']) : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  String? chatListId;

  Result({this.chatListId});

  Result.fromJson(Map<String, dynamic> json) {
    try {
      chatListId = json['chatListId'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['chatListId'] = this.chatListId;
    return data;
  }
}