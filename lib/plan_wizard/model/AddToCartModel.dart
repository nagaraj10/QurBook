
import 'package:myfhb/common/CommonUtil.dart';

class AddToCartModel {
  bool? isSuccess;
  String? message;
  String? result;

  AddToCartModel({this.isSuccess, this.message, this.result});

  AddToCartModel.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      message = json['message'];
      if(json.containsKey('result'))
          result = json['result'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    data['result'] = this.result;
    return data;
  }
}