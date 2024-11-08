
import 'package:myfhb/common/CommonUtil.dart';

import '../../constants/fhb_parameters.dart' as parameters;

class LinkedData {
  String? nickName;
  String? customRoleId;
  String? roleName;
  String? modeOfShare;

  LinkedData(
      {this.nickName, this.customRoleId, this.roleName, this.modeOfShare});

  LinkedData.fromJson(Map<String, dynamic> json) {
    try {
      nickName = json[parameters.strnickName];
      customRoleId = json[parameters.strcustomRoleId];
      roleName = json[parameters.strroleName];
      modeOfShare = json[parameters.strmodeOfShare];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[parameters.strnickName] = nickName;
    data[parameters.strcustomRoleId] = customRoleId;
    data[parameters.strroleName] = roleName;
    data[parameters.strmodeOfShare] = modeOfShare;
    return data;
  }
}