
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/keysofmodel.dart';
import 'package:myfhb/video_call/model/messagedetails.dart';

class CallPushNSModel {
  List<String>? recipients;
  MessageDetails? messageDetails;
  List<String>? transportMedium;
  bool? saveMessage;

  CallPushNSModel(
      {this.recipients,
      this.messageDetails,
      this.transportMedium,
      this.saveMessage});

  CallPushNSModel.fromJson(Map<String, dynamic> json) {
    try {
      recipients = json[c_recipients].cast<String>();
      messageDetails = json[c_messageDetails] != null
              ? MessageDetails.fromJson(json[c_messageDetails])
              : null;
      transportMedium = json[c_transportMedium].cast<String>();
      saveMessage = json[c_saveMessage];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data[c_recipients] = this.recipients;
    if (this.messageDetails != null) {
      data[c_messageDetails] = this.messageDetails!.toJson();
    }
    data[c_transportMedium] = this.transportMedium;
    data[c_saveMessage] = this.saveMessage;
    return data;
  }
}
