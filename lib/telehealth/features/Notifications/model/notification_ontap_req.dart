
import 'package:myfhb/common/CommonUtil.dart';

class NotificationOntapRequest {
  List<String?>? logIds;
  bool? isMarkAllRead;

  NotificationOntapRequest({this.logIds, this.isMarkAllRead});

  NotificationOntapRequest.fromJson(Map<String, dynamic> json) {
    try {
      logIds = json['logIds'].cast<String>();
      isMarkAllRead = json['isMarkAllRead'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['logIds'] = this.logIds;
    data['isMarkAllRead'] = this.isMarkAllRead;
    return data;
  }
}
