import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/src/model/Health/MediaMetaInfo.dart';

class CompleteData {
  List<MediaMetaInfo> mediaMetaInfo;

  CompleteData({this.mediaMetaInfo});

  CompleteData.fromJson(Map<String, dynamic> json) {
    if (json[parameters.strmediaMetaInfo] != null) {
      mediaMetaInfo = new List<MediaMetaInfo>();
      json[parameters.strmediaMetaInfo].forEach((v) {
        mediaMetaInfo.add(new MediaMetaInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mediaMetaInfo != null) {
      data[parameters.strmediaMetaInfo] =
          this.mediaMetaInfo.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

