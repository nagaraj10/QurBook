import '../../../common/CommonUtil.dart';
import 'MemberShipAdditionalInfoBenefitType.dart';

class MemberShipAdditionalInfo {
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
  /// Add New Parameter for MemberShip Benefit.
  List<MemberShipAdditionalInfoBenefitType>? benefitType;

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
      this.planPackageCategoryName,
      this.benefitType});

  MemberShipAdditionalInfo.fromJson(Map<String, dynamic> json) {
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
      benefitType = json['benefitType'] == null
          ? []
          : List<MemberShipAdditionalInfoBenefitType>.from(json['benefitType']!
              .map((x) => MemberShipAdditionalInfoBenefitType.fromJson(x)));
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
    data['benefitType'] = benefitType == null
        ? []
        : List<dynamic>.from(benefitType!.map((x) => x.toJson()));
    return data;
  }
}