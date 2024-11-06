
import 'package:myfhb/common/CommonUtil.dart';

class Result {
  Result({
      String? id, 
      String? code, 
      String? name,}){
    _id = id;
    _code = code;
    _name = name;
}

  Result.fromJson(dynamic json) {
    try {
      _id = json['id'];
      _code = json['code'];
      _name = json['name'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }
  String? _id;
  String? _code;
  String? _name;

  String? get id => _id;
  String? get code => _code;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['code'] = _code;
    map['name'] = _name;
    return map;
  }

}