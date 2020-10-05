import 'package:myfhb/authentication/constants/constants.dart';

class PatientLogIn {
  String userName;
  String password;
  String source;
  String message;
  bool isSuccess;

  PatientLogIn(
      {this.userName,
      this.password,
      this.source,
      this.message,
      this.isSuccess});

  PatientLogIn.fromJson(Map<String, dynamic> json) {
    userName = json[struserName];
    password = json[strpassword];
    source = json[strsource];
    message = json[strmessage];
    isSuccess = json[strIsSuccess];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[struserName] = this.userName;
    data[strpassword] = this.password;
    data[strsource] = this.source;
    data[strmessage] = this.message;
    data[strIsSuccess] = this.isSuccess;
    return data;
  }
}
