import 'dart:convert';
import 'dart:io';

// import 'package:flutter/services.dart';
// import 'package:gallery_saver/files.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/HeaderRequest.dart';
import 'package:myfhb/constants/variable_constant.dart';
import 'package:myfhb/reminders/ReminderModel.dart';
import 'package:myfhb/src/utils/FHBUtils.dart';
import 'package:http/http.dart' as http;
import 'package:myfhb/constants/fhb_constants.dart' as Constants;

class QurPlanReminders {
  static const reminderLocalFile = 'notificationList.json';

  static getTheRemindersFromAPI() async {
    //final fileName = 'assets/tempData.json';

    //final dataString = await rootBundle.loadString(fileName);
    HeaderRequest headerRequest = new HeaderRequest();
    final headers = await headerRequest.getRequestHeadersAuthContents();
    final now = DateTime.now();
    final dayAfterTomorrowDate = DateTime(now.year, now.month, now.day + 2);
    final today = CommonUtil().dateConversionToApiFormat(now);
    final dayAfterTomorrow =
        CommonUtil().dateConversionToApiFormat(dayAfterTomorrowDate);
    final String _baseUrl = Constants.BASE_URL;
    final params = jsonEncode({
      "method": "get",
      "data":
          "Action=GetUserReminders&startdate=$today&enddate=$dayAfterTomorrow"
    });
    try {
      final responseFromApi = await http.post(
          _baseUrl + "plan-package-master/wrapperApi",
          headers: headers,
          body: params);

      final dataArray = await json.decode(responseFromApi.body);
      List<dynamic> data = dataArray['result'];
      List<Reminder> reminders = [];
      var oneHourbeforeFromNow = DateTime.now().subtract(Duration(hours: 1));
      print(oneHourbeforeFromNow);
      data.forEach((element) {
        final newData = Reminder.fromMap(element);
        final currentDateAndTime = DateTime.parse(newData.estart);
        print(currentDateAndTime);
        if (currentDateAndTime.isAfter(oneHourbeforeFromNow)) {
          reminders.add(newData);
        }
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
    } else {
      reminderMethodChannelAndroid
          .invokeMethod(addReminderMethod, {'data': jsonEncode(reminderMap)});
    }
  }

  static Future<bool> saveRemindersLocally(
      List<Reminder> notificationToSave) async {
    final String directory =
        await FHBUtils.createFolderInAppDocDirForIOS('reminders');
    final File file = File(directory + 'notificationList.json');
    final dataTosave = notificationToSave.map((e) => e.toJson()).toList();
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
      if (reminders[i].eid == data.eid) {
        foundTheMatched = reminders.removeAt(i);
        break;
      }

      if (foundTheMatched != null) {
        if (Platform.isIOS) {
          reminderMethodChannel
              .invokeMethod(removeReminderMethod, [foundTheMatched.eid]);
        } else {
          reminderMethodChannelAndroid.invokeMethod(
              removeReminderMethod, {'data': foundTheMatched.eid});
        }
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
        if (apiReminder.eid == localReminder.eid) {
          found = true;
          if (apiReminder == localReminder) {
            if (Platform.isIOS) {
              apiReminder.alreadyScheduled = true;
              reminderMethodChannel
                  .invokeMethod(addReminderMethod, [apiReminder.toMap()]);
            }
            break;
          } else {
            if (Platform.isIOS) {
              reminderMethodChannel
                  .invokeMethod(removeReminderMethod, [localReminder.eid]);
              reminderMethodChannel
                  .invokeMethod(addReminderMethod, [apiReminder.toMap()]);
            } else {
              reminderMethodChannelAndroid.invokeMethod(
                  removeReminderMethod, {'data': localReminder.eid});
              reminderMethodChannelAndroid.invokeMethod(
                  addReminderMethod, {'data': jsonEncode(apiReminder.toMap())});
            }
          }
        }
      }
      if (!found) {
        if (Platform.isIOS) {
          reminderMethodChannel
              .invokeMethod(addReminderMethod, [apiReminder.toMap()]);
        } else {
          reminderMethodChannelAndroid.invokeMethod(
              addReminderMethod, {'data': jsonEncode(apiReminder.toMap())});
        }
      }
    }

    for (var i = 0; i < localReminders.length; i++) {
      final localReminder = localReminders[i];
      if (!data.contains(localReminder)) {
        if (Platform.isIOS) {
          reminderMethodChannel
              .invokeMethod(removeReminderMethod, [localReminder.eid]);
        } else {
          reminderMethodChannelAndroid
              .invokeMethod(removeReminderMethod, {'data': localReminder.eid});
        }
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
      if (reminders[i].eid == data.eid) {
        foundTheMatched = reminders.removeAt(i);
        break;
      }

      if (foundTheMatched != null) {
        if (Platform.isIOS) {
          reminderMethodChannel
              .invokeMethod(removeReminderMethod, [foundTheMatched.eid]);
        } else {
          reminderMethodChannelAndroid.invokeMethod(
              removeReminderMethod, {'data': foundTheMatched.eid});
        }
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
        Reminder val = Reminder.fromJson(myJson[i]);
        //final newData = Reminder.fromMap(val);
        notifications.add(val);
      }
      return notifications;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  static deleteAllLocalReminders() async{
    if (Platform.isIOS) {
      reminderMethodChannel.invokeMethod(removeAllReminderMethod);
    } else {
      List<Reminder> reminders = await getLocalReminder();
      for (Reminder r in reminders) {
        reminderMethodChannelAndroid
            .invokeMethod(removeReminderMethod, {'data': r.eid});
      }
    }
    saveRemindersLocally([]);
  }
}
