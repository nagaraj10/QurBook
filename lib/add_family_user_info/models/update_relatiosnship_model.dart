
import 'package:myfhb/common/CommonUtil.dart';

import '../../my_family/models/relationships.dart';

class UpdateRelationshipModel{
  String? id;
  RelationsShipModel? relationship;

  UpdateRelationshipModel({this.id,this.relationship});

  UpdateRelationshipModel.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      relationship = json['relationship'] != null
              ? RelationsShipModel.fromJson(json['relationship'])
              : null;
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    if (relationship != null) {
      data['relationship'] = relationship!.toJson();
    }
    return data;
  }

}