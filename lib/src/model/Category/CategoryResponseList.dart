
import 'package:myfhb/common/CommonUtil.dart';

import 'CategoryData.dart';
import '../../../constants/fhb_parameters.dart' as parameters;

class CategoryResponseList {
  int? status;
  bool? success;
  String? message;
  Response? response;

  CategoryResponseList(
      {this.status, this.success, this.message, this.response});

  CategoryResponseList.fromJson(Map<String, dynamic> json) {
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
    final data = <String, dynamic>{};
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
  List<CategoryData>? data;

  Response({this.count, this.data});

  Response.fromJson(Map<String, dynamic> json) {
    try {
      count = json[parameters.strCount];
      if (json[parameters.strData] != null) {
            data = <CategoryData>[];
            json[parameters.strData].forEach((v) {
              data!.add(CategoryData.fromJson(v));
            });
          }
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
     data[parameters.strCount] = count;
    if (this.data != null) {
      data[parameters.strData] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

