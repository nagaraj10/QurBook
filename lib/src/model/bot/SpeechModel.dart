import '../../../constants/fhb_parameters.dart' as parameters;

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
    final data = Map<String, dynamic>();
    data[parameters.strSender] = sender;
    data[parameters.strSenderName] = name;
    data[parameters.strMessage] = message;
    data[parameters.strSource] = source;
    data[parameters.strSessionId] = sessionId;
    data[parameters.strAuthToken] = authToken;
    return data;
  }
}