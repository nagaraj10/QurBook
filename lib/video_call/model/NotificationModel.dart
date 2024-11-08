import 'dart:io';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:myfhb/common/CommonUtil.dart';
import '../../constants/fhb_parameters.dart' as parameters;
import 'CallArguments.dart';

class NotificationModel {
  String? title;
  String? body;
  String? ringtone;
  String? templateName;
  String? userId;
  String? idToHighlight;
  String? redirect;
  String? healthRecordMetaIds;
  bool? isCall = false;
  bool? needToHighlight = false;
  bool isCancellation = false;
  String? meeting_id;
  String? doctorId;
  String? username;
  String? type;
  String? eventId;
  String? rawTitle;
  String? rawBody;
  String? doctorName;
  String? doctorPicture;
  String? patientId;
  String? careCoordinatorUserId;
  String? careGiverName;
  String? activityTime;
  String? activityName;
  String? patientName;
  String? patientPicture;
  String? externalLink;
  String? patientPhoneNumber;
  String? uid;
  String? verificationCode;
  String? caregiverRequestor;
  String? caregiverReceiver;
  CallArguments? callArguments;
  bool? isWeb;
  bool? isCaregiver;
  String? deliveredDateTime;
  bool? isFromCareCoordinator;
  String? callType;
  String? claimId;
  Map<int, dynamic>? redirectData;
  String? planId;
  String? notificationListId;
  bool? viewRecordAction, isSheela, chatWithCC = false;
  String? message;
  String? sheelaAudioMsgUrl;
  String? eventType;
  String? others;
  String? appointmentId;
  String? bookingId;
  String? createdBy;
  String? status;
  String? voiceCloneId;
  // Nullable variable to store the Voice Clone ID.

  String? voiceCloneStatus;
  // Nullable variable to store the Voice Clone Status.


