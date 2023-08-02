
import 'package:myfhb/common/CommonUtil.dart';

class CreateDeviceSelectionModel {
  bool? isSuccess;
  String? message;
  String? result;

  CreateDeviceSelectionModel({this.isSuccess, this.message, this.result});

  CreateDeviceSelectionModel.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      message = json['message'];
      result = json['result'];
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['isSuccess'] = isSuccess;
    data['message'] = message;
    data['result'] = result;
    return data;
  }
}