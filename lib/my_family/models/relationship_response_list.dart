import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/my_family/models/RelationShip.dart';

class RelationShipResponseList {
  int status;
  bool success;
  String message;
  List<RelationShip> relationShipAry;

  RelationShipResponseList(
      {this.status, this.success, this.message, this.relationShipAry});

  RelationShipResponseList.fromJson(Map<String, dynamic> json) {
    status = json[parameters.strStatus];
    success = json[parameters.strSuccess];
    message = json[parameters.strMessage];
    Map<String, dynamic> responseJson = json[parameters.strResponse];

    if (responseJson != null) {
      relationShipAry = new List<RelationShip>();
      responseJson[parameters.strData].forEach((v) {
        relationShipAry.add(new RelationShip.fromJson(v));
      });
    }
  }
}

/*class RelationShip {
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
    id = json['id'];
    roleName = json['roleName'];
    roleDescription = json['roleDescription'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['roleName'] = this.roleName;
    data['roleDescription'] = this.roleDescription;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;

    return data;
  }
}*/
