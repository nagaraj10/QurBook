import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class SignInAndSignUpResponse {
  String createdTimeString;
  String expiryTimeString;

  SignInAndSignUpResponse({this.createdTimeString, this.expiryTimeString});

  SignInAndSignUpResponse.fromJson(Map<String, dynamic> parsedJson) {
    createdTimeString = parsedJson[parameters.strCreationTime];
    expiryTimeString = parsedJson[parameters.strExpirationTime];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strCreationTime] = this.createdTimeString;
    data[parameters.strExpirationTime] = this.expiryTimeString;
    return data;
  }
}