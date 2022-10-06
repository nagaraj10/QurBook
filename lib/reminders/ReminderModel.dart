import 'dart:convert';

class Reminder {
  String eid;
  String title;
  String description;
  String estart;
  String tplanid;
  String teid_user;
  String activityname;
  String uformname;
  String remindin;
  String remindin_type;
  String remindbefore;
  String remindbefore_type;
  String providerid;
  String providername;
  bool alreadyScheduled = false;
  bool evDisabled;
  String importance;
  String ack;
  String ack_local;

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
      this.ack_local = ""});

  Reminder copyWith(
      {String eid,
      String title,
      String description,
      String estart,
      String tplanid,
      String teid_user,
      String activityname,
      String uformname,
      String remindin,
      String remindin_type,
      String remindbefore,
      String remindbefore_type,
      String providerid,
      String providername,
      bool evDisabled,
      int importance,
      String ack,
      String ack_local}) {
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
      importance: importance ?? this.importance,
      ack: ack ?? this.ack,
      ack_local: ack_local ?? this.ack_local,
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
      'ack_local': ack_local,
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
      remindin: map['remindin'],
      remindin_type: map['remindin_type'],
      remindbefore: map['remindbefore'],
      remindbefore_type: map['remindbefore_type'],
      providerid: map['providerid'],
      providername: map['providername'],
      importance: map['importance'],
      evDisabled: (map['ev_disabled'] ?? '0') == '1',
      ack: map['ack'],
      ack_local: map['ack_local'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Reminder.fromJson(String source) =>
      Reminder.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Reminder(eid: $eid, title: $title, description: $description, estart: $estart, tplanid: $tplanid, teid_user: $teid_user, activityname: $activityname, uformname: $uformname, remindin: $remindin, remindin_type: $remindin_type, providerid: $providerid, providername: $providername, evDisabled: $evDisabled,ack: $ack,ack_local: $ack_local,)';
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
        other.ack_local == ack_local;
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
        ack_local.hashCode ^
        evDisabled.hashCode;
  }
}
