
import 'package:myfhb/common/CommonUtil.dart';

class VerifyOTPModel {
  String? verificationCode;
  String? phoneNumber;

  VerifyOTPModel({this.verificationCode, this.phoneNumber});

  VerifyOTPModel.fromJson(Map<String, dynamic> json) {
    try {
      verificationCode = json['verificationCode'];
      phoneNumber = json['phoneNumber'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['verificationCode'] = verificationCode;
    data['phoneNumber'] = phoneNumber;
    return data;
  }
}
