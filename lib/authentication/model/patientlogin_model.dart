import 'package:myfhb/authentication/constants/constants.dart';

class PatientLogIn {
  String userName;
  String password;
  String source;
  String message;
  bool isSuccess;
  DiagnosticsLogin diagnostics;

  PatientLogIn(
      {this.userName,
      this.password,
      this.source,
      this.message,
      this.isSuccess,
      this.diagnostics});

  PatientLogIn.fromJson(Map<String, dynamic> json) {
    userName = json[struserName];
    password = json[strpassword];
    source = json[strsource];
    message = json[strmessage];
    isSuccess = json[strIsSuccess];
    diagnostics = json['diagnostics'] != null
        ? new DiagnosticsLogin.fromJson(json['diagnostics'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[struserName] = this.userName;
    data[strpassword] = this.password;
    data[strsource] = this.source;
    data[strmessage] = this.message;
    data[strIsSuccess] = this.isSuccess;
    if (this.diagnostics != null) {
      data['diagnostics'] = this.diagnostics.toJson();
    }
    return data;
  }
}

class DiagnosticsLogin {
  ErrorDataLogin errorData;
  bool includeErrorDataInResponse;

  DiagnosticsLogin({this.errorData, this.includeErrorDataInResponse});

  DiagnosticsLogin.fromJson(Map<String, dynamic> json) {
    errorData = json['errorData'] != null
        ? new ErrorDataLogin.fromJson(json['errorData'])
        : null;
    includeErrorDataInResponse = json['includeErrorDataInResponse'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.errorData != null) {
      data['errorData'] = this.errorData.toJson();
    }
    data['includeErrorDataInResponse'] = this.includeErrorDataInResponse;
    return data;
  }
}

class ErrorDataLogin {
  String userId;
  String userName;
  String source;

  ErrorDataLogin({this.userId, this.userName, this.source});

  ErrorDataLogin.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userName = json['userName'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['source'] = this.source;
    return data;
  }
}
