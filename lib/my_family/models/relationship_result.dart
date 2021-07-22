

import 'FamilyMembersRes.dart';
import 'relationships.dart';

class Result {
  String id;
  String code;
  String name;
  String description;
  bool isActive;
  String createdBy;
  String createdOn;
  String lastModifiedOn;
  List<RelationsShipModel> referenceValueCollection;

  Result(
      {this.id,
      this.code,
      this.name,
      this.description,
      this.isActive,
      this.createdBy,
      this.createdOn,
      this.lastModifiedOn,
      this.referenceValueCollection});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    description = json['description'];
    isActive = json['isActive'];
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    if (json['referenceValueCollection'] != null) {
      referenceValueCollection = List<RelationsShipModel>();
      json['referenceValueCollection'].forEach((v) {
        referenceValueCollection.add(RelationsShipModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['code'] = code;
    data['name'] = name;
    data['description'] = description;
    data['isActive'] = isActive;
    data['createdBy'] = createdBy;
    data['createdOn'] = createdOn;
    data['lastModifiedOn'] = lastModifiedOn;
    if (referenceValueCollection != null) {
      data['referenceValueCollection'] =
          referenceValueCollection.map((v) => v.toJson()).toList();
    }
    return data;
  }
}