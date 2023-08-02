import 'package:myfhb/common/CommonUtil.dart';

class SuccessModel {
  bool? isSuccess;

  SuccessModel({this.isSuccess});

  SuccessModel.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    return data;
  }
}
