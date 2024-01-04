
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/src/model/user/Tags.dart';

class TagsResult {
  bool? isSuccess;
  List<Tags>? result;

  TagsResult({this.isSuccess, this.result});

  TagsResult.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      if (json['result'] != null) {
            result = <Tags>[];
            json['result'].forEach((v) {
              result!.add(Tags.fromJson(v));
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


