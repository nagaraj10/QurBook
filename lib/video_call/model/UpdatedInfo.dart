
import 'package:myfhb/common/CommonUtil.dart';

class UpdatedInfo {
  String? bookingId;
  String? actualStartDateTime;
  String? actualEndDateTime;

  UpdatedInfo(
      {this.bookingId, this.actualStartDateTime, this.actualEndDateTime});

  UpdatedInfo.fromJson(Map<String, dynamic> json) {
    try {
      bookingId = json['id'];
      actualStartDateTime = json['actualStartDateTime'];
      actualEndDateTime = json['actualEndDateTime'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.bookingId;
    data['actualStartDateTime'] = this.actualStartDateTime;
    data['actualEndDateTime'] = this.actualEndDateTime;
    return data;
  }
}
