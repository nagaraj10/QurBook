import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/src/model/Authentication/SignInAndSignUpResponse.dart';

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
        ? new SignInAndSignUpResponse.fromJson(json[parameters.strResponse])
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

