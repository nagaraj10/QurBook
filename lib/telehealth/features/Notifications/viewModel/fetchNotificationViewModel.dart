import 'package:flutter/cupertino.dart';
import 'package:myfhb/telehealth/features/Notifications/model/notification_model.dart';
import 'package:myfhb/telehealth/features/Notifications/services/notification_services.dart';

enum LoadingStatus {
  completed,
  searching,
  empty,
}

class FetchNotificationViewModel extends ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;
  NotificationModel _notificationModel=NotificationModel();
  FetchNotificationService _fetchNotificationService=FetchNotificationService();

  NotificationModel notificationModel;

  FetchNotificationViewModel({NotificationModel notificationModel})
      : _notificationModel = notificationModel;

  NotificationModel get notifications => _notificationModel;

  Future<NotificationModel> fetchNotifications() async {
    try {
      this.loadingStatus = LoadingStatus.searching;
      NotificationModel notification = await _fetchNotificationService.fetchNotificationList();
      _notificationModel=notification;
      this.loadingStatus = LoadingStatus.completed;
      notifyListeners();
      return _notificationModel;
    } catch (e) {
      this.loadingStatus = LoadingStatus.empty;
      notifyListeners();
    }
  }

  void clearNotifications() {
    _notificationModel = null;
    notifyListeners();
  }

}
