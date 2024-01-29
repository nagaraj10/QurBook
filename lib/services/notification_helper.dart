import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:myfhb/constants/fhb_parameters.dart';

///Ios Notification Categories
List<DarwinNotificationCategory> darwinIOSCategories = [
  DarwinNotificationCategory(
    'darwinCall_category',
    actions: [
      DarwinNotificationAction.plain(
        'accept_action',
        'Accept',
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
        options: <DarwinNotificationActionOption>{},
      ),
    ],
  ),
  DarwinNotificationCategory(
    'showBothButtonsCat',
    actions: [
      DarwinNotificationAction.plain(
        stringSnooze,
        stringSnooze,
      ),
      DarwinNotificationAction.plain(
        stringDismiss,
        stringDismiss,
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
  DarwinNotificationCategory(
    'payNowButton',
    actions: [
      DarwinNotificationAction.plain(
        'PayNow',
        'Pay Now',
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.foreground,
        },
      )
    ],
  ),
];

///Android ACtionButtons
const acceptAction = AndroidNotificationAction(
  'Accept', // Replace with your own action ID
  'Accept', // Replace with your own action label
  showsUserInterface: true,
);
const rejectAction = AndroidNotificationAction(
  'Reject', // Replace with your own action ID
  'Reject',
  showsUserInterface: true, // Replace with your own action label
);
const declineAction = AndroidNotificationAction(
  'Decline', // Replace with your own action ID
  'Decline',
  showsUserInterface: true, // Replace with your own action label
);

const viewMemberAction = AndroidNotificationAction(
  'ViewMember', // Replace with your own action ID
  'View Member', // Replace with your own action label
  showsUserInterface: true,
);
const communicationSettingAction = AndroidNotificationAction(
  'Communicationsettings', // Replace with your own action ID
  'Communication Settings', // Replace with your own action label
  showsUserInterface: true,
);
const chatwithccAction = AndroidNotificationAction(
  'chatwithcc', // Replace with your own action ID
  'Chat with CC', // Replace with your own action label
  showsUserInterface: true,
);
const viewRecordAction = AndroidNotificationAction(
  'viewrecord', // Replace with your own action ID
  'View Record', // Replace with your own action label
  showsUserInterface: true,
);

const renewalAction = AndroidNotificationAction(
  'Renew', // Replace with your own action ID
  'Renew', // Replace with your own action label
  showsUserInterface: true,
);

const callBackAction = AndroidNotificationAction(
  'Callback', // Replace with your own action ID
  'Call back', // Replace with your own action label
  showsUserInterface: true,
);

const escalateAction = AndroidNotificationAction(
  'Escalate', // Replace with your own action ID
  'Escalate', // Replace with your own action label
  showsUserInterface: true,
);

const viewDetailsAction = AndroidNotificationAction(
  'ViewDetails', // Replace with your own action ID
  'View Details', // Replace with your own action label
  showsUserInterface: true,
);

const payNowAction = AndroidNotificationAction(
  'PayNow', // Replace with your own action ID
  'Pay Now', // Replace with your own action label
  showsUserInterface: true,
);


// Define a constant for the snooze action configuration.
const snoozeAction = AndroidNotificationAction(
  stringSnooze, // Action ID (replace with your own action ID)
  stringSnooze, // Action label (replace with your own action label)
  showsUserInterface: true, // Indicates whether the action should display in the notification UI
);

// Define a constant for the dismiss action configuration.
const dismissAction = AndroidNotificationAction(
  stringDismiss, // Action ID (replace with your own action ID)
  stringDismiss, // Action label (replace with your own action label)
  showsUserInterface: true, // Indicates whether the action should display in the notification UI
);


///Notification Channel
const androidNormalchannel = AndroidNotificationChannel(
  '12345', // id
  'Qurbook_channel', // title
  enableVibration: false,
  description: 'This channel is used for important notifications.', //
  sound: RawResourceAndroidNotificationSound('msg_tone'),
  importance: Importance.high,
);
var callChannel = const AndroidNotificationChannel(
  '5678', // id
  'Qurbook_call_channel',
  enableVibration: false, // title
  description: 'This channel is used for important notifications.',
  sound: RawResourceAndroidNotificationSound('helium'), // description
  importance: Importance.high,
);

// Define a constant for the remainder schedule notification channel.
var remainderScheduleChannel = const AndroidNotificationChannel(
  'remainderScheduleChannel', // ID for the channel
  'qurbook_remainder_schedule_channel', // Title of the channel
  enableVibration: false, // Enable or disable vibration
  description: 'This channel is used for important remainder schedule notifications.', // Description of the channel
  sound: RawResourceAndroidNotificationSound('msg_tone'), // Sound for notifications
  importance: Importance.high, // Importance level of the channel
);

// Define a constant for the remainder schedulev3 notification channel.
var remainderScheduleV3Channel = const AndroidNotificationChannel(
  'remainderScheduleV3Channel', // ID for the channel
  'qurbook_remainder_schedulev3_channel', // Title of the channel
  enableVibration: false, // Enable or disable vibration
  description: 'This channel is used for important remainder schedulev3 notifications.', // Description of the channel
  sound: RawResourceAndroidNotificationSound('beep_beep'), // Sound for notifications
  importance: Importance.high, // Importance level of the channel
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
