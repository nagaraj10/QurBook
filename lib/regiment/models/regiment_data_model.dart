import 'dart:convert';

class RegimentDataModel {
  RegimentDataModel({
    this.eid,
    this.providerid,
    this.uid,
    this.title,
    this.description,
    this.tplanid,
    this.teidUser,
    this.aid,
    this.activityname,
    this.uformid,
    this.uformname,
    this.estart,
    this.eend,
    this.html,
    this.otherinfo,
    this.remindin,
    this.remindinType,
    this.ack,
    this.alarm,
    this.uformdata,
    this.ts,
    this.deleted,
    this.evDuration,
    this.hashtml,
    this.hascustform,
    this.htmltemplate,
    this.dosesNeeded,
    this.dosesAvailable,
    this.dosesUsed,
    this.providername,
    this.hasform,
    this.saytext,
  });

  final String eid;
  final String providerid;
  final String uid;
  final String title;
  final String description;
  final String tplanid;
  final String teidUser;
  final String aid;
  final Activityname activityname;
  final String uformid;
  final Uformname uformname;
  final DateTime estart;
  final DateTime eend;
  final dynamic html;
  final Otherinfo otherinfo;
  final String remindin;
  final String remindinType;
  final DateTime ack;
  final String alarm;
  final UformData uformdata;
  final DateTime ts;
  final String deleted;
  final String evDuration;
  final int hashtml;
  final int hascustform;
  final dynamic htmltemplate;
  final String dosesNeeded;
  final String dosesAvailable;
  final String dosesUsed;
  final String providername;
  final bool hasform;
  final String saytext;

  factory RegimentDataModel.fromJson(Map<String, dynamic> json) =>
      RegimentDataModel(
        eid: json["eid"],
        providerid: json["providerid"],
        uid: json["uid"],
        title: json["title"],
        description: json["description"],
        tplanid: json["tplanid"],
        teidUser: json["teid_user"],
        aid: json["aid"],
        activityname: activitynameValues.map[json["activityname"]],
        uformid: json["uformid"],
        uformname: uformnameValues.map[json["uformname"]],
        estart: DateTime.tryParse(json["estart"] ?? ''),
        eend: DateTime.tryParse(json["eend"] ?? ''),
        html: json["html"],
        otherinfo: Otherinfo.fromJson(
            json["otherinfo"] is List ? {} : (json["otherinfo"] ?? '{}')),
        remindin: json["remindin"],
        remindinType: json["remindin_type"],
        ack: DateTime.tryParse(json["ack"] ?? ''),
        alarm: json["alarm"],
        uformdata: UformData().fromJson(jsonDecode(json["uformdata"] ?? '{}')),
        ts: DateTime.tryParse(json["ts"] ?? ''),
        deleted: json["deleted"],
        evDuration: json["ev_duration"],
        hashtml: json["hashtml"],
        hascustform: json["hascustform"],
        htmltemplate: json["htmltemplate"],
        dosesNeeded: json["doses_needed"],
        dosesAvailable: json["doses_available"],
        dosesUsed: json["doses_used"],
        providername: json["providername"],
        hasform: (json["hasform"] ?? 0) == 1,
        saytext: json["saytext"],
      );

  Map<String, dynamic> toJson() => {
        "eid": eid,
        "providerid": providerid,
        "uid": uid,
        "title": title,
        "description": description,
        "tplanid": tplanid,
        "teid_user": teidUser,
        "aid": aid,
        "activityname": activitynameValues.reverse[activityname],
        "uformid": uformid,
        "uformname": uformnameValues.reverse[uformname],
        "estart": estart.toIso8601String(),
        "eend": eend.toIso8601String(),
        "html": html,
        "otherinfo": otherinfo.toJson(),
        "remindin": remindin,
        "remindin_type": remindinType,
        "ack": ack.toIso8601String(),
        "alarm": alarm,
        "uformdata": uformdata,
        "ts": ts.toIso8601String(),
        "deleted": deleted,
        "ev_duration": evDuration,
        "hashtml": hashtml,
        "hascustform": hascustform,
        "htmltemplate": htmltemplate,
        "doses_needed": dosesNeeded,
        "doses_available": dosesAvailable,
        "doses_used": dosesUsed,
        "providername": providername,
        "hasform": hasform,
        "saytext": saytext,
      };
}

