
import 'package:myfhb/common/CommonUtil.dart';

class ClaimSuccess {
  dynamic isSuccess;
  dynamic message;
  dynamic result;
  Diagnostics? diagnostics;

  ClaimSuccess({this.isSuccess, this.message, this.result});

  ClaimSuccess.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      if (json.containsKey('message')) message = json['message'];
      if (json.containsKey('result')) result = json['result'];
      if (json.containsKey('diagnostics')) {
            diagnostics = json['diagnostics'] != null
                ? Diagnostics.fromJson(json['diagnostics'])
                : null;
          }
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (message != null) {
      data['message'] = this.message;
    }
    if (result != null) {
      data['result'] = this.result;
    }
    if (diagnostics != null) {
      data['diagnostics'] = diagnostics!.toJson();
    }
    return data;
  }
}

class Diagnostics {
  dynamic message;

  Diagnostics({this.message});

  Diagnostics.fromJson(Map<String, dynamic> json) {
    try {
      message = json['message'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['message'] = this.message;
    return data;
  }
}
