class OTPResponse {
  int status;
  bool success;
  String message;
  Response response;

  OTPResponse({this.status, this.success, this.message, this.response});

  OTPResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    message = json['message'];
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.response != null) {
      data['response'] = this.response.toJson();
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
    id = json['id'];
    countryCode = json['countryCode'];
    phoneNumber = json['phoneNumber'];
    lastLoggedIn = json['lastLoggedIn'];
    authToken = json['authToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['countryCode'] = this.countryCode;
    data['phoneNumber'] = this.phoneNumber;
    data['lastLoggedIn'] = this.lastLoggedIn;
    data['authToken'] = this.authToken;
    return data;
  }
}