import 'package:myfhb/src/model/Media/media_result.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class MediaDataList {
  bool isSuccess;
  List<MediaResult> result;

  MediaDataList({this.isSuccess, this.result});

  MediaDataList.fromJson(Map<String, dynamic> json) {
    isSuccess = json[parameters.strIsSuccess];
    if (json[parameters.strResult] != null) {
      result = new List<MediaResult>();
      json[parameters.strResult].forEach((v) {
        result.add(new MediaResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strIsSuccess] = this.isSuccess;
    if (this.result != null) {
      data[parameters.strResult] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
