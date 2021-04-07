import 'dart:io';

import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/reminders/ReminderModel.dart';

class QurPlanReminders {
  static Future<bool> addReminder(Reminder data) {
    final reminderMap = data.toMap();
    if (Platform.isIOS) {
      reminderMethodChannel.invokeMethod(addReminderMethod, [reminderMap]);
    }
  }

  static Future<bool> removeReminder(int data) {
    if (Platform.isIOS) {
      reminderMethodChannel.invokeMethod(removeReminderMethod, [data]);
    }
  }

  static Future<bool> saveRemindersLocally() {}

  static Future<bool> updateRemindersLocally() {}
}
