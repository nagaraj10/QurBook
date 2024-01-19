import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const _showBothButtonsCat = 'showBothButtonsCat';
const _showSingleButtonCat = 'showSingleButtonCat';
const _showVCAcceptRejectedButtons = 'showVCAcceptRejectedButtons';
const _planRenewButton = 'planRenewButton';
const _escalateToCareCoordinatorButtons = 'escalateToCareCoordinatorButtons';
const _showTransportationNotification =
    'transportationRequestAcceptDeclineButtons';
const _acceptDeclineButtonsCaregiver = 'showAcceptDeclineButtonsCaregiver';
const _ChatCCAndViewrecordButtons = 'showChatCCAndViewrecordButtons';
const _viewDetailsButton = 'memberviewDetailsButtons';
const _showViewMemberAndCommunicationButtons =
    'showViewMemberAndCommunicationButtons';

///IOS Notification ActionButtons
final _snoozeDarwinNotificationAction =
    DarwinNotificationAction.plain('Snooze', 'Snooze');
final _dismissDestructiveDarwinNotificationAction =
    DarwinNotificationAction.plain(
  'Dismiss',
  'Dismiss',
  options: <DarwinNotificationActionOption>{
    DarwinNotificationActionOption.destructive,
  },
);

final _payNowDestructiveDarwinNotificationAction =
    DarwinNotificationAction.plain(
  'PayNow',
  'Pay Now',
  options: <DarwinNotificationActionOption>{
    DarwinNotificationActionOption.destructive,
  },
);

final _renewDarwinNotificationAction = DarwinNotificationAction.plain(
  'Renew',
  'Renew',
  options: <DarwinNotificationActionOption>{
    DarwinNotificationActionOption.foreground
  },
);
final _escalateDarwinNotificationAction = DarwinNotificationAction.plain(
  'Escalate',
  'Escalate',
  options: <DarwinNotificationActionOption>{
    DarwinNotificationActionOption.foreground
  },
);
final _callbackDarwinNotificationAction = DarwinNotificationAction.plain(
  'Callback',
  'Call back',
  options: <DarwinNotificationActionOption>{
    DarwinNotificationActionOption.foreground
  },
);
final _rejectDarwinNotificationAction = DarwinNotificationAction.plain(
  'Reject',
  'Reject',
  options: <DarwinNotificationActionOption>{
    DarwinNotificationActionOption.destructive,
  },
);
final _acceptDarwinNotificationAction = DarwinNotificationAction.plain(
  'Accept',
  'Accept',
  options: <DarwinNotificationActionOption>{
    DarwinNotificationActionOption.foreground
  },
);
final _chatwithccDarwinNotificationAction = DarwinNotificationAction.plain(
  'chatwithcc',
  'Chat with CC',
  options: <DarwinNotificationActionOption>{
    DarwinNotificationActionOption.foreground
  },
);
final _viewRecordDarwinNotificationAction = DarwinNotificationAction.plain(
  'viewrecord',
  'View Record',
  options: <DarwinNotificationActionOption>{
    DarwinNotificationActionOption.foreground
  },
);
final _viewMemberDarwinNotificationAction = DarwinNotificationAction.plain(
  'ViewMember',
  'View Member',
  options: <DarwinNotificationActionOption>{
    DarwinNotificationActionOption.foreground
  },
);
final _viewDetailsDarwinNotificationAction = DarwinNotificationAction.plain(
  'ViewDetails',
  'ViewDetails',
  options: <DarwinNotificationActionOption>{
    DarwinNotificationActionOption.foreground
  },
);
final _communicationsettingsDarwinNotificationAction =
    DarwinNotificationAction.plain(
  'Communicationsettings',
  'Communication settings',
  options: <DarwinNotificationActionOption>{
    DarwinNotificationActionOption.foreground
  },
);
final _declineNewDarwinNotificationAction = DarwinNotificationAction.plain(
  'Decline',
  'Decline',
);
final _declineForegroundDarwinNotificationAction =
    DarwinNotificationAction.plain(
  'Decline',
  'Decline',
  options: <DarwinNotificationActionOption>{
    DarwinNotificationActionOption.foreground
  },
);

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
    _showTransportationNotification,
    actions: [
      _acceptDarwinNotificationAction,
      _declineNewDarwinNotificationAction,
    ],
  ),
  DarwinNotificationCategory(
    _showVCAcceptRejectedButtons,
    actions: [
      _acceptDarwinNotificationAction,
      _declineForegroundDarwinNotificationAction,
    ],
  ),
  DarwinNotificationCategory(
    _showBothButtonsCat,
    actions: [
      _snoozeDarwinNotificationAction,
      _dismissDestructiveDarwinNotificationAction,
    ],
  ),
  DarwinNotificationCategory(
    _escalateToCareCoordinatorButtons,
    actions: [
      _escalateDarwinNotificationAction,
    ],
  ),
  DarwinNotificationCategory(
    _showViewMemberAndCommunicationButtons,
    actions: [
      _viewMemberDarwinNotificationAction,
      _communicationsettingsDarwinNotificationAction,
    ],
  ),
  DarwinNotificationCategory(
    _showSingleButtonCat,
    actions: [
      _dismissDestructiveDarwinNotificationAction,
    ],
  ),
  DarwinNotificationCategory(
    _planRenewButton,
    actions: [
      _renewDarwinNotificationAction,
      _callbackDarwinNotificationAction,
    ],
  ),
  DarwinNotificationCategory(
    _acceptDeclineButtonsCaregiver,
    actions: [
      _acceptDarwinNotificationAction,
      _rejectDarwinNotificationAction,
    ],
  ),
  DarwinNotificationCategory(
    _ChatCCAndViewrecordButtons,
    actions: [
      _chatwithccDarwinNotificationAction,
      _viewRecordDarwinNotificationAction,
    ],
  ),
  DarwinNotificationCategory(
    _viewDetailsButton,
    actions: [
      _viewDetailsDarwinNotificationAction,
    ],
  ),
];

///Android ACtionButtons
const callAction = [
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
