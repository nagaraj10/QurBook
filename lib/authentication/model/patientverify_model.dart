import 'package:myfhb/authentication/constants/constants.dart';

class PatientSignupOtp {
  String verificationCode;
  String userName;
  String source;
  String message;
  bool isSuccess;

  PatientSignupOtp(
      {this.verificationCode,
      this.userName,
      this.source,
      this.message,
      this.isSuccess});

  PatientSignupOtp.fromJson(Map<String, dynamic> json) {
    verificationCode = json[strverificationCode];
    userName = json[struserName];
    source = json[strsource];
    message = json[strmessage];
    isSuccess = json[strIsSuccess];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[strverificationCode] = this.verificationCode;
    data[struserName] = this.userName;
    data[strsource] = this.source;
    data[strmessage] = this.message;
    data[strIsSuccess] = this.isSuccess;
    return data;
  }
}
