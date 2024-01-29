import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import '../reminders/ReminderModel.dart';
import '../../main.dart';
import '../common/CommonUtil.dart';
import '../constants/fhb_parameters.dart';
import '../video_call/services/iOS_Notification_Handler.dart';
import 'notification_helper.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

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
        final mapResponse = message.data;
        if (message.category != null) {
          mapResponse['action'] = message.category;
        }
        IosNotificationHandler()
          ..isAlreadyLoaded = true
          ..handleNotificationResponse(mapResponse);
      } else {
        notificationBasedOnCategory(message);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('212121 onMessageOpenedApp listen:${message.toMap()}');
      if (Platform.isIOS) {
        final mapResponse = message.data;
        if (message.category != null) {
          mapResponse['action'] = message.category;
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
        if (message.data['type'] == 'call' && Platform.isAndroid) {
          listenEvent(message.data['meeting_id']);
          showCallNotification(message);
        } else if (Platform.isIOS) {
          final mapResponse = message.data;
          if (message.category != null) {
            mapResponse['action'] = message.category;
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
      '@mipmap/ic_launcher',
    );

    final iOSSettings = DarwinInitializationSettings(
        notificationCategories: darwinIOSCategories);
    final initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iOSSettings);
    await localNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (details) async {
      print(
          '212121 onDidReceiveNotificationResponse details: ${details.payload}');
      final Map<String, dynamic> mapResponse = jsonDecode(details.payload!);
      if (details.payload != null) {
        if (details.actionId != null) {
          mapResponse['action'] = details.actionId;
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
  if (message.data['type'] == 'call' && Platform.isAndroid) {
    listenEvent(message.data['meeting_id']);
    showCallNotification(message);
  } else {
    if (message.data['templateName'] == familyMemberCaregiverRequest) {
      showFamilyMemberNotifications(message);
    } else if (message.data.containsKey('associationNotificationToCaregiver')) {
      showViewMemberAndCommunication(message);
    } else if (message.data['templateName'] ==
        'notifyCaregiverForMedicalRecord') {
      showNotificationCaregiverForMedicalRecord(message);
    } else if (message.data['templateName'] ==
            'careGiverTransportRequestReminder' ||
        message.data['templateName'] == 'voiceClonePatientAssignment') {
      showNotificationCareGiverTransportRequestReminder(message);
    } else if (message.data['redirectTo'] == 'mycartdetails') {
      showNotificationRenewNotification(message);
    } else if (message.data['redirectTo'] ==
        'escalateToCareCoordinatorToRegimen') {
      showNotificationEscalate(message);
    } else if (message.data['redirectTo'] == 'familyProfile') {
      showNotificationForFamilyAddition(message);
    } else if (message.data['redirectTo'] == 'appointmentPayment' &&
        Platform.isAndroid) {
      showNotificationForAppointmentPayment(message);
    } else if (message.data['redirectTo'] == 'mycart' && Platform.isAndroid) {
      showNotificationForMyCartPayment(message);
    } else {
      showNotification(message);
    }
  }
}

@pragma('vm:entry-point')
Future<void> onBackgroundMessageReceived(RemoteMessage message) async {
  try {
    if (Platform.isIOS) {
      final mapResponse = message.data;
      if (message.category != null) {
        mapResponse['action'] = message.category;
      }
      IosNotificationHandler()
        ..isAlreadyLoaded = true
        ..handleNotificationResponse(mapResponse);
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
      iOS: const DarwinNotificationDetails(sound: 'ringtone.aiff'));
  await localNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidNormalchannel);

  await localNotificationsPlugin.show(
      Platform.isIOS ? message.notification.hashCode : message.hashCode,
      Platform.isIOS ? message.notification!.title : message.data['title'],
      Platform.isIOS ? message.notification!.body : message.data['body'],
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
          DarwinNotificationDetails(categoryIdentifier: 'darwinCall_category'));
  await localNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(callChannel);
  localNotificationsPlugin.show(
      Platform.isIOS ? message.notification.hashCode : 5678,
      Platform.isIOS ? message.notification!.title : message.data['title'],
      Platform.isIOS ? message.notification!.body : message.data['body'],
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
          DarwinNotificationDetails(categoryIdentifier: 'darwinCall_category'));
  await localNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(callChannel);
  localNotificationsPlugin.show(
      Platform.isIOS ? message.notification.hashCode : message.data.hashCode,
      Platform.isIOS ? message.notification!.title : message.data['title'],
      Platform.isIOS ? message.notification!.body : message.data['body'],
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
          categoryIdentifier: 'showViewMemberAndCommunicationButtons'));

  await localNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(callChannel);
  localNotificationsPlugin.show(
      Platform.isIOS ? message.notification.hashCode : message.data.hashCode,
      Platform.isIOS ? message.notification!.title : message.data['title'],
      Platform.isIOS ? message.notification!.body : message.data['body'],
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
          categoryIdentifier: 'ChatCCAndViewrecordButtons'));

  await localNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(callChannel);
  localNotificationsPlugin.show(
      Platform.isIOS ? message.notification.hashCode : message.data.hashCode,
      Platform.isIOS ? message.notification!.title : message.data['title'],
      Platform.isIOS ? message.notification!.body : message.data['body'],
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
          categoryIdentifier: 'showTransportationNotification'));

  await localNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(callChannel);
  localNotificationsPlugin.show(
      Platform.isIOS ? message.notification.hashCode : message.data.hashCode,
      Platform.isIOS ? message.notification!.title : message.data['title'],
      Platform.isIOS ? message.notification!.body : message.data['body'],
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
      iOS: DarwinNotificationDetails(categoryIdentifier: 'planRenewButton'));

  await localNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(callChannel);
  localNotificationsPlugin.show(
      Platform.isIOS ? message.notification.hashCode : message.data.hashCode,
      Platform.isIOS ? message.notification!.title : message.data['title'],
      Platform.isIOS ? message.notification!.body : message.data['body'],
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
          categoryIdentifier: 'escalateToCareCoordinatorButtons'));

  await localNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(callChannel);
  localNotificationsPlugin.show(
      Platform.isIOS ? message.notification.hashCode : message.data.hashCode,
      Platform.isIOS ? message.notification!.title : message.data['title'],
      Platform.isIOS ? message.notification!.body : message.data['body'],
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
      iOS: DarwinNotificationDetails(categoryIdentifier: 'viewDetailsButton'));

  await localNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(callChannel);
  localNotificationsPlugin.show(
      Platform.isIOS ? message.notification.hashCode : message.data.hashCode,
      Platform.isIOS ? message.notification!.title : message.data['title'],
      Platform.isIOS ? message.notification!.body : message.data['body'],
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
      iOS: DarwinNotificationDetails(categoryIdentifier: 'payNowButton'));

  await localNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(callChannel);
  localNotificationsPlugin.show(
      Platform.isIOS ? message.notification.hashCode : message.data.hashCode,
      Platform.isIOS ? message.notification!.title : message.data['title'],
      Platform.isIOS ? message.notification!.body : message.data['body'],
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
      iOS: DarwinNotificationDetails(categoryIdentifier: 'payNowButton'));

  await localNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(callChannel);
  localNotificationsPlugin.show(
      Platform.isIOS ? message.notification.hashCode : message.data.hashCode,
      Platform.isIOS ? message.notification!.title : message.data['title'],
      Platform.isIOS ? message.notification!.body : message.data['body'],
      platformChannelSpecifics,
      payload: jsonEncode(message.data));
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  print(
      '212121: onBackground:${jsonDecode(notificationResponse.payload ?? '')}');
}

void listenEvent(String meetingId) {
  FirebaseFirestore.instance
      .collection('call_log')
      .doc(meetingId)
      .snapshots()
      .listen((DocumentSnapshot snapshot) {
    if (snapshot.exists) {
      String callStatus = snapshot['call_status'];

      if (callStatus == 'call_ended_by_user' ||
          callStatus == 'accept' ||
          callStatus == 'decline') {
        localNotificationsPlugin.cancel(5678);
      }
    }
  }, onError: (Object error) {});
}

getIconBasedOnRegion({required bool isSmallIcon}) {
  if (isSmallIcon) {
    if (CommonUtil.isUSRegion()) {
      return 'app_ns_qurhome_icon';
    }
    return 'app_ns_qurbook_icon';
  } else {
    if (CommonUtil.isUSRegion()) {
      return 'ic_launcher_qurhome';
    }
    return 'ic_launcher_qurbook';
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

    var eventDateTime = reminder.estart ?? '';
    var scheduledDate = CommonUtil().parseDateTimeFromString(eventDateTime);

    if (scheduledDate.isAfter(tz.TZDateTime.now(tz.local))) {
      final notificationId =
      CommonUtil().toSigned32BitInt(int.tryParse('${reminder.eid}') ?? 0);
      await zonedScheduleNotification(
          reminder, notificationId, scheduledDate, true, false);
    }

    List<Future<dynamic>> conCurrentCalls = [
      scheduleReminder(reminder.remindbefore, reminder, subtract: true),
      scheduleReminder(reminder.remindin, reminder, subtract: false),
    ];

    await Future.wait(conCurrentCalls);
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
      var scheduledDate = CommonUtil().parseDateTimeFromString(eventDateTime);

      var remindDurationInMinutes = int.parse(remindDuration);
      scheduledDate = subtract
          ? scheduledDate.subtract(Duration(minutes: remindDurationInMinutes))
          : scheduledDate.add(Duration(minutes: remindDurationInMinutes));

      if (scheduledDate.isAfter(tz.TZDateTime.now(tz.local))) {
        final notificationId =
        CommonUtil().calculateNotificationId(reminder, subtract);
        await zonedScheduleNotification(
            reminder, notificationId, scheduledDate, false, false);
      }
    }
  } catch (e, stackTrace) {
    CommonUtil().appLogs(message: e, stackTrace: stackTrace);
  }
}