  NotificationModel(
      {this.title,
      this.body,
      this.ringtone,
      this.templateName,
      this.userId,
      this.idToHighlight,
      this.redirect,
      this.healthRecordMetaIds,
      this.isCall,
      this.needToHighlight,
      this.meeting_id,
      this.doctorId,
      this.username,
      this.type,
      this.eventId,
      this.rawTitle,
      this.rawBody,
      this.externalLink,
      this.planId,
      this.callType,
      this.isWeb,
      this.claimId,
      this.caregiverReceiver,
      this.caregiverRequestor,
      this.verificationCode,
      this.patientPhoneNumber,
      this.notificationListId,
      this.careCoordinatorUserId,
      this.activityName,
      this.activityTime,
      this.careGiverName,
      this.uid,
      this.isCaregiver,
      this.deliveredDateTime,
      this.isFromCareCoordinator,
      this.message,
      this.sheelaAudioMsgUrl,
      this.eventType,
      this.others,
      this.appointmentId,
      this.bookingId,
      this.createdBy,
      this.status,
      this.voiceCloneId,
      this.voiceCloneStatus});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'ringtone': ringtone,
      'templateName': templateName,
      'userId': userId,
      'idToHighlight': idToHighlight,
      'redirect': redirect,
      'healthRecordMetaIds': healthRecordMetaIds,
      'isCall': isCall,
      'needToHighlight': needToHighlight,
      'meeting_id': meeting_id,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'doctorPicture': doctorPicture,
      'username': username,
      'type': type,
      'externalLink': externalLink,
      'planId': planId,
      'callType': callType,
      'isWeb': isWeb,
      'claimId': claimId,
      'notificationListId': notificationListId,
      'careCoordinatorUserId': careCoordinatorUserId,
      'activityName': activityName,
      'activityTime': activityTime,
      'careGiverName': careGiverName,
      'uid': uid,
      'isCaregiver': isCaregiver,
      'deliveredDateTime': deliveredDateTime,
      'isFromCareCoordinator': isFromCareCoordinator,
      'sheelaAudioMsgUrl': sheelaAudioMsgUrl,
      'viewRecordAction': viewRecordAction,
      'chatWithCC': chatWithCC,
      'eventType': eventType,
      'others': others,
      'appointmentId': appointmentId,
      'bookingId': bookingId,
      'createdBy': createdBy,
      'voiceCloneId': voiceCloneId,
      'voiceCloneStatus': voiceCloneStatus,
    };
  }

  NotificationModel.fromSharePreferences(Map<String, dynamic> message) {
    try {
      title = message['title'];
      body = message['body'];
      ringtone = message['ringtone'];
      templateName = message['templateName'];
      userId = message['userId'];
      idToHighlight = message['idToHighlight'];
      redirect = message['redirect'];
      healthRecordMetaIds = message['healthRecordMetaIds'];
      isCall = message['isCall'];
      needToHighlight = message['needToHighlight'];
      meeting_id = message['meeting_id'];
      doctorId = message['doctorId'];
      doctorName = message['doctorName'];
      doctorPicture = message['doctorPicture'];
      username = message['username'];
      type = message['type'];
      externalLink = message['externalLink'];
      callType = message['callType'];
      isWeb = message['isWeb'];
      claimId = message['claimId'];
      notificationListId = message['notificationListId'];
      careCoordinatorUserId = message['careCoordinatorUserId'];
      activityName = message['activityName'];
      activityTime = message['activityTime'];
      careGiverName = message['careGiverName'];
      isCaregiver = message['isCaregiver'];
      deliveredDateTime = message['deliveredDateTime'];
      isFromCareCoordinator = message['isFromCareCoordinator'];
      sheelaAudioMsgUrl = message['sheelaAudioMsgUrl'];
      eventType = message['eventType'];
      others = message['others'];
      viewRecordAction = message['viewRecordAction'];
      chatWithCC = message['chatWithCC'];
      bookingId = message['bookingId'];
      createdBy = message['createdBy'];
      voiceCloneId = message['voiceCloneId'];
      voiceCloneStatus = message['voiceCloneStatus'];
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  NotificationModel.fromMap(Map<String, dynamic> messageFromNative) {
    print('Call Payload: ${messageFromNative}');

    if (messageFromNative[parameters.notification] != null) {
      setData(messageFromNative[parameters.notification]);
    } else if (messageFromNative[parameters.aps] != null) {
      final aps = messageFromNative[parameters.aps];
      if (aps[parameters.alert] != null) {
        final message = aps[parameters.alert];
        if (message[parameters.title] != null) {
          title = message[parameters.title];
        }

        if (message[parameters.callType] != null) {
          callType = message[parameters.callType];
        }
        if (message[parameters.body] != null) {
          body = message[parameters.body];
        }
        if (message[parameters.sound] != null) {
          ringtone = message[parameters.sound];
        }
        if (message[parameters.templateName] != null) {
          templateName = message[parameters.templateName];
        }
        if (message[parameters.redirectTo] != null) {
          redirect = message[parameters.redirectTo];
        }
        if (message[parameters.gcmredirectTo] != null) {
          redirect = message[parameters.gcmredirectTo];
        }
        if (message[parameters.healthRecordMetaIds] != null) {
          healthRecordMetaIds = message[parameters.healthRecordMetaIds];
        }
        if (message[parameters.struserId] != null) {
          userId = message[parameters.struserId];
        }
        if (message[parameters.GCMUserId] != null) {
          userId = message[parameters.GCMUserId];
        }
        if (message[parameters.meeting_id] != null) {
          meeting_id = message[parameters.meeting_id];
        }
        if (message[parameters.doctorId] != null) {
          doctorId = message[parameters.doctorId];
        }
        if (message[parameters.username] != null) {
          username = message[parameters.username];
        }
        if (message[parameters.userNameparam] != null) {
          username = message[parameters.userNameparam];
        }

        if (message[parameters.strtype] != null) {
          type = message[parameters.strtype];
        }
        if (message[parameters.strgcmtype] != null) {
          type = message[parameters.strgcmtype];
        }
        if (message[parameters.patientPhoneNumber] != null) {
          patientPhoneNumber = message[parameters.patientPhoneNumber];
        }
        if (message[parameters.uid] != null) {
          uid = message[parameters.uid];
        }
        if (message[parameters.verificationCode] != null) {
          verificationCode = message[parameters.verificationCode];
        }
        if (message[parameters.caregiverRequestor] != null) {
          caregiverRequestor = message[parameters.caregiverRequestor];
        }
        if (message[parameters.caregiverReceiver] != null) {
          caregiverReceiver = message[parameters.caregiverReceiver];
        }
        if (message[parameters.PROP_EVEID] != null) {
          eventId = message[parameters.PROP_EVEID];
        }
        if (message[parameters.PROP_RAWTITLE] != null) {
          rawTitle = message[parameters.PROP_RAWTITLE];
        }
        if (message[parameters.PROP_RAWBODY] != null) {
          rawBody = message[parameters.PROP_RAWBODY];
        }
        if (message[parameters.doctorName] != null) {
          doctorName = message[parameters.doctorName];
        }
        if (message[parameters.doctorPicture] != null) {
          doctorPicture = message[parameters.doctorPicture];
        }
        if (message[parameters.strPatientId] != null) {
          patientId = message[parameters.strPatientId];
        }
        if (message[parameters.patientName] != null) {
          patientName = message[parameters.patientName];
        }
        if (message[parameters.gcmpatientName] != null) {
          patientName = message[parameters.gcmpatientName];
        }
        if (message[parameters.patientPicture] != null) {
          patientPicture = message[parameters.patientPicture];
        }
        if (message[parameters.gcmEventId] != null) {
          eventId = message[parameters.gcmEventId];
        }
        if ((message[parameters.sheelaAudioMsgUrl] ?? '').isNotEmpty) {
          sheelaAudioMsgUrl = message[parameters.sheelaAudioMsgUrl];
        }
        if ((message[parameters.gcmsheelaAudioMsgUrl] ?? '').isNotEmpty) {
          sheelaAudioMsgUrl = message[parameters.gcmsheelaAudioMsgUrl];
        }

        if ((message[parameters.eventType] ?? '').isNotEmpty) {
          eventType = message[parameters.eventType];
        }

        if ((message[parameters.others] ?? '').isNotEmpty) {
          others = message[parameters.others];
        }

        if ((message[parameters.appointmentId] ?? '').isNotEmpty) {
          appointmentId = message[parameters.appointmentId];
        }

        if ((message[parameters.strBookingId_S] ?? '').isNotEmpty) {
          bookingId = message[parameters.strBookingId_S];
        }

        if ((message[parameters.strCreatedBy] ?? '').isNotEmpty) {
          createdBy = message[parameters.strCreatedBy];
        }

        if (message[parameters.externalLink] != null) {
          externalLink = message[parameters.externalLink];
        }
        if (message[parameters.gcmExternalLink] != null) {
          externalLink = message[parameters.gcmExternalLink];
        }
        if ((message[parameters.claimId] ?? '').isNotEmpty) {
          claimId = message[parameters.claimId];
        }
        if ((message[parameters.KIOSK_isSheela] ?? '').isNotEmpty) {
          isSheela = (message[parameters.KIOSK_isSheela] ?? '')
                  .toString()
                  .toLowerCase() ==
              "true";
        }
        if ((message[parameters.gcmClaimId] ?? '').isNotEmpty) {
          claimId = message[parameters.gcmClaimId];
        }
        if ((message[parameters.notificationListId] ?? '').isNotEmpty) {
          notificationListId = message[parameters.notificationListId];
        }
        if (message[parameters.gcmplanId] != null) {
          planId = message[parameters.gcmplanId];
        }
        if (message[parameters.gcmpatientPhoneNumber] != null) {
          patientPhoneNumber = message[parameters.gcmpatientPhoneNumber];
        }
        if (message[parameters.gcmverificationCode] != null) {
          verificationCode = message[parameters.gcmverificationCode];
        }
        if (message[parameters.gcmcaregiverRequestor] != null) {
          caregiverRequestor = message[parameters.gcmcaregiverRequestor];
        }
        if (message[parameters.gcmcaregiverReceiver] != null) {
          caregiverReceiver = message[parameters.gcmcaregiverReceiver];
        }
        if (message[parameters.senderName] != null) {
          doctorName = message[parameters.senderName];
        }
        if (message[parameters.senderProfilePic] != null) {
          doctorPicture = message[parameters.senderProfilePic];
        }
        if (message[parameters.senderId] != null) {
          doctorId = message[parameters.senderId];
        }
        if (message[parameters.CARE_COORDINATOR_USER_ID] != null) {
          careCoordinatorUserId = message[parameters.CARE_COORDINATOR_USER_ID];
        }
        if (message[parameters.ACTIVITY_NAME] != null) {
          activityName = message[parameters.ACTIVITY_NAME];
        }
        if (message[parameters.ACTIVITY_TIME] != null) {
          activityTime = message[parameters.ACTIVITY_TIME];
        }
        if (message[parameters.CARE_GIVER_NAME] != null) {
          careGiverName = message[parameters.CARE_GIVER_NAME];
        }
        if (message[parameters.strIsCaregiver] != null) {
          isCaregiver = message[parameters.strIsCaregiver];
        }
        if (message[parameters.strDeliveredDateTime] != null) {
          deliveredDateTime = message[parameters.strDeliveredDateTime];
        }
        if (message[parameters.strMessage] != null) {
          this.message = message[parameters.strMessage];
        }
        if (message[parameters.strVoiceCloneId] != null) {
          voiceCloneId = message[parameters.strVoiceCloneId];
        }
        if (message[parameters.strVoiceCloneStatus] != null) {
          voiceCloneStatus = message[parameters.strVoiceCloneStatus];
        }
        if (message[parameters.strisFromCareCoordinator] != null) {
          var currentVal = message[parameters.strisFromCareCoordinator];
          if (currentVal.runtimeType == String) {
            isFromCareCoordinator =
                (message[parameters.strisFromCareCoordinator] ?? "false") ==
                    "true";
          } else if (currentVal.runtimeType == bool) {
            isFromCareCoordinator =
                message[parameters.strisFromCareCoordinator];
          }
        }
        if (message[parameters.isWeb] != null) {
          if (message[parameters.isWeb].runtimeType == String) {
            isWeb = message[parameters.isWeb].toLowerCase() == 'true'
                ? true
                : false;
          }
        }
      }
    }

    setData(messageFromNative);
    if (redirect != null && redirect!.contains('|')) {
      final split = redirect!.split('|');
      if (split.first == 'sheela') {
        redirect = split.first;
      } else {
        redirectData = {for (int i = 0; i < split.length; i++) i: split[i]};
        if ((healthRecordMetaIds ?? '').isNotEmpty) {
          redirectData![split.length] = healthRecordMetaIds;
        }
      }
    }
    if (title == null) {
      title = "title";
      body = "body";
    }
    isCall = messageFromNative[parameters.strtype] == parameters.call;
    isCancellation = messageFromNative[parameters.templateName] ==
            parameters.doctorCancellation ||
        messageFromNative[parameters.templateName] ==
            parameters.doctorRescheduling;
    if (isCall!) {
      callArguments = CallArguments(
        role: ClientRole.Broadcaster,
        channelName: meeting_id,
        userName: username ?? doctorName,
        doctorId: doctorId,
        doctorName: doctorName,
        doctorPicture: doctorPicture,
        patientId: patientId,
        patientName: patientName,
        patientPicture: patientPicture,
        isWeb: isWeb ?? false,
      );
    }
  }

  void setData(Map<String, dynamic> message) {
    if (message[parameters.status] != null) {
      status = message[parameters.status];
    }

    if (message[parameters.title] != null) {
      title = message[parameters.title];
    }
    if (message[parameters.body] != null) {
      body = message[parameters.body];
    }
    if (message[parameters.sound] != null) {
      ringtone = message[parameters.sound];
    }
    if (message[parameters.templateName] != null) {
      templateName = message[parameters.templateName];
    }
    if (message[parameters.redirectTo] != null) {
      redirect = message[parameters.redirectTo];
    }
    if (message[parameters.gcmredirectTo] != null) {
      redirect = message[parameters.gcmredirectTo];
    }
    if (message[parameters.healthRecordMetaIds] != null) {
      healthRecordMetaIds = message[parameters.healthRecordMetaIds];
    }
    if (message[parameters.struserId] != null) {
      userId = message[parameters.struserId];
    }
    if (message[parameters.GCMUserId] != null) {
      userId = message[parameters.GCMUserId];
    }
    if (message[parameters.strVoiceCloneId] != null) {
      voiceCloneId = message[parameters.strVoiceCloneId];
    }
    if (message[parameters.strVoiceCloneStatus] != null) {
      voiceCloneStatus = message[parameters.strVoiceCloneStatus];
    }
    if (message[parameters.meeting_id] != null) {
      meeting_id = message[parameters.meeting_id];
    }
    if (message[parameters.patientPhoneNumber] != null) {
      patientPhoneNumber = message[parameters.patientPhoneNumber];
    }
    if (message[parameters.uid] != null) {
      uid = message[parameters.uid];
    }
    if ((message[parameters.sheelaAudioMsgUrl] ?? '').isNotEmpty) {
      sheelaAudioMsgUrl = message[parameters.sheelaAudioMsgUrl];
    }
    if ((message[parameters.gcmsheelaAudioMsgUrl] ?? '').isNotEmpty) {
      sheelaAudioMsgUrl = message[parameters.gcmsheelaAudioMsgUrl];
    }

    if ((message[parameters.eventType] ?? '').isNotEmpty) {
      eventType = message[parameters.eventType];
    }

    if ((message[parameters.others] ?? '').isNotEmpty) {
      others = message[parameters.others];
    }

    if ((message[parameters.appointmentId] ?? '').isNotEmpty) {
      appointmentId = message[parameters.appointmentId];
    }

    if ((message[parameters.strBookingId_S] ?? '').isNotEmpty) {
      bookingId = message[parameters.strBookingId_S];
    }

    if ((message[parameters.strCreatedBy] ?? '').isNotEmpty) {
      createdBy = message[parameters.strCreatedBy];
    }

    if (message[parameters.strMessage] != null) {
      this.message = message[parameters.strMessage];
    }
    if ((message[parameters.KIOSK_isSheela] ?? '').isNotEmpty) {
      isSheela =
          (message[parameters.KIOSK_isSheela] ?? '').toString().toLowerCase() ==
              "true";
    }
    if (message[parameters.verificationCode] != null) {
      verificationCode = message[parameters.verificationCode];
    }
    if (message[parameters.caregiverRequestor] != null) {
      caregiverRequestor = message[parameters.caregiverRequestor];
    }
    if (message[parameters.caregiverReceiver] != null) {
      caregiverReceiver = message[parameters.caregiverReceiver];
    }
    if (message[parameters.gcmpatientPhoneNumber] != null) {
      patientPhoneNumber = message[parameters.gcmpatientPhoneNumber];
    }
    if (message[parameters.gcmverificationCode] != null) {
      verificationCode = message[parameters.gcmverificationCode];
    }
    if (message[parameters.gcmcaregiverRequestor] != null) {
      caregiverRequestor = message[parameters.gcmcaregiverRequestor];
    }
    if (message[parameters.gcmcaregiverReceiver] != null) {
      caregiverReceiver = message[parameters.gcmcaregiverReceiver];
    }
    if (message[parameters.doctorId] != null) {
      doctorId = message[parameters.doctorId];
    }
    if (message[parameters.username] != null) {
      username = message[parameters.username];
    }
    if (message[parameters.userNameparam] != null) {
      username = message[parameters.userNameparam];
    }

    if (message[parameters.strtype] != null) {
      type = message[parameters.strtype];
    }
    if (message[parameters.strgcmtype] != null) {
      type = message[parameters.strgcmtype];
    }
    if (message[parameters.PROP_EVEID] != null) {
      eventId = message[parameters.PROP_EVEID];
    }
    if (message[parameters.gcmEventId] != null) {
      eventId = message[parameters.gcmEventId];
    }
    if (message[parameters.PROP_RAWTITLE] != null) {
      rawTitle = message[parameters.PROP_RAWTITLE];
    }
    if (message[parameters.PROP_RAWBODY] != null) {
      rawBody = message[parameters.PROP_RAWBODY];
    }
    if (message[parameters.doctorName] != null) {
      doctorName = message[parameters.doctorName];
    }
    if (message[parameters.doctorPicture] != null) {
      doctorPicture = message[parameters.doctorPicture];
    }
    if (message[parameters.strPatientId] != null) {
      patientId = message[parameters.strPatientId];
    }
    if (message[parameters.patientName] != null) {
      patientName = message[parameters.patientName];
    }
    if (message[parameters.patientPicture] != null) {
      patientPicture = message[parameters.patientPicture];
    }
    if ((message[parameters.claimId] ?? '').isNotEmpty) {
      claimId = message[parameters.claimId];
    }
    if ((message[parameters.gcmClaimId] ?? '').isNotEmpty) {
      claimId = message[parameters.gcmClaimId];
    }
    if (message[parameters.planId] != null) {
      planId = message[parameters.planId];
    }
    if (message[parameters.gcmplanId] != null) {
      planId = message[parameters.gcmplanId];
    }
    if (message[parameters.externalLink] != null) {
      externalLink = message[parameters.externalLink];
    }
    if (message[parameters.gcmExternalLink] != null) {
      externalLink = message[parameters.gcmExternalLink];
    }
    if (message[parameters.callType] != null) {
      callType = message[parameters.callType];
    }
    if ((message[parameters.notificationListId] ?? '').isNotEmpty) {
      notificationListId = message[parameters.notificationListId];
    }
    if (message[parameters.gcmpatientName] != null) {
      patientName = message[parameters.gcmpatientName];
    }
    if (message[parameters.senderName] != null) {
      doctorName = message[parameters.senderName];
    }
    if (message[parameters.senderProfilePic] != null) {
      doctorPicture = message[parameters.senderProfilePic];
    }
    if (message[parameters.senderId] != null) {
      doctorId = message[parameters.senderId];
    }
    if (message[parameters.CARE_COORDINATOR_USER_ID] != null) {
      careCoordinatorUserId = message[parameters.CARE_COORDINATOR_USER_ID];
    }
    if (message[parameters.ACTIVITY_NAME] != null) {
      activityName = message[parameters.ACTIVITY_NAME];
    }
    if (message[parameters.ACTIVITY_TIME] != null) {
      activityTime = message[parameters.ACTIVITY_TIME];
    }
    if (message[parameters.CARE_GIVER_NAME] != null) {
      careGiverName = message[parameters.CARE_GIVER_NAME];
    }
    if (message[parameters.strIsCaregiver] != null) {
      if (message[parameters.strIsCaregiver].runtimeType == String) {
        if ((message[parameters.strIsCaregiver] ?? '').isNotEmpty) {
          isCaregiver =
              message[parameters.strIsCaregiver].toLowerCase() == "true";
        }
      } else {
        isCaregiver = message[parameters.strIsCaregiver];
      }
    }
    if (message[parameters.strDeliveredDateTime] != null) {
      deliveredDateTime = message[parameters.strDeliveredDateTime];
    }
    if (message[parameters.strisFromCareCoordinator] != null) {
      var currentVal = message[parameters.strisFromCareCoordinator];
      if (currentVal.runtimeType == String) {
        isFromCareCoordinator =
            (message[parameters.strisFromCareCoordinator] ?? "false") == "true";
      } else if (currentVal.runtimeType == bool) {
        isFromCareCoordinator = message[parameters.strisFromCareCoordinator];
      }
    }
    if (message[parameters.isWeb] != null) {
      if (message[parameters.isWeb].runtimeType == String) {
        isWeb =
            message[parameters.isWeb].toLowerCase() == 'true' ? true : false;
      }
    }
  }
}
