class SheelaReminderResponse {
  String? chatListId;
  String? chatMessageId;

  SheelaReminderResponse({this.chatListId, this.chatMessageId});

  SheelaReminderResponse.fromJson(Map<String, dynamic> json) {
    chatListId = json['chatListId'];
    chatMessageId = json['chatMessageId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['chatListId'] = this.chatListId;
    data['chatMessageId'] = this.chatMessageId;
    return data;
  }
}