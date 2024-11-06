import 'dart:core';

import 'package:myfhb/common/CommonUtil.dart';

class SOSCallAgentNumberData {
  bool? isSuccess;
  Result? result;

  SOSCallAgentNumberData({this.isSuccess, this.result});

  SOSCallAgentNumberData.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      result =
          json['result'] != null ? Result.fromJson(json['result']) : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    try {
      data['isSuccess'] = this.isSuccess;
      if (this.result != null) {
        data['result'] = this.result!.toJson();
      }
    } catch (e,stackTrace) {
      print(e);
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }

    return data;
  }
}

class Result {
  String? exoPhoneNumber;
  String? verificationPin;

  Result({this.exoPhoneNumber, this.verificationPin});

  Result.fromJson(Map<String, dynamic> json) {
    try {
      exoPhoneNumber = json['exoPhoneNumber'];
      verificationPin = json['verificationPin'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    try {
      data['exoPhoneNumber'] = this.exoPhoneNumber;
      data['verificationPin'] = this.verificationPin;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
    return data;
  }
}
