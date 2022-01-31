class ClaimExpiryAdditionalInfo {
  String remarks;
  String planTags;
  int actualFee;
  bool isRenewal;
  String paymentId;
  String planEndDate;
  bool isTerminated;
  String planStartDate;
  int packageDuration;
  String terminationDate;
  String prescribedDoctor;
  String planPackageCategoryName;

  ClaimExpiryAdditionalInfo(
      {this.remarks,
        this.planTags,
        this.actualFee,
        this.isRenewal,
        this.paymentId,
        this.planEndDate,
        this.isTerminated,
        this.planStartDate,
        this.packageDuration,
        this.terminationDate,
        this.prescribedDoctor,
        this.planPackageCategoryName});

  ClaimExpiryAdditionalInfo.fromJson(Map<String, dynamic> json) {
    remarks = json['remarks'];
    planTags = json['planTags'];
    actualFee = json['actualFee'];
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
    data['actualFee'] = this.actualFee;
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