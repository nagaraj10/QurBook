import 'dart:convert';

import 'package:myfhb/plan_dashboard/model/MetaDataForURL.dart';

class MyPlanListModel {
  bool isSuccess;
  List<MyPlanListResult> result;

  MyPlanListModel({this.isSuccess, this.result});

  MyPlanListModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['result'] != null) {
      result = new List<MyPlanListResult>();
      json['result'].forEach((v) {
        result.add(new MyPlanListResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MyPlanListResult {
  String packageid;
  String title;
  String docid;
  String price;
  String paid;
  String packcatid;
  String catname;
  String catdesc;
  String docNick;
  String providerid;
  String providerName;
  String startdate;
  String duration;
  String enddate;
  String isexpired;
  MetaDataForURL metadata;
  MetaDataForURL catmetadata;

  MyPlanListResult(
      {this.packageid,
      this.title,
      this.docid,
      this.price,
      this.paid,
      this.packcatid,
      this.catname,
      this.catdesc,
      this.docNick,
      this.providerid,
      this.providerName,
      this.startdate,
      this.duration,
      this.enddate,
      this.isexpired,
      this.metadata,
      this.catmetadata});

  factory MyPlanListResult.fromJson(Map<String, dynamic> json) {
    return MyPlanListResult(
        packageid: json['packageid'],
        title: json['title'],
        docid: json['docid'],
        price: json['price'],
        paid: json['paid'],
        packcatid: json['packcatid'],
        catname: json['catname'],
        catdesc: json['catdesc'],
        docNick: json['doc_nick'],
        providerid: json['providerid'],
        providerName: json['provider_name'],
        startdate: json['startdate'],
        duration: json['duration'],
        enddate: json['enddate'],
        isexpired: json['isexpired'],
        metadata:
            json['metadata'] != null && json['metadata'].toString().isNotEmpty
                ? MetaDataForURL.fromJson(jsonDecode(json["metadata"] ?? '{}'))
                : null,
        catmetadata: json['catmetadata'] != null &&
                json['catmetadata'].toString().isNotEmpty
            ? MetaDataForURL.fromJson(jsonDecode(json["catmetadata"] ?? '{}'))
            : null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['packageid'] = this.packageid;
    data['title'] = this.title;
    data['docid'] = this.docid;
    data['price'] = this.price;
    data['paid'] = this.paid;
    data['packcatid'] = this.packcatid;
    data['catname'] = this.catname;
    data['catdesc'] = this.catdesc;
    data['doc_nick'] = this.docNick;
    data['providerid'] = this.providerid;
    data['provider_name'] = this.providerName;
    data['startdate'] = this.startdate;
    data['duration'] = this.duration;
    data['enddate'] = this.enddate;
    data['isexpired'] = this.isexpired;
    data['metadata'] = this.metadata;
    data['metadata'] = this.catmetadata;
    return data;
  }
}
