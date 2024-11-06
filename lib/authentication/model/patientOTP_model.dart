
import 'package:myfhb/common/CommonUtil.dart';

import '../constants/constants.dart';

class PatientOtpModel {
  String? verificationCode;
  String? source;

  PatientOtpModel(
      {this.verificationCode,
      this.source});

  PatientOtpModel.fromJson(Map<String, dynamic> json) {
    try {
      verificationCode = json[strverificationCode];
      source = json[strsource];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data[strverificationCode] = verificationCode;
    data[strsource] = source;
    return data;
  }
}