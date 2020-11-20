import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class MedicalCouncilInfo {
  String name;
  String isActive;
  String description;

  MedicalCouncilInfo({this.name, this.isActive, this.description});

  MedicalCouncilInfo.fromJson(Map<String, dynamic> json) {
    name = json[parameters.strName];
    isActive = json[parameters.strIsActive];
    description = json[parameters.strDescription];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strName] = this.name;
    data[parameters.strIsActive] = this.isActive;
    data[parameters.strDescription] = this.description;
    return data;
  }
}
