
import 'package:myfhb/common/CommonUtil.dart';

class OtherInfo {
  OtherInfo({
    this.needPhoto,
    this.needAudio,
    this.needVideo,
    this.needFile,
  });

  int? needPhoto;
  int? needAudio;
  int? needVideo;
  int? needFile;

  OtherInfo.fromJson(Map<String, dynamic> json) {
    try {
      needPhoto = json['NeedPhoto'];
      needAudio = json['NeedAudio'];
      needVideo = json['NeedVideo'];
      needFile = json['NeedFile'];
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['NeedPhoto'] = needPhoto;
    data['NeedAudio'] = needAudio;
    data['NeedVideo'] = needVideo;
    data['NeedFile'] = needFile;
    return data;
  }
}
