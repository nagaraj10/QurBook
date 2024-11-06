
import 'package:myfhb/common/CommonUtil.dart';

import '../../constants/fhb_parameters.dart' as parameters;
import 'FamilyData.dart';

class FamilyMembersList {
  int? status;
  bool? success;
  String? message;
  Response? response;

  FamilyMembersList({this.status, this.success, this.message, this.response});

  FamilyMembersList.fromJson(Map<String, dynamic> json) {
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
  FamilyData? data;

  Response({this.data});

  Response.fromJson(Map<String, dynamic> json) {
    try {
      data = json[parameters.strData] != null ? FamilyData.fromJson(json[parameters.strData]) : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (this.data != null) {
      data[parameters.strData] = this.data!.toJson();
    }
    return data;
  }
}

