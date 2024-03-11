import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:package_info/package_info.dart';
import '../reminders/ReminderModel.dart';
import '../../main.dart';
import '../common/CommonUtil.dart';
import '../constants/fhb_parameters.dart'as parameters;
import '../video_call/services/iOS_Notification_Handler.dart';
import 'notification_helper.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:myfhb/constants/variable_constant.dart'as variable;

class PushNotificationService {
  late Stream<String> _tokenStream;
  static final PushNotificationService _instance =
  PushNotificationService._internal();

  factory PushNotificationService() {
    return _instance;
  }
  PushNotificationService._internal();

  Future<void> setupNotification() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await FirebaseMessaging.instance.getToken();
      _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
      _tokenStream.listen(setToken);
      if (token == null) {
        print('unable to retrieve FCM token.');
      } else {
        print('FCM generated.');
        await setToken(token);
      }
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      AppSettings.openNotificationSettings();
      // User denied permission to receive notifications.
      print('User denied permission to receive notifications.');
    }
    List<Future<dynamic>> conCurrentCalls = [
      initPushNotification(),
      initLocalNotification(),
      configureLocalTimeZone(),
    ];

    await Future.wait(conCurrentCalls);
  }

  Future initPushNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onBackgroundMessage(onBackgroundMessageReceived);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (Platform.isIOS) {
        onInitNotification(message);
      } else {
        notificationBasedOnCategory(message);
        // Checking if message data is not null and it contains the 'KIOSK_isSheela' parameter set to 'true'
        if (message.data != null &&
            message.data[parameters.KIOSK_isSheela] != null &&
            message.data[parameters.KIOSK_isSheela] == parameters.strTrue) {
          // Calling the function to handle initialization of notifications
          onInitNotification(message);
        }

      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (Platform.isIOS) {
        final mapResponse = message.data;
        if (message.category != null) {
          mapResponse[strAction] = message.category;
        }
        IosNotificationHandler()
          ..isAlreadyLoaded = true
          ..handleNotificationResponse(mapResponse);
      }
    });
  }

  void readInitialMessage() {
    FirebaseMessaging.instance.getInitialMessage().then((message) async {
      if (message != null) {
        if (message.data[STR_TYPE] == variable.strCall.toLowerCase() && Platform.isAndroid) {
          listenEvent(message.data[strMeetingId]);
          showCallNotification(message);
        } else if (Platform.isIOS) {
          final mapResponse = message.data;
          if (message.category != null) {
            mapResponse[strAction] = message.category;
          }
          IosNotificationHandler()
            ..isAlreadyLoaded = false
            ..handleNotificationResponse(mapResponse);
        } else {
          await showNotification(message);
        }
      }
    }).onError((error, stackTrace) {
      print('212121 getInitialMessage onError: ${error.toString()}');
    });
  }

  Future initLocalNotification() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings(
          strMipmapIcLauncher,
    );

    final iOSSettings = DarwinInitializationSettings(
        notificationCategories: darwinIOSCategories);
    final initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iOSSettings);
    await localNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (details) async {
      final Map<String, dynamic> mapResponse = jsonDecode(details.payload!);
      if (details.payload != null) {
        if (details.actionId != null) {
          mapResponse[strAction] = details.actionId;
        }
        IosNotificationHandler()
          ..isAlreadyLoaded = true
          ..handleNotificationResponse(mapResponse);
      }
    }, onDidReceiveBackgroundNotificationResponse: notificationTapBackground);
  }

  setToken(String? token) async {
    print('FCM Token: $token');
  }
}

