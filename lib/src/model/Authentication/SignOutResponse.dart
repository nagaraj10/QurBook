import '../../../common/CommonUtil.dart';
import '../../../constants/fhb_parameters.dart' as parameters;

class SignOutResponse {
  int status;
  bool success;
  String message;
  String response;

  SignOutResponse({this.status, this.success, this.message, this.response});

  SignOutResponse.fromJson(Map<String, dynamic> json) {
    final commonUtil = CommonUtil();
    status = json[parameters.strStatus];
    success = json[parameters.strSuccess];
    message = json[parameters.strMessage];
    response = commonUtil.checkIfStringIsEmpty(json[parameters.strResponse]);
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data[parameters.strStatus] = status;
    data[parameters.strSuccess] = success;
    data[parameters.strMessage] = message;
    data[parameters.strResponse] = response;
    return data;
  }
}
