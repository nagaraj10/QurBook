
import 'package:myfhb/common/CommonUtil.dart';

class UpdateAddFamilyInfo {
  bool? isSuccess;
  String? message;
  Result? result;

  UpdateAddFamilyInfo({this.isSuccess, this.message, this.result});

  UpdateAddFamilyInfo.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      message = json['message'];
      result =
              json['result'] != null ? Result.fromJson(json['result']) : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['isSuccess'] = isSuccess;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class Result {
  String? id;

  Result({this.id});

  Result.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    return data;
  }
}