notificationBasedOnCategory(RemoteMessage message) {
  if (message.data['type'] == variable.strCall.toLowerCase && Platform.isAndroid) {
    listenEvent(message.data[strMeetingId]);
    showCallNotification(message);
  } else {
    if (message.data[strTemplateName] == parameters.familyMemberCaregiverRequest) {
      showFamilyMemberNotifications(message);
    } else if (message.data.containsKey(parameters.associationNotificationToCaregiver)) {
      showViewMemberAndCommunication(message);
    } else if (message.data[strTemplateName] ==
        parameters.notifyCaregiverForMedicalRecord) {
      showNotificationCaregiverForMedicalRecord(message);
    } else if (message.data[strTemplateName] ==
        parameters.careGiverTransportRequestReminder ||
        message.data[strTemplateName] == strVoiceClonePatientAssignment) {
      showNotificationCareGiverTransportRequestReminder(message);
    } else if (message.data[parameters.strRedirectTo] == parameters.myCartDetails) {
      showNotificationRenewNotification(message);
    } else if (message.data[parameters.strRedirectTo] ==
        parameters.escalateToCareCoordinatorToRegimen) {
      showNotificationEscalate(message);
    } else if (message.data[parameters.strRedirectTo] == strFamilyProfile) {
      showNotificationForFamilyAddition(message);
    } else if (message.data[parameters.strRedirectTo] == strAppointmentPayment &&
        Platform.isAndroid) {
      showNotificationForAppointmentPayment(message);
    } else if (message.data[parameters.strRedirectTo] == strMycart && Platform.isAndroid) {
      showNotificationForMyCartPayment(message);
    } else {
      showNotification(message);
    }
  }
}

@pragma('vm:entry-point')
Future<void> onBackgroundMessageReceived(RemoteMessage message) async {
  ///We are Binding values to identify the region on main.dart file
  ///that will works only in background and in Foreground
  ///To identify in killed state i have used the packageInfo library which already exists
  ///Based on app name we can bind Icons.
  try {
    if(CommonUtil.AppName.trim().isEmpty){
      var packageInfo = await PackageInfo.fromPlatform();
      CommonUtil.AppName= packageInfo.appName;
    }
    if (Platform.isIOS) {
      onInitNotification(message);
    } else {
      notificationBasedOnCategory(message);
    }
  } catch (e) {
    print('2121 catch:$e');
  }
}

Future<void> showNotification(RemoteMessage message) async {
  final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        '${androidNormalchannel.id}', // id
        '${androidNormalchannel.name}', // title
        priority: Priority.high,
        channelDescription: '${androidNormalchannel.description}',
        icon: getIconBasedOnRegion(isSmallIcon: true),
        largeIcon: DrawableResourceAndroidBitmap(
            getIconBasedOnRegion(isSmallIcon: false)),
      ),
      iOS: const DarwinNotificationDetails(sound: strRingtoneIOS));
  await localNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidNormalchannel);

  await localNotificationsPlugin.show(
      Platform.isIOS ? message.notification.hashCode : message.hashCode,
      Platform.isIOS ? message.notification!.title : message.data[parameters.strtitle],
      Platform.isIOS ? message.notification!.body : message.data[parameters.body],
      notificationDetails,
      payload: jsonEncode(message.data));
}

void showCallNotification(RemoteMessage message) async {
  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    '${callChannel.id}',
    '${callChannel.description}',
    importance: Importance.max,
    icon: getIconBasedOnRegion(isSmallIcon: true),
    largeIcon:
        DrawableResourceAndroidBitmap(getIconBasedOnRegion(isSmallIcon: false)),
    priority: Priority.high,
    timeoutAfter: 30 * 1000,
    actions: [acceptAction, declineAction],
    ongoing: true,
  );
  final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS:
          DarwinNotificationDetails(categoryIdentifier: strDarwinCallCategory));
  await localNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(callChannel);
  localNotificationsPlugin.show(
      Platform.isIOS ? message.notification.hashCode : 5678,
      Platform.isIOS ? message.notification!.title : message.data[parameters.strtitle],
      Platform.isIOS ? message.notification!.body : message.data[parameters.body],
      platformChannelSpecifics,
      payload: jsonEncode(message.data));
}

void showFamilyMemberNotifications(RemoteMessage message) async {
  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    '${androidNormalchannel.id}',
    '${androidNormalchannel.description}',
    importance: Importance.max,
    priority: Priority.high,
    actions: [acceptAction, rejectAction],
    icon: getIconBasedOnRegion(isSmallIcon: true),
    largeIcon:
        DrawableResourceAndroidBitmap(getIconBasedOnRegion(isSmallIcon: false)),
  );
  final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS:
          DarwinNotificationDetails(categoryIdentifier: strDarwinCallCategory));
  await localNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(callChannel);
  localNotificationsPlugin.show(
      Platform.isIOS ? message.notification.hashCode : message.data.hashCode,
      Platform.isIOS ? message.notification!.title : message.data[parameters.strtitle],
      Platform.isIOS ? message.notification!.body : message.data[parameters.body],
      platformChannelSpecifics,
      payload: jsonEncode(message.data));
}

void showViewMemberAndCommunication(RemoteMessage message) async {
  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
          '${androidNormalchannel.id}', '${androidNormalchannel.description}',
          importance: Importance.max,
          priority: Priority.high,
          icon: getIconBasedOnRegion(isSmallIcon: true),
          largeIcon: DrawableResourceAndroidBitmap(
              getIconBasedOnRegion(isSmallIcon: false)),
          actions: [viewMemberAction, communicationSettingAction]);
  final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(
          categoryIdentifier: strShowViewMemberAndCommunicationButtons));

  await localNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(callChannel);
  localNotificationsPlugin.show(
      Platform.isIOS ? message.notification.hashCode : message.data.hashCode,
      Platform.isIOS ? message.notification!.title : message.data[parameters.strtitle],
      Platform.isIOS ? message.notification!.body : message.data[parameters.body],
      platformChannelSpecifics,
      payload: jsonEncode(message.data));
}

void showNotificationCaregiverForMedicalRecord(RemoteMessage message) async {
  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
          '${androidNormalchannel.id}', '${androidNormalchannel.description}',
          importance: Importance.max,
          priority: Priority.high,
          category: AndroidNotificationCategory.reminder,
          icon: getIconBasedOnRegion(isSmallIcon: true),
          largeIcon: DrawableResourceAndroidBitmap(
              getIconBasedOnRegion(isSmallIcon: false)),
          actions: [chatwithccAction, viewRecordAction]);
  final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(
          categoryIdentifier: strChatCCAndViewrecordButtons));

  await localNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(callChannel);
  localNotificationsPlugin.show(
      Platform.isIOS ? message.notification.hashCode : message.data.hashCode,
      Platform.isIOS ? message.notification!.title : message.data[parameters.strtitle],
      Platform.isIOS ? message.notification!.body : message.data[parameters.body],
      platformChannelSpecifics,
      payload: jsonEncode(message.data));
}

void showNotificationCareGiverTransportRequestReminder(
    RemoteMessage message) async {
  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
          '${androidNormalchannel.id}', '${androidNormalchannel.description}',
          importance: Importance.max,
          priority: Priority.high,
          category: AndroidNotificationCategory.reminder,
          icon: getIconBasedOnRegion(isSmallIcon: true),
          largeIcon: DrawableResourceAndroidBitmap(
              getIconBasedOnRegion(isSmallIcon: false)),
          actions: [acceptAction, declineAction]);
  final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(
          categoryIdentifier: strShowTransportationNotification));

  await localNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(callChannel);
  localNotificationsPlugin.show(
      Platform.isIOS ? message.notification.hashCode : message.data.hashCode,
      Platform.isIOS ? message.notification!.title : message.data[parameters.strtitle],
      Platform.isIOS ? message.notification!.body : message.data[parameters.body],
      platformChannelSpecifics,
      payload: jsonEncode(message.data));
}

void showNotificationRenewNotification(RemoteMessage message) async {
  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
          '${androidNormalchannel.id}', '${androidNormalchannel.description}',
          importance: Importance.max,
          priority: Priority.high,
          category: AndroidNotificationCategory.reminder,
          icon: getIconBasedOnRegion(isSmallIcon: true),
          largeIcon: DrawableResourceAndroidBitmap(
              getIconBasedOnRegion(isSmallIcon: false)),
          actions: [renewalAction, callBackAction]);
  final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(categoryIdentifier: strPlanRenewButton));

  await localNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(callChannel);
  localNotificationsPlugin.show(
      Platform.isIOS ? message.notification.hashCode : message.data.hashCode,
      Platform.isIOS ? message.notification!.title : message.data[parameters.strtitle],
      Platform.isIOS ? message.notification!.body : message.data[parameters.body],
      platformChannelSpecifics,
      payload: jsonEncode(message.data));
}

void showNotificationEscalate(RemoteMessage message) async {
  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
          '${androidNormalchannel.id}', '${androidNormalchannel.description}',
          importance: Importance.max,
          priority: Priority.high,
          category: AndroidNotificationCategory.reminder,
          icon: getIconBasedOnRegion(isSmallIcon: true),
          largeIcon: DrawableResourceAndroidBitmap(
              getIconBasedOnRegion(isSmallIcon: false)),
          actions: [escalateAction]);
  final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(
          categoryIdentifier: strEscalateToCareCoordinatorButtons));

  await localNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(callChannel);
  localNotificationsPlugin.show(
      Platform.isIOS ? message.notification.hashCode : message.data.hashCode,
      Platform.isIOS ? message.notification!.title : message.data[parameters.strtitle],
      Platform.isIOS ? message.notification!.body : message.data[parameters.body],
      platformChannelSpecifics,
      payload: jsonEncode(message.data));
}

void showNotificationForFamilyAddition(RemoteMessage message) async {
  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
          '${androidNormalchannel.id}', '${androidNormalchannel.description}',
          importance: Importance.max,
          priority: Priority.high,
          category: AndroidNotificationCategory.reminder,
          icon: getIconBasedOnRegion(isSmallIcon: true),
          largeIcon: DrawableResourceAndroidBitmap(
              getIconBasedOnRegion(isSmallIcon: false)),
          actions: [viewDetailsAction]);
  final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(categoryIdentifier: strViewDetailsButton));

  await localNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(callChannel);
  localNotificationsPlugin.show(
      Platform.isIOS ? message.notification.hashCode : message.data.hashCode,
      Platform.isIOS ? message.notification!.title : message.data[parameters.strtitle],
      Platform.isIOS ? message.notification!.body : message.data[parameters.body],
      platformChannelSpecifics,
      payload: jsonEncode(message.data));
}

void showNotificationForAppointmentPayment(RemoteMessage message) async {
  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
          '${androidNormalchannel.id}', '${androidNormalchannel.description}',
          importance: Importance.max,
          priority: Priority.high,
          category: AndroidNotificationCategory.reminder,
          icon: getIconBasedOnRegion(isSmallIcon: true),
          largeIcon: DrawableResourceAndroidBitmap(
              getIconBasedOnRegion(isSmallIcon: false)),
          actions: [payNowAction]);
  final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(categoryIdentifier: strPayNowButton));

  await localNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(callChannel);
  localNotificationsPlugin.show(
      Platform.isIOS ? message.notification.hashCode : message.data.hashCode,
      Platform.isIOS ? message.notification!.title : message.data[parameters.strtitle],
      Platform.isIOS ? message.notification!.body : message.data[parameters.body],
      platformChannelSpecifics,
      payload: jsonEncode(message.data));
}

void showNotificationForMyCartPayment(RemoteMessage message) async {
  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
          '${androidNormalchannel.id}', '${androidNormalchannel.description}',
          importance: Importance.max,
          priority: Priority.high,
          category: AndroidNotificationCategory.reminder,
          icon: getIconBasedOnRegion(isSmallIcon: true),
          largeIcon: DrawableResourceAndroidBitmap(
              getIconBasedOnRegion(isSmallIcon: false)),
          actions: [payNowAction]);
  final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(categoryIdentifier: strPayNowButton));

  await localNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(callChannel);
  localNotificationsPlugin.show(
      Platform.isIOS ? message.notification.hashCode : message.data.hashCode,
      Platform.isIOS ? message.notification!.title : message.data[parameters.strtitle],
      Platform.isIOS ? message.notification!.body : message.data[parameters.body],
      platformChannelSpecifics,
      payload: jsonEncode(message.data));
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
}

void listenEvent(String meetingId) {
  FirebaseFirestore.instance
      .collection(strCallLog)
      .doc(meetingId)
      .snapshots()
      .listen((DocumentSnapshot snapshot) {
    if (snapshot.exists) {
      String callStatus = snapshot[strCallStatus];

      if (callStatus == strCallEndedByUser ||
          callStatus == parameters.accept.toLowerCase() ||
          callStatus == parameters.decline.toLowerCase()) {
        localNotificationsPlugin.cancel(5678);
      }
    }
  }, onError: (Object error) {});
}

getIconBasedOnRegion({required bool isSmallIcon}) {

  if (isSmallIcon) {
    if (CommonUtil.AppName.toLowerCase().trim().toString()==AppNameConstants.QURHOME) {
      return strAppNsQurhomeIcon;
    }else if(CommonUtil.AppName.toLowerCase().trim().toString()==AppNameConstants.QURDAY){
      return strAppNsQurdayIcon;
    }
    return strAppNsQurbookIcon;
  } else {
    if (CommonUtil.AppName.toLowerCase().trim().toString()==AppNameConstants.QURHOME) {
      return strIcLauncherQurhome;
    }
    else if(CommonUtil.AppName.toLowerCase().trim().toString()==AppNameConstants.QURDAY){
      return strIcLauncherQurDay;
    }
    return strIcLauncherQurbook;
  }
}

// Initialize the local time zone.
configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterTimezone.getLocalTimezone();
  final timeZoneTemp = tz.getLocation(timeZoneName!);
  tz.setLocalLocation(timeZoneTemp);
}

// Initialize scheduling of notifications based on a Reminder object.
onInitScheduleNotification(Reminder? reminder) async {
  try {
    if (reminder == null) {
      return; // Handle null reminder case
    }

    await scheduleReminder(reminder.remindbefore, reminder, subtract: true);

    var eventDateTime = reminder.estart ?? '';
    var scheduledDate = parseDateTimeFromString(eventDateTime);

    if (scheduledDate.isAfter(tz.TZDateTime.now(tz.local))) {
      final notificationId =
          int.tryParse('${reminder?.notificationListId}') ?? 0;
      await zonedScheduleNotification(
          reminder, notificationId, scheduledDate, true, false);
    }

    await scheduleReminder(reminder.remindin, reminder, subtract: false);

    // Check if repeat Every reminder is true in otherinfo of the reminder
    if (reminder.otherinfo?.postRemindercheck ?? false) {
      // If true, schedule repeating reminders based on postreminderdurationbyminutes
      await scheduleRepeatEveryReminder(
        reminder.otherinfo?.postreminderdurationbyminutes, reminder,
        subtract: false,
      );
    }

  } catch (e, stackTrace) {
    CommonUtil().appLogs(message: e, stackTrace: stackTrace);
  }
}

// Schedule a reminder based on the specified duration before or after the event.
scheduleReminder(String? remindDuration, Reminder reminder,
    {bool subtract = false}) async {
  try {
    if (remindDuration != null && (int.tryParse(remindDuration) ?? 0) > 0) {
      var eventDateTime = reminder.estart ?? '';
      var scheduledDate = parseDateTimeFromString(eventDateTime);

      var remindDurationInMinutes = int.parse(remindDuration);
      scheduledDate = subtract
          ? scheduledDate.subtract(Duration(minutes: remindDurationInMinutes))
          : scheduledDate.add(Duration(minutes: remindDurationInMinutes));

      if (scheduledDate.isAfter(tz.TZDateTime.now(tz.local))) {
        final notificationId =
        calculateNotificationId(reminder, subtract);
        await zonedScheduleNotification(
            reminder, notificationId, scheduledDate, false, false);
      }
    }
  } catch (e, stackTrace) {
    CommonUtil().appLogs(message: e, stackTrace: stackTrace);
  }
}

// Schedule repeating reminders based on a specified duration and reminder details
scheduleRepeatEveryReminder(String? remindDuration, Reminder reminder,
    {bool subtract = false}) async {
  try {
    // Check if remindDuration is not null and is a positive integer
    if (remindDuration != null && (int.tryParse(remindDuration) ?? 0) > 0) {
      // Parse remindIn and remindDuration to integers
      int? remindInInt = int.tryParse(reminder.remindin ?? '0');
      int? remindDurationInt = int.tryParse(remindDuration ?? '0');

      // Check if parsed values are not null and greater than 0
      if ((remindInInt != null) &&
          (remindDurationInt != null) &&
          (remindDurationInt > 0) &&
          (remindInInt > 0)) {

        // Calculate the number of reminders to schedule
        double numberOfReminders = remindDurationInt.toDouble() / remindInInt.toDouble();
        int numberOfRemindersInt = numberOfReminders.toInt();

        // Check if there are more than 0 reminders to schedule
        if (numberOfRemindersInt > 0) {

          // Loop through the reminders to schedule
          for (int i = 0; i < numberOfRemindersInt-1; i++) {
            // Extract eventDateTime from the reminder
            var eventDateTime = reminder.estart ?? '';

            // Parse eventDateTime to a DateTime object
            var scheduledDate = parseDateTimeFromString(eventDateTime);

            // Calculate the time for the next reminder
            var avoidActualReminder = scheduledDate.add(Duration(minutes: remindInInt));
            var avoidPostReminder = avoidActualReminder.add(Duration(minutes: remindInInt));

            // Calculate the adjusted reminder time based on the iteration
            var remindDurationInMinutes = int.parse(remindDuration);
            avoidPostReminder = subtract
                ? avoidPostReminder.subtract(Duration(minutes: remindDurationInMinutes))
                : avoidPostReminder.add(Duration(minutes: i * remindInInt));

            // Check if the calculated reminder time is in the future
            if (avoidPostReminder.isAfter(tz.TZDateTime.now(tz.local))) {
              // Generate a unique notification ID based on iteration and reminder ID
              final notificationId = toSigned32BitInt(int.tryParse('${i+1}${reminder.eid}') ?? 0);

              // Schedule the notification
              await zonedScheduleNotification(
                  reminder, notificationId, avoidPostReminder, false, false);
            }
          }
        }
      }
    }
  } catch (e, stackTrace) {
    // Log any exceptions or errors
    CommonUtil().appLogs(message: e, stackTrace: stackTrace);
  }
}

// Schedule a notification using FlutterLocalNotificationsPlugin with specified configurations.
zonedScheduleNotification(
    Reminder? reminder,
    int notificationId,
    tz.TZDateTime scheduledDateTime,
    bool isButtonShown,
    bool isSnoozePress,
    ) async {
  try {

    // Initialize SheelaAIController
    final sheelaAIController = CommonUtil().onInitSheelaAIController();

    // Get the list of pending notifications
    List<PendingNotificationRequest> pendingNotifications =
    await localNotificationsPlugin.pendingNotificationRequests();

    // Check if the notification with the given ID is already scheduled
    bool isScheduled = pendingNotifications.any(
          (notification) => notification.id == notificationId,
    );


    var isDismissButtonOnlyShown = false;
    var channelId = remainderScheduleChannel.id;
    var channelName = remainderScheduleChannel.name;
    var channelDescription = remainderScheduleChannel.description;

    // Use V3 channel for high importance reminders.
    if (reminder?.importance == '2') {
      channelId = remainderScheduleV3Channel.id;
      channelName = remainderScheduleV3Channel.name;
      channelDescription = remainderScheduleV3Channel.description;
    }

    // Increment snoozeTapCountTime if snooze button is pressed
    reminder?.snoozeTapCountTime =
    (isButtonShown & isSnoozePress) ? (reminder?.snoozeTapCountTime ?? 0) + 1 : null;

    // Adjust scheduled time for snooze actions
    if (isSnoozePress && (reminder?.snoozeTapCountTime ?? 0) <= 1) {
      var now = tz.TZDateTime.now(tz.local);
      scheduledDateTime = now.add(const Duration(minutes: 5));
    } else if (isButtonShown & isSnoozePress) {
      var now = tz.TZDateTime.now(tz.local);
      scheduledDateTime = now.add(const Duration(minutes: 5));
      isDismissButtonOnlyShown = true;
    }

    // Create a copy of the reminder and update the notificationListId property
    Reminder reminderTemp = Reminder.fromJson(reminder!.toJson());
    reminderTemp.notificationListId = notificationId.toString();

    // Encode the reminder data to JSON
    var payLoadData = jsonEncode(reminderTemp?.toMap());

    // Create notification details based on platform
    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        priority: Priority.high,
        channelDescription: channelDescription,
        icon: getIconBasedOnRegion(isSmallIcon: true),
        largeIcon: DrawableResourceAndroidBitmap(getIconBasedOnRegion(isSmallIcon: false)),
        actions: isButtonShown
            ? isDismissButtonOnlyShown
            ? [dismissAction]
            : [dismissAction, snoozeAction]
            : null,
      ),
      iOS: isButtonShown
          ? isDismissButtonOnlyShown
          ? const DarwinNotificationDetails(categoryIdentifier: strShowSingleButtonCat)
          : const DarwinNotificationDetails(categoryIdentifier: strShowBothButtonsCat)
          : const DarwinNotificationDetails(sound: strRingtoneIOS, categoryIdentifier: strShowSingleButtonCat),
    );

    // Resolve Android specific implementation to create the notification channel
    await localNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
      reminderTemp?.importance == '2' ? remainderScheduleV3Channel : remainderScheduleChannel,
    );


    if (isScheduled) {
      // If the reminder is scheduled, add the scheduled time using SheelaAIController
      await sheelaAIController.addScheduledTime(reminderTemp!, scheduledDateTime);
      return;
    }


    // List to hold asynchronous function calls
    var functionCalls = <Future<dynamic>>[
      // Schedule a local notification
      localNotificationsPlugin.zonedSchedule(
        notificationId,
        reminderTemp?.title ?? strScheduledtitle,
        reminderTemp?.description ?? strScheduledbody,
        scheduledDateTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payLoadData,
      ),
      // Add scheduled time using SheelaAIController
      sheelaAIController.addScheduledTime(reminderTemp!, scheduledDateTime),
    ];

    // Wait for all functions to complete
    await Future.wait(functionCalls);

  } catch (e, stackTrace) {
    // Handle exceptions and log errors
    CommonUtil().appLogs(message: e, stackTrace: stackTrace);
  }
}


// Convert an integer to a signed 32-bit integer.
int toSigned32BitInt(int value) {
  // Apply bitwise AND operation to ensure the result is a signed 32-bit integer.
  return value & 0xFFFFFFFF;
}

// Parse a date-time string into a timezone-aware DateTime object.
tz.TZDateTime parseDateTimeFromString(String dateTimeString) {
  // Split the date and time components from the input string.
  var date = dateTimeString.split(' ')[0];
  var time = dateTimeString.split(' ')[1];

  // Parse the date-time string and create a DateTime object.
  var dateTime = DateTime.parse('$date $time');

  // Convert the DateTime object to a timezone-aware TZDateTime using the local timezone.
  return tz.TZDateTime.from(dateTime, tz.local);
}

// Calculate a notification ID based on the reminder and a subtraction flag.
int calculateNotificationId(Reminder reminder, bool subtract) {
  // Create a base ID by prefixing with '0' or '1' based on the subtraction flag.
  var baseId = subtract ? '${reminder.eid}00' : '${reminder.eid}11';
  // Convert the base ID to a signed 32-bit integer using the toSigned32BitInt function.
  return toSigned32BitInt(int.tryParse(baseId) ?? 0);
}


// Function to handle initialization of notifications
void onInitNotification(RemoteMessage message) {
  try {
    // Extracting data from the message
    final mapResponse = message.data;

    // Checking if the message has a category
    if (message.category != null) {
      // Assigning the message category to the 'strAction' key in the mapResponse
      mapResponse[strAction] = message.category;
    }

    // Handling iOS notifications
    IosNotificationHandler()
      ..isAlreadyLoaded = true // Setting the notification handler as already loaded
      ..handleNotificationResponse(mapResponse); // Handling the notification response
  } catch (e, stackTrace) {
    // Handling exceptions and logging errors
    CommonUtil().appLogs(message: e, stackTrace: stackTrace);
  }
}



