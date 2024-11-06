
import 'package:myfhb/common/CommonUtil.dart';

class ReferAFriendResponse {
  bool? isSuccess;
  List<Result>? result;

  ReferAFriendResponse({this.isSuccess, this.result});

  ReferAFriendResponse.fromJson(Map<String, dynamic> json) {
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
    final data = <String, dynamic>{};
    data['isSuccess'] = isSuccess;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String? phoneNumber;
  String? name;
  bool? isExistingUser;
  String? message;

  Result({this.phoneNumber, this.name, this.isExistingUser, this.message});

  Result.fromJson(Map<String, dynamic> json) {
    try {
      phoneNumber = json['phoneNumber'];
      name = json['name'];
      isExistingUser = json['isExistingUser'];
      message = json['message'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['phoneNumber'] = phoneNumber;
    data['name'] = name;
    data['isExistingUser'] = isExistingUser;
    data['message'] = message;
    return data;
  }
}
