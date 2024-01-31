import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/constants/variable_constant.dart';

///Ios Notification Categories
List<DarwinNotificationCategory> darwinIOSCategories = [
  DarwinNotificationCategory(
    strDarwinCallCategory,
    actions: [
      DarwinNotificationAction.plain(
        strAcceptAction,
        accept,
      ),
      DarwinNotificationAction.plain(
        strRejectAction,
        reject,
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.foreground,
        },
      ),
    ],
  ),
  DarwinNotificationCategory(
    strShowTransportationNotification,
    actions: [
      DarwinNotificationAction.plain(
        accept,
        accept,
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.foreground,
        },
      ),
      DarwinNotificationAction.plain(
        decline,
        decline,
        options: <DarwinNotificationActionOption>{},
      ),
    ],
  ),
  DarwinNotificationCategory(
    strShowBothButtonsCat,
    actions: [
      DarwinNotificationAction.plain(
        stringSnooze,
        stringSnooze,
      ),
      DarwinNotificationAction.plain(
        stringDismiss,
        stringDismiss,
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.foreground,
        },
      ),
    ],
  ),
  DarwinNotificationCategory(
    strEscalateToCareCoordinatorButtons,
    actions: [
      DarwinNotificationAction.plain(
        strEscalate,
        strEscalate,
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.foreground,
        },
      ),
    ],
  ),
  DarwinNotificationCategory(
    strShowViewMemberAndCommunicationButtons,
    actions: [
      DarwinNotificationAction.plain(
        strViewMember,
        strViewMemberSpace,
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.foreground,
        },
      ),
      DarwinNotificationAction.plain(
        strCommunicationsettings,
        strCommunicationSettingsSpace,
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.foreground,
        },
      ),
    ],
  ),
  DarwinNotificationCategory(
    strShowSingleButtonCat,
    actions: [
      DarwinNotificationAction.plain(
        stringDismiss,
        stringDismiss,
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.foreground,
        },
      )
    ],
  ),
  DarwinNotificationCategory(
    strPlanRenewButton,
    actions: [
      DarwinNotificationAction.plain(
        strIsRenew,
        strIsRenew,
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.foreground,
        },
      ),
      DarwinNotificationAction.plain(
        strCallback,
        strCallbackSpace,
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.foreground,
        },
      ),
    ],
  ),
  DarwinNotificationCategory(
    strAcceptDeclineButtonsCaregiver,
    actions: [
      DarwinNotificationAction.plain(
        accept,
        accept,
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.foreground,
        },
      ),
      DarwinNotificationAction.plain(
        reject,
        reject,
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.foreground,
        },
      ),
    ],
  ),
  DarwinNotificationCategory(
    strChatCCAndViewrecordButtons,
    actions: [
      DarwinNotificationAction.plain(
        strChatwithcc,
        strChatwithccSpace,
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.foreground,
        },
      ),
      DarwinNotificationAction.plain(
        strViewrecord,
        strViewRecordSpace,
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.foreground,
        },
      ),
    ],
  ),
  DarwinNotificationCategory(
    strViewDetailsButton,
    actions: [
      DarwinNotificationAction.plain(
        strViewDetails,
        strViewDetailsSpace,
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.foreground,
        },
      )
    ],
  ),
  DarwinNotificationCategory(
    strPayNowButton,
    actions: [
      DarwinNotificationAction.plain(
        strPayNow,
        strPayNowSpace,
        options: <DarwinNotificationActionOption>{
          DarwinNotificationActionOption.foreground,
        },
      )
    ],
  ),
];

///Android ACtionButtons
const acceptAction = AndroidNotificationAction(
  accept, // Replace with your own action ID
  accept, // Replace with your own action label
  showsUserInterface: true,
);
const rejectAction = AndroidNotificationAction(
  reject, // Replace with your own action ID
  reject,
  showsUserInterface: true, // Replace with your own action label
);
const declineAction = AndroidNotificationAction(
  decline, // Replace with your own action ID
  decline,
  showsUserInterface: true, // Replace with your own action label
);

const viewMemberAction = AndroidNotificationAction(
  strViewMember, // Replace with your own action ID
  strViewMemberSpace, // Replace with your own action label
  showsUserInterface: true,
);
const communicationSettingAction = AndroidNotificationAction(
  strCommunicationsettings, // Replace with your own action ID
  strCommunicationSettingsSpace, // Replace with your own action label
  showsUserInterface: true,
);
const chatwithccAction = AndroidNotificationAction(
  strChatwithcc, // Replace with your own action ID
  strChatwithCCSpace, // Replace with your own action label
  showsUserInterface: true,
);
const viewRecordAction = AndroidNotificationAction(
  strViewrecord, // Replace with your own action ID
  strViewRecordSpace, // Replace with your own action label
  showsUserInterface: true,
);

const renewalAction = AndroidNotificationAction(
  strIsRenew, // Replace with your own action ID
  strIsRenew, // Replace with your own action label
  showsUserInterface: true,
);

const callBackAction = AndroidNotificationAction(
  strCallback, // Replace with your own action ID
  strCallbackSpace, // Replace with your own action label
  showsUserInterface: true,
);

const escalateAction = AndroidNotificationAction(
  strEscalate, // Replace with your own action ID
  strEscalate, // Replace with your own action label
  showsUserInterface: true,
);

const viewDetailsAction = AndroidNotificationAction(
  strViewDetails, // Replace with your own action ID
  strViewDetailsSpace, // Replace with your own action label
  showsUserInterface: true,
);

const payNowAction = AndroidNotificationAction(
  strPayNow, // Replace with your own action ID
  strPayNowSpace, // Replace with your own action label
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
  strAndroidNormalchannelId, // id
  strQurbookChannel, // title
  enableVibration: false,
  description: strNormalQurbookChannelDesc, //
  sound: RawResourceAndroidNotificationSound(strMsgTone),
  importance: Importance.high,
);
var callChannel = const AndroidNotificationChannel(
  strAndroidNormalCallchannelId, // id
  strQurbookCallChannel,
  enableVibration: false, // title
  description: strNormalQurbookChannelDesc,
  sound: RawResourceAndroidNotificationSound(strHelium), // description
  importance: Importance.high,
);

// Define a constant for the remainder schedule notification channel.
var remainderScheduleChannel = const AndroidNotificationChannel(
  strRemainderScheduleChannel, // ID for the channel
  strQurbookRemainderScheduleChannel, // Title of the channel
  enableVibration: false, // Enable or disable vibration
  description: strRemainderNotificationChannelDes, // Description of the channel
  sound: RawResourceAndroidNotificationSound(strMsgTone), // Sound for notifications
  importance: Importance.high, // Importance level of the channel
);

// Define a constant for the remainder schedulev3 notification channel.
var remainderScheduleV3Channel = const AndroidNotificationChannel(
  strRemainderScheduleV3Channel, // ID for the channel
  strQurbookRemainderScheduleV3Channel, // Title of the channel
  enableVibration: false, // Enable or disable vibration
  description: strRemainderNotificationV3ChannelDes, // Description of the channel
  sound: RawResourceAndroidNotificationSound(strBeepBeep), // Sound for notifications
  importance: Importance.high, // Importance level of the channel
);


Future<void> updateCallStatus(bool isAccept, String recordId) async {
  try {
    final db = FirebaseFirestore.instance;

    final data = <String, dynamic>{
      strCallStatus: isAccept ? accept.toLowerCase() : decline.toLowerCase(),
    };
    await db.collection(strCallLog).doc(recordId).update(data);
  } catch (e) {
    print('firestoreException:${e.toString()}');
  }
}
