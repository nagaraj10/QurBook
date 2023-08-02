
import 'package:myfhb/common/CommonUtil.dart';

import '../../../constants/fhb_parameters.dart' as parameters;

class SignInAndSignUpResponse {
  String? createdTimeString;
  String? expiryTimeString;

  SignInAndSignUpResponse({this.createdTimeString, this.expiryTimeString});

  SignInAndSignUpResponse.fromJson(Map<String, dynamic> parsedJson) {
    try {
      createdTimeString = parsedJson[parameters.strCreationTime];
      expiryTimeString = parsedJson[parameters.strExpirationTime];
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[parameters.strCreationTime] = createdTimeString;
    data[parameters.strExpirationTime] = expiryTimeString;
    return data;
  }
}