
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/keysofmodel.dart';
import 'package:myfhb/video_call/model/msgcontent.dart';
import 'package:myfhb/video_call/model/payload.dart';

class MessageDetails {
  Content? content;
  Payload? payload;

  MessageDetails({this.content, this.payload});

  MessageDetails.fromJson(Map<String, dynamic> json) {
    try {
      content =
              json[c_content] != null ? Content.fromJson(json[c_content]) : null;
      payload =
              json[c_payload] != null ? Payload.fromJson(json[c_payload]) : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.content != null) {
      data[c_content] = this.content!.toJson();
    }
    if (this.payload != null) {
      data[c_payload] = this.payload!.toJson();
    }
    return data;
  }
}
