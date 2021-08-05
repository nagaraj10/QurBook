import 'State.dart';

class StateModel {
  bool isSuccess;
  List<State> result;

  StateModel({this.isSuccess, this.result});

  StateModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['result'] != null) {
      result = List<State>();
      json['result'].forEach((v) {
        result.add(State.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['isSuccess'] = isSuccess;
    if (result != null) {
      data['result'] = result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
