import '../constants/constants.dart';

class PatientForgotPasswordModel {
  String userName;
  String source;
  String message;
  bool isSuccess;
  ForgorResult result;

  PatientForgotPasswordModel(
      {this.userName, this.source, this.message, this.isSuccess});

  PatientForgotPasswordModel.fromJson(Map<String, dynamic> json) {
    userName = json[struserName];
    source = json[strsource];
    message = json[strmessage];
    isSuccess = json[strIsSuccess];
    result =
        json['result'] != null ? new ForgorResult.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data[struserName] = userName;
    data[strsource] = source;
    data[strmessage] = message;
    data[strIsSuccess] = isSuccess;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class ForgorResult {
  bool isVirtualNumber;

  ForgorResult({this.isVirtualNumber});

  ForgorResult.fromJson(Map<String, dynamic> json) {
    isVirtualNumber =
        json['isVirtualNumber'] != null ? json['isVirtualNumber'] : false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isVirtualNumber'] = this.isVirtualNumber;
    return data;
  }
}
