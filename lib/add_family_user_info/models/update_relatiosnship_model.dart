import 'package:myfhb/my_family/models/relationships.dart';

class UpdateRelationshipModel{
  String id;
  RelationsShipModel relationship;

  UpdateRelationshipModel({this.id,this.relationship});

  UpdateRelationshipModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    relationship = json['relationship'] != null
        ? new RelationsShipModel.fromJson(json['relationship'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.relationship != null) {
      data['relationship'] = this.relationship.toJson();
    }
    return data;
  }

}