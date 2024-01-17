import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../main.dart';
import '../constants/variable_constant.dart';
import '../video_call/services/iOS_Notification_Handler.dart';

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

    FirebaseMessaging.onBackgroundMessage(onBackgroundMessageReceived);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print(
          '212121 message listen:${message.toMap()}');
      if(message.data['type']=='call' && Platform.isAndroid){
          showCallNotification(message);
      }else{
        await showNotification(message);
      }



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
    try{
      await localNotificationsPlugin.initialize(initializationSettings,
          onDidReceiveNotificationResponse: (details)  {
            if (details.payload != null) {
              print('8888: onNotificationTaps:$details)}');
              IosNotificationHandler()..
              isAlreadyLoaded=true
                ..handleNotificationResponse(details.payload!);
            }
          }, onDidReceiveBackgroundNotificationResponse: notificationTapBackground);
    }catch(e){
      print('8888:exception:$e');
    }

  }

  setToken(String? token) async {
    print('FCM Token: $token');
  }
}

@pragma('vm:entry-point')
Future<void> onBackgroundMessageReceived(RemoteMessage message) async {
  try {
  //  showNotification(message);
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
    ),
    iOS: const DarwinNotificationDetails(
      sound: 'ringtone.aiff'
    )
  );
  await localNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidNormalchannel);

  await localNotificationsPlugin.show(
    Platform.isIOS ? message.notification.hashCode : message.hashCode,
    Platform.isIOS ? message.notification!.title : message.data['title'],
    Platform.isIOS ? message.notification!.body : message.data['body'],
    notificationDetails,
    payload:jsonEncode(message.data),
  );
}

void showCallNotification(RemoteMessage message)async{
   AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
      '${callChannel.id}',
      '${callChannel.description}',
      importance: Importance.max,
      priority: Priority.high,
      actions: [
        AndroidNotificationAction(
          'accept_action', // Replace with your own action ID
          'Accept', // Replace with your own action label
          showsUserInterface: true,
        ),
        AndroidNotificationAction(
          'reject_action', // Replace with your own action ID
          'Reject',
          showsUserInterface: true, // Replace with your own action label
        ),
      ]
  );
  final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS:DarwinNotificationDetails(categoryIdentifier:
      'darwinCall_category'));
  await localNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(callChannel);
  localNotificationsPlugin.show(
      Platform.isIOS? message.notification.hashCode:message.hashCode,
      Platform.isIOS? message.notification!.title:message.data['title'],
      Platform.isIOS? message.notification!.body:message.data['body'],
      platformChannelSpecifics,
      payload: jsonEncode(message.data));
}


@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  print('8888: onBackground:${jsonDecode(notificationResponse.payload ?? '')}');
}

Future<void> updateStatus(bool isAccept, String recordId) async {
  try {
    final db = FirebaseFirestore.instance;

    final data = <String, dynamic>{
      'call_status': isAccept ? 'accept' : 'decline',
    };
    await db.collection('call_log').doc(recordId).update(data);
  } catch (e) {
    print('firestoreException:${e.toString()}');
  }
}



///Ios Notification Categories
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

///Notification Channel
final androidNormalchannel = AndroidNotificationChannel(
  '12345', // id
  'Qurbook_channel', // title
  enableVibration: false,
  description:
  'This channel is used for important notifications.', //
  sound: RawResourceAndroidNotificationSound('msg_tone'),
  importance: Importance.high,
);
var callChannel = const AndroidNotificationChannel(
  '5678', // id
  'Qurbook_call_channel',
  enableVibration: false,// title
  description:
  'This channel is used for important notifications.',
  sound: RawResourceAndroidNotificationSound('helium'),// description
  importance: Importance.high,
);
