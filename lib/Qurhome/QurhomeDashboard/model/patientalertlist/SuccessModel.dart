import 'package:myfhb/common/CommonUtil.dart';

class SuccessModel {
  bool? isSuccess;
  String? message;

  SuccessModel({this.isSuccess, this.message});

  SuccessModel.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      message = json.containsKey('message') ? (json['message'] ?? "") : "";
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    return data;
  }
}
