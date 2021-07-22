import '../../../constants/fhb_parameters.dart' as parameters;

class MediaMasterIds {
  String id;
  String fileType;

  MediaMasterIds({this.id, this.fileType});

  MediaMasterIds.fromJson(Map<String, dynamic> json) {
    id = json[parameters.strId];
    fileType = json[parameters.strfileType];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[parameters.strId] = id;
    data[parameters.strfileType] = fileType;
    return data;
  }
}