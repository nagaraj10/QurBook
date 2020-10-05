import 'package:myfhb/authentication/constants/constants.dart';
class ErrorModelResponse {
  int status;
  bool success;
  String message;

  ErrorModelResponse({this.status, this.success, this.message});

  ErrorModelResponse.fromJson(Map<String, dynamic> json) {
    status = json[strStatus];
    success = json[strIsSuccess];
    message = json[strmessage];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[strStatus] = this.status;
    data[strIsSuccess] = this.success;
    data[strmessage] = this.message;
    return data;
  }
}
