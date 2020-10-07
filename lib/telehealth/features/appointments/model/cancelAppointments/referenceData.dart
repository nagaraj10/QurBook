
import 'package:myfhb/telehealth/features/appointments/constants/appointments_parameters.dart'as parameters;

class ReferenceData {
  String id;
  String code;
  String name;
  String description;
  bool isActive;
  String createdBy;
  String createdOn;
  dynamic lastModifiedOn;

  ReferenceData(
      {this.id,
        this.code,
        this.name,
        this.description,
        this.isActive,
        this.createdBy,
        this.createdOn,
        this.lastModifiedOn});

  ReferenceData.fromJson(Map<String, dynamic> json) {
    id = json[parameters.strId];
    code = json[parameters.strCode];
    name = json[parameters.strName];
    description = json[parameters.strDescription];
    isActive = json[parameters.strIsActive];
    createdBy = json[parameters.strCreatedBy];
    createdOn = json[parameters.strCreatedOn];
    lastModifiedOn = json[parameters.strLastModifiedOn];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strId] = this.id;
    data[parameters.strCode] = this.code;
    data[parameters.strName] = this.name;
    data[parameters.strDescription] = this.description;
    data[parameters.strIsActive] = this.isActive;
    data[parameters.strCreatedBy] = this.createdBy;
    data[parameters.strCreatedOn] = this.createdOn;
    data[parameters.strLastModifiedOn] = this.lastModifiedOn;
    return data;
  }
}