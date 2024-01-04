
import 'package:myfhb/common/CommonUtil.dart';

class DelinkCheckResponse {
  bool? isSuccess;
  String? message;

  DelinkCheckResponse({this.isSuccess, this.message});

  DelinkCheckResponse.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      message = json['message'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    return data;
  }
}