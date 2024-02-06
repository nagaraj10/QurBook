import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import '../common/CommonUtil.dart';
import '../common/PreferenceUtil.dart';
import '../constants/HeaderRequest.dart';
import '../constants/fhb_constants.dart';
import '../constants/fhb_constants.dart' as Constants;
import '../constants/fhb_parameters.dart';
import '../main.dart';
import '../services/pushnotification_service.dart';
import '../src/resources/network/api_services.dart';
import '../src/utils/FHBUtils.dart';
import 'ReminderModel.dart';

class QurPlanReminders {
  static const reminderLocalFile = 'notificationList.json';

  static getTheRemindersFromAPI(
      {bool isSnooze = false, Reminder? snoozeReminderData}) async {
    final headerRequest = HeaderRequest();
    var headers = await headerRequest.getRequestHeadersAuthContents();
    var now = DateTime.now();
    var dayAfterTomorrowDate = DateTime(now.year, now.month, now.day + 2);
    var today = CommonUtil.dateConversionToApiFormat(
      now,
      isIndianTime: true,
    );
    var dayAfterTomorrow = CommonUtil.dateConversionToApiFormat(
      dayAfterTomorrowDate,
      isIndianTime: true,
    );
    var userId = PreferenceUtil.getStringValue(KEY_USERID);
    final _baseUrl = Constants.BASE_URL;
    var params = jsonEncode({
      'method': 'get',
      'data':
          'Action=GetUserReminders&patientId=$userId&startdate=$today&enddate=$dayAfterTomorrow'
    });
    try {
      var responseFromApi = await ApiServices.post(
          _baseUrl + 'plan-package-master/wrapperApi',
          headers: headers,
          body: params);
      var dataArray = await json.decode(responseFromApi!.body);
      final List<dynamic> data = dataArray['result'] ?? [];
      var reminders = <Reminder>[];
      data.forEach((element) {
        var newData = Reminder.fromMap(element);
        final notificationId =
            toSigned32BitInt(int.tryParse('${newData.eid}') ?? 0);
        newData.notificationListId = notificationId.toString();
        newData?.redirectTo = stringRegimentScreen;
        if (!newData.evDisabled) {
          if (newData.ack_local == '' || newData.ack_local == null)
            reminders.add(newData);
        }
      });
      if (isSnooze) {
        final notificationId =
            toSigned32BitInt(int.tryParse('${snoozeReminderData?.eid}') ?? 0);
        snoozeReminderData?.notificationListId = notificationId.toString();
        snoozeReminderData?.redirectTo = stringRegimentScreen;
        reminders.add(snoozeReminderData ?? Reminder());
      }
      await updateReminderswithLocal(reminders, isSnooze: isSnooze);
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      print(e.toString());
    }
  }

  static Future<bool> saveRemindersLocally(
      List<Reminder> notificationToSave) async {
    final directory = Platform.isIOS
        ? await FHBUtils.createFolderInAppDocDirForIOS('reminders')
        : await FHBUtils.abstractUserData();
    final file = Platform.isIOS
        ? File(directory + 'notificationList.json')
        : File(directory + '/notificationList.json');
    var dataTosave = notificationToSave.map((e) => e.toJson()).toList();
    try {
      var dataToSave = {'reminders': dataTosave};
      var dataToJson = json.encode(dataToSave);
      await file.writeAsString(dataToJson);
      // Check if the platform is Android
      if (Platform.isAndroid) {
        // Get SharedPreferences instance
        SharedPreferences prefs = await SharedPreferences.getInstance();

        // Encode the dataToSave object to a JSON string
        dataToJson = json.encode(dataToSave);

        // Save the JSON string to SharedPreferences with the key 'remindersPref'
        prefs.setString('remindersPref', dataToJson);
      }

      return true;
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      print(e.toString());
      return false;
    }
  }

  static Future<bool?> updateRemindersLocally(Reminder data) async {
    final reminders = await getLocalReminder();
    Reminder? foundTheMatched;
    for (var i = 0; i < reminders.length; i++) {
      if (reminders[i].eid == data.eid) {
        foundTheMatched = reminders.removeAt(i);
        break;
      }

      if (foundTheMatched != null) {
        await cancelLocalReminders(foundTheMatched);
      }
      reminders.add(data);
    }
  }

  static Future<bool> updateReminderswithLocal(List<Reminder> data,
      {bool isSnooze = false}) async {
    var localReminders = await getLocalReminder();

    try {
      for (var i = 0; i < data.length; i++) {
        var apiReminder = data[i];
        var found = false;
        for (var j = 0; j < localReminders.length; j++) {
          var localReminder = localReminders[j];
          if (apiReminder.eid == localReminder.eid) {
            found = true;
            if (apiReminder == localReminder) {
              break;
            } else {
              await cancelLocalReminders(localReminder);
              await onInitScheduleNotification(apiReminder);
            }
          }
        }
        if (!found) {
          await onInitScheduleNotification(apiReminder);
        }
      }

      for (var i = 0; i < localReminders.length; i++) {
        var localReminder = localReminders[i];
        if (!data.contains(localReminder)) {
          await cancelLocalReminders(localReminder);
        }
      }
      return await saveRemindersLocally(data);
    } catch (e) {
      print(e);
    }

    return await saveRemindersLocally(data);
  }

