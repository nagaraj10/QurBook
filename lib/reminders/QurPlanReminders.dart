import 'dart:convert';
import 'dart:io';

import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/reminders/ReminderModel.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';

class QurPlanReminders {
  static const reminderLocalFile = 'notificationList.json';
  static Future<bool> addReminder(Reminder data) {
    final reminderMap = data.toMap();
    if (Platform.isIOS) {
      reminderMethodChannel.invokeMethod(addReminderMethod, [reminderMap]);
    }
  }

  static Future<bool> saveRemindersLocally(
      List<Reminder> notifiationToSave) async {
    final String directory = await FHBUtils.getInAppDocDirForReminders();
    final File file = File('${directory}/${reminderLocalFile}');
    try {
      await file.writeAsString(json.encode(notifiationToSave));
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  static Future<bool> updateRemindersLocally(Reminder data) async {
    List<Reminder> reminders = await getLocalReminder();
    Reminder foundTheMatched = null;
    for (var i = 0; i < reminders.length; i++) {
      if (reminders[i].id == data.id) {
        foundTheMatched = reminders.removeAt(i);
        break;
      }

      if (foundTheMatched != null) {
        reminderMethodChannel
            .invokeMethod(removeReminderMethod, [foundTheMatched.id]);
      }
      reminders.add(data);
    }
  }

  static Future<bool> deleteReminderLocally(Reminder data) async {
    List<Reminder> reminders = await getLocalReminder();
    Reminder foundTheMatched = null;

    if (reminders.length == 0) {
      return false;
    }
    for (var i = 0; i < reminders.length; i++) {
      print(identical(reminders[i], data));

      if (reminders[i].id == data.id) {
        foundTheMatched = reminders.removeAt(i);
        break;
      }

      if (foundTheMatched != null) {
        reminderMethodChannel
            .invokeMethod(removeReminderMethod, [foundTheMatched.id]);
        return true;
      } else {
        return false;
      }
    }
  }

  static Future<List<Reminder>> getLocalReminder() async {
    final directory = await FHBUtils.getInAppDocDirForReminders();
    final file = File('$directory/$reminderLocalFile');
    final data = await file.readAsString();
    List<dynamic> myJson = await json.decode(data);
    var notifications = <Reminder>[];
    for (var i = 0; i < myJson.length; i++) {
      Map val = jsonDecode(myJson[i]);
      final newData = Reminder.fromMap(val);
      notifications.add(newData);
    }
    return notifications;
  }
}
