
import 'package:myfhb/common/CommonUtil.dart';

import '../../constants/fhb_parameters.dart' as parameters;
import 'Data.dart';

class MetaDataMovedResponse {
  int? status;
  bool? success;
  String? message;
  Response? response;

  MetaDataMovedResponse(
      {this.status, this.success, this.message, this.response});

  MetaDataMovedResponse.fromJson(Map<String, dynamic> json) {
    try {
      status = json[parameters.strStatus];
      success = json[parameters.strSuccess];
      message = json[parameters.strMessage];
      response = json[parameters.strResponse] != null
              ? Response.fromJson(json[parameters.strResponse])
              : null;
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
   data[parameters.strStatus] = status;
    data[parameters.strSuccess] = success;
    data[parameters.strMessage] = message;
    if (response != null) {
      data[parameters.strResponse] = response!.toJson();
    }
    return data;
  }
}

class Response {
  int? count;
  Data? data;

  Response({this.count, this.data});

  Response.fromJson(Map<String, dynamic> json) {
    try {
      count = json[parameters.strCount];
      data = json[parameters.strData] != null ? Data.fromJson(json[parameters.strprofileData]) : null;
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[parameters.strCount] = count;
    if (this.data != null) {
      data[parameters.strData] = this.data!.toJson();
    }
    return data;
  }
}









