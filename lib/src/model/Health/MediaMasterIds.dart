import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class MediaMasterIds {
  String id;
  String fileType;

  MediaMasterIds({this.id, this.fileType});

  MediaMasterIds.fromJson(Map<String, dynamic> json) {
    id = json[parameters.strId];
    fileType = json[parameters.strfileType];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strId] = this.id;
    data[parameters.strfileType] = this.fileType;
    return data;
  }
}