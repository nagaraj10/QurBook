import 'package:myfhb/authentication/constants/constants.dart';

class ResendOtpModel {
  String userName;
  String source;
  String userId;
  String message;
  bool isSuccess;
  ResendOtpModel({this.userName, this.source, this.userId, this.message, this.isSuccess});

  ResendOtpModel.fromJson(Map<String, dynamic> json) {
    userName = json[struserName];
    source = json[strsource];
    userId = json[strUserId];
    message = json[strmessage];
    isSuccess = json[strIsSuccess];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[struserName] = this.userName;
    data[strsource] = this.source;
    data[strUserId] = this.userId;
    data[strmessage] = this.message;
    data[strIsSuccess] = this.isSuccess;
    return data;
  }
}
