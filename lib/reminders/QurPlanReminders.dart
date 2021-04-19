import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:gallery_saver/files.dart';
import 'package:myfhb/constants/HeaderRequest.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/reminders/ReminderModel.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:http/http.dart' as http;

class QurPlanReminders {
  static const reminderLocalFile = 'notificationList.json';

  static getTheRemindersFromAPI() async {
    //final fileName = 'assets/tempData.json';

    //final dataString = await rootBundle.loadString(fileName);
    HeaderRequest headerRequest = new HeaderRequest();
    final headers = await headerRequest.getRequestHeadersAuthContents();
    final params = jsonEncode({
      "method": "get",
      "data":
          "Action=GetUserReminders&pl=QurHealth&ul=patient_1_1@qurhealth.in&ispatient=1"
    });
    try {
      final responseFromApi = await http.post(
          "https://dwtg3mk9sjz8epmqfo.vsolgmi.com/api/plan-package-master/wrapperApi",
          headers: headers,
          body: params);

      final dataArray = await json.decode(responseFromApi.body);
      List<dynamic> data = dataArray['result'];
      List<Reminder> reminders = [];
      data.forEach((element) {
        final newData = Reminder.fromMap(element);
        reminders.add(newData);
      });
      updateReminderswithLocal(reminders);
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<bool> addReminder(Reminder data) {
    final reminderMap = data.toMap();
    if (Platform.isIOS) {
      reminderMethodChannel.invokeMethod(addReminderMethod, [reminderMap]);
    }
  }

  static Future<bool> saveRemindersLocally(
      List<Reminder> notificationToSave) async {
    final String directory =
        await FHBUtils.createFolderInAppDocDirForIOS('reminders');
    final File file = File(directory + 'notificationList.json');
    final dataTosave = notificationToSave.map((e) => json.encode(e)).toList();
    try {
      final dataToSave = {"reminders": dataTosave};
      final dataToJson = json.encode(dataToSave);
      await file.writeAsString(dataToJson);
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

  static Future<bool> updateReminderswithLocal(List<Reminder> data) async {
    List<Reminder> localReminders = await getLocalReminder();

    for (var i = 0; i < data.length; i++) {
      final apiReminder = data[i];
      bool found = false;
      for (var j = 0; j < localReminders.length; j++) {
        final localReminder = localReminders[j];
        if (apiReminder.id == localReminder.id) {
          found = true;
          if (apiReminder == localReminder) {
            break;
          } else {
            reminderMethodChannel
                .invokeMethod(removeReminderMethod, [localReminder.id]);
            reminderMethodChannel
                .invokeMethod(addReminderMethod, [apiReminder.toMap()]);
          }
        }
      }
      if (!found) {
        reminderMethodChannel
            .invokeMethod(addReminderMethod, [apiReminder.toMap()]);
      }
    }

    for (var i = 0; i < localReminders.length; i++) {
      final localReminder = localReminders[i];
      if (!data.contains(localReminder)) {
        reminderMethodChannel
            .invokeMethod(removeReminderMethod, [localReminder.id]);
      }
    }
    saveRemindersLocally(data);
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
    try {
      final directory =
          await FHBUtils.createFolderInAppDocDirForIOS('reminders');
      final file = File('$directory$reminderLocalFile');
      final data = await file.readAsString();
      final decodedData = await json.decode(data);

      List<dynamic> myJson = decodedData['reminders'];

      var notifications = <Reminder>[];
      for (var i = 0; i < myJson.length; i++) {
        Map val = jsonDecode(myJson[i]);
        final newData = Reminder.fromMap(val);
        notifications.add(newData);
      }
      return notifications;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
