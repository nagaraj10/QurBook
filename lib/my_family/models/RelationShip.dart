import '../../constants/fhb_parameters.dart' as parameters;

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
    final data = <String, dynamic>{};
    data[parameters.strId] = id;
    data[parameters.strRoleName] = roleName;
    data[parameters.strRoleDescription] = roleDescription;
    data[parameters.strIsActive] = isActive;
    data[parameters.strCreatedOn] = createdOn;
    data[parameters.strLastModifiedOn] = lastModifiedOn;

    return data;
  }
}
