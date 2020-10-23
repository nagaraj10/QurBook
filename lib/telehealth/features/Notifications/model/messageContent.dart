class MessageContent {
  String messageBody;
  String messageTitle;

  MessageContent({this.messageBody, this.messageTitle});

  MessageContent.fromJson(Map<String, dynamic> json) {
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