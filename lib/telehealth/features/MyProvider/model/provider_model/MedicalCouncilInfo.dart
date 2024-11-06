
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class MedicalCouncilInfo {
  String? name;
  String? isActive;
  String? description;

  MedicalCouncilInfo({this.name, this.isActive, this.description});

  MedicalCouncilInfo.fromJson(Map<String, dynamic> json) {
    try {
      name = json[parameters.strName];
      isActive = json[parameters.strIsActive];
      description = json[parameters.strDescription];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data[parameters.strName] = this.name;
    data[parameters.strIsActive] = this.isActive;
    data[parameters.strDescription] = this.description;
    return data;
  }
}
