import 'dart:convert';
import 'package:timezone/timezone.dart' as tz;

class Reminder {
  String? eid;
  String? title;
  String? description;
  String? estart;
  String? tplanid;
  String? teid_user;
  String? activityname;
  String? uformname;
  String? remindin;
  String? remindin_type;
  String? remindbefore;
  String? remindbefore_type;
  String? providerid;
  String? providername;
  bool alreadyScheduled = false;
  bool evDisabled;
  String? importance;
  String? ack;
  String? ack_local;
  String? dosemeal;
  String? snoozeTime;
  // Nullable string to store the notification list ID associated with the notification.
  String? notificationListId;

  // Nullable string to store the redirection target when the notification is tapped.
  String? redirectTo;

  // Nullable integer to store the count of times the snooze action is tapped for the notification.
  int? snoozeTapCountTime;

  Otherinfo? otherinfo;


  // for restrict the reminders based on patient view access flag
  bool? isPatientViewAccess = false;




  Reminder(
      {this.eid,
        this.title,
        this.description,
        this.estart,
        this.tplanid,
        this.teid_user,
        this.activityname,
        this.uformname,
        this.remindin,
        this.remindin_type,
        this.providerid,
        this.providername,
        this.remindbefore,
        this.remindbefore_type,
        this.evDisabled = false,
        this.importance = "0",
        this.ack = "",
        this.snoozeTime = '',
        this.ack_local = "",this.dosemeal,this.notificationListId,this.redirectTo,this.snoozeTapCountTime,this.otherinfo,this.isPatientViewAccess});

  Reminder copyWith(
      {String? eid,
        String? title,
        String? description,
        String? estart,
        String? tplanid,
        String? teid_user,
        String? activityname,
        String? uformname,
        String? remindin,
        String? remindin_type,
        String? remindbefore,
        String? remindbefore_type,
        String? providerid,
        String? providername,
        bool? evDisabled,
        int? importance,
        String? ack,
        String? snoozeTime,
        String? ack_local,String? dosemeal,String? notificationListId,String? redirectTo,int? snoozeTapCountTime,tz.TZDateTime? scheduledDateTime,Otherinfo? otherinfo,bool? isPatientViewAccess}) {
    return Reminder(
      eid: eid ?? this.eid,
      title: title ?? this.title,
      description: description ?? this.description,
      estart: estart ?? this.estart,
      tplanid: tplanid ?? this.tplanid,
      teid_user: teid_user ?? this.teid_user,
      activityname: activityname ?? this.activityname,
      uformname: uformname ?? this.uformname,
      remindin: remindin ?? this.remindin,
      remindin_type: remindin_type ?? this.remindin_type,
      providerid: providerid ?? this.providerid,
      providername: providername ?? this.providername,
      evDisabled: evDisabled ?? this.evDisabled,
      remindbefore: remindbefore ?? this.remindbefore,
      remindbefore_type: remindbefore_type ?? this.remindbefore_type,
      importance: importance as String? ?? this.importance,
      ack: ack ?? this.ack,
      snoozeTime: snoozeTime ?? this.snoozeTime,
      ack_local: ack_local ?? this.ack_local,
      dosemeal: dosemeal ?? this.dosemeal,
      notificationListId: notificationListId ?? this.notificationListId,
      redirectTo: redirectTo ?? this.redirectTo,
      snoozeTapCountTime: snoozeTapCountTime ?? this.snoozeTapCountTime,
      otherinfo: otherinfo ?? this.otherinfo,
      isPatientViewAccess: isPatientViewAccess ?? this.isPatientViewAccess,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'eid': eid,
      'title': title,
      'description': description,
      'estart': estart,
      'tplanid': tplanid,
      'teid_user': teid_user,
      'activityname': activityname,
      'uformname': uformname,
      'remindin': remindin,
      'remindin_type': remindin_type,
      'remindbefore': remindbefore,
      'remindbefore_type': remindbefore_type,
      'providerid': providerid,
      'providername': providername,
      'alreadyScheduled': alreadyScheduled,
      'ev_disabled': evDisabled,
      'importance': importance,
      'ack': ack,
      'snoozeTime': snoozeTime,
      'ack_local': ack_local,
      'dosemeal': dosemeal,
      'notificationListId': notificationListId,
      'redirectTo': redirectTo,
      'snoozeTapCountTime': snoozeTapCountTime,
      'otherinfo': otherinfo,
      'isPatientViewAccess': isPatientViewAccess,
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      eid: map['eid'],
      title: map['title'],
      description: map['description'],
      estart: map['estart'],
      tplanid: map['tplanid'],
      teid_user: map['teid_user'],
      activityname: map['activityname'],
      uformname: map['uformname'],
      remindin: (map['remindin']??'0'),
      remindin_type: map['remindin_type'],
      remindbefore: (map['remindbefore']??'0'),
      remindbefore_type: map['remindbefore_type'],
      providerid: map['providerid'],
      providername: map['providername'],
      importance: map['importance'],
      evDisabled: (map['ev_disabled'] ?? '0') == '1',
      ack: map['ack'],
      snoozeTime: map['snoozeTime'],
      ack_local: map['ack_local'],
      dosemeal: map['dosemeal'],
      notificationListId: map['notificationListId'],
      redirectTo: map['redirectTo'],
      snoozeTapCountTime: map['snoozeTapCountTime'],
      otherinfo:map['otherinfo'] != null && map['otherinfo'] is String
          ? Otherinfo.fromJson(jsonDecode(map['otherinfo']))
          :  Otherinfo.fromJson(map['otherinfo']??'{}'),
        isPatientViewAccess: (map['isPatientViewAccess']??false)
    );
  }

