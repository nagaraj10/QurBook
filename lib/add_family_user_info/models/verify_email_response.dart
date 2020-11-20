import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class VerifyEmailResponse {
  int status;
  bool success;
  String message;
  Response response;

  VerifyEmailResponse({this.status, this.success, this.message, this.response});

  VerifyEmailResponse.fromJson(Map<String, dynamic> json) {
    status = json[parameters.strStatus];
    success = json[parameters.strSuccess];
    message = json[parameters.strMessage];
    response = json[parameters.strResponse] != null
        ? new Response.fromJson(json[parameters.strResponse])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strStatus] = this.status;
    data[parameters.strSuccess] = this.success;
    data[parameters.strMessage] = this.message;
    if (this.response != null) {
      data[parameters.strResponse] = this.response.toJson();
    }
    return data;
  }
}

class Response {
  String creationTime;
  String expirationTime;

  Response({this.creationTime, this.expirationTime});

  Response.fromJson(Map<String, dynamic> json) {
    creationTime = json[parameters.strCreationTime];
    expirationTime = json[parameters.strExpirationTime];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strCreationTime] = this.creationTime;
    data[parameters.strExpirationTime] = this.expirationTime;
    return data;
  }
}