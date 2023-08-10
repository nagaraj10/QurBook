import 'package:myfhb/common/CommonUtil.dart';

class SuccessModel {
  bool? isSuccess;

  SuccessModel({this.isSuccess});

  SuccessModel.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    return data;
  }
}
