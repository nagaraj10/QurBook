// To parse this JSON data, do
//
//     final regimentModel = regimentModelFromJson(jsonString);

import 'dart:convert';
import 'package:myfhb/regiment/models/regiment_data_model.dart';

List<RegimentDataModel> regimentModelFromJson(String str) =>
    List<RegimentDataModel>.from(
        json.decode(str).map((x) => RegimentDataModel.fromJson(x)));

String regimentModelToJson(List<RegimentDataModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RegimentResponseModel {
  RegimentResponseModel({
    this.isSuccess,
    this.regimentsList,
  });

  final bool isSuccess;
  final List<RegimentDataModel> regimentsList;

  factory RegimentResponseModel.fromJson(Map<String, dynamic> json) =>
      RegimentResponseModel(
        isSuccess: json["isSuccess"],
        regimentsList: List<RegimentDataModel>.from(
            json["result"].map((x) => RegimentDataModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "result":
            List<RegimentDataModel>.from(regimentsList.map((x) => x.toJson())),
      };
}

// class RegimentDataModel {
//   RegimentDataModel({
//     this.eid,
//     this.providerid,
//     this.uid,
//     this.title,
//     this.description,
//     this.tplanid,
//     this.teidUser,
//     this.aid,
//     this.activityname,
//     this.uformid,
//     this.uformname,
//     this.estart,
//     this.eend,
//     this.html,
//     this.otherinfo,
//     this.remindin,
//     this.remindinType,
//     this.ack,
//     this.alarm,
//     this.uformdata,
//     this.ts,
//     this.deleted,
//     this.hashtml,
//     this.hascustform,
//     this.hasform,
//     this.saytext,
//   });
//
//   final String eid;
//   final String providerid;
//   final String uid;
//   final String title;
//   final String description;
//   final String tplanid;
//   final String teidUser;
//   final String aid;
//   final Activityname activityname;
//   final String uformid;
//   final Uformname uformname;
//   final DateTime estart;
//   final DateTime eend;
//   final dynamic html;
//   final Otherinfo otherinfo;
//   final String remindin;
//   final String remindinType;
//   final DateTime ack;
//   final String alarm;
//   final String uformdata;
//   final DateTime ts;
//   final String deleted;
//   final int hashtml;
//   final int hascustform;
//   final int hasform;
//   final String saytext;
//
//   factory RegimentDataModel.fromJson(Map<String, dynamic> json) =>
//       RegimentDataModel(
//         eid: json["eid"],
//         providerid: json["providerid"],
//         uid: json["uid"],
//         title: json["title"],
//         description: json["description"],
//         tplanid: json["tplanid"],
//         teidUser: json["teid_user"],
//         aid: json["aid"],
//         activityname: activitynameValues.map[json["activityname"]],
//         uformid: json["uformid"],
//         uformname: uformnameValues.map[json["uformname"]],
//         estart: DateTime.parse(json["estart"]),
//         eend: DateTime.parse(json["eend"]),
//         html: json["html"],
//         otherinfo: Otherinfo.fromJson(json["otherinfo"]),
//         remindin: json["remindin"],
//         remindinType: json["remindin_type"],
//         ack: json["ack"] == null ? null : DateTime.parse(json["ack"]),
//         alarm: json["alarm"],
//         uformdata: json["uformdata"] == null ? null : json["uformdata"],
//         ts: DateTime.parse(json["ts"]),
//         deleted: json["deleted"],
//         hashtml: json["hashtml"],
//         hascustform: json["hascustform"],
//         hasform: json["hasform"],
//         saytext: json["saytext"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "eid": eid,
//         "providerid": providerid,
//         "uid": uid,
//         "title": title,
//         "description": description,
//         "tplanid": tplanid,
//         "teid_user": teidUser,
//         "aid": aid,
//         "activityname": activitynameValues.reverse[activityname],
//         "uformid": uformid,
//         "uformname": uformnameValues.reverse[uformname],
//         "estart": estart.toIso8601String(),
//         "eend": eend.toIso8601String(),
//         "html": html,
//         "otherinfo": otherinfo.toJson(),
//         "remindin": remindin,
//         "remindin_type": remindinType,
//         "ack": ack == null ? null : ack.toIso8601String(),
//         "alarm": alarm,
//         "uformdata": uformdata == null ? null : uformdata,
//         "ts": ts.toIso8601String(),
//         "deleted": deleted,
//         "hashtml": hashtml,
//         "hascustform": hascustform,
//         "hasform": hasform,
//         "saytext": saytext,
//       };
// }
//
// enum Activityname { DIET, VITALS, MEDICATION, SCREENING }
//
// final activitynameValues = EnumValues({
//   "diet": Activityname.DIET,
//   "medication": Activityname.MEDICATION,
//   "screening": Activityname.SCREENING,
//   "vitals": Activityname.VITALS
// });
//
// class Otherinfo {
//   Otherinfo({
//     this.needPhoto,
//     this.needAudio,
//     this.needVideo,
//     this.needFile,
//   });
//
//   final dynamic needPhoto;
//   final dynamic needAudio;
//   final dynamic needVideo;
//   final int needFile;
//
//   factory Otherinfo.fromJson(Map<String, dynamic> json) => Otherinfo(
//         needPhoto: json["NeedPhoto"],
//         needAudio: json["NeedAudio"],
//         needVideo: json["NeedVideo"],
//         needFile: json["NeedFile"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "NeedPhoto": needPhoto,
//         "NeedAudio": needAudio,
//         "NeedVideo": needVideo,
//         "NeedFile": needFile,
//       };
// }
//
// enum Uformname { EMPTY, BLOODPRESSURE, BLOODSUGAR }
//
// final uformnameValues = EnumValues({
//   "bloodpressure": Uformname.BLOODPRESSURE,
//   "bloodsugar": Uformname.BLOODSUGAR,
//   "": Uformname.EMPTY
// });
//
// class EnumValues<T> {
//   Map<String, T> map;
//   Map<T, String> reverseMap;
//
//   EnumValues(this.map);
//
//   Map<T, String> get reverse {
//     if (reverseMap == null) {
//       reverseMap = map.map((k, v) => new MapEntry(v, k));
//     }
//     return reverseMap;
//   }
// }
