import '../../../constants/fhb_parameters.dart' as parameters;
import 'MediaMetaInfo.dart';

class CompleteData {
  List<MediaMetaInfo> mediaMetaInfo;

  CompleteData({this.mediaMetaInfo});

  CompleteData.fromJson(Map<String, dynamic> json) {
    if (json[parameters.strmediaMetaInfo] != null) {
      mediaMetaInfo = List<MediaMetaInfo>();
      json[parameters.strmediaMetaInfo].forEach((v) {
        mediaMetaInfo.add(MediaMetaInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (mediaMetaInfo != null) {
      data[parameters.strmediaMetaInfo] =
          mediaMetaInfo.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

