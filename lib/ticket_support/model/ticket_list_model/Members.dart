
import 'package:myfhb/common/CommonUtil.dart';

class Members {
  Members({
    String? id,
  }) {
    _id = id;
  }

  Members.fromJson(dynamic json) {
    try {
      _id = json['id'];
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
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
