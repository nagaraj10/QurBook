import '../constants/constants.dart';

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
        ? DiagnosticsLogin.fromJson(json['diagnostics'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data[struserName] = userName;
    data[strpassword] = password;
    data[strsource] = source;
    data[strmessage] = message;
    data[strIsSuccess] = isSuccess;
    if (diagnostics != null) {
      data['diagnostics'] = diagnostics.toJson();
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
        ? ErrorDataLogin.fromJson(json['errorData'])
        : null;
    includeErrorDataInResponse = json['includeErrorDataInResponse'];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    if (errorData != null) {
      data['errorData'] = errorData.toJson();
    }
    data['includeErrorDataInResponse'] = includeErrorDataInResponse;
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
    final data = <String, dynamic>{};
    data['userId'] = userId;
    data['userName'] = userName;
    data['source'] = source;
    return data;
  }
}
