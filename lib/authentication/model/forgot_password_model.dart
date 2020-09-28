import 'package:myfhb/authentication/constants/constants.dart';

class PatientForgotPasswordModel {
  String userName;
  String source;
  String message;
  bool isSuccess;

  PatientForgotPasswordModel(
      {this.userName, this.source, this.message, this.isSuccess});

  PatientForgotPasswordModel.fromJson(Map<String, dynamic> json) {
    userName = json[struserName];
    source = json[strsource];
    message = json[strmessage];
    isSuccess = json[strIsSuccess];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[struserName] = this.userName;
    data[strsource] = this.source;
    data[strmessage] = this.message;
    data[strIsSuccess] = this.isSuccess;
    return data;
  }
}
