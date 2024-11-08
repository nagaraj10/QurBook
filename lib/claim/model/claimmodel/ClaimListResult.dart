
import 'package:myfhb/claim/model/claimmodel/DocumentMetadata.dart';
import 'package:myfhb/claim/model/claimmodel/Status.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/model/user/MyProfileResult.dart';

class ClaimListResult {
  String? id;
  String? planName;
  String? claimNumber;
  String? claimAmountTotal;
  List<DocumentMetadata>? documentMetadata;
  String? remark;
  String? approvedAmount;
  String? settlementReference;
  bool? isActive;
  String? createdOn;
  String? lastModifiedOn;
  Status? status;
  MyProfileResult? submittedBy;
  MyProfileResult? submittedFor;



  ClaimListResult(
      {this.id,this.planName,
        this.claimNumber,
        this.claimAmountTotal,
        this.documentMetadata,
        this.remark,
        this.approvedAmount,
        this.settlementReference,
        this.isActive,
        this.createdOn,
        this.lastModifiedOn,
        this.status,this.submittedBy,
        this.submittedFor,});

  ClaimListResult.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      if(json.containsKey('planName'))
            planName = json['planName'];
      claimNumber = json['claimNumber'];
      claimAmountTotal = json['claimAmountTotal'];
      if (json['documentMetadata'] != null) {
            documentMetadata = <DocumentMetadata>[];
            json['documentMetadata'].forEach((v) {
              documentMetadata!.add(DocumentMetadata.fromJson(v));
            });
          }
      remark = json['remark'];
      approvedAmount = json['approvedAmount'];
      settlementReference = json['settlementReference'];
      isActive = json['isActive'];
      createdOn = json['createdOn'];
      lastModifiedOn = json['lastModifiedOn'];
      status =
          json['status'] != null ? Status.fromJson(json['status']) : null;
      submittedBy = json['submittedBy'] != null
              ? MyProfileResult.fromJson(json['submittedBy'])
              : null;
      submittedFor = json['submittedFor'] != null
              ? MyProfileResult.fromJson(json['submittedFor'])
              : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['planName'] = this.planName;
    data['claimNumber'] = this.claimNumber;
    data['claimAmountTotal'] = this.claimAmountTotal;
    if (this.documentMetadata != null) {
      data['documentMetadata'] =
          this.documentMetadata!.map((v) => v.toJson()).toList();
    }
    data['remark'] = this.remark;
    data['approvedAmount'] = this.approvedAmount;
    data['settlementReference'] = this.settlementReference;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    if (this.status != null) {
      data['status'] = this.status!.toJson();
    }
    if (this.submittedBy != null) {
      data['submittedBy'] = this.submittedBy!.toJson();
    }
    if (this.submittedFor != null) {
      data['submittedFor'] = this.submittedFor!.toJson();
    }
    return data;
  }
}
