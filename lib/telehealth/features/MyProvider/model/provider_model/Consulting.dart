import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class Consulting {
  String fee;

  Consulting({this.fee});

  Consulting.fromJson(Map<String, dynamic> json) {
    fee = json[parameters.strfee];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strfee] = this.fee;
    return data;
  }
}