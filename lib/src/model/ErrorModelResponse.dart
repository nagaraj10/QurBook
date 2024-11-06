
import 'package:myfhb/common/CommonUtil.dart';

class ErrorModelResponse {
  int? status;
  bool? success;
  String? message;

  ErrorModelResponse({this.status, this.success, this.message});

  ErrorModelResponse.fromJson(Map<String, dynamic> json) {
    try {
      if (json.containsKey('isSuccess')) {
            success = json['isSuccess'];
          } else {
            success = json['success'];
          }
      status = json['status'];
      message = json['message'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (data.containsKey('isSuccess')) {
      data['isSuccess'] = success;
    } else {
      data['success'] = success;
    }
    data['status'] = status;
    data['message'] = message;

    return data;
  }
}
