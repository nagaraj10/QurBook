import 'package:myfhb/telehealth/features/Notifications/model/variables.dart';

class Content {
  Variables variables;
  String templateName;

  Content({this.variables, this.templateName});

  Content.fromJson(Map<String, dynamic> json) {
    variables = json['variables'] != null
        ? new Variables.fromJson(json['variables'])
        : null;
    templateName = json['templateName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.variables != null) {
      data['variables'] = this.variables.toJson();
    }
    data['templateName'] = this.templateName;
    return data;
  }
}