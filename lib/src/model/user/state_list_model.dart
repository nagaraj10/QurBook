import 'package:myfhb/src/model/user/State.dart';

class StateModel {
  bool isSuccess;
  List<State> result;

  StateModel({this.isSuccess, this.result});

  StateModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['result'] != null) {
      result = new List<State>();
      json['result'].forEach((v) {
        result.add(new State.fromJson(v));
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
