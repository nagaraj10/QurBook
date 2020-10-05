import 'package:myfhb/authentication/constants/constants.dart';

class PatientConfirmPasswordModel {
  String verificationCode;
  String userName;
  String password;
  String source;
  String message;
  bool isSuccess;

  PatientConfirmPasswordModel(
      {this.verificationCode,
      this.userName,
      this.password,
      this.source,
      this.message,
      this.isSuccess});

  PatientConfirmPasswordModel.fromJson(Map<String, dynamic> json) {
    verificationCode = json[strverificationCode];
    userName = json[struserName];
    password = json[strpassword];
    source = json[strsource];
    message = json[strmessage];
    isSuccess = json[strIsSuccess];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[strverificationCode] = this.verificationCode;
    data[struserName] = this.userName;
    data[strpassword] = this.password;
    data[strsource] = this.source;
    data[strmessage] = this.message;
    data[strIsSuccess] = this.isSuccess;
    return data;
  }
}
