import 'package:myfhb/src/model/user/Tags.dart';

class TagsResult {
  bool isSuccess;
  List<Tags> result;

  TagsResult({this.isSuccess, this.result});

  TagsResult.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['result'] != null) {
      result = new List<Tags>();
      json['result'].forEach((v) {
        result.add(new Tags.fromJson(v));
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


