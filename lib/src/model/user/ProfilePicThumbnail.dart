import '../../../constants/fhb_parameters.dart' as parameters;

class ProfilePicThumbnailMain {
  String type;
  List<int> data;

  ProfilePicThumbnailMain({this.type, this.data});

  ProfilePicThumbnailMain.fromJson(Map<String, dynamic> json) {
    type = json[parameters.strtype];
    data = json[parameters.strData].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[parameters.strtype] = type;
    data[parameters.strData] = this.data;
    return data;
  }
}