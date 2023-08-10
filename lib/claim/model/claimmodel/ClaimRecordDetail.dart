
import 'package:myfhb/claim/model/claimmodel/ClaimRecordDetailResult.dart';
import 'package:myfhb/claim/model/claimmodel/DocumentMetadata.dart';
import 'package:myfhb/common/CommonUtil.dart';

class ClaimRecordDetails {
  bool? isSuccess;
  ClaimRecordDetailsResult? result;

  ClaimRecordDetails({this.isSuccess, this.result});

  ClaimRecordDetails.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      result =
          json['result'] != null ? new ClaimRecordDetailsResult.fromJson(json['result']) : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}


