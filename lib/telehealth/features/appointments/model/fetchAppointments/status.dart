
import 'package:myfhb/telehealth/features/appointments/constants/appointments_parameters.dart'as parameters;

class Status {
  Status({
    this.id,
    this.code,
    this.name,
    this.description,
    this.sortOrder,
    this.isActive,
    this.createdBy,
    this.createdOn,
    this.lastModifiedOn,
  });

  String id;
  String code;
  String name;
  String description;
  int sortOrder;
  bool isActive;
  String createdBy;
  String createdOn;
  dynamic lastModifiedOn;

  Status.fromJson(Map<String, dynamic> json) {
    id = json[parameters.strId];
    code = json[parameters.strCode];
    name = json[parameters.strName];
    description = json[parameters.strDescription];
    sortOrder = json[parameters.strSortOrder];
    isActive = json[parameters.strIsActive];
    createdBy = json[parameters.strCreatedBy];
    createdOn = json[parameters.strCreatedOn];
    lastModifiedOn = json[parameters.strLastModifiedOn];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strId] = id;
    data[parameters.strCode] = code;
    data[parameters.strName] = name;
    data[parameters.strDescription] = description;
    data[parameters.strSortOrder] = sortOrder;
    data[parameters.strIsActive] = isActive;
    data[parameters.strCreatedBy] = createdBy;
    data[parameters.strCreatedOn] = createdOn;
    data[parameters.strLastModifiedOn] = lastModifiedOn;
    return data;
  }
}
