class RawMessage {
  String messageTitle;
  String messageBody;

  RawMessage({this.messageTitle, this.messageBody});

  RawMessage.fromJson(Map<String, dynamic> json) {
    messageTitle = json['messageTitle'];
    messageBody = json['messageBody'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['messageTitle'] = this.messageTitle;
    data['messageBody'] = this.messageBody;
    return data;
  }
}