
import 'package:myfhb/common/CommonUtil.dart';

import '../../constants/fhb_parameters.dart' as parameters;
class UserLinkingResponseList {
  int? status;
  bool? success;
  String? message;

  UserLinkingResponseList({this.status, this.success, this.message});

  UserLinkingResponseList.fromJson(Map<String, dynamic> json) {
    try {
      status = json[parameters.strStatus];
      success = json[parameters.strSuccess];
      message = json[parameters.strMessage];
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }
}
