
import 'package:myfhb/common/CommonUtil.dart';

class CityListModel {
  int? status;
  bool? success;
  String? message;
  Response? response;

  CityListModel({this.status, this.success, this.message, this.response});

  CityListModel.fromJson(Map<String, dynamic> json) {
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
  List<CityData>? data;

  Response({this.count, this.data});

  Response.fromJson(Map<String, dynamic> json) {
    try {
      count = json['count'];
      if (json['data'] != null) {
            data = <CityData>[];
            json['data'].forEach((v) {
              data!.add(CityData.fromJson(v));
            });
          }
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['count'] = count;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CityData {
  String? id;
  String? name;

  CityData({this.id, this.name});

  CityData.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      name = json['name'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}