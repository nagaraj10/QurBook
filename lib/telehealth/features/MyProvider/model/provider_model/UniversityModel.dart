import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class University {
  String id;
  String name;

  University({this.id, this.name});

  University.fromJson(Map<String, dynamic> json) {
    id = json[parameters.strId];
    name = json[parameters.strName];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strId] = this.id;
    data[parameters.strName] = this.name;
    return data;
  }
}
