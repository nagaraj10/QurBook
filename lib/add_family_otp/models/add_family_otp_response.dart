import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
class AddFamilyOTPResponse {
  int status;
  bool success;
  String message;
  Response response;

  AddFamilyOTPResponse(
      {this.status, this.success, this.message, this.response});

  AddFamilyOTPResponse.fromJson(Map<String, dynamic> json) {
    status = json[parameters.strStatus];
    success = json[parameters.strSuccess];
    message = json[parameters.strMessage];
    response = json[parameters.strResponse] != null
        ? new Response.fromJson(json[parameters.strResponse])
        : null;
  }


}

class Response {
  AddFamilyUserInfo data;

  Response({this.data});

  Response.fromJson(Map<String, dynamic> json) {
    data = json[parameters.strData] != null
        ? new AddFamilyUserInfo.fromJson(json[parameters.strData])
        : null;
  }
}

class AddFamilyUserInfo {
  String id;
  String email;
  String countryCode;
  String phoneNumber;
  String gender;
  String name;
  bool isTempUser;
  bool isEmailVerified;
  String transactionId;

  AddFamilyUserInfo(
      {this.id,
      this.email,
      this.countryCode,
      this.phoneNumber,
      this.gender,
      this.name,
      this.isTempUser,
      this.isEmailVerified,
      this.transactionId});

  AddFamilyUserInfo.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> userInfo = json[parameters.strUserInfo];

    id = userInfo[parameters.strId];
    email = userInfo[parameters.strEmail];
    countryCode = userInfo[parameters.strCountryCode];
    phoneNumber = userInfo[parameters.strPhoneNumber];
    gender = userInfo[parameters.strGender];
    name = userInfo[parameters.strName];
    isTempUser = userInfo[parameters.strIstemper];
    isEmailVerified = userInfo[parameters.strIsEmailVerified];
    transactionId = json[parameters.strTransactionId];
  }
}
