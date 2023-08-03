
import 'package:myfhb/common/CommonUtil.dart';

import '../../constants/fhb_parameters.dart' as parameters;

class BookmarkResponse {
  int? status;
  bool? success;
  String? message;

  BookmarkResponse({this.status, this.success, this.message});

  BookmarkResponse.fromJson(Map<String, dynamic> json) {
     try {
       status = json[parameters.strStatus];
       success = json[parameters.strSuccess];
       message = json[parameters.strMessage];
     } catch (e,stackTrace) {
       CommonUtil().appLogs(message: e,stackTrace:stackTrace);
     }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[parameters.strStatus] = status;
    data[parameters.strSuccess] = success;
    data[parameters.strMessage] = message;
    return data;
  }
}
