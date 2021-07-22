import '../../../constants/fhb_parameters.dart' as parameters;

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
        ? Response.fromJson(json[parameters.strResponse])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data[parameters.strStatus] = status;
    data[parameters.strSuccess] = success;
    data[parameters.strMessage] = message;
    if (response != null) {
      data[parameters.strResponse] = response.toJson();
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
    final data = Map<String, dynamic>();
    data[parameters.strId] = id;
    data[parameters.strCountryCode] = countryCode;
    data[parameters.strPhoneNumber] = phoneNumber;
    data[parameters.strLastLoggedIn] = lastLoggedIn;
    data[parameters.strAuthToken] = authToken;
    return data;
  }
}