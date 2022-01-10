class MemberShipAdditionalInfo {
  String remarks;
  String planTags;
  bool isRenewal;
  String paymentId;
  String planEndDate;
  bool isTerminated;
  String planStartDate;
  int packageDuration;
  String terminationDate;
  String prescribedDoctor;
  String planPackageCategoryName;

  MemberShipAdditionalInfo(
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

  MemberShipAdditionalInfo.fromJson(Map<String, dynamic> json) {
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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