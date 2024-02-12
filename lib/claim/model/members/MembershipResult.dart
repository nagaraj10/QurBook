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
  /// New Parameters added for Membership Benefits
  int? planId;
  String? creditAmount;
  int? noOfCarePlans;
  dynamic noOfDoctorAppointments;//Added dynamic because value may be possiblities to come as double and string or int
  int? labAppointment;
  int? medicineOrdering;
  int? tranportation;
  int? homecareServices;

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
      this.tranportation,
      this.homecareServices});

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
      noOfCarePlans = json['noOfCarePlans'] != null
          ? int.parse(json['noOfCarePlans'])
          : null; // Parsing to int or null if it's null
      noOfDoctorAppointments = json['noOfDoctorAppointments'];
      labAppointment = json['labAppointment'] != null
          ? int.parse(json['labAppointment'])
          : null; // Parsing to int or null if it's null
      medicineOrdering = json['medicineOrdering'] != null
          ? int.parse(json['medicineOrdering'])
          : null;
      tranportation = json['tranportation'] != null
          ? int.parse(json['tranportation'])
          : null; // Parsing to int or null if it's null
      homecareServices = json['homecareServices'] != null
          ? int.parse(json['homecareServices'])
          : null; // Parsing to int or null if it's null
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
    data['homecareServices'] = homecareServices;
    return data;
  }
}
