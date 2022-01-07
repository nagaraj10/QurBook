import 'package:myfhb/claim/model/claimmodel/DocumentMetadata.dart';

class ClaimRecordDetailsResult {
  dynamic claimId;
  dynamic claimNumber;
  dynamic submitDate;
  List<DocumentMetadata> documentMetadata;
  dynamic submittedBy;
  dynamic submittedByFirstName;
  dynamic submittedByMiddleName;
  dynamic submittedByLastName;
  dynamic submittedFor;
  dynamic submittedForFirstName;
  dynamic submittedForMiddleName;
  dynamic submittedForLastName;
  bool isSignedIn;
  dynamic healthOrganizationId;
  dynamic phoneNumber;
  dynamic status;
  dynamic statusCode;
  dynamic healthOrganizationName;
  dynamic remark;
  dynamic planName;
  dynamic planDescription;

  ClaimRecordDetailsResult(
      {this.claimId,
        this.claimNumber,
        this.submitDate,
        this.documentMetadata,
        this.submittedBy,
        this.submittedByFirstName,
        this.submittedByMiddleName,
        this.submittedByLastName,
        this.submittedFor,
        this.submittedForFirstName,
        this.submittedForMiddleName,
        this.submittedForLastName,
        this.isSignedIn,
        this.healthOrganizationId,
        this.phoneNumber,
        this.status,
        this.statusCode,
        this.healthOrganizationName,
        this.remark,this.planName,this.planDescription});

  ClaimRecordDetailsResult.fromJson(Map<dynamic, dynamic> json) {
    claimId = json['claimId'];
    claimNumber = json['claimNumber'];
    submitDate = json['submitDate'];
    if (json['documentMetadata'] != null) {
      documentMetadata = <DocumentMetadata>[];
      json['documentMetadata'].forEach((v) {
        documentMetadata.add(new DocumentMetadata.fromJson(v));
      });
    }
    submittedBy = json['submittedBy'];
    submittedByFirstName = json['submittedByFirstName'];
    submittedByMiddleName = json['submittedByMiddleName'];
    submittedByLastName = json['submittedByLastName'];
    submittedFor = json['submittedFor'];
    submittedForFirstName = json['submittedForFirstName'];
    submittedForMiddleName = json['submittedForMiddleName'];
    submittedForLastName = json['submittedForLastName'];
    isSignedIn = json['isSignedIn'];
    healthOrganizationId = json['healthOrganizationId'];
    phoneNumber = json['phoneNumber'];
    status = json['status'];
    statusCode = json['statusCode'];
    healthOrganizationName = json['healthOrganizationName'];
    remark = json['remark'];
    planName = json['planName'];
    planDescription = json['planDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['claimId'] = this.claimId;
    data['claimNumber'] = this.claimNumber;
    data['submitDate'] = this.submitDate;
    if (this.documentMetadata != null) {
      data['documentMetadata'] =
          this.documentMetadata.map((v) => v.toJson()).toList();
    }
    data['submittedBy'] = this.submittedBy;
    data['submittedByFirstName'] = this.submittedByFirstName;
    data['submittedByMiddleName'] = this.submittedByMiddleName;
    data['submittedByLastName'] = this.submittedByLastName;
    data['submittedFor'] = this.submittedFor;
    data['submittedForFirstName'] = this.submittedForFirstName;
    data['submittedForMiddleName'] = this.submittedForMiddleName;
    data['submittedForLastName'] = this.submittedForLastName;
    data['isSignedIn'] = this.isSignedIn;
    data['healthOrganizationId'] = this.healthOrganizationId;
    data['phoneNumber'] = this.phoneNumber;
    data['status'] = this.status;
    data['statusCode'] = this.statusCode;
    data['healthOrganizationName'] = this.healthOrganizationName;
    data['remark'] = this.remark;
    data['planName'] = this.planName;
    data['planDescription'] = this.planDescription;
    return data;
  }
}
