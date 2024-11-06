
import 'package:myfhb/common/CommonUtil.dart';

import '../../claim/model/members/MembershipResult.dart';

class MemberShipDetailResponse {
  bool? isSuccess;
  List<MemberShipResult>? result;

  MemberShipDetailResponse({this.isSuccess, this.result});

  MemberShipDetailResponse.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      if (json['result'] != null) {
            result = List<MemberShipResult>.from(json["result"].map((x) => MemberShipResult.fromJson(x)));
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

class Result {
  String? id;
  String? healthOrganizationName;
  String? healthOrganizationId;
  String? planName;
  AdditionalInfo? additionalInfo;
  String? planStartDate;
  String? planEndDate;
  String? planSubscriptionInfoId;

  Result(
      {this.id,
      this.healthOrganizationName,
      this.healthOrganizationId,
      this.planName,
      this.additionalInfo,
      this.planStartDate,
      this.planEndDate,
      this.planSubscriptionInfoId});

  Result.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      healthOrganizationName = json['healthOrganizationName'];
      healthOrganizationId = json['healthOrganizationId'];
      planName = json['planName'];
      additionalInfo = json['additionalInfo'] != null
              ? AdditionalInfo.fromJson(json['additionalInfo'])
              : null;
      planStartDate = json['planStartDate'];
      planEndDate = json['planEndDate'];
      planSubscriptionInfoId = json['planSubscriptionInfoId'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['healthOrganizationName'] = this.healthOrganizationName;
    data['healthOrganizationId'] = this.healthOrganizationId;
    data['planName'] = this.planName;
    if (this.additionalInfo != null) {
      data['additionalInfo'] = this.additionalInfo!.toJson();
    }
    data['planStartDate'] = this.planStartDate;
    data['planEndDate'] = this.planEndDate;
    data['planSubscriptionInfoId'] = this.planSubscriptionInfoId;
    return data;
  }
}

class AdditionalInfo {
  String? remarks;
  String? planTags;
  bool? isRenewal;
  String? paymentId;
  String? planEndDate;
  bool? isTerminated;
  String? planStartDate;
  int? packageDuration;
  String? terminationDate;
  String? prescribedDoctor;
  String? planPackageCategoryName;

  AdditionalInfo(
      {this.remarks,
      this.planTags,
      this.isRenewal,
      this.paymentId,
      this.planEndDate,
      this.isTerminated,
      this.planStartDate,
      this.packageDuration,
      this.terminationDate,
      this.prescribedDoctor,
      this.planPackageCategoryName});

  AdditionalInfo.fromJson(Map<String, dynamic> json) {
    try {
      remarks = json['remarks'];
      planTags = json['planTags'];
      isRenewal = json['isRenewal'];
      paymentId = json['paymentId'];
      planEndDate = json['planEndDate'];
      isTerminated = json['isTerminated'];
      planStartDate = json['planStartDate'];
      packageDuration = json['packageDuration'];
      terminationDate = json['terminationDate'];
      prescribedDoctor = json['prescribedDoctor'];
      planPackageCategoryName = json['planPackageCategoryName'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['remarks'] = this.remarks;
    data['planTags'] = this.planTags;
    data['isRenewal'] = this.isRenewal;
    data['paymentId'] = this.paymentId;
    data['planEndDate'] = this.planEndDate;
    data['isTerminated'] = this.isTerminated;
    data['planStartDate'] = this.planStartDate;
    data['packageDuration'] = this.packageDuration;
    data['terminationDate'] = this.terminationDate;
    data['prescribedDoctor'] = this.prescribedDoctor;
    data['planPackageCategoryName'] = this.planPackageCategoryName;
    return data;
  }
}
