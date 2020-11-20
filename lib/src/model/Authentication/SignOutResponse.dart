import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class SignOutResponse {
  int status;
  bool success;
  String message;
  String response;

  SignOutResponse({this.status, this.success, this.message, this.response});

  SignOutResponse.fromJson(Map<String, dynamic> json) {
    CommonUtil commonUtil=new CommonUtil();
     status = json[parameters.strStatus];
    success = json[parameters.strSuccess];
    message = json[parameters.strMessage];
    response = commonUtil.checkIfStringIsEmpty(json[parameters.strResponse] );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strStatus] = this.status;
    data[parameters.strSuccess] = this.success;
    data[parameters.strMessage] = this.message;
    data[parameters.strResponse] = this.response;
    return data;
  }
}