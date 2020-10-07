import 'package:myfhb/telehealth/features/MyProvider/model/healthOrganization/HealthOrganizationResult.dart';

class HealthOrganizationModel {
  bool isSuccess;
  List<HealthOrganizationResult> result;

  HealthOrganizationModel({this.isSuccess, this.result});

  HealthOrganizationModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['result'] != null) {
      result = new List<HealthOrganizationResult>();
      json['result'].forEach((v) {
        result.add(new HealthOrganizationResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


