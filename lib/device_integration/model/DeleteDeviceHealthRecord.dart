
import 'package:myfhb/common/CommonUtil.dart';

class DeleteDeviceHealthRecord {
  bool? isSuccess;

  DeleteDeviceHealthRecord({this.isSuccess});

  DeleteDeviceHealthRecord.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['isSuccess'] = isSuccess;
    return data;
  }
}