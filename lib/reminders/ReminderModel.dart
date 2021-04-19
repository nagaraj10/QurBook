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
  String providerid;
  String providername;

  Reminder({
    this.eid,
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
  });

  Reminder copyWith({
    String eid,
    String title,
    String description,
    String estart,
    String tplanid,
    String teid_user,
    String activityname,
    String uformname,
    String remindin,
    String remindin_type,
    String providerid,
    String providername,
  }) {
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
      'providerid': providerid,
      'providername': providername,
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
      providerid: map['providerid'],
      providername: map['providername'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Reminder.fromJson(String source) =>
      Reminder.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Reminder(eid: $eid, title: $title, description: $description, estart: $estart, tplanid: $tplanid, teid_user: $teid_user, activityname: $activityname, uformname: $uformname, remindin: $remindin, remindin_type: $remindin_type, providerid: $providerid, providername: $providername)';
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
        other.providerid == providerid &&
        other.providername == providername;
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
        providername.hashCode;
  }
}
