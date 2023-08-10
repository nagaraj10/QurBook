
import 'package:myfhb/common/CommonUtil.dart';

class ProfilePic {
  String? type;
  List<int>? data;

  ProfilePic({this.type, this.data});

  ProfilePic.fromJson(Map<String, dynamic> json) {
    try {
      type = json['type'];
      data = json['data'].cast<int>();
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['data'] = this.data;
    return data;
  }
}