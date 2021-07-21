import '../../my_family/models/relationships.dart';

class UpdateRelationshipModel{
  String id;
  RelationsShipModel relationship;

  UpdateRelationshipModel({this.id,this.relationship});

  UpdateRelationshipModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    relationship = json['relationship'] != null
        ? RelationsShipModel.fromJson(json['relationship'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    if (relationship != null) {
      data['relationship'] = relationship.toJson();
    }
    return data;
  }

}