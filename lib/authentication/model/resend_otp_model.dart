import 'package:myfhb/authentication/constants/constants.dart';

class ResendOtpModel {
  String userName;
  String source;
  String message;
  bool isSuccess;
  ResendOtpModel({this.userName, this.source, this.message, this.isSuccess});

  ResendOtpModel.fromJson(Map<String, dynamic> json) {
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
