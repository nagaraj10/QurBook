
import 'package:myfhb/common/CommonUtil.dart';

import '../../constants/fhb_parameters.dart' as parameters;
import 'Data.dart';
import '../../src/model/Health/Laboratory.dart';

class GlobalSearch {
  int? status;
  bool? success;
  String? message;
  Response? response;

  GlobalSearch({this.status, this.success, this.message, this.response});

  GlobalSearch.fromJson(Map<String, dynamic> json) {
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
  List<Data>? data;

  Response({this.count, this.data});

  Response.fromJson(Map<String, dynamic> json) {
    try {
      count = json[parameters.strCount];
      if (json[parameters.strData] != null) {
            data = <Data>[];
            json[parameters.strData].forEach((v) {
              data!.add(Data.fromJson(v));
            });
          }
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data[parameters.strCount] = count;
    if (this.data != null) {
      data[parameters.strData] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}









