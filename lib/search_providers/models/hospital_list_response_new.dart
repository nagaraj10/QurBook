
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/search_providers/models/doctor_list_response_new.dart';

class HospitalsSearchListResponse {
  bool? isSuccess;
  List<HospitalsListResult>? result;
  Diagnostics? diagnostics;

  HospitalsSearchListResponse({this.isSuccess, this.result,this.diagnostics});

  HospitalsSearchListResponse.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      if (json['result'] != null) {
            result = <HospitalsListResult>[];
            json['result'].forEach((v) {
              result!.add(HospitalsListResult.fromJson(v));
            });
          }
      if (json.containsKey('diagnostics')) {
            diagnostics = json['diagnostics'] != null
                ? Diagnostics.fromJson(json['diagnostics'])
                : null;
          }
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }

  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['isSuccess'] = isSuccess;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    if (diagnostics != null) {
      data['diagnostics'] = diagnostics!.toJson();
    }
    return data;
  }
}

class HospitalsListResult {
  String? healthOrganizationReferenceId;
  String? healthOrganizationName;
  String? name;
  String? addressLine1;
  String? addressLine2;
  String? cityName;
  String? stateName;
  String? pincode;
  String? healthOrganizationId;
  String? healthOrganizationTypeId;
  String? healthOrganizationTypeName;
  String? phoneNumber;
  String? phoneNumberTypeId;
  String? phoneNumberTypeName;
  String? specialization;

  HospitalsListResult({
    this.healthOrganizationReferenceId,
    this.healthOrganizationName,
    this.addressLine1,
    this.addressLine2,
    this.cityName,
    this.stateName,
    this.pincode,
    this.healthOrganizationId,
    this.healthOrganizationTypeId,
    this.healthOrganizationTypeName,
    this.phoneNumber,
    this.phoneNumberTypeId,
    this.phoneNumberTypeName,
    this.name,
    this.specialization,
  });

  HospitalsListResult.fromJson(Map<String, dynamic> json) {
    try {
      healthOrganizationReferenceId = json['healthOrganizationReferenceId'];
      healthOrganizationName = json['healthOrganizationName'];
      try {
            name = json['name'];
          } catch (e,stackTrace) {
                        CommonUtil().appLogs(message: e,stackTrace:stackTrace);

          }
      addressLine1 = json['addressLine1'];
      addressLine2 = json['addressLine2'];
      cityName = json['cityName'];
      stateName = json['stateName'];
      pincode = json['pincode'];
      healthOrganizationId = json['healthOrganizationId'];
      healthOrganizationTypeId = json['healthOrganizationTypeId'];
      healthOrganizationTypeName = json['healthOrganizationTypeName'];
      phoneNumber = json['phoneNumber'];
      phoneNumberTypeId = json['phoneNumberTypeId'];
      phoneNumberTypeName = json['phoneNumberTypeName'];
      specialization = json['specialization'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['healthOrganizationReferenceId'] = healthOrganizationReferenceId;
    data['healthOrganizationName'] = healthOrganizationName;
    data['name'] = name;
    data['addressLine1'] = addressLine1;
    data['addressLine2'] = addressLine2;
    data['cityName'] = cityName;
    data['stateName'] = stateName;
    data['pincode'] = pincode;
    data['healthOrganizationId'] = healthOrganizationId;
    data['healthOrganizationTypeId'] = healthOrganizationTypeId;
    data['healthOrganizationTypeName'] = healthOrganizationTypeName;
    data['phoneNumber'] = phoneNumber;
    data['phoneNumberTypeId'] = phoneNumberTypeId;
    data['phoneNumberTypeName'] = phoneNumberTypeName;
    data['specialization'] = specialization;
    return data;
  }
}
