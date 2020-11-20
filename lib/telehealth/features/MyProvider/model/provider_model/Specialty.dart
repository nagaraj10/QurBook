import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class Specialty {
  String name;
  String isActive;
  String createdOn;
  String description;
  String lastModifiedBy;
  String lastModifiedOn;

  Specialty(
      {this.name,
      this.isActive,
      this.createdOn,
      this.description,
      this.lastModifiedBy,
      this.lastModifiedOn});

  Specialty.fromJson(Map<String, dynamic> json) {
    name = json[parameters.strName];
    isActive = json[parameters.strIsActive];
    createdOn = json[parameters.strCreatedOn];
    description = json[parameters.strDescription];
    lastModifiedBy = json[parameters.strlastModifiedBy];
    lastModifiedOn = json[parameters.strLastModifiedOn];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strName] = this.name;
    data[parameters.strIsActive] = this.isActive;
    data[parameters.strCreatedOn] = this.createdOn;
    data[parameters.strDescription] = this.description;
    data[parameters.strlastModifiedBy] = this.lastModifiedBy;
    data[parameters.strLastModifiedOn] = this.lastModifiedOn;
    return data;
  }
}