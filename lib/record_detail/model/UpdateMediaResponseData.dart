import 'package:myfhb/record_detail/model/MediaMetaInfo.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class UpdateMediaResponseData {
  MediaMetaInfo mediaMetaInfo;

  UpdateMediaResponseData({this.mediaMetaInfo});

  UpdateMediaResponseData.fromJson(Map<String, dynamic> json) {
    mediaMetaInfo = json[parameters.strmediaMetaInfo] != null
        ? new MediaMetaInfo.fromJson(json[parameters.strmediaMetaInfo])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mediaMetaInfo != null) {
      data[parameters.strmediaMetaInfo] = this.mediaMetaInfo.toJson();
    }
    return data;
  }
}