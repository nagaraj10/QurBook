import '../constants/constants.dart';

class PatientSignupOtp {
  String verificationCode;
  String userName;
  String source;
  String userId;
  String message;
  bool isSuccess;

  PatientSignupOtp(
      {this.verificationCode,
      this.userName,
      this.source,
        this.userId,
      this.message,
      this.isSuccess});

  PatientSignupOtp.fromJson(Map<String, dynamic> json) {
    verificationCode = json[strverificationCode];
    userName = json[struserName];
    source = json[strsource];
    userId = json[strUserId];
    message = json[strmessage];
    isSuccess = json[strIsSuccess];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data[strverificationCode] = verificationCode;
    data[struserName] = userName;
    data[strsource] = source;
    data[strUserId] = userId;
    data[strmessage] = message;
    data[strIsSuccess] = isSuccess;
    return data;
  }
}
