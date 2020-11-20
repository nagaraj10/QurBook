import 'package:myfhb/authentication/constants/constants.dart';

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[strNewPassword] = this.newPassword;
    data[strOldPassword] = this.oldPassword;
    data[strsource] = this.source;
    data[strmessage] = this.message;
    data[strIsSuccess] = this.isSuccess;
    return data;
  }
}
