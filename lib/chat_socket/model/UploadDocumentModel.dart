
import 'package:myfhb/common/CommonUtil.dart';

class UploadDocumentModel {
  bool? isSuccess;
  Result? result;

  UploadDocumentModel({this.isSuccess, this.result});

  UploadDocumentModel.fromJson(Map<String, dynamic> json) {
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
  String? chatMessageId;
  String? fileUrl;

  Result({this.chatMessageId, this.fileUrl});

  Result.fromJson(Map<String, dynamic> json) {
    try {
      chatMessageId = json['chatMessageId'];
      fileUrl = json['fileUrl'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['chatMessageId'] = this.chatMessageId;
    data['fileUrl'] = this.fileUrl;
    return data;
  }
}