
import 'package:myfhb/common/CommonUtil.dart';

class AssociateRecordsResponse {
  int? status;
  bool? success;
  String? message;
  Response? response;

  AssociateRecordsResponse(
      {this.status, this.success, this.message, this.response});

  AssociateRecordsResponse.fromJson(Map<String, dynamic> json) {
    try {
      status = json['status'];
      success = json['success'];
      message = json['message'];
      response = json['response'] != null
              ? new Response.fromJson(json['response'])
              : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.response != null) {
      data['response'] = this.response!.toJson();
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
      count = json['count'];
      if (json['data'] != null) {
            data = <Data>[];
            json['data'].forEach((v) {
              data!.add(new Data.fromJson(v));
            });
          }
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? mediaMetaId;
  bool? success;
  AssociateData? data;

  Data({this.mediaMetaId, this.success, this.data});

  Data.fromJson(Map<String, dynamic> json) {
    try {
      mediaMetaId = json['mediaMetaId'];
      success = json['success'];
      data =
              json['data'] != null ? new AssociateData.fromJson(json['data']) : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mediaMetaId'] = this.mediaMetaId;
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class AssociateData {
  String? id;
  bool? isActive;
  String? approvedOn;

  AssociateData({this.id, this.isActive, this.approvedOn});

  AssociateData.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      isActive = json['isActive'];
      approvedOn = json['approvedOn'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['isActive'] = this.isActive;
    data['approvedOn'] = this.approvedOn;
    return data;
  }
}
