

import 'package:myfhb/common/CommonUtil.dart';

class ImageDocumentResponse {
  int? status;
  bool? success;
  String? message;
  Response? response;

  ImageDocumentResponse(
      {this.status, this.success, this.message, this.response});

  ImageDocumentResponse.fromJson(Map<String, dynamic> json) {
    try {
      status = json['status'];
      success = json['success'];
      message = json['message'];
      response = json['response'] != null
              ? Response.fromJson(json['response'])
              : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['success'] = success;
    data['message'] = message;
    if (response != null) {
      data['response'] = response!.toJson();
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
      count = json['count'];
      data = json['data'] != null ? Data.fromJson(json['data']) : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['count'] = count;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? fileContent;
  String? fileType;

  Data({this.fileContent, this.fileType});

  Data.fromJson(Map<String, dynamic> json) {
    try {
      fileContent = json['fileContent'];
      fileType = json['fileType'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['fileContent'] = fileContent;
    data['fileType'] = fileType;
    return data;
  }
}

