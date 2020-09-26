

import 'package:myfhb/my_family/models/FamilyMembersRes.dart';
import 'package:myfhb/my_family/models/relationships.dart';

class Result {
  String id;
  String code;
  String name;
  String description;
  bool isActive;
  String createdBy;
  String createdOn;
  String lastModifiedOn;
  List<RelationsShipCollection> referenceValueCollection;

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
      referenceValueCollection = new List<RelationsShipCollection>();
      json['referenceValueCollection'].forEach((v) {
        referenceValueCollection.add(new RelationsShipCollection.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['description'] = this.description;
    data['isActive'] = this.isActive;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    if (this.referenceValueCollection != null) {
      data['referenceValueCollection'] =
          this.referenceValueCollection.map((v) => v.toJson()).toList();
    }
    return data;
  }
}