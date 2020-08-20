import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationsProvider {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _pushStreamCOntroller = StreamController<String>.broadcast();

  Stream<String> get pushController => _pushStreamCOntroller.stream;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static Future<dynamic> onBackgroundMessage(
      Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
  }

  initNotification() async {
    await _firebaseMessaging.requestNotificationPermissions();
    final token = await _firebaseMessaging.getToken();
    print("Token new: $token");

    initLocalNotification();

    _firebaseMessaging.configure(
        onMessage: onMessage,
        onBackgroundMessage: onBackgroundMessage,
        onResume: onResume,
        onLaunch: onLaunch);
  }

  initLocalNotification() {
    // Local Notification
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
  }

  showLocalNotification() async {
    var android = new AndroidNotificationDetails(
      'channel id',
      'channel NAME',
      'CHANNEL DESCRIPTION',
      priority: Priority.High,
      importance: Importance.Max,
    );

    var iOS = new IOSNotificationDetails(sound: 'iPHONE RINGTONE.aiff');
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
        0, 'John Doe', 'Incoming Video call.....', platform,
        payload: 'Custom_Sound');
  }

  Future onSelectNotification(String payload) {
    debugPrint("payload : $payload");

    final arg = 'Test';
    _pushStreamCOntroller.sink.add(arg);
  }

  Future<dynamic> onMessage(Map<String, dynamic> message) async {
    print("OnMessage New: $message");

    showLocalNotification();
  }

  Future<dynamic> onLaunch(Map<String, dynamic> message) async {
    print("OnLaunch New: $message");
    final arg = 'Test';
    _pushStreamCOntroller.sink.add(arg);
  }

  Future<dynamic> onResume(Map<String, dynamic> message) async {
    print("OnResume New: $message");
    final arg = 'Test';
    _pushStreamCOntroller.sink.add(arg);
  }

  void dispose() {
    _pushStreamCOntroller.close();
  }
}
