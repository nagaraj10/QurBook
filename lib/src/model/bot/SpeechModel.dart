class SpeechModel {
  String sender;
  String name;
  String message;
  String source;
  String sessionId;
  String authToken;

  SpeechModel(
      {this.sender,
      this.name,
      this.message,
      this.source,
      this.sessionId,
      this.authToken});

  SpeechModel.fromJson(Map<String, dynamic> json) {
    sender = json['sender'];
    name = json['Name'];
    message = json['message'];
    source = json['source'];
    sessionId = json['sessionId'];
    authToken = json['authToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sender'] = this.sender;
    data['Name'] = this.name;
    data['message'] = this.message;
    data['source'] = this.source;
    data['sessionId'] = this.sessionId;
    data['authToken'] = this.authToken;
    return data;
  }
}