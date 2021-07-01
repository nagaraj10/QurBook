import '../constants/constants.dart';

class ChangePasswordModel {
  String newPassword;
  String oldPassword;
  String source;
  String message;
  bool isSuccess;

  ChangePasswordModel(
      {this.newPassword,
      this.oldPassword,
      this.source,
      this.message,
      this.isSuccess});

  ChangePasswordModel.fromJson(Map<String, dynamic> json) {
    newPassword = json[strNewPassword];
    oldPassword = json[strOldPassword];
    source = json[strsource];
    message = json[strmessage];
    isSuccess = json[strIsSuccess];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data[strNewPassword] = newPassword;
    data[strOldPassword] = oldPassword;
    data[strsource] = source;
    data[strmessage] = message;
    data[strIsSuccess] = isSuccess;
    return data;
  }
}
