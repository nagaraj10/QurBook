
import 'package:myfhb/claim/model/claimexpiry/ClaimExpiryResult.dart';
import 'package:myfhb/common/CommonUtil.dart';

class ClaimExpiryResponse {
  bool? isSuccess;
  String? message;
  List<ClaimExpiryResult>? result;

  ClaimExpiryResponse({this.isSuccess, this.result});

  ClaimExpiryResponse.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      if (json.containsKey('message')) {
            message = json['message'];
          }
      if (json.containsKey('result')) {
            if (json['result'] != null) {
              result = <ClaimExpiryResult>[];
              json['result'].forEach((v) {
                result!.add(ClaimExpiryResult.fromJson(v));
              });
            }
          }
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;

    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
