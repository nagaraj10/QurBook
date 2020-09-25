import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class LinkedData {
  String nickName;
  String customRoleId;
  String roleName;
  String modeOfShare;

  LinkedData(
      {this.nickName, this.customRoleId, this.roleName, this.modeOfShare});

  LinkedData.fromJson(Map<String, dynamic> json) {
    nickName = json[parameters.strnickName];
    customRoleId = json[parameters.strcustomRoleId];
    roleName = json[parameters.strroleName];
    modeOfShare = json[parameters.strmodeOfShare];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strnickName] = this.nickName;
    data[parameters.strcustomRoleId] = this.customRoleId;
    data[parameters.strroleName] = this.roleName;
    data[parameters.strmodeOfShare] = this.modeOfShare;
    return data;
  }
}