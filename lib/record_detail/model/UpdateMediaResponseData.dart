import 'MediaMetaInfo.dart';
import '../../constants/fhb_parameters.dart' as parameters;

class UpdateMediaResponseData {
  MediaMetaInfo mediaMetaInfo;

  UpdateMediaResponseData({this.mediaMetaInfo});

  UpdateMediaResponseData.fromJson(Map<String, dynamic> json) {
    mediaMetaInfo = json[parameters.strmediaMetaInfo] != null
        ? MediaMetaInfo.fromJson(json[parameters.strmediaMetaInfo])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    if (mediaMetaInfo != null) {
      data[parameters.strmediaMetaInfo] = mediaMetaInfo.toJson();
    }
    return data;
  }
}