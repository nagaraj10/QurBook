
import 'package:myfhb/common/CommonUtil.dart';

import '../../../constants/fhb_parameters.dart' as parameters;

class ProfilePicThumbnailMain {
  String? type;
  List<int>? data;

  ProfilePicThumbnailMain({this.type, this.data});

  ProfilePicThumbnailMain.fromJson(Map<String, dynamic> json) {
    try {
      type = json[parameters.strtype];
      data = json[parameters.strData].cast<int>();
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[parameters.strtype] = type;
    data[parameters.strData] = this.data;
    return data;
  }
}