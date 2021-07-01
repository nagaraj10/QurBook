import 'dart:convert';

import '../../plan_dashboard/model/MetaDataForURL.dart';

import 'ProviderMetaModel.dart';

class MyPlanListModel {
  bool isSuccess;
  List<MyPlanListResult> result;

  MyPlanListModel({this.isSuccess, this.result});

  MyPlanListModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['result'] != null) {
      result = List<MyPlanListResult>();
      json['result'].forEach((v) {
        result.add(MyPlanListResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['isSuccess'] = isSuccess;
    if (result != null) {
      data['result'] = result.map((v) => v.toJson()).toList();
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
  ProviderMetaModel providermetadata;

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
      this.catmetadata,this.providermetadata});

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
                ? MetaDataForURL.fromJson(jsonDecode(json['metadata'] ?? '{}'))
                : null,
        catmetadata: json['catmetadata'] != null &&
                json['catmetadata'].toString().isNotEmpty
            ? MetaDataForURL.fromJson(jsonDecode(json['catmetadata'] ?? '{}'))
            : null,
    providermetadata: json['providermetadata'] != null &&
        json['providermetadata'].toString().isNotEmpty
        ? ProviderMetaModel.fromJson(jsonDecode(json['providermetadata'] ?? '{}'))
        : null);
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['packageid'] = packageid;
    data['title'] = title;
    data['docid'] = docid;
    data['price'] = price;
    data['paid'] = paid;
    data['packcatid'] = packcatid;
    data['catname'] = catname;
    data['catdesc'] = catdesc;
    data['doc_nick'] = docNick;
    data['providerid'] = providerid;
    data['provider_name'] = providerName;
    data['startdate'] = startdate;
    data['duration'] = duration;
    data['enddate'] = enddate;
    data['isexpired'] = isexpired;
    data['metadata'] = metadata;
    data['catmetadata'] = catmetadata;
    data['providermetadata'] = providermetadata;
    return data;
  }
}
