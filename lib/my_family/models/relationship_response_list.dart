import 'package:myfhb/my_family/models/relationship_result.dart';

class RelationShipResponseList {
  bool isSuccess;
  List<Result> result;

  RelationShipResponseList({this.isSuccess, this.result});

  RelationShipResponseList.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['result'] != null) {
      result = new List<Result>();
      json['result'].forEach((v) {
        result.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
