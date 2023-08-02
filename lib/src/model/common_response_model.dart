
import 'package:myfhb/common/CommonUtil.dart';

class CommonResponseModel {
  bool? isSuccess;
  String? message;

  CommonResponseModel({this.isSuccess, this.message});

  CommonResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      message = json['message'];
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }


  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['isSuccess'] = isSuccess;
    data['message'] = message;
    return data;
  }
}
