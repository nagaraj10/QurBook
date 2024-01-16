import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import '../../constants/router_variable.dart' as router;
import '../../main.dart';

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
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await FirebaseMessaging.instance.getToken();
      _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
      _tokenStream.listen(setToken);
      if (token == null) {
        // Token may be null if the server is unable to generate it
        // or if the app hasn't been configured with FCM correctly.
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
    await initPushNotification();
    await initLocalNotification();
  }


  Future initPushNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get the initial message when the app is launched from terminated state
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print(
          '212121 message killed:${initialMessage.data} Notification:${initialMessage.notification}');
    }

    FirebaseMessaging.onBackgroundMessage(onBackgroundMessageReceived);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print(
          '212121 message open:${message.data} Notification:${message.notification}');
    });

// Called when the app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print(
          '212121 message data:${message.data} Notification:${message.notification}');

    });
    // Just handling the notification when App is in background
  }

  Future initLocalNotification() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    List<DarwinNotificationCategory> darwinIOSCategories = [
      DarwinNotificationCategory(
        'darwinCall_category',
        actions: [
          DarwinNotificationAction.text(
            'accept_action',
            'Accept',
            buttonTitle: 'Accept',
          ),
          DarwinNotificationAction.plain(
            'reject_action',
            'Reject',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.destructive,
            },
          ),
        ],
      )
    ];
    final iOSSettings = DarwinInitializationSettings(
        requestBadgePermission: false,
        requestAlertPermission: false,
        notificationCategories: darwinIOSCategories);
    final initializationSettings =
    InitializationSettings(android: androidSettings, iOS: iOSSettings);
    await localNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (details) async {
          print('8888: onforegorun:${jsonDecode(details.payload ?? '')}');
          if (details.payload != null) {

          }
        }, onDidReceiveBackgroundNotificationResponse: notificationTapBackground);
  }

  setToken(String? token) async {
    print('FCM Token: $token');
  }

  Future<void> enableIOSNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }
}

@pragma('vm:entry-point')
Future<void> onBackgroundMessageReceived(RemoteMessage message) async {
  try {

  } catch (e) {
    print('2121 catch:$e');
  }
}


Future<void> showNotificationAndroid(RemoteMessage message) async {
  const channel = AndroidNotificationChannel(
    '12345', // id
    'Qurbook_channel', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.high,
  );
  const notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      '12345', // id
      'Qurbook_channel', // title
      priority: Priority.high,
      channelDescription: 'This channel is used for important notifications.',
    ),
  );
  await localNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await localNotificationsPlugin.show(
    Platform.isIOS ? message.notification.hashCode : message.hashCode,
    Platform.isIOS ? message.notification!.title : message.data['title'],
    Platform.isIOS ? message.notification!.body : message.data['body'],
    notificationDetails,
    payload:
    jsonEncode(Platform.isAndroid ? message.data : message.notification),
  );
}


@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  var message = jsonDecode(notificationResponse.payload!);
  var nsRoute = '';
  print('7890: onBackground:${jsonDecode(notificationResponse.payload ?? '')}');
}

Future<void> updateStatus(bool isAccept, String recordId) async {
  try {
    await Firebase.initializeApp();
    final db = FirebaseFirestore.instance;

    final data = <String, dynamic>{
      'call_status': isAccept ? 'accept' : 'decline',
    };
    await db.collection('call_log').doc(recordId).update(data);
  } catch (e) {
    print('firestoreException:${e.toString()}');
  }
}
