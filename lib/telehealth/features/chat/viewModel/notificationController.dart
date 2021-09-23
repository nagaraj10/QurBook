import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/src/resources/network/api_services.dart';
import 'package:myfhb/telehealth/features/chat/constants/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myfhb/src/resources/network/api_services.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'dart:math';

/*Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    print('myBackgroundMessageHandler data');
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    print('myBackgroundMessageHandler notification');
    final dynamic notification = message['notification'];
  }
  // Or do other work.
}*/

class NotificationController {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static NotificationController get instance => NotificationController();

  final String _firebaseChatNotifyToken = CommonUtil.FIREBASE_CHAT_NOTIFY_TOKEN;

  Future<void> sendNotificationMessageToPeerUser(
      messageType, textFromTextField, myName, chatID, peerUserToken) async {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    var meetingId = getMyMeetingID().toString();
    await ApiServices.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$_firebaseChatNotifyToken',
        KEY_OffSet: CommonUtil.TimeZone
      },
      body: jsonEncode(
        <String, dynamic>{
          /*'notification': <String, dynamic>{
            //'badge':'$unReadMSGCount',//'$unReadMSGCount'
            "sound" : "default"
          },*/
          'priority': 'high',
          'data': <String, dynamic>{
            'body': messageType == 0 ? '$textFromTextField' : '(File)',
            'title': '$myName',
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
            "sound": Platform.isIOS ? 'ringtone.aiff' : 'default',
            'chatroomid': chatID,
            'meeting_id': meetingId,
            'type': 'ack',
            'templateName': 'chat'
          },
          'to': peerUserToken,
        },
      ),
    );

    final Completer<Map<String, dynamic>> completer =
        Completer<Map<String, dynamic>>();

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        completer.complete(message.data);
      },
    );
  }

  int getMyMeetingID() {
    int min = 100000; //min and max values act as your 6 digit range
    int max = 999999;
    var randomizer = new Random();
    var rNum = min + randomizer.nextInt(max - min);

    return rNum;
  }
}
