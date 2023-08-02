import 'package:myfhb/common/CommonUtil.dart';

class SendMailTo {
  SendMailTo({
    dynamic id,
  }) {
    _id = id;
  }

  SendMailTo.fromJson(dynamic json) {
    try{
    _id = json['id'];
    }catch(e){
      CommonUtil().appLogs(message: e.toString());
    }
  }
  dynamic _id;

  dynamic get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    return map;
  }
}
