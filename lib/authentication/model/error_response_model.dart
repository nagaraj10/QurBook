import '../constants/constants.dart';

class ErrorModelResponse {
  int status;
  bool success;
  String message;

  ErrorModelResponse({this.status, this.success, this.message});

  ErrorModelResponse.fromJson(Map<String, dynamic> json) {
    status = json[strStatus];
    success = json[strIsSuccess];
    message = json[strmessage];
    if (json['diagnostics'] != null) {
      var diagnostics = json['diagnostics'];
      if (diagnostics['message'] != null) {
        message = json['message'];
      }
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[strStatus] = status;
    data[strIsSuccess] = success;
    data[strmessage] = message;
    return data;
  }
}
