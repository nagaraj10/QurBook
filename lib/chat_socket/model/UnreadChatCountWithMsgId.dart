class UnreadChatCountWithMsgId {
  bool? isSuccess;

  UnreadChatCountWithMsgId({this.isSuccess});

  UnreadChatCountWithMsgId.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    return data;
  }
}