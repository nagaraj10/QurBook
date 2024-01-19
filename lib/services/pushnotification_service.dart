import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../main.dart';
import '../constants/fhb_parameters.dart';
import '../constants/variable_constant.dart';
import '../video_call/services/iOS_Notification_Handler.dart';
import 'notification_helper.dart';

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
          listenEvent(message.data['meeting_id']);
          showCallNotification(message);
      }
      else{
        if(message.data['templateName']==familyMemberCaregiverRequest){
          showFamilyMemberNotifications(message);
        }else if(message.data.containsKey('associationNotificationToCaregiver')){
          showViewMemberAndCommunication(message);
        }else if(message.data['templateName']=='notifyCaregiverForMedicalRecord'){
          showNotificationCaregiverForMedicalRecord(message);
        }else if(message.data['templateName']=='careGiverTransportRequestReminder'|| message.data['templateName']=='voiceClonePatientAssignment'){

        }else{
          showNotification(message);
        }

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
      await localNotificationsPlugin.initialize(initializationSettings,
          onDidReceiveNotificationResponse: (details) async {
        final Map<String,dynamic> mapResponse = jsonDecode(details.payload!);
            if (details.payload != null) {
              if(details.actionId!=null){
                mapResponse['action'] = details.actionId;
              }
              IosNotificationHandler()..
              isAlreadyLoaded=true
                ..handleNotificationResponse(mapResponse);
            }
          }, onDidReceiveBackgroundNotificationResponse: notificationTapBackground);

  }


  setToken(String? token) async {
    print('FCM Token: $token');
  }
}

@pragma('vm:entry-point')
Future<void> onBackgroundMessageReceived(RemoteMessage message) async {
  try {
    print('2121 : on Background Message Received ${message.data}');
    if (message.data['type'] == 'call' && Platform.isAndroid) {
       showCallNotification(message);
    } else {
      showNotification(message);
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
      icon:'app_ns_icon',
      largeIcon:DrawableResourceAndroidBitmap('ic_launcher'),
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
    payload:jsonEncode(message.data)
  );
}

void showCallNotification(RemoteMessage message)async{
   AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
      '${callChannel.id}',
      '${callChannel.description}',
      importance: Importance.max,
      icon:'app_ns_icon',
      largeIcon:DrawableResourceAndroidBitmap('ic_launcher'),
      priority: Priority.high,
      timeoutAfter: 30 * 1000,
      actions:[acceptAction,declineAction],
      ongoing: true,
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
      Platform.isIOS? message.notification.hashCode:5678,
      Platform.isIOS? message.notification!.title:message.data['title'],
      Platform.isIOS? message.notification!.body:message.data['body'],
      platformChannelSpecifics,
      payload: jsonEncode(message.data));
}

void showFamilyMemberNotifications(RemoteMessage message)async{
  AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    '${androidNormalchannel.id}',
    '${androidNormalchannel.description}',
    importance: Importance.max,
    priority: Priority.high,
    actions: [acceptAction,rejectAction],
    icon:'app_ns_icon',
    largeIcon:DrawableResourceAndroidBitmap('ic_launcher'),
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
      Platform.isIOS? message.notification.hashCode:message.data.hashCode,
      Platform.isIOS? message.notification!.title:message.data['title'],
      Platform.isIOS? message.notification!.body:message.data['body'],
      platformChannelSpecifics,
      payload: jsonEncode(message.data));
}
void showViewMemberAndCommunication(RemoteMessage message)async{
  AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    '${androidNormalchannel.id}',
    '${androidNormalchannel.description}',
    importance: Importance.max,
    priority: Priority.high,
      icon:'app_ns_icon',
      largeIcon:DrawableResourceAndroidBitmap('ic_launcher'),
    actions: [viewMemberAction,communicationSettingAction]
  );
  final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS:DarwinNotificationDetails(categoryIdentifier:
      'showViewMemberAndCommunicationButtons'));

  await localNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(callChannel);
  localNotificationsPlugin.show(
      Platform.isIOS? message.notification.hashCode:message.data.hashCode,
      Platform.isIOS? message.notification!.title:message.data['title'],
      Platform.isIOS? message.notification!.body:message.data['body'],
      platformChannelSpecifics,
      payload: jsonEncode(message.data));
}

void showNotificationCaregiverForMedicalRecord(RemoteMessage message)async{
  AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
      '${androidNormalchannel.id}',
      '${androidNormalchannel.description}',
      importance: Importance.max,
      priority: Priority.high,
      category: AndroidNotificationCategory.reminder,
      icon:'app_ns_icon',
      largeIcon:DrawableResourceAndroidBitmap('ic_launcher'),
      actions: [chatwithccAction,viewRecordAction]
  );
  final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS:DarwinNotificationDetails(categoryIdentifier:
      'ChatCCAndViewrecordButtons'));

  await localNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(callChannel);
  localNotificationsPlugin.show(
      Platform.isIOS? message.notification.hashCode:message.data.hashCode,
      Platform.isIOS? message.notification!.title:message.data['title'],
      Platform.isIOS? message.notification!.body:message.data['body'],
      platformChannelSpecifics,
      payload: jsonEncode(message.data));
}


@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  print('8888: onBackground:${jsonDecode(notificationResponse.payload ?? '')}');
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
  }, onError: (Object error) {

  });
}




