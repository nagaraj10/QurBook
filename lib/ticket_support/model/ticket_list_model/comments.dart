
import 'package:myfhb/common/CommonUtil.dart';

class Comments {
  Comments({
    String? id,
  }) {
    _id = id;
  }

  Comments.fromJson(dynamic json) {
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
