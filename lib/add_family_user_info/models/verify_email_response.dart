
import 'package:myfhb/common/CommonUtil.dart';

import '../../constants/fhb_parameters.dart' as parameters;

class VerifyEmailResponse {
  int? status;
  bool? success;
  String? message;
  Response? response;

  VerifyEmailResponse({this.status, this.success, this.message, this.response});

  VerifyEmailResponse.fromJson(Map<String, dynamic> json) {
    try {
      status = json[parameters.strStatus];
      success = json[parameters.strSuccess];
      message = json[parameters.strMessage];
      response = json[parameters.strResponse] != null
              ? Response.fromJson(json[parameters.strResponse])
              : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[parameters.strStatus] = status;
    data[parameters.strSuccess] = success;
    data[parameters.strMessage] = message;
    if (response != null) {
      data[parameters.strResponse] = response!.toJson();
    }
    return data;
  }
}

class Response {
  String? creationTime;
  String? expirationTime;

  Response({this.creationTime, this.expirationTime});

  Response.fromJson(Map<String, dynamic> json) {
    try {
      creationTime = json[parameters.strCreationTime];
      expirationTime = json[parameters.strExpirationTime];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data[parameters.strCreationTime] = creationTime;
    data[parameters.strExpirationTime] = expirationTime;
    return data;
  }
}