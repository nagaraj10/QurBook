import 'dart:convert';

import 'package:myfhb/regiment/models/regiment_data_model.dart';

class QurHomeRegimenResponseModel {
  bool isSuccess;
  Result result;

  QurHomeRegimenResponseModel({this.isSuccess, this.result});

  QurHomeRegimenResponseModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    result =
    json['result'] != null ?  Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class Result {
  String date;
  List<UpcomingActivities> upcomingActivities;

  Result(
      {this.date,
        this.upcomingActivities});

  Result.fromJson(Map<String, dynamic> json) {
    date = json['date'];

    if (json['upcomingActivities'] != null) {
      upcomingActivities = [];
      json['upcomingActivities'].forEach((v) {
        upcomingActivities.add(new UpcomingActivities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;

    if (this.upcomingActivities != null) {
      data['upcomingActivities'] =
          this.upcomingActivities.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UpcomingActivities {
  int eid;
  String description;
  String title;
  DateTime estart;
  String eend;
  String otherinfo;
  Uformname uformname;
  Activityname activityname;
  Metadata metadata;

  UpcomingActivities(
      {this.eid,
        this.description,
        this.title,
        this.estart,
        this.eend,
        this.otherinfo,
        this.uformname,
        this.activityname,
        this.metadata});

  UpcomingActivities.fromJson(Map<String, dynamic> json) {
    eid = json['eid'];
    description = json['description'];
    title = json['title'];
    estart = DateTime.tryParse(json['estart'] ?? '');
    eend = json['eend'];
    otherinfo = json['otherinfo'];
    uformname= uformnameValues.map[json['uformname']];
    activityname= activitynameValues.map[json['activityname']];
    metadata=Metadata.fromJson(json['metadata'] !=null?jsonDecode(json['metadata']) :{});
  }



  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eid'] = this.eid;
    data['description'] = this.description;
    data['title'] = this.title;
    data['estart'] = this.estart;
    data['eend'] = this.eend;
    data['otherinfo'] = this.otherinfo;
    data['uformname'] = this.uformname;
    data['activityname'] = this.activityname;
    data['metadata'] = this.metadata;
    return data;
  }
}
// enum Activityname { DIET, VITALS, MEDICATION, SCREENING, SYMPTOM }
//
// final activitynameValues = EnumValues({
//   'diet': Activityname.DIET,
//   'medication': Activityname.MEDICATION,
//   'screening': Activityname.SCREENING,
//   'vitals': Activityname.VITALS,
//   'symptom': Activityname.SYMPTOM
// });
//
// enum Uformname { EMPTY, BLOODPRESSURE, BLOODSUGAR, PULSE }
//
// final uformnameValues = EnumValues({
//   'bloodpressure': Uformname.BLOODPRESSURE,
//   'bloodsugar': Uformname.BLOODSUGAR,
//   'pulse': Uformname.PULSE,
//   '': Uformname.EMPTY
// });
//
// class Metadata {
//   Metadata({
//     this.icon,
//     this.color,
//     this.bgcolor,
//     this.metadatafrom,
//   });
//
//   final String icon;
//   final String color;
//   final String bgcolor;
//   final String metadatafrom;
//
//   factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
//     icon: json['icon'],
//     color: json['color'],
//     bgcolor: json['bgcolor'],
//     metadatafrom: json['metadatafrom'],
//   );
//
//   Map<String, dynamic> toJson() => {
//     'icon': icon,
//     'color': color,
//     'bgcolor': bgcolor,
//     'metadatafrom': metadatafrom,
//   };
// }
