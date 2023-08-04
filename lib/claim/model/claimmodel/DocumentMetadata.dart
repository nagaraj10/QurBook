import 'package:myfhb/common/CommonUtil.dart';

class DocumentMetadata {
  dynamic billDate;
  dynamic billName;
  dynamic memoText;
  dynamic claimType;
  dynamic claimAmount;
  dynamic healthRecordId;

  DocumentMetadata(
      {this.billDate,
        this.billName,
        this.memoText,
        this.claimType,
        this.claimAmount,
        this.healthRecordId});

  DocumentMetadata.fromJson(Map<String, dynamic> json) {
    try {
      billDate = json['bill_date'];
      billName = json['bill_name'];
      memoText = json['memo_text'];
      claimType = json['claim_type'];
      claimAmount = json['claim_amount'].toString();
      healthRecordId = json['health_record_id'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bill_date'] = this.billDate;
    data['bill_name'] = this.billName;
    data['memo_text'] = this.memoText;
    data['claim_type'] = this.claimType;
    data['claim_amount'] = this.claimAmount;
    data['health_record_id'] = this.healthRecordId;
    return data;
  }
}
