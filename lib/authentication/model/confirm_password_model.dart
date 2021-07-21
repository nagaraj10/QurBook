import '../constants/constants.dart';

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
    final data = Map<String, dynamic>();
    data[strverificationCode] = verificationCode;
    data[struserName] = userName;
    data[strpassword] = password;
    data[strsource] = source;
    data[strmessage] = message;
    data[strIsSuccess] = isSuccess;
    return data;
  }
}
