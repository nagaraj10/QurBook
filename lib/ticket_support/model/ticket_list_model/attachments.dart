
import 'package:myfhb/common/CommonUtil.dart';

class Attachments {
  Attachments({
    String? id,
  }) {
    _id = id;
  }

  Attachments.fromJson(dynamic json) {
    try {
      _id = json['id'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }
  String? _id;

  String? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    return map;
  }
}
