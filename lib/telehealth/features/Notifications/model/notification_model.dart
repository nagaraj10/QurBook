import 'package:myfhb/telehealth/features/Notifications/model/notificationResult.dart';

class NotificationModel {
  bool isSuccess;
  List<NotificationResult> result;

  NotificationModel({this.isSuccess, this.result});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['result'] != null) {
      result = new List<NotificationResult>();
      json['result'].forEach((v) {
        result.add(new NotificationResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

