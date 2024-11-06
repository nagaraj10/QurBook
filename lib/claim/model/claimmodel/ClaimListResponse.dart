
import 'package:myfhb/claim/model/claimmodel/ClaimListResult.dart';
import 'package:myfhb/common/CommonUtil.dart';

class ClaimListResponse {
  bool? isSuccess;
  String? message;
  List<ClaimListResult>? result;

  ClaimListResponse({this.isSuccess, this.result});

  ClaimListResponse.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      if(json.containsKey('message')){
            message = json['message'];

          }
      if(json.containsKey('result')) {
            if (json['result'] != null) {
              result = <ClaimListResult>[];
              json['result'].forEach((v) {
                result!.add(ClaimListResult.fromJson(v));
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