  static Future<bool?> deleteReminderLocally(Reminder data) async {
    final reminders = await getLocalReminder();
    Reminder? foundTheMatched;

    if (reminders.isEmpty) {
      return false;
    }
    for (var i = 0; i < reminders.length; i++) {
      if (reminders[i].eid == data.eid) {
        foundTheMatched = reminders.removeAt(i);
        break;
      }

      if (foundTheMatched != null) {
        await cancelLocalReminders(foundTheMatched);
        return true;
      } else {
        return false;
      }
    }
  }

  static Future<List<Reminder>> getLocalReminder() async {
    var notifications = <Reminder>[];
    try {
      var directory = Platform.isIOS
          ? await FHBUtils.createFolderInAppDocDirForIOS('reminders')
          : await FHBUtils.abstractUserData();

      var file = Platform.isIOS
          ? File('$directory$reminderLocalFile')
          : File('$directory/$reminderLocalFile');
      var data = await file.readAsString();
      var decodedData = await json.decode(data);

      final List<dynamic> myJson = decodedData['reminders'];

      notifications = <Reminder>[];
      for (var i = 0; i < myJson.length; i++) {
        var val = Reminder.fromJson(myJson[i]);
        //final newData = Reminder.fromMap(val);
        notifications.add(val);
      }
      return notifications;
    } catch (e, stackTrace) {
      try {
        // Get SharedPreferences instance
        SharedPreferences prefs = await SharedPreferences.getInstance();

        // Retrieve the JSON string from SharedPreferences
        String? jsonData = prefs.getString('remindersPref');

        // Check if the JSON string is not null
        if (jsonData != null) {
          // Decode the JSON string into a Dart object
          var retrievedData = await json.decode(jsonData);

          // Extract the 'reminders' list from the decoded data
          final List<dynamic> myJson = retrievedData['reminders'];

          // Initialize an empty list to store Reminder objects
          notifications = <Reminder>[];

          // Iterate over the 'reminders' list and convert each item to a Reminder object
          for (var i = 0; i < myJson.length; i++) {
            // Convert the current JSON object to a Reminder object using the fromJson method
            var val = Reminder.fromJson(myJson[i]);

            // Add the converted Reminder object to the notifications list
            notifications.add(val);
          }

          // Return the list of Reminder objects
          return notifications;
        }
      } catch (e, stackTrace) {
        // Handle any exceptions that may occur during the process
        CommonUtil().appLogs(message: e, stackTrace: stackTrace);
      }
    }
    return notifications;
  }

  static deleteAllLocalReminders() async {
    var reminders = await getLocalReminder();
    for (var r in reminders) {
      await cancelLocalReminders(r);
    }
    return await saveRemindersLocally([]);
  }

  // Cancel local reminder notifications
  static Future<void> cancelLocalReminders(Reminder foundTheMatched) async {
    try {
      var sheelaAIController = CommonUtil().onInitSheelaAIController();

      var id = foundTheMatched.eid;

      // Cancel the main notification
      var mainNotificationId = int.tryParse('$id') ?? 0;
      await localNotificationsPlugin.cancel(mainNotificationId);
      await sheelaAIController
          .clearScheduledTime(mainNotificationId.toString());

      // Cancel reminder notifications if beforeInt is greater than 0
      var beforeInt = int.tryParse(foundTheMatched.remindbefore!);
      if (beforeInt != null && beforeInt > 0) {
        var baseId = '${id}00';
        var beforeNotificationId = int.tryParse(baseId) ?? 0;
        await localNotificationsPlugin.cancel(beforeNotificationId);
        await sheelaAIController
            .clearScheduledTime(beforeNotificationId.toString());
      }

      // Cancel reminder notifications if afterInt is greater than 0
      var afterInt = int.tryParse(foundTheMatched.remindin!);
      if (afterInt != null && afterInt > 0) {
        var baseId = '${id}11';
        var afterNotificationId = int.tryParse(baseId) ?? 0;
        await localNotificationsPlugin.cancel(afterNotificationId);
        await sheelaAIController
            .clearScheduledTime(afterNotificationId.toString());
      }
    } catch (e, stackTrace) {
      // Log any errors and their stack traces
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  // Static method to refresh activity reminders
  static refreshActivityReminders() async {
    try {
      // Retrieve the user ID from preferences or use an empty string if not available
      String userId = PreferenceUtil.getStringValue(KEY_USERID) ?? "";

      // Check if the user ID is valid and not empty
      if ((CommonUtil().validString(userId ?? "").trim().isNotEmpty)) {
        // Retrieve local reminders
        var reminders = await getLocalReminder();

        // Iterate through each reminder and schedule notifications
        for (var reminder in reminders) {
          await onInitScheduleNotification(reminder);
        }
      }
    } catch (e, stackTrace) {
      // Handle any exceptions and log them using appLogs method
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }
}
