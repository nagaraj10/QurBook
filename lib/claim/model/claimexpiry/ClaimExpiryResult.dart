import 'package:myfhb/claim/model/claimexpiry/ClaimExpiryAdditionalInfo.dart';

class ClaimExpiryResult {
  String userId;
  String balanceAmount;
  String balanceDoctorAppointments;
  String balanceDieticianAppointments;
  String balanceCarePlans;
  String balanceDietPlans;
  bool isMembershipUser;
  String membershipId;
  String healthOrganizationId;
  String healthOrganizationName;
  String planName;
  String planStartDate;
  String planEndDate;
  String planSubscriptionInfoId;
  ClaimExpiryAdditionalInfo additionalInfo;
  String membershipStatus;

  ClaimExpiryResult(
      {this.userId,
        this.balanceAmount,
        this.balanceDoctorAppointments,
        this.balanceDieticianAppointments,
        this.balanceCarePlans,
        this.balanceDietPlans,
        this.isMembershipUser,
        this.membershipId,
        this.healthOrganizationId,
        this.healthOrganizationName,
        this.planName,
        this.planStartDate,
        this.planEndDate,
        this.planSubscriptionInfoId,
        this.additionalInfo,
        this.membershipStatus});

  ClaimExpiryResult.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    balanceAmount = json['balanceAmount'];
    balanceDoctorAppointments = json['balanceDoctorAppointments'];
    balanceDieticianAppointments = json['balanceDieticianAppointments'];
    balanceCarePlans = json['balanceCarePlans'];
    balanceDietPlans = json['balanceDietPlans'];
    isMembershipUser = json['isMembershipUser'];
    membershipId = json['membershipId'];
    healthOrganizationId = json['healthOrganizationId'];
    healthOrganizationName = json['healthOrganizationName'];
    planName = json['planName'];
    planStartDate = json['planStartDate'];
    planEndDate = json['planEndDate'];
    planSubscriptionInfoId = json['planSubscriptionInfoId'];
    additionalInfo = json['additionalInfo'] != null ?
    new ClaimExpiryAdditionalInfo.fromJson(json['additionalInfo'])
        : null;
    membershipStatus = json['membershipStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['balanceAmount'] = this.balanceAmount;
    data['balanceDoctorAppointments'] = this.balanceDoctorAppointments;
    data['balanceDieticianAppointments'] = this.balanceDieticianAppointments;
    data['balanceCarePlans'] = this.balanceCarePlans;
    data['balanceDietPlans'] = this.balanceDietPlans;
    data['isMembershipUser'] = this.isMembershipUser;
    data['membershipId'] = this.membershipId;
    data['healthOrganizationId'] = this.healthOrganizationId;
    data['healthOrganizationName'] = this.healthOrganizationName;
    data['planName'] = this.planName;
    data['planStartDate'] = this.planStartDate;
    data['planEndDate'] = this.planEndDate;
    data['planSubscriptionInfoId'] = this.planSubscriptionInfoId;
    if (this.additionalInfo != null) {
      data['additionalInfo'] = this.additionalInfo.toJson();
    }
    data['membershipStatus'] = this.membershipStatus;
    return data;
  }
}
