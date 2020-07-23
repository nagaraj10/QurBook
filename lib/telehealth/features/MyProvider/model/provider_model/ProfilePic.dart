import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class ProfilePic {
  String type;
  List<int> data;

  ProfilePic({this.type, this.data});

  ProfilePic.fromJson(Map<String, dynamic> json) {
    type = json[parameters.strtype];
    data = json[parameters.strData].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strtype] = this.type;
    data[parameters.strData] = this.data;
    return data;
  }
}
