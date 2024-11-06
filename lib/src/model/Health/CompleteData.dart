
import 'package:myfhb/common/CommonUtil.dart';

import '../../../constants/fhb_parameters.dart' as parameters;
import 'MediaMetaInfo.dart';

class CompleteData {
  List<MediaMetaInfo>? mediaMetaInfo;

  CompleteData({this.mediaMetaInfo});

  CompleteData.fromJson(Map<String, dynamic> json) {
    try {
      if (json[parameters.strmediaMetaInfo] != null) {
            mediaMetaInfo = <MediaMetaInfo>[];
            json[parameters.strmediaMetaInfo].forEach((v) {
              mediaMetaInfo!.add(MediaMetaInfo.fromJson(v));
            });
          }
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (mediaMetaInfo != null) {
      data[parameters.strmediaMetaInfo] =
          mediaMetaInfo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

