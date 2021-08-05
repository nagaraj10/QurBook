import 'media_result.dart';
import '../../../constants/fhb_parameters.dart' as parameters;

class MediaDataList {
  bool isSuccess;
  List<MediaResult> result;

  MediaDataList({this.isSuccess, this.result});

  MediaDataList.fromJson(Map<String, dynamic> json) {
    isSuccess = json[parameters.strIsSuccess];
    if (json[parameters.strResult] != null) {
      result = <MediaResult>[];
      json[parameters.strResult].forEach((v) {
        result.add(MediaResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data[parameters.strIsSuccess] = isSuccess;
    if (result != null) {
      data[parameters.strResult] = result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
