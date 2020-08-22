import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:myfhb/video_call/model/CallArguments.dart';

class PushNotificationsProvider {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _pushStreamCOntroller = StreamController<CallArguments>.broadcast();

  Stream<CallArguments> get pushController => _pushStreamCOntroller.stream;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  String title;
  String body;
  String ringtone;

  var callArguments = CallArguments();

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

    var iOS = new IOSNotificationDetails(sound: ringtone);
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(0, title, body, platform,
        payload: 'Custom_Sound');
  }

  Future onSelectNotification(String payload) {
    debugPrint("payload : $payload");

    _pushStreamCOntroller.sink.add(callArguments);
  }

  Future<dynamic> onMessage(Map<String, dynamic> message) async {
    print("OnMessage New: $message");

    title = message['aps']['alert']['title'];
    body = message['aps']['alert']['body'];
    ringtone = message['aps']['sound'];

    final userName = message['username'];
    final channelName = message['meetingid'];

    callArguments = CallArguments(
        role: ClientRole.Broadcaster,
        channelName: channelName,
        userName: userName);

    showLocalNotification();
  }

  Future<dynamic> onLaunch(Map<String, dynamic> message) async {
    print("OnLaunch New: $message");

    Future.delayed(const Duration(seconds: 3), () {
      final userName = message['username'];
      final channelName = message['meetingid'];

      var callArguments = CallArguments(
          role: ClientRole.Broadcaster,
          channelName: channelName,
          userName: userName);
      _pushStreamCOntroller.sink.add(callArguments);
    });
  }

  Future<dynamic> onResume(Map<String, dynamic> message) async {
    print("OnResume New: $message");
    final userName = message['username'];
    final channelName = message['meetingid'];

    var callArguments = CallArguments(
        role: ClientRole.Broadcaster,
        channelName: channelName,
        userName: userName);
    _pushStreamCOntroller.sink.add(callArguments);
  }

  void dispose() {
    _pushStreamCOntroller.close();
  }
}
