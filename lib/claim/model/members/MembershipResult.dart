
import 'package:myfhb/claim/model/members/MembershipAdditionInfo.dart';
import 'package:myfhb/common/CommonUtil.dart';

class MemberShipResult {
  String? id;
  String? healthOrganizationName;
  String? healthOrganizationId;
  String? planName;
  MemberShipAdditionalInfo? additionalInfo;
  String? planStartDate;
  String? planEndDate;
  String? planSubscriptionInfoId;

  MemberShipResult(
      {this.id,
        this.healthOrganizationName,
        this.healthOrganizationId,
        this.planName,
        this.additionalInfo,
        this.planStartDate,
        this.planEndDate,
        this.planSubscriptionInfoId});

  MemberShipResult.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      healthOrganizationName = json['healthOrganizationName'];
      healthOrganizationId = json['healthOrganizationId'];
      planName = json['planName'];
      additionalInfo = json['additionalInfo'] != null
              ? MemberShipAdditionalInfo.fromJson(json['additionalInfo'])
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
