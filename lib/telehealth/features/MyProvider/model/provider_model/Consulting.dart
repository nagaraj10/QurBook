
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class Consulting {
  String? fee;

  Consulting({this.fee});

  Consulting.fromJson(Map<String, dynamic> json) {
    try {
      fee = json[parameters.strfee];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data[parameters.strfee] = this.fee;
    return data;
  }
}