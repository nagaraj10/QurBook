
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class University {
  String? id;
  String? name;

  University({this.id, this.name});

  University.fromJson(Map<String, dynamic> json) {
    try {
      id = json[parameters.strId];
      name = json[parameters.strName];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data[parameters.strId] = this.id;
    data[parameters.strName] = this.name;
    return data;
  }
}
