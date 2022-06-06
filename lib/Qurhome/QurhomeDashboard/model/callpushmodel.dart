import 'package:myfhb/common/keysofmodel.dart';
import 'package:myfhb/video_call/model/messagedetails.dart';

class CallPushNSModel {
  List<String> recipients;
  MessageDetails messageDetails;
  List<String> transportMedium;
  bool saveMessage;

  CallPushNSModel(
      {this.recipients,
      this.messageDetails,
      this.transportMedium,
      this.saveMessage});

  CallPushNSModel.fromJson(Map<String, dynamic> json) {
    recipients = json[c_recipients].cast<String>();
    messageDetails = json[c_messageDetails] != null
        ? new MessageDetails.fromJson(json[c_messageDetails])
        : null;
    transportMedium = json[c_transportMedium].cast<String>();
    saveMessage = json[c_saveMessage];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[c_recipients] = this.recipients;
    if (this.messageDetails != null) {
      data[c_messageDetails] = this.messageDetails.toJson();
    }
    data[c_transportMedium] = this.transportMedium;
    data[c_saveMessage] = this.saveMessage;
    return data;
  }
}
