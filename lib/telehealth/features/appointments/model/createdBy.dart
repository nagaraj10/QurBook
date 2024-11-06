
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/telehealth/features/appointments/constants/appointments_parameters.dart'as parameters;

class CreatedBy {
  String? id;

  CreatedBy({this.id});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    try {
      id = json[parameters.strId];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data[parameters.strId] = this.id;
    return data;
  }
}