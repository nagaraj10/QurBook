class InitChatFamilyModel {
  bool isSuccess;
  Result result;

  InitChatFamilyModel({this.isSuccess, this.result});

  InitChatFamilyModel.fromJson(Map<String, dynamic> json) {
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
  String chatListId;

  Result({this.chatListId});

  Result.fromJson(Map<String, dynamic> json) {
    chatListId = json['chatListId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chatListId'] = this.chatListId;
    return data;
  }
}