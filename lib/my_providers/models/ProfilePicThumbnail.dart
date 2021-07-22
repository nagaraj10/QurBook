import '../../constants/fhb_parameters.dart' as parameters;

class ProfilePicThumbnail {
  String type;
  List<int> data;

  ProfilePicThumbnail({this.type, this.data});

  ProfilePicThumbnail.fromJson(Map<String, dynamic> json) {
    type = json[parameters.strtype];
    data = json[parameters.strData].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data[parameters.strtype] = type;
    data[parameters.strData] = this.data;
    return data;
  }
}