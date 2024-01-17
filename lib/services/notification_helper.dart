
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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

///Android ACtionButtons
const callAction =[
  AndroidNotificationAction(
    'Accept', // Replace with your own action ID
    'Accept', // Replace with your own action label
    showsUserInterface: true,
  ),
  AndroidNotificationAction(
    'Reject', // Replace with your own action ID
    'Reject',
    showsUserInterface: true, // Replace with your own action label
  ),
];


///Notification Channel
const androidNormalchannel = AndroidNotificationChannel(
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




