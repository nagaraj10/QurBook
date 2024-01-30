import 'MembershipAdditionInfo.dart';
import '../../../common/CommonUtil.dart';

class MemberShipResult {
  String? id;
  String? healthOrganizationName;
  String? healthOrganizationId;
  String? planName;
  MemberShipAdditionalInfo? additionalInfo;
  String? planStartDate;
  String? planEndDate;
  String? planSubscriptionInfoId;
  int? planId;
  String? creditAmount;
  int? noOfCarePlans;
  int? noOfDoctorAppointments;
  int? labAppointment;
  int? medicineOrdering;
  int? tranportation;

  MemberShipResult(
      {this.id,
      this.healthOrganizationName,
      this.healthOrganizationId,
      this.planName,
      this.additionalInfo,
      this.planStartDate,
      this.planEndDate,
      this.planSubscriptionInfoId,
      this.planId,
      this.creditAmount,
      this.noOfCarePlans,
      this.noOfDoctorAppointments,
      this.labAppointment,
      this.medicineOrdering,
      this.tranportation});

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
      planId = json['planId'];
      creditAmount = json['creditAmount'];
      noOfCarePlans = json['noOfCarePlans'];
      noOfDoctorAppointments = json['noOfDoctorAppointments'];
      labAppointment = json['labAppointment'];
      medicineOrdering = json['medicineOrdering'];
      tranportation = json['tranportation'];
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
    data['planId'] = planId;
    data['creditAmount'] = creditAmount;
    data['noOfCarePlans'] = noOfCarePlans;
    data['noOfDoctorAppointments'] = noOfDoctorAppointments;
    data['labAppointment'] = labAppointment;
    data['medicineOrdering'] = medicineOrdering;
    data['tranportation'] = tranportation;
    return data;
  }
}
