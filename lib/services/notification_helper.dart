
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
  ),
  DarwinNotificationCategory(
    'showTransportationNotification',
    actions: [
      DarwinNotificationAction.plain(
        'Accept',
        'Accept',
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.foreground,
        },
      ),
      DarwinNotificationAction.plain(
        'Decline',
        'Decline',
        options: <DarwinNotificationActionOption>{
        },
      ),
    ],
  ),
  DarwinNotificationCategory(
    'showBothButtonsCat',
    actions: [
      DarwinNotificationAction.plain(
        'Snooze',
        'Snooze',
      ),
      DarwinNotificationAction.plain(
        'Dismiss',
        'Dismiss',
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.destructive,
        },
      ),
    ],
  ),
  DarwinNotificationCategory(
    'escalateToCareCoordinatorButtons',
    actions: [
      DarwinNotificationAction.plain(
        'Escalate',
        'Escalate',
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.foreground,
        },
      ),
    ],
  ),
  DarwinNotificationCategory(
    'showViewMemberAndCommunicationButtons',
    actions: [
      DarwinNotificationAction.plain(
        'ViewMember',
        'View Member',
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.foreground,
        },
      ),
      DarwinNotificationAction.plain(
        'Communicationsettings',
        'Communication settings',
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.foreground,
        },
      ),
    ],
  ),
  DarwinNotificationCategory(
    'showSingleButtonCat',
    actions: [
      DarwinNotificationAction.plain(
        'Dismiss',
        'Dismiss',
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.destructive,
        },
      )
    ],
  ),
  DarwinNotificationCategory(
    'planRenewButton',
    actions: [
      DarwinNotificationAction.plain(
        'Renew',
        'Renew',
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.foreground,
        },
      ),
      DarwinNotificationAction.plain(
        'Callback',
        'Call back',
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.foreground,
        },
      ),
    ],
  ),
  DarwinNotificationCategory(
    'acceptDeclineButtonsCaregiver',
    actions: [
      DarwinNotificationAction.plain(
        'Accept',
        'Accept',
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.foreground,
        },
      ),
      DarwinNotificationAction.plain(
        'Reject',
        'Reject',
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.destructive,
        },
      ),
    ],
  ),
  DarwinNotificationCategory(
    'ChatCCAndViewrecordButtons',
    actions: [
      DarwinNotificationAction.plain(
        'chatwithcc',
        'Chat with cc',
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.foreground,
        },
      ),
      DarwinNotificationAction.plain(
        'viewrecord',
        'View Record',
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.foreground,
        },
      ),
    ],
  ),
  DarwinNotificationCategory(
    'viewDetailsButton',
    actions: [
      DarwinNotificationAction.plain(
        'ViewDetails',
        'View Details',
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.foreground,
        },
      )
    ],
  ),
];

///Android ACtionButtons
const acceptAction =  AndroidNotificationAction(
  'Accept', // Replace with your own action ID
  'Accept', // Replace with your own action label
  showsUserInterface: true,
);
const rejectAction =   AndroidNotificationAction(
  'Reject', // Replace with your own action ID
  'Reject',
  showsUserInterface: true, // Replace with your own action label
);
const declineAction =   AndroidNotificationAction(
  'Decline', // Replace with your own action ID
  'Decline',
  showsUserInterface: true, // Replace with your own action label
);

const viewMemberAction =AndroidNotificationAction(
  'ViewMember', // Replace with your own action ID
  'View Member', // Replace with your own action label
  showsUserInterface: true,
);
const communicationSettingAction =AndroidNotificationAction(
  'Communicationsettings', // Replace with your own action ID
  'Communication Settings', // Replace with your own action label
  showsUserInterface: true,
);
const chatwithccAction =AndroidNotificationAction(
  'chatwithcc', // Replace with your own action ID
  'Chat with CC', // Replace with your own action label
  showsUserInterface: true,
);
const viewRecordAction =AndroidNotificationAction(
  'viewrecord', // Replace with your own action ID
  'View Record', // Replace with your own action label
  showsUserInterface: true,
);



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



Future<void> updateCallStatus(bool isAccept, String recordId) async {
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




