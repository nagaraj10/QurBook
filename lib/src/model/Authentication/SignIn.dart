class SignIn {
  int status;
  bool success;
  String message;
  SignInResponse signInResponse;

  SignIn({this.status, this.success, this.message, this.signInResponse});

  factory SignIn.fromJson(Map<String, dynamic> parsedJson) {
    var statusCode = parsedJson['status'];
    var successValue = parsedJson['success'];
    var messageString = parsedJson['message'];
    var responseString = parsedJson['response'];

    SignInResponse signInResponse = SignInResponse.fromJson(responseString);

    return SignIn(
        status: statusCode,
        success: successValue,
        message: messageString,
        signInResponse: signInResponse);
  }
}

class SignInResponse {
  String creationTime;
  String expirationTime;

  SignInResponse({this.creationTime, this.expirationTime});

  factory SignInResponse.fromJson(Map<String, dynamic> parsedJson) {
    var createdTimeString = parsedJson['creationTime'];
    var expiryTimeString = parsedJson['expirationTime'];

    return SignInResponse(
      creationTime: createdTimeString,
      expirationTime: expiryTimeString,
    );
  }
}
