
import 'package:myfhb/common/CommonUtil.dart';

class CartGenricResponse {
  bool? isSuccess;
  String? message;

  CartGenricResponse({this.isSuccess, this.message});

  CartGenricResponse.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      message = json['message'];
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    return data;
  }
}
