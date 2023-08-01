
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/telehealth/features/appointments/constants/appointments_parameters.dart'as parameters;

class CreatedBy {
  String? id;

  CreatedBy({this.id});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    try {
      id = json[parameters.strId];
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strId] = this.id;
    return data;
  }
}