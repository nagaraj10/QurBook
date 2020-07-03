import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class ProfilePicThumbnailMain {
  String type;
  List<int> data;

  ProfilePicThumbnailMain({this.type, this.data});

  ProfilePicThumbnailMain.fromJson(Map<String, dynamic> json) {
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