import 'package:myfhb/common/keysofmodel.dart';
import 'package:myfhb/video_call/model/msgcontent.dart';
import 'package:myfhb/video_call/model/payload.dart';

class MessageDetails {
  Content content;
  Payload payload;

  MessageDetails({this.content, this.payload});

  MessageDetails.fromJson(Map<String, dynamic> json) {
    content =
        json[c_content] != null ? new Content.fromJson(json[c_content]) : null;
    payload =
        json[c_payload] != null ? new Payload.fromJson(json[c_payload]) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.content != null) {
      data[c_content] = this.content.toJson();
    }
    if (this.payload != null) {
      data[c_payload] = this.payload.toJson();
    }
    return data;
  }
}