  String toJson() => json.encode(toMap());

  factory Reminder.fromJson(dynamic source) =>
      Reminder.fromMap(jsonDecode(source));

  @override
  String toString() {
    return 'Reminder(eid: $eid, title: $title, description: $description, estart: $estart, tplanid: $tplanid, teid_user: $teid_user, activityname: $activityname, uformname: $uformname, remindin: $remindin, remindin_type: $remindin_type, providerid: $providerid, providername: $providername, evDisabled: $evDisabled,ack: $ack,ack_local: $ack_local,dosemeal: $dosemeal,snoozeTime: $snoozeTime,notificationListId: $notificationListId,redirectTo: $redirectTo,snoozeTapCountTime: $snoozeTapCountTime,otherinfo:$otherinfo,isPatientViewAccess:$isPatientViewAccess)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Reminder &&
        other.eid == eid &&
        other.title == title &&
        other.description == description &&
        other.estart == estart &&
        other.tplanid == tplanid &&
        other.teid_user == teid_user &&
        other.activityname == activityname &&
        other.uformname == uformname &&
        other.remindin == remindin &&
        other.remindin_type == remindin_type &&
        other.remindbefore == remindbefore &&
        other.remindbefore_type == remindbefore_type &&
        other.providerid == providerid &&
        other.providername == providername &&
        other.evDisabled == evDisabled &&
        other.importance == importance &&
        other.ack == ack &&
        other.snoozeTime == snoozeTime &&
        other.ack_local == ack_local&&
        other.dosemeal == dosemeal&&
        other.notificationListId == notificationListId&&
        other.redirectTo == redirectTo&&
        other.snoozeTapCountTime == snoozeTapCountTime;
  }

  @override
  int get hashCode {
    return eid.hashCode ^
    title.hashCode ^
    description.hashCode ^
    estart.hashCode ^
    tplanid.hashCode ^
    teid_user.hashCode ^
    activityname.hashCode ^
    uformname.hashCode ^
    remindin.hashCode ^
    remindin_type.hashCode ^
    providerid.hashCode ^
    providername.hashCode ^
    importance.hashCode ^
    ack.hashCode ^
    snoozeTime.hashCode ^
    ack_local.hashCode ^
    dosemeal.hashCode ^
    notificationListId.hashCode ^
    redirectTo.hashCode ^
    snoozeTapCountTime.hashCode ^
    evDisabled.hashCode;
  }
}
class Otherinfo {
  Otherinfo({
    this.needPhoto,
    this.needAudio,
    this.needVideo,
    this.needFile,
    this.snoozeText,
    this.introText,
    this.isAllDayActivity,
    this.isSkipAcknowledgement,
    this.postRemindercheck,
    this.postreminderdurationbyminutes,
  });

  final String? needPhoto;
  final String? needAudio;
  final String? needVideo;
  final String? needFile;
  final String? snoozeText;
  final String? introText;
  final bool? isAllDayActivity;
  final String? isSkipAcknowledgement;
  final bool? postRemindercheck;
  final String? postreminderdurationbyminutes;

  factory Otherinfo.fromJson(Map<String, dynamic> json) {
    return Otherinfo(
      needPhoto: json['NeedPhoto'] ?? '0',
      needAudio: json['NeedAudio'] ?? '0',
      needVideo: json['NeedVideo'] ?? '0',
      needFile: json['NeedFile'] ?? '0',
      snoozeText: json['snoozeText'] ?? '',
      introText: json['introtext'] ?? '',
      isAllDayActivity: json['isAllDayActivity'] ?? false,
      isSkipAcknowledgement: json['isSkipAcknowledgement'] ?? '0',
      postRemindercheck: json['postRemindercheck'] ?? false,
      postreminderdurationbyminutes: json['postreminderdurationbyminutes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'NeedPhoto': needPhoto,
      'NeedAudio': needAudio,
      'NeedVideo': needVideo,
      'NeedFile': needFile,
      'snoozeText': snoozeText,
      'introtext': introText,
      'isAllDayActivity': isAllDayActivity,
      'isSkipAcknowledgement': isSkipAcknowledgement,
      'postRemindercheck': postRemindercheck,
      'postreminderdurationbyminutes': postreminderdurationbyminutes,
    };
  }
}