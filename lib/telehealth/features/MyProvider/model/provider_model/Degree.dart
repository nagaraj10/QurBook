import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class Degree {
  String id;
  String name;
  String isActive;

  Degree({this.id, this.name, this.isActive});

  Degree.fromJson(Map<String, dynamic> json) {
    id = json[parameters.strId];
    name = json[parameters.strName];
    isActive = json[parameters.strIsActive];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strId] = this.id;
    data[parameters.strName] = this.name;
    data[parameters.strIsActive] = this.isActive;
    return data;
  }
}