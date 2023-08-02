
import 'package:myfhb/common/CommonUtil.dart';

class LabsSearchListResponse {
  bool? isSuccess;
  List<LabListResult>? result;

  LabsSearchListResponse({this.isSuccess, this.result});

  LabsSearchListResponse.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      if (json['result'] != null) {
            result = <LabListResult>[];
            json['result'].forEach((v) {
              result!.add(LabListResult.fromJson(v));
            });
          }
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['isSuccess'] = isSuccess;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LabListResult {
  String? healthOrganizationId;
  String? healthOrganizationName;
  String? healthOrganizationTypeId;
  String? healthOrganizationTypeName;
  String? addressLine1;
  String? addressLine2;
  String? pincode;
  String? cityName;
  String? stateName;
  String? phoneNumber;
  String? phoneNumberTypeId;
  String? phoneNumberTypeName;
  dynamic healthOrganizationReferenceId;

  LabListResult(
      {this.healthOrganizationId,
        this.healthOrganizationName,
        this.healthOrganizationTypeId,
        this.healthOrganizationTypeName,
        this.addressLine1,
        this.addressLine2,
        this.pincode,
        this.cityName,
        this.stateName,
        this.phoneNumber,
        this.phoneNumberTypeId,
        this.phoneNumberTypeName,
        this.healthOrganizationReferenceId});

  LabListResult.fromJson(Map<String, dynamic> json) {
    try {
      healthOrganizationId = json['healthOrganizationId'];
      healthOrganizationName = json['healthOrganizationName'];
      healthOrganizationTypeId = json['healthOrganizationTypeId'];
      healthOrganizationTypeName = json['healthOrganizationTypeName'];
      addressLine1 = json['addressLine1'];
      addressLine2 = json['addressLine2'];
      pincode = json['pincode'];
      cityName = json['cityName'];
      stateName = json['stateName'];
      phoneNumber = json['phoneNumber'];
      phoneNumberTypeId = json['phoneNumberTypeId'];
      phoneNumberTypeName = json['phoneNumberTypeName'];
      healthOrganizationReferenceId = json['healthOrganizationReferenceId'];
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['healthOrganizationId'] = healthOrganizationId;
    data['healthOrganizationName'] = healthOrganizationName;
    data['healthOrganizationTypeId'] = healthOrganizationTypeId;
    data['healthOrganizationTypeName'] = healthOrganizationTypeName;
    data['addressLine1'] = addressLine1;
    data['addressLine2'] = addressLine2;
    data['pincode'] = pincode;
    data['cityName'] = cityName;
    data['stateName'] = stateName;
    data['phoneNumber'] = phoneNumber;
    data['phoneNumberTypeId'] = phoneNumberTypeId;
    data['phoneNumberTypeName'] = phoneNumberTypeName;
    data['healthOrganizationReferenceId'] = healthOrganizationReferenceId;
    return data;
  }
}
