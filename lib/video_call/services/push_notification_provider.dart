import 'dart:async';
//import 'dart:html';
import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/src/model/home_screen_arguments.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/TelehealthProviderModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/view/TelehealthProviders.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/city.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/doctor.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/past.dart';
import 'package:myfhb/telehealth/features/appointments/view/resheduleMain.dart';
import 'package:myfhb/video_call/model/CallArguments.dart';
import 'package:myfhb/video_call/pages/callmain.dart';
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/doctor.dart'
    as doc;

class PushNotificationsProvider {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _pushStreamCOntroller = StreamController<CallArguments>.broadcast();
  final myDB = Firestore.instance;
  String meetingId;
  CallArguments callDetails;
  Past rescheduleDetails;
  String plannedStartDateTime;
  String bookingId;
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
    AwesomeNotifications().actionStream.listen((receivedNotification) {
      print("notification action ${receivedNotification.buttonKeyPressed}");
      // if (receivedNotification.buttonKeyPressed.toLowerCase() ==
      //     parameters.Accept.toLowerCase()) {
      //   updateStatus(parameters.Accept.toLowerCase());
      // } else if (receivedNotification.buttonKeyPressed.toLowerCase() ==
      //     parameters.Decline.toLowerCase()) {
      //   updateStatus(parameters.Decline.toLowerCase());
      // } else
      Get.to(CallMain(
        doctorName: callDetails.userName,
        doctorId: callDetails.doctorId,
        doctorPic: callDetails.doctorPicture,
        channelName: callDetails.meetingId,
        role: callDetails.role,
        isAppExists: callDetails.isAppExists,
      ));
      // if (receivedNotification.buttonKeyPressed.toLowerCase() ==
      //         parameters.reschedule.toLowerCase() &&
      //     rescheduleDetails != null) {
      //   Get.to(ResheduleMain(
      //     isFromNotification: true,
      //     isReshedule: true,
      //     doc: rescheduleDetails,
      //   ));
      // } else if (receivedNotification.buttonKeyPressed.toLowerCase() ==
      //     parameters.cancel.toLowerCase()) {
      //   Get.to(TelehealthProviders(
      //     arguments: HomeScreenArguments(
      //         selectedIndex: 0,
      //         dialogType: 'CANCEL',
      //         isCancelDialogShouldShow: true,
      //         bookingId: bookingId ?? '',
      //         date: plannedStartDateTime ?? ''),
      //   ));
      // }
    });

    _firebaseMessaging.configure(
        onMessage: onMessage,
        onBackgroundMessage: Platform.isIOS ? null : onBackgroundMessage,
        onResume: onResume,
        onLaunch: onLaunch);
  }

  void updateStatus(String status) async {
    try {
      await myDB
          .collection("call_log")
          .document("$meetingId")
          .setData({"call_status": status});
    } catch (e) {
      print(e);
    }
    if (callDetails != null) {
      Get.to(CallMain(
        doctorName: callDetails.userName,
        doctorId: callDetails.doctorId,
        doctorPic: callDetails.doctorPicture,
        channelName: callDetails.meetingId,
        role: callDetails.role,
        isAppExists: callDetails.isAppExists,
      ));
    }
  }

  // initLocalNotification() {
  //   // Local Notification
  //   flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  //   var android = new AndroidInitializationSettings(parameters.launcher);
  //   var iOS = new IOSInitializationSettings();
  //   var initSetttings = new InitializationSettings(android, iOS);
  //   flutterLocalNotificationsPlugin.initialize(initSetttings,
  //       onSelectNotification: onSelectNotification);
  // }

  // showLocalNotification() async {
  //   var android = new AndroidNotificationDetails(
  //     parameters.channel_id,
  //     parameters.channel_name,
  //     parameters.channel_descrip,
  //     priority: Priority.High,
  //     importance: Importance.Max,
  //   );

  //   var iOS = new IOSNotificationDetails(sound: ringtone);
  //   var platform = new NotificationDetails(android, iOS);
  //   await flutterLocalNotificationsPlugin.show(0, title, body, platform,
  //       payload: parameters.custom_sound);
  // }

  showLocalNotificationNew(Map<String, dynamic> message) async {
    var fcmToken = await AwesomeNotifications().firebaseAppToken;

    print('fcm token by $fcmToken');
    createNotificationWith(message,
        addActions: ((message[parameters.strtype] == parameters.call) ||
            (message[parameters.templateName] ==
                parameters.doctorCancellation)));
  }

  void createNotificationWith(Map<String, dynamic> message,
      {bool addActions = false}) {
    meetingId = message[parameters.meetingId];

    String keyForAccept;
    String keyForDecline;

    if (addActions) {
      if (message[parameters.templateName] == parameters.doctorCancellation) {
        keyForAccept = parameters.reschedule;
        keyForDecline = parameters.cancel;
        rescheduleDetails = Past(
            doctorSessionId: message[parameters.strDoctorSessionId],
            bookingId: message[parameters.strBookingId_S],
            doctor: doc.Doctor(id: message[parameters.doctorId]),
            healthOrganization:
                City(id: message[parameters.healthOrganization]));
        bookingId = message[parameters.strBookingId_S];
        plannedStartDateTime = message[parameters.strPlannedStartDateTime];
      } else {
        keyForAccept = parameters.Accept;
        keyForDecline = parameters.Decline;
        callDetails = CallArguments(
            userName: message[parameters.notification][parameters.title],
            doctorId: message[parameters.doctorId],
            meetingId: message[parameters.meeting_id],
            doctorPicture: message[parameters.doctorPicture],
            role: ClientRole.Broadcaster,
            isAppExists: true);
      }
    }

    AwesomeNotifications().createNotification(
      actionButtons: addActions
          ? [
              NotificationActionButton(
                key: keyForAccept,
                label: keyForAccept,
                buttonType: ActionButtonType.KeepOnTop,
              ),
              NotificationActionButton(
                  key: keyForDecline,
                  label: keyForDecline,
                  buttonType: ActionButtonType.Default),
            ]
          : [],
      content: NotificationContent(
          id: 1, channelKey: 'basic_channel', title: title, body: body),
    );
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

    // initLocalNotification();
    // showLocalNotification();

    initNotification();
    showLocalNotificationNew(message);
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
