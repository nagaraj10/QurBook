
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class FollowupIn {
  List<int>? days;

  FollowupIn({this.days});

  FollowupIn.fromJson(Map<String, dynamic> json) {
    try {
      days = json[parameters.strdays].cast<int>();
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data[parameters.strdays] = this.days;
    return data;
  }
}