
import 'package:myfhb/common/CommonUtil.dart';

import 'State.dart';

class StateModel {
  bool? isSuccess;
  List<State>? result;

  StateModel({this.isSuccess, this.result});

  StateModel.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      if (json['result'] != null) {
            result = <State>[];
            json['result'].forEach((v) {
              result!.add(State.fromJson(v));
            });
          }
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['isSuccess'] = isSuccess;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
