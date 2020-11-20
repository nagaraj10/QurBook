import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
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
    if (message.containsKey(parameters.data)) {
      // Handle data message
      final dynamic data = message[parameters.data];
    }

    if (message.containsKey(parameters.notification)) {
      // Handle notification message
      final dynamic notification = message[parameters.notification];
    }
    // Or do other work.
  }

  initNotification() async {
    await _firebaseMessaging.requestNotificationPermissions();
    final token = await _firebaseMessaging.getToken();
    print('${parameters.token} : $token');

    // initLocalNotification();

    _firebaseMessaging.configure(
        onMessage: onMessage,
        onBackgroundMessage: onBackgroundMessage,
        onResume: onResume,
        onLaunch: onLaunch);
  }

  initLocalNotification() {
    // Local Notification
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings(parameters.launcher);
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
  }

  showLocalNotification() async {
    var android = new AndroidNotificationDetails(
      parameters.channel_id,
      parameters.channel_name,
      parameters.channel_descrip,
      priority: Priority.High,
      importance: Importance.Max,
    );

    var iOS = new IOSNotificationDetails(sound: ringtone);
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(0, title, body, platform,
        payload: parameters.custom_sound);
  }

  Future onSelectNotification(String payload) {
    _pushStreamCOntroller.sink.add(callArguments);
  }

  Future<dynamic> onMessage(Map<String, dynamic> message) async {
    print("OnMessage New: $message");

    title = message[parameters.aps][parameters.alert][parameters.title];
    body = message[parameters.aps][parameters.alert][parameters.body];
    ringtone = message[parameters.aps][parameters.sound];

    final userName = message[parameters.username];
    final channelName = message[parameters.meeting_id];
    final doctorId = message[parameters.doctorId];

    callArguments = CallArguments(
        role: ClientRole.Broadcaster,
        channelName: channelName,
        userName: userName,
        doctorId: doctorId);

    initLocalNotification();
    showLocalNotification();
  }

  Future<dynamic> onLaunch(Map<String, dynamic> message) async {
    print("${parameters.onlaunch}: $message");

    Future.delayed(const Duration(seconds: 5), () {
      final userName = message[parameters.username];
      final channelName = message[parameters.meeting_id];
      final doctorId = message[parameters.doctorId];

      var callArguments = CallArguments(
          role: ClientRole.Broadcaster,
          channelName: channelName,
          userName: userName,
          doctorId: doctorId);
      _pushStreamCOntroller.sink.add(callArguments);
    });
  }

  Future<dynamic> onResume(Map<String, dynamic> message) async {
    print("${parameters.onresume}: $message");

    final userName = message[parameters.username];
    final channelName = message[parameters.meeting_id];
    final doctorId = message[parameters.doctorId];

    var callArguments = CallArguments(
        role: ClientRole.Broadcaster,
        channelName: channelName,
        userName: userName,
        doctorId: doctorId);
    _pushStreamCOntroller.sink.add(callArguments);
  }

  void dispose() {
    _pushStreamCOntroller.close();
  }
}