class Otherinfo {
  Otherinfo({
    this.needPhoto,
    this.needAudio,
    this.needVideo,
    this.needFile,
  });

  final String needPhoto;
  final String needAudio;
  final String needVideo;
  final String needFile;

  factory Otherinfo.fromJson(Map<String, dynamic> json) => Otherinfo(
        needPhoto: (json["NeedPhoto"] ?? 0).toString(),
        needAudio: (json["NeedAudio"] ?? 0).toString(),
        needVideo: (json["NeedVideo"] ?? 0).toString(),
        needFile: (json["NeedFile"] ?? 0).toString(),
      );

  Map<String, dynamic> toJson() => {
        "NeedPhoto": needPhoto,
        "NeedAudio": needAudio,
        "NeedVideo": needVideo,
        "NeedFile": needFile,
      };
}

class UformData {
  UformData({
    this.vitalsData,
  });

  List<VitalsData> vitalsData;

  UformData fromJson(Map<String, dynamic> json) {
    List<VitalsData> vitalsDataList = [];
    json.forEach((key, value) {
      Map<String, dynamic> vitalsMap = {};
      vitalsMap.addAll(value);
      vitalsMap.putIfAbsent('vitalName', () => key);
      vitalsDataList.add(VitalsData.fromJson(vitalsMap ?? {}));
    });
    return UformData(
      vitalsData: vitalsDataList,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {};
    vitalsData.forEach((vitalData) {
      jsonMap.putIfAbsent(vitalData.vitalName, () => vitalData.toJson());
    });
    return jsonMap;
  }
}

class VitalsData {
  VitalsData({
    this.vitalName,
    this.value,
    this.type,
    this.display,
    this.alarm,
    this.amin,
    this.amax,
    this.fieldType,
  });

  String vitalName;
  String value;
  String type;
  String display;
  int alarm;
  String amin;
  String amax;
  FieldType fieldType;

  factory VitalsData.fromJson(Map<String, dynamic> json) {
    return VitalsData(
      vitalName: json["vitalName"] ?? '',
      value: json["value"],
      type: json["type"],
      display: json["display"],
      alarm: json["alarm"],
      amin: json["amin"],
      amax: json["amax"],
      fieldType: fieldTypeValues.map[json["type"]],
    );
  }

  Map<String, dynamic> toJson() => {
        "value": value,
        "type": type,
        "display": display,
        "alarm": alarm,
        "amin": amin,
        "amax": amax,
      };
}

enum Activityname { DIET, VITALS, MEDICATION, SCREENING }

final activitynameValues = EnumValues({
  "diet": Activityname.DIET,
  "medication": Activityname.MEDICATION,
  "screening": Activityname.SCREENING,
  "vitals": Activityname.VITALS
});

enum FieldType { NUMBER, CHECKBOX, TEXT, LOOKUP, RADIO }

final fieldTypeValues = EnumValues({
  "number": FieldType.NUMBER,
  "checkbox": FieldType.CHECKBOX,
  "text": FieldType.TEXT,
  "lookup": FieldType.LOOKUP,
  "check": FieldType.CHECKBOX,
  "radio": FieldType.RADIO,
});

enum Uformname { EMPTY, BLOODPRESSURE, BLOODSUGAR }

final uformnameValues = EnumValues({
  "bloodpressure": Uformname.BLOODPRESSURE,
  "bloodsugar": Uformname.BLOODSUGAR,
  "": Uformname.EMPTY
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
