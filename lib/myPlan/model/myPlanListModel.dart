import 'dart:convert';

import 'package:myfhb/common/CommonUtil.dart';

import '../../plan_dashboard/model/MetaDataForURL.dart';

import 'ProviderMetaModel.dart';

class MyPlanListModel {
  bool? isSuccess;
  List<MyPlanListResult>? result;

  MyPlanListModel({this.isSuccess, this.result});

  MyPlanListModel.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      if (json['result'] != null) {
        result = <MyPlanListResult>[];
        json['result'].forEach((v) {
          result!.add(MyPlanListResult.fromJson(v));
        });
      }
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['isSuccess'] = isSuccess;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MyPlanListResult {
  String? packageid;
  String? title;
  String? tags;
  String? docid;
  String? price;
  String? paid;
  String? packcatid;
  String? catname;
  String? catdesc;
  String? docNick;
  String? providerid;
  String? providerName;
  String? startdate;
  String? duration;
  String? enddate;
  String? isexpired;
  String? isExtendable;
  String? ispublic;
  MetaDataForURL? metadata;
  MetaDataForURL? catmetadata;
  ProviderMetaModel? providermetadata;

  MyPlanListResult(
      {this.packageid,
      this.title,
      this.tags,
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
      this.isExtendable,
      this.ispublic,
      this.catmetadata,
      this.providermetadata});

  factory MyPlanListResult.fromJson(Map<String, dynamic> json) {
    return MyPlanListResult(
        packageid: json['packageid'],
        title: json['title'],
        tags: json['tags'],
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
        isExtendable: json['IsExtendable'],
        ispublic: json['ispublic'],
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
            ? ProviderMetaModel.fromJson(
                jsonDecode(json['providermetadata'] ?? '{}'))
            : null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['packageid'] = this.packageid;
    data['title'] = this.title;
    data['tags'] = this.tags;
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
    data['catmetadata'] = this.catmetadata;
    data['providermetadata'] = this.providermetadata;
    data['IsExtendable'] = this.isExtendable;
    data['ispublic'] = this.ispublic;
    return data;
  }
}
