import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class Languages {
  String languageId;
  String name;

  Languages({this.languageId, this.name});

  Languages.fromJson(Map<String, dynamic> json) {
    languageId = json[parameters.strlanguageId];
    name = json[parameters.strName];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strlanguageId] = this.languageId;
    data[parameters.strName] = this.name;
    return data;
  }
}
