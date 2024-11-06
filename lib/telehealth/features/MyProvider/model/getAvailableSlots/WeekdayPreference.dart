
import 'package:myfhb/common/CommonUtil.dart';

class WeekdayPreference {
  String? day;
  bool? isAvailable;

  WeekdayPreference({this.day, this.isAvailable});

  WeekdayPreference.fromJson(Map<String, dynamic> json) {
    try {
      day = json['Day'];
      isAvailable = json['isAvailable'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Day'] = this.day;
    data['isAvailable'] = this.isAvailable;
    return data;
  }
}