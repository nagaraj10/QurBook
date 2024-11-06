
import 'package:myfhb/common/CommonUtil.dart';

class AddProviderPlanResponse {
  bool? isSuccess;
  List<AddProviderPlanResponseResult>? result;

  AddProviderPlanResponse({this.isSuccess, this.result});

  AddProviderPlanResponse.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      if (json['result'] != null) {
            result =  <AddProviderPlanResponseResult>[];
            json['result'].forEach((v) {
              result!.add(AddProviderPlanResponseResult.fromJson(v));
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

class AddProviderPlanResponseResult {
  String? providerType;
  CreatedBy? createdBy;
  String? createdOn;
  bool? isDefault;
  bool? isInvite;
  dynamic doctor;
  CreatedBy? healthOrganization;
  CreatedBy? patient;
  String? startDate;
  String? endDate;
  String? lastModifiedOn;
  String? id;
  bool? isActive;

  AddProviderPlanResponseResult(
      {this.providerType,
        this.createdBy,
        this.createdOn,
        this.isDefault,
        this.isInvite,
        this.doctor,
        this.healthOrganization,
        this.patient,
        this.startDate,
        this.endDate,
        this.lastModifiedOn,
        this.id,
        this.isActive});

  AddProviderPlanResponseResult.fromJson(Map<String, dynamic> json) {
    try {
      providerType = json['providerType'];
      createdBy = json['createdBy'] != null
              ? CreatedBy.fromJson(json['createdBy'])
              : null;
      createdOn = json['createdOn'];
      isDefault = json['isDefault'];
      isInvite = json['isInvite'];
      doctor = json['doctor'];
      healthOrganization = json['healthOrganization'] != null
              ? CreatedBy.fromJson(json['healthOrganization'])
              : null;
      patient = json['patient'] != null
              ? CreatedBy.fromJson(json['patient'])
              : null;
      startDate = json['startDate'];
      endDate = json['endDate'];
      lastModifiedOn = json['lastModifiedOn'];
      id = json['id'];
      isActive = json['isActive'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['providerType'] = this.providerType;
    if (this.createdBy != null) {
      data['createdBy'] = this.createdBy!.toJson();
    }
    data['createdOn'] = this.createdOn;
    data['isDefault'] = this.isDefault;
    data['isInvite'] = this.isInvite;
    data['doctor'] = this.doctor;
    if (this.healthOrganization != null) {
      data['healthOrganization'] = this.healthOrganization!.toJson();
    }
    if (this.patient != null) {
      data['patient'] = this.patient!.toJson();
    }
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['lastModifiedOn'] = this.lastModifiedOn;
    data['id'] = this.id;
    data['isActive'] = this.isActive;
    return data;
  }
}

class CreatedBy {
  String? id;

  CreatedBy({this.id});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}
