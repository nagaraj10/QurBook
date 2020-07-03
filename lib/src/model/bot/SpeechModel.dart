import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

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
    sender = json[parameters.strSender];
    name = json[parameters.strSenderName];
    message = json[parameters.strMessage];
    source = json[parameters.strSource];
    sessionId = json[parameters.strSessionId];
    authToken = json[parameters.strAuthToken];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strSender] = this.sender;
    data[parameters.strSenderName] = this.name;
    data[parameters.strMessage] = this.message;
    data[parameters.strSource] = this.source;
    data[parameters.strSessionId] = this.sessionId;
    data[parameters.strAuthToken] = this.authToken;
    return data;
  }
}