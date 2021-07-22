import '../constants/constants.dart';

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
    final data = Map<String, dynamic>();
    data[struserName] = userName;
    data[strsource] = source;
    data[strmessage] = message;
    data[strIsSuccess] = isSuccess;
    return data;
  }
}