// Schedule a notification using FlutterLocalNotificationsPlugin with specified configurations.
zonedScheduleNotification(
    Reminder? reminder,
    int notificationId,
    tz.TZDateTime scheduledDateTime,
    bool isButtonShown,
    bool isSnoozePress) async {
  try {
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

    reminder?.redirectTo = stringRegimentScreen;
    reminder?.notificationListId = notificationId.toString();
    reminder?.snoozeTapCountTime = (isButtonShown & isSnoozePress)
        ? (reminder?.snoozeTapCountTime ?? 0) + 1
        : 0;

    // Adjust scheduled time for snooze actions.
    if (isSnoozePress && (reminder?.snoozeTapCountTime ?? 0) <= 1) {
      var now = tz.TZDateTime.now(tz.local);
      scheduledDateTime = now.add(const Duration(minutes: 5));
    } else if (isButtonShown & isSnoozePress) {
      var now = tz.TZDateTime.now(tz.local);
      scheduledDateTime = now.add(const Duration(minutes: 5));
      isDismissButtonOnlyShown = true;
    }

    var payLoadData = jsonEncode(reminder?.toMap());

    final notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          channelId, // ID
          channelName, // Title
          priority: Priority.high,
          channelDescription: channelDescription,
          icon: getIconBasedOnRegion(isSmallIcon: true),
          largeIcon: DrawableResourceAndroidBitmap(
              getIconBasedOnRegion(isSmallIcon: false)),
          actions: isButtonShown
              ? isDismissButtonOnlyShown
              ? [dismissAction]
              : [dismissAction, snoozeAction]
              : null,
        ),
        iOS: isButtonShown
            ? isDismissButtonOnlyShown
            ? DarwinNotificationDetails(
            categoryIdentifier: 'showSingleButtonCat')
            : DarwinNotificationDetails(
            categoryIdentifier: 'showBothButtonsCat')
            : DarwinNotificationDetails(sound: 'ringtone.aiff'));
    await localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(reminder?.importance == '2'
        ? remainderScheduleV3Channel
        : remainderScheduleChannel);

    await localNotificationsPlugin.zonedSchedule(
        notificationId,
        reminder?.title ?? 'scheduled title',
        reminder?.description ?? 'scheduled body',
        scheduledDateTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        payload: payLoadData);
    print('Sadham Hussain notificationId $notificationId');
  } catch (e, stackTrace) {
    CommonUtil().appLogs(message: e, stackTrace: stackTrace);
  }
}

