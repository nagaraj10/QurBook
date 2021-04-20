// To parse this JSON data, do
//
//     final regimentDataModel = regimentDataModelFromJson(jsonString);

import 'dart:convert';

List<RegimentDataModel> regimentDataModelFromJson(String str) =>
    List<RegimentDataModel>.from(
        json.decode(str).map((x) => RegimentDataModel.fromJson(x)));

String regimentDataModelToJson(List<RegimentDataModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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
        otherinfo: Otherinfo.fromJson(jsonDecode(json["otherinfo"] ?? '{}')),
        remindin: json["remindin"],
        remindinType: json["remindin_type"],
        ack: DateTime.tryParse(json["ack"] ?? ''),
        alarm: json["alarm"],
        uformdata: UformData().fromJson(jsonDecode(json["uformdata"] ?? '{}')),
        ts: DateTime.tryParse(json["ts"] ?? ''),
        deleted: json["deleted"],
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
      };
}

class Otherinfo {
  Otherinfo({
    this.needPhoto,
    this.needAudio,
    this.needVideo,
    this.needFile,
  });

  final dynamic needPhoto;
  final dynamic needAudio;
  final dynamic needVideo;
  final int needFile;

  factory Otherinfo.fromJson(Map<String, dynamic> json) => Otherinfo(
        needPhoto: json["NeedPhoto"],
        needAudio: json["NeedAudio"],
        needVideo: json["NeedVideo"],
        needFile: json["NeedFile"],
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
