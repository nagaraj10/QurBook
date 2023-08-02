
import 'package:myfhb/common/CommonUtil.dart';

class SystemConfiguration {
  SystemConfiguration({
      String? name, 
      String? value,}){
    _name = name;
    _value = value;
}

  SystemConfiguration.fromJson(dynamic json) {
    try {
      _name = json['name'];
      _value = json['value'].toString();
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }
  String? _name;
  String? _value;

  String? get name => _name;
  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['value'] = _value;
    return map;
  }

}