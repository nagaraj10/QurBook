import '../constants/constants.dart';

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
    final data = <String, dynamic>{};
    data[struserName] = userName;
    data[strsource] = source;
    data[strUserId] = userId;
    data[strmessage] = message;
    data[strIsSuccess] = isSuccess;
    return data;
  }
}
