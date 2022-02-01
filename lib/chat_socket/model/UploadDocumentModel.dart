class UploadDocumentModel {
  bool isSuccess;
  Result result;

  UploadDocumentModel({this.isSuccess, this.result});

  UploadDocumentModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class Result {
  String chatMessageId;
  String fileUrl;

  Result({this.chatMessageId, this.fileUrl});

  Result.fromJson(Map<String, dynamic> json) {
    chatMessageId = json['chatMessageId'];
    fileUrl = json['fileUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chatMessageId'] = this.chatMessageId;
    data['fileUrl'] = this.fileUrl;
    return data;
  }
}