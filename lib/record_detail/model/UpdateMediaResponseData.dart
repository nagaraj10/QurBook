
import 'package:myfhb/common/CommonUtil.dart';

import 'MediaMetaInfo.dart';
import '../../constants/fhb_parameters.dart' as parameters;

class UpdateMediaResponseData {
  MediaMetaInfo? mediaMetaInfo;

  UpdateMediaResponseData({this.mediaMetaInfo});

  UpdateMediaResponseData.fromJson(Map<String, dynamic> json) {
    try {
      mediaMetaInfo = json[parameters.strmediaMetaInfo] != null
              ? MediaMetaInfo.fromJson(json[parameters.strmediaMetaInfo])
              : null;
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    if (mediaMetaInfo != null) {
      data[parameters.strmediaMetaInfo] = mediaMetaInfo!.toJson();
    }
    return data;
  }
}