
import 'package:myfhb/common/CommonUtil.dart';

class PlanCode {
  bool? isSuccess;
  List<PlanCodeResult>? result;

  PlanCode({this.isSuccess, this.result});

  PlanCode.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      if (json['result'] != null) {
            result =  <PlanCodeResult>[];
            json['result'].forEach((v) {
              result!.add(PlanCodeResult.fromJson(v));
            });
          }
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PlanCodeResult {
  String? id;
  String? code;
  String? name;

  PlanCodeResult({this.id, this.code, this.name});

  PlanCodeResult.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      code = json['code'];
      name = json['name'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    return data;
  }
}