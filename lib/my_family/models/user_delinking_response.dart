
import 'package:myfhb/common/CommonUtil.dart';

import '../../constants/fhb_parameters.dart' as parameters;

class UserDeLinkingResponseList {
  //int status;
  bool? isSuccess;
  String? message;

  UserDeLinkingResponseList({/* this.status, */ this.isSuccess, this.message});

  UserDeLinkingResponseList.fromJson(Map<String, dynamic> json) {
    // status = json[parameters.strStatus];
    try {
      isSuccess = json[parameters.strSuccess];
      message = json[parameters.strMessage];
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }
}
