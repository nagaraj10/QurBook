import '../../../constants/fhb_parameters.dart' as parameters;

class SignInAndSignUpResponse {
  String createdTimeString;
  String expiryTimeString;

  SignInAndSignUpResponse({this.createdTimeString, this.expiryTimeString});

  SignInAndSignUpResponse.fromJson(Map<String, dynamic> parsedJson) {
    createdTimeString = parsedJson[parameters.strCreationTime];
    expiryTimeString = parsedJson[parameters.strExpirationTime];
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[parameters.strCreationTime] = createdTimeString;
    data[parameters.strExpirationTime] = expiryTimeString;
    return data;
  }
}