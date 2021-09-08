import 'package:flutter/cupertino.dart';
import 'package:myfhb/constants/fhb_query.dart';
import 'package:myfhb/telehealth/features/Notifications/model/notification_model.dart';
import 'package:myfhb/telehealth/features/Notifications/services/notification_services.dart';

enum LoadingStatus {
  completed,
  searching,
  empty,
}

class FetchNotificationViewModel extends ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.searching;
  NotificationModel _notificationModel = NotificationModel();
  FetchNotificationService _fetchNotificationService =
      FetchNotificationService();
  bool deleteMode = false;
  bool selectAllTapped = false;
  NotificationModel notificationModel;
  List<String> deleteLogId = [];

  FetchNotificationViewModel({NotificationModel notificationModel})
      : _notificationModel = notificationModel;

  NotificationModel get notifications => _notificationModel;

  Future<NotificationModel> fetchNotifications() async {
    deleteLogId = [];
    deleteMode = false;
    selectAllTapped = false;
    try {
      this.loadingStatus = LoadingStatus.searching;
      notifyListeners();
      NotificationModel notification =
          await _fetchNotificationService.fetchNotificationList();
      _notificationModel = notification;
      this.loadingStatus = LoadingStatus.completed;
      notifyListeners();
      return _notificationModel;
    } catch (e) {
      this.loadingStatus = LoadingStatus.empty;
      notifyListeners();
    }
  }

  Future deleteTheSelectedNotifiations() async {
    this.loadingStatus = LoadingStatus.searching;
    notifyListeners();
    try {
      var body = {};
      body[qr_medium] = "Push";
      body[qr_clearIds] = deleteLogId;
      final status = await _fetchNotificationService.clearNotifications(body);
      fetchNotifications();
    } catch (e) {
      print(e.toString());
      fetchNotifications();
    }
  }

  void addTheidToDelete(String id) {
    this.deleteLogId.add(id);
    this.loadingStatus = LoadingStatus.completed;
    notifyListeners();
  }

  void removeTheIdToDelete(String id) {
    this.deleteLogId.removeWhere((element) => element == id);
    if (deleteLogId.length <= 0) {
      deleteMode = false;
    }
    this.loadingStatus = LoadingStatus.completed;
    notifyListeners();
  }

  void selectOrDeselectAllTapped() {
    selectAllTapped = !selectAllTapped;

    this.loadingStatus = LoadingStatus.searching;
    this.deleteLogId.clear();
    _notificationModel.result.forEach(
      (element) {
        element.deleteSelected = selectAllTapped;
        if (selectAllTapped) {
          this.deleteLogId.add(element.id);
        }
      },
    );
    if (!selectAllTapped) {
      deleteMode = false;
    }
    this.loadingStatus = LoadingStatus.completed;
    notifyListeners();
  }

  void clearNotifications() {
    _notificationModel = null;
    notifyListeners();
  }
}
