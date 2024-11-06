
import 'package:myfhb/common/CommonUtil.dart';

class Slots {
  String? startTime;
  String? endTime;
  String? isAvailable;
  int? slotNumber;

  Slots({this.startTime, this.endTime, this.isAvailable, this.slotNumber});

  Slots.fromJson(Map<String, dynamic> json) {
    try {
      startTime = json['startTime'];
      endTime = json['endTime'];
      isAvailable = json['isAvailable'];
      slotNumber = json['slotNumber'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['isAvailable'] = this.isAvailable;
    data['slotNumber'] = this.slotNumber;
    return data;
  }
}