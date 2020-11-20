import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class OTPResponse {
  int status;
  bool success;
  String message;
  Response response;

  OTPResponse({this.status, this.success, this.message, this.response});

  OTPResponse.fromJson(Map<String, dynamic> json) {
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
  String id;
  String countryCode;
  String phoneNumber;
  String lastLoggedIn;
  String authToken;

  Response(
      {this.id,
      this.countryCode,
      this.phoneNumber,
      this.lastLoggedIn,
      this.authToken});

  Response.fromJson(Map<String, dynamic> json) {
    id = json[parameters.strId];
    countryCode = json[parameters.strCountryCode];
    phoneNumber = json[parameters.strPhoneNumber];
    lastLoggedIn = json[parameters.strLastLoggedIn];
    authToken = json[parameters.strAuthToken];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strId] = this.id;
    data[parameters.strCountryCode] = this.countryCode;
    data[parameters.strPhoneNumber] = this.phoneNumber;
    data[parameters.strLastLoggedIn] = this.lastLoggedIn;
    data[parameters.strAuthToken] = this.authToken;
    return data;
  }
}