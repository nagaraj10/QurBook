
import 'package:myfhb/common/CommonUtil.dart';

class AppointmentStatus {
  String? code;
  String? name;
  String? description;

  AppointmentStatus({this.code, this.name, this.description});

  AppointmentStatus.fromJson(Map<String, dynamic> json) {
    try {
      code = json['code'];
      name = json['name'];
      description = json['description'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    data['description'] = this.description;
    return data;
  }
}