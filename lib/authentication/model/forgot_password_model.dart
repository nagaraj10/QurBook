
import 'package:myfhb/common/CommonUtil.dart';

import '../constants/constants.dart';

class PatientForgotPasswordModel {
  String? userName;
  String? source;
  String? message;
  bool? isSuccess;
  ForgorResult? result;

  PatientForgotPasswordModel(
      {this.userName, this.source, this.message, this.isSuccess});

  PatientForgotPasswordModel.fromJson(Map<String, dynamic> json) {
    try {
      userName = json[struserName];
      source = json[strsource];
      message = json[strmessage];
      isSuccess = json[strIsSuccess];
      result =
              json['result'] != null ? ForgorResult.fromJson(json['result']) : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data[struserName] = userName;
    data[strsource] = source;
    data[strmessage] = message;
    data[strIsSuccess] = isSuccess;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class ForgorResult {
  bool? isVirtualNumber;

  ForgorResult({this.isVirtualNumber});

  ForgorResult.fromJson(Map<String, dynamic> json) {
    try {
      isVirtualNumber =
              json['isVirtualNumber'] != null ? json['isVirtualNumber'] : false;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['isVirtualNumber'] = this.isVirtualNumber;
    return data;
  }
}
