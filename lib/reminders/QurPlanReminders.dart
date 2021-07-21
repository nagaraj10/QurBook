import 'dart:convert';
import 'dart:io';
import 'package:myfhb/src/resources/network/api_services.dart';

import '../common/CommonUtil.dart';
import '../constants/HeaderRequest.dart';
import '../constants/variable_constant.dart';
import 'ReminderModel.dart';
import '../src/utils/FHBUtils.dart';
import 'package:myfhb/src/resources/network/api_services.dart';
import '../constants/fhb_constants.dart' as Constants;

class QurPlanReminders {
  static const reminderLocalFile = 'notificationList.json';

  static getTheRemindersFromAPI() async {
    //final fileName = 'assets/tempData.json';

    //final dataString = await rootBundle.loadString(fileName);
    final headerRequest = HeaderRequest();
    var headers = await headerRequest.getRequestHeadersAuthContents();
    var now = DateTime.now();
    var dayAfterTomorrowDate = DateTime(now.year, now.month, now.day + 2);
    var today = CommonUtil().dateConversionToApiFormat(now);
    var dayAfterTomorrow =
        CommonUtil().dateConversionToApiFormat(dayAfterTomorrowDate);
    final _baseUrl = Constants.BASE_URL;
    var params = jsonEncode({
      'method': 'get',
      'data':
          'Action=GetUserReminders&startdate=$today&enddate=$dayAfterTomorrow'
    });
    try {
      var responseFromApi = await ApiServices.post(
          _baseUrl + 'plan-package-master/wrapperApi',
          headers: headers,
          body: params);

      var dataArray = await json.decode(responseFromApi.body);
      final List<dynamic> data = dataArray['result'];
      var reminders = <Reminder>[];
      data.forEach((element) {
        var newData = Reminder.fromMap(element);
        print(newData.estart);
        reminders.add(newData);
      });
      await updateReminderswithLocal(reminders);
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<bool> addReminder(Reminder data) {
    var reminderMap = data.toMap();
    if (Platform.isIOS) {
      reminderMethodChannel.invokeMethod(addReminderMethod, [reminderMap]);
    } else {
      reminderMethodChannelAndroid
          .invokeMethod(addReminderMethod, {'data': jsonEncode(reminderMap)});
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
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  static Future<bool> updateRemindersLocally(Reminder data) async {
    final reminders = await getLocalReminder();
    Reminder foundTheMatched;
    for (var i = 0; i < reminders.length; i++) {
      if (reminders[i].eid == data.eid) {
        foundTheMatched = reminders.removeAt(i);
        break;
      }

      if (foundTheMatched != null) {
        if (Platform.isIOS) {
          await reminderMethodChannel
              .invokeMethod(removeReminderMethod, [foundTheMatched.eid]);
        } else {
          await reminderMethodChannelAndroid.invokeMethod(
              removeReminderMethod, {'data': foundTheMatched.eid});
        }
      }
      reminders.add(data);
    }
  }

  static Future<bool> updateReminderswithLocal(List<Reminder> data) async {
    var localReminders = await getLocalReminder();

    for (var i = 0; i < data.length; i++) {
      var apiReminder = data[i];
      var found = false;
      for (var j = 0; j < localReminders.length; j++) {
        var localReminder = localReminders[j];
        if (apiReminder.eid == localReminder.eid) {
          found = true;
          if (apiReminder == localReminder) {
            if (Platform.isIOS) {
              apiReminder.alreadyScheduled = true;
              await reminderMethodChannel
                  .invokeMethod(addReminderMethod, [apiReminder.toMap()]);
            }
            break;
          } else {
            if (Platform.isIOS) {
              await reminderMethodChannel
                  .invokeMethod(removeReminderMethod, [localReminder.eid]);
              await reminderMethodChannel
                  .invokeMethod(addReminderMethod, [apiReminder.toMap()]);
            } else {
              await reminderMethodChannelAndroid.invokeMethod(
                  removeReminderMethod, {'data': localReminder.eid});
              await reminderMethodChannelAndroid.invokeMethod(
                  addReminderMethod, {'data': jsonEncode(apiReminder.toMap())});
            }
          }
        }
      }
      if (!found) {
        if (Platform.isIOS) {
          await reminderMethodChannel
              .invokeMethod(addReminderMethod, [apiReminder.toMap()]);
        } else {
          await reminderMethodChannelAndroid.invokeMethod(
              addReminderMethod, {'data': jsonEncode(apiReminder.toMap())});
        }
      }
    }

    for (var i = 0; i < localReminders.length; i++) {
      var localReminder = localReminders[i];
      if (!data.contains(localReminder)) {
        if (Platform.isIOS) {
          await reminderMethodChannel
              .invokeMethod(removeReminderMethod, [localReminder.eid]);
        } else {
          await reminderMethodChannelAndroid
              .invokeMethod(removeReminderMethod, {'data': localReminder.eid});
        }
      }
    }
    await saveRemindersLocally(data);
  }

  static Future<bool> deleteReminderLocally(Reminder data) async {
    final reminders = await getLocalReminder();
    Reminder foundTheMatched;

    if (reminders.isEmpty) {
      return false;
    }
    for (var i = 0; i < reminders.length; i++) {
      if (reminders[i].eid == data.eid) {
        foundTheMatched = reminders.removeAt(i);
        break;
      }

      if (foundTheMatched != null) {
        if (Platform.isIOS) {
          await reminderMethodChannel
              .invokeMethod(removeReminderMethod, [foundTheMatched.eid]);
        } else {
          await reminderMethodChannelAndroid.invokeMethod(
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
      var directory = Platform.isIOS
          ? await FHBUtils.createFolderInAppDocDirForIOS('reminders')
          : await FHBUtils.abstractUserData();

      var file = Platform.isIOS
          ? File('$directory$reminderLocalFile')
          : File('$directory/$reminderLocalFile');
      var data = await file.readAsString();
      var decodedData = await json.decode(data);

      final List<dynamic> myJson = decodedData['reminders'];

      final notifications = <Reminder>[];
      for (var i = 0; i < myJson.length; i++) {
        var val = Reminder.fromJson(myJson[i]);
        //final newData = Reminder.fromMap(val);
        notifications.add(val);
      }
      return notifications;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  static deleteAllLocalReminders() async {
    if (Platform.isIOS) {
      await reminderMethodChannel.invokeMethod(removeAllReminderMethod);
    } else {
      var reminders = await getLocalReminder();
      for (var r in reminders) {
        await reminderMethodChannelAndroid
            .invokeMethod(removeReminderMethod, {'data': r.eid});
      }
    }
    await saveRemindersLocally([]);
  }
}
