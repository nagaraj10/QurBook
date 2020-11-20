import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class RelationShip {
  String id;
  String roleName;
  String roleDescription;
  bool isActive;
  String createdOn;
  String lastModifiedOn;

  RelationShip(
      {this.id,
      this.roleName,
      this.roleDescription,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn});

  RelationShip.fromJson(Map<String, dynamic> json) {
    id = json[parameters.strId];
    roleName = json[parameters.strRoleName];
    roleDescription = json[parameters.strRoleDescription];
    isActive = json[parameters.strIsActive];
    createdOn = json[parameters.strCreatedOn];
    lastModifiedOn = json[parameters.strLastModifiedOn];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strId] = this.id;
    data[parameters.strRoleName] = this.roleName;
    data[parameters.strRoleDescription] = this.roleDescription;
    data[parameters.strIsActive] = this.isActive;
    data[parameters.strCreatedOn] = this.createdOn;
    data[parameters.strLastModifiedOn] = this.lastModifiedOn;

    return data;
  }
}
