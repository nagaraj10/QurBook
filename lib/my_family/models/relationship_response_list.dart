
import 'package:myfhb/common/CommonUtil.dart';

import 'relationship_result.dart';

class RelationShipResponseList {
  bool? isSuccess;
  List<Result>? result;

  RelationShipResponseList({this.isSuccess, this.result});

  RelationShipResponseList.fromJson(Map<String, dynamic> json) {
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
