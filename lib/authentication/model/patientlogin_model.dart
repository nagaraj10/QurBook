
import 'package:myfhb/common/CommonUtil.dart';

import '../constants/constants.dart';

class PatientLogIn {
  String? userName;
  String? password;
  String? source;
  String? message;
  bool? isSuccess;
  DiagnosticsLogin? diagnostics;

  PatientLogIn(
      {this.userName,
      this.password,
      this.source,
      this.message,
      this.isSuccess,
      this.diagnostics});

  PatientLogIn.fromJson(Map<String, dynamic> json) {
    try {
      userName = json[struserName];
      password = json[strpassword];
      source = json[strsource];
      message = json[strmessage];
      isSuccess = json[strIsSuccess];
      diagnostics = json['diagnostics'] != null
              ? DiagnosticsLogin.fromJson(json['diagnostics'])
              : null;
    } catch (e,stackTrace) {
      CommonUtil()
          .appLogs(message: e,stackTrace:stackTrace, userName: (json[struserName] ?? ""));
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data[struserName] = userName;
    data[strpassword] = password;
    data[strsource] = source;
    data[strmessage] = message;
    data[strIsSuccess] = isSuccess;
    if (diagnostics != null) {
      data['diagnostics'] = diagnostics!.toJson();
    }
    return data;
  }
}

class DiagnosticsLogin {
  ErrorDataLogin? errorData;
  bool? includeErrorDataInResponse;

  DiagnosticsLogin({this.errorData, this.includeErrorDataInResponse});

  DiagnosticsLogin.fromJson(Map<String, dynamic> json) {
    try {
      errorData = json['errorData'] != null
              ? ErrorDataLogin.fromJson(json['errorData'])
              : null;
      includeErrorDataInResponse = json['includeErrorDataInResponse'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    if (errorData != null) {
      data['errorData'] = errorData!.toJson();
    }
    data['includeErrorDataInResponse'] = includeErrorDataInResponse;
    return data;
  }
}

class ErrorDataLogin {
  String? userId;
  String? userName;
  String? source;

  ErrorDataLogin({this.userId, this.userName, this.source});

  ErrorDataLogin.fromJson(Map<String, dynamic> json) {
    try {
      userId = json['userId'];
      userName = json['userName'];
      source = json['source'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userId'] = userId;
    data['userName'] = userName;
    data['source'] = source;
    return data;
  }
}

class SignInValidationModel {
  bool? isSuccess;
  Result? result;

  SignInValidationModel({this.isSuccess, this.result});

  SignInValidationModel.fromJson(Map<String, dynamic> json,String userName) {
    try {
      isSuccess = json['isSuccess'];
      result =
          json['result'] != null ? Result.fromJson(json['result'],userName) : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(
          message: e, stackTrace: stackTrace, userName: (userName ?? ""));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  bool? isRegistered;
  String? firstName;
  String? lastName;
  String? providerName;

  Result({this.isRegistered, this.firstName, this.lastName, this.providerName });

  Result.fromJson(Map<String, dynamic> json,String userName) {
    try {
      isRegistered = json['isRegistered'];
      firstName = json['firstName'];
      lastName = json['lastName'];
      providerName = json['providerName'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(
          message: e, stackTrace: stackTrace, userName: (userName ?? ""));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['isRegistered'] = this.isRegistered;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['providerName'] = this.providerName;
    return data;
  }
}

