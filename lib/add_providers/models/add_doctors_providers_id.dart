
import 'package:myfhb/common/CommonUtil.dart';

import 'add_more_data.dart';
import '../../constants/fhb_parameters.dart' as parameters;
class AddDoctorsProvidersId {
  int? status;
  bool? success;
  String? message;
  Response? response;

  AddDoctorsProvidersId(
      {this.status, this.success, this.message, this.response});

  AddDoctorsProvidersId.fromJson(Map<String, dynamic> json) {
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
}

class Response {
  int? count;
  AddMoreData? data;

  Response({this.count, this.data});

  Response.fromJson(Map<String, dynamic> json) {
    try {
      count = json[parameters.strCount];

      Map<String, dynamic>? dic;
      if (json[parameters.strData] != null) {
            dic = json[parameters.strData];
            data = AddMoreData.fromJson(dic!);
          }
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }
}

