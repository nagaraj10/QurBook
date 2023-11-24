
import 'package:myfhb/common/CommonUtil.dart';

class AssociateUpdateSuccessResponse {
  bool? isSuccess;
  String? message;
  String? result;

  AssociateUpdateSuccessResponse({this.isSuccess, this.message, this.result});

  AssociateUpdateSuccessResponse.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      message = json['message'];
      result = json['result'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    data['result'] = this.result;
    return data;
  }
}
