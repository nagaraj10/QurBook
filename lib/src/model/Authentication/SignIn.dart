class SignIn {
  int status;
  bool success;
  String message;
  SignInResponse response;

  SignIn({this.status, this.success, this.message, this.response});

  SignIn.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    message = json['message'];
    response = json['response'] != null
        ? new SignInResponse.fromJson(json['response'])
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

class SignInResponse {
  String createdTimeString;
  String expiryTimeString;

  SignInResponse({this.createdTimeString, this.expiryTimeString});

  SignInResponse.fromJson(Map<String, dynamic> parsedJson) {
    createdTimeString = parsedJson['creationTime'];
    expiryTimeString = parsedJson['expirationTime'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['creationTime'] = this.createdTimeString;
    data['expirationTime'] = this.expiryTimeString;
    return data;
  }
}
