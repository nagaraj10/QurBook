import '../../../constants/fhb_parameters.dart' as parameters;
import 'SignInAndSignUpResponse.dart';

class SignUp {
  int status;
  bool success;
  String message;
  SignInAndSignUpResponse response;

  SignUp({this.status, this.success, this.message, this.response});

  SignUp.fromJson(Map<String, dynamic> json) {
    status = json[parameters.strStatus];
    success = json[parameters.strSuccess];
    message = json[parameters.strMessage];
    response = json[parameters.strResponse] != null
        ? SignInAndSignUpResponse.fromJson(json[parameters.strResponse])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
      data[parameters.strStatus] = status;
    data[parameters.strSuccess] = success;
    data[parameters.strMessage] = message;
    if (response != null) {
      data[parameters.strResponse] = response.toJson();
    }
    return data;
  }
}

