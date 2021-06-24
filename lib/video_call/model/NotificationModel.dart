import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/video_call/model/CallArguments.dart';

class NotificationModel {
  String title;
  String body;
  String ringtone;
  String templateName;
  String userId;
  String idToHighlight;
  String redirect;
  String healthRecordMetaIds;
  bool isCall = false;
  bool needToHighlight = false;
  bool isCancellation = false;
  String meeting_id;
  String doctorId;
  String username;
  String type;
  String externalLink;
  CallArguments callArguments;
  Map<int, dynamic> redirectData;

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
      this.externalLink});

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
      'username': username,
      'type': type,
      'externalLink': externalLink
    };
  }

  NotificationModel.fromSharePreferences(Map<String, dynamic> message) {
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
    username = message['username'];
    type = message['type'];
    externalLink = message['externalLink'];
  }

  NotificationModel.fromMap(Map<String, dynamic> messageFromNative) {
    if (messageFromNative[parameters.notification] != null) {
      setData(messageFromNative[parameters.notification]);
    } else if (messageFromNative[parameters.aps] != null) {
      final aps = messageFromNative[parameters.aps];
      if (aps[parameters.alert] != null) {
        final message = aps[parameters.alert];
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
        if (message[parameters.meeting_id] != null) {
          meeting_id = message[parameters.meeting_id];
        }
        if (message[parameters.doctorId] != null) {
          doctorId = message[parameters.doctorId];
        }
        if (message[parameters.username] != null) {
          username = message[parameters.username];
        }
        if (message[parameters.strtype] != null) {
          type = message[parameters.strtype];
        }
        if (message[parameters.externalLink] != null) {
          externalLink = message[parameters.externalLink];
        }
        if (message[parameters.gcmExternalLink] != null) {
          externalLink = message[parameters.gcmExternalLink];
        }
      }
    }
    setData(messageFromNative);
    if (redirect != null && redirect.contains('|')) {
      final split = redirect.split('|');
      redirectData = {for (int i = 0; i < split.length; i++) i: split[i]};
      redirectData[split.length] = healthRecordMetaIds;
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
    if (isCall) {
      callArguments = CallArguments(
          role: ClientRole.Broadcaster,
          channelName: meeting_id,
          userName: username,
          doctorId: doctorId);
    }
  }

  void setData(Map<String, dynamic> message) {
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
    if (message[parameters.meeting_id] != null) {
      meeting_id = message[parameters.meeting_id];
    }
    if (message[parameters.doctorId] != null) {
      doctorId = message[parameters.doctorId];
    }
    if (message[parameters.username] != null) {
      username = message[parameters.username];
    }
    if (message[parameters.strtype] != null) {
      type = message[parameters.strtype];
    }
    if (message[parameters.externalLink] != null) {
      externalLink = message[parameters.externalLink];
    }
    if (message[parameters.gcmExternalLink] != null) {
      externalLink = message[parameters.gcmExternalLink];
    }
  }
}
