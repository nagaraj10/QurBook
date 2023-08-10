
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/healthOrganization/HealthOrganizationResult.dart';

class HealthOrganizationModel {
  bool? isSuccess;
  List<HealthOrganizationResult>? result;
  String? message;

  HealthOrganizationModel({this.isSuccess, this.result,this.message});

  HealthOrganizationModel.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      message = json['message'];
      if (json['result'] != null) {
            result = <HealthOrganizationResult>[];
            json['result'].forEach((v) {
              result!.add(new HealthOrganizationResult.fromJson(v));
            });
          }
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
