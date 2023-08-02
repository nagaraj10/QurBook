
// To parse this JSON data, do
//
//     final regimentModel = regimentModelFromJson(jsonString);

import 'dart:convert';
import 'package:myfhb/common/CommonUtil.dart';

import 'regiment_data_model.dart';

List<RegimentDataModel> regimentModelFromJson(String str) =>
    List<RegimentDataModel>.from(
        json.decode(str).map((x) => RegimentDataModel.fromJson(x)));

String regimentModelToJson(List<RegimentDataModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RegimentQurHubResponseModel {
  RegimentQurHubResponseModel({
    this.isSuccess,
    this.result,
  });

  bool? isSuccess;
  Result? result;

  RegimentQurHubResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      result = json['result'] != null ? new Result.fromJson(json['result']) : null;
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  String? date;
  List<RegimentDataModel>? upcomingActivities;

  Result(
      {this.date,
        this.upcomingActivities});

  Result.fromJson(Map<String, dynamic> json) {
    try {
      date = json['date'];

      if (json['upcomingActivities'] != null) {
            upcomingActivities = <RegimentDataModel>[];
            json['upcomingActivities'].forEach((v) {
              upcomingActivities!.add(new RegimentDataModel.fromJson(v));
            });
          }
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    if (this.upcomingActivities != null) {
      data['upcomingActivities'] =
          this.upcomingActivities!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
