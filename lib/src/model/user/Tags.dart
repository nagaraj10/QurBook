
import 'package:myfhb/common/CommonUtil.dart';

class Tags {
  String? id;
  String? name;
  String? code;
  bool? isChecked = false;

  Tags({this.id, this.name,this.isChecked});

  Tags.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      name = json['name'];
      if(json.containsKey('code')){
            code = json['code'];

          }
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    return data;
  }
}


