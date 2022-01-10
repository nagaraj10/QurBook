class CreditBalanceResult {
  String userId;
  String balanceAmount;
  String balanceDoctorAppointments;
  String balanceDieticianAppointments;
  String balanceCarePlans;
  String balanceDietPlans;
  bool isMembershipUser;

  CreditBalanceResult(
      {this.userId,
        this.balanceAmount,
        this.balanceDoctorAppointments,
        this.balanceDieticianAppointments,
        this.balanceCarePlans,
        this.balanceDietPlans,
        this.isMembershipUser});

  CreditBalanceResult.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    balanceAmount = json['balanceAmount'];
    balanceDoctorAppointments = json['balanceDoctorAppointments'];
    balanceDieticianAppointments = json['balanceDieticianAppointments'];
    balanceCarePlans = json['balanceCarePlans'];
    balanceDietPlans = json['balanceDietPlans'];
    isMembershipUser = json['isMembershipUser'];
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
    return data;
  }
}