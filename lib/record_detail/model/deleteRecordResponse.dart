
import 'package:myfhb/common/CommonUtil.dart';

import '../../constants/fhb_parameters.dart' as parameters;

class DeleteRecordResponse {
  int? status;
  bool? success;
  String? message;

  DeleteRecordResponse({this.status, this.success, this.message});

  DeleteRecordResponse.fromJson(Map<String, dynamic> json) {
    try {
      status = json[parameters.strStatus];
      if (json.containsKey(parameters.strSuccess)) {
            success = json[parameters.strSuccess];
          }
      if (json.containsKey(parameters.strMessage)) {
            message = json[parameters.strMessage];
          }
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data[parameters.strStatus] = status;
    data[parameters.strSuccess] = success;
    data[parameters.strMessage] = message;
    return data;
  }
}
