
import 'package:myfhb/common/CommonUtil.dart';

class VideoLinks {
  String? title;
  String? thumbnail;
  String? url;

  VideoLinks({this.title, this.thumbnail, this.url});

  VideoLinks.fromJson(Map<String, dynamic> json) {
    try {
      title = json['title'];
      thumbnail = json['thumbnail'];
      url = json['url'];
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['thumbnail'] = thumbnail;
    data['url'] = url;
    return data;
  }
}