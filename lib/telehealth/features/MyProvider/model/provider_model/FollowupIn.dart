import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class FollowupIn {
  List<int> days;

  FollowupIn({this.days});

  FollowupIn.fromJson(Map<String, dynamic> json) {
    days = json[parameters.strdays].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strdays] = this.days;
    return data;
  }
}