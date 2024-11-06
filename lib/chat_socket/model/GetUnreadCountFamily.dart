
import 'package:myfhb/common/CommonUtil.dart';

class GetUnreadCountFamily {
  bool? isSuccess;
  List<Result>? result;

  GetUnreadCountFamily({this.isSuccess, this.result});

  GetUnreadCountFamily.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      if (json['result'] != null) {
            result = <Result>[];
            json['result'].forEach((v) {
              result!.add(Result.fromJson(v));
            });
          }
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String? count;

  Result({this.count});

  Result.fromJson(Map<String, dynamic> json) {
    try {
      count = json['count'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['count'] = this.count;
    return data;
  }
}