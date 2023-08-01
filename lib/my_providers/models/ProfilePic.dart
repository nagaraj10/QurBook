
import 'package:myfhb/common/CommonUtil.dart';

import '../../constants/fhb_parameters.dart' as parameters;

class ProfilePic {
  String? type;
  List<int>? data;

  ProfilePic({this.type, this.data});

  ProfilePic.fromJson(Map<String, dynamic> json) {
    try {
      type = json[parameters.strtype];
      data = json[parameters.strData].cast<int>();
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data[parameters.strtype] = type;
    data[parameters.strData] = this.data;
    return data;
  }
}