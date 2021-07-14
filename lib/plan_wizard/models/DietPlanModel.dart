// To parse this JSON data, do
//
//     final dietPlanModel = dietPlanModelFromJson(jsonString);

import 'dart:convert';

import 'package:myfhb/plan_dashboard/model/MetaDataForHospitalLogo.dart';
import 'package:myfhb/plan_dashboard/model/MetaDataForURL.dart';

DietPlanModel dietPlanModelFromJson(String str) => DietPlanModel.fromJson(json.decode(str));

String dietPlanModelToJson(DietPlanModel data) => json.encode(data.toJson());

class DietPlanModel {
  DietPlanModel({
    this.isSuccess,
    this.result,
  });

  final bool isSuccess;
  final List<List<DietPlanResult>> result;

  factory DietPlanModel.fromJson(Map<String, dynamic> json) => DietPlanModel(
    isSuccess: json["isSuccess"],
    result: List<List<DietPlanResult>>.from(json["result"]?.map((x) => List<DietPlanResult>.from(x?.map((x) => DietPlanResult.fromJson(x??{}))))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "result": List<dynamic>.from(result.map((x) => List<dynamic>.from(x?.map((x) => x?.toJson())))),
  };
}

class DietPlanResult {
  DietPlanResult({
    this.packageid,
    this.title,
    this.tags,
    this.description,
    this.docid,
    this.price,
    this.metadata,
    this.issubscription,
    this.ispublic,
    this.html,
    this.packageDuration,
    this.billingCycle,
    this.ts,
    this.providerid,
    this.providerName,
    this.providermetadata,
    this.providerdescription,
    this.plinkid,
    this.packcatid,
    this.catname,
    this.catdesc,
    this.catselecttype,
    this.catmetadata,
    this.userpackid,
    this.isSubscribed,
    this.startdate,
    this.userpackageduration,
    this.enddate,
    this.isexpired,
    this.matchcount,
  });

  final String packageid;
  final String title;
  final String tags;
  final String description;
  final String docid;
  final String price;
  final MetaDataForURL metadata;
  final String issubscription;
  final String ispublic;
  final String html;
  final String packageDuration;
  final String billingCycle;
  final DateTime ts;
  final String providerid;
  final String providerName;
  final MetaDataForHospitalLogo providermetadata;
  final String providerdescription;
  final String plinkid;
  final String packcatid;
  final String catname;
  final String catdesc;
  final String catselecttype;
  final MetaDataForURL catmetadata;
  final dynamic userpackid;
  final String isSubscribed;
  final dynamic startdate;
  final dynamic userpackageduration;
  final dynamic enddate;
  final String isexpired;
  final int matchcount;

  factory DietPlanResult.fromJson(Map<String, dynamic> json) => DietPlanResult(
    packageid: json["packageid"],
    title: json["title"],
    tags: json["tags"],
    description: json["description"],
    docid: json["docid"],
    price: json["price"],
    metadata:
    json['metadata'] != null && json['metadata'].toString().isNotEmpty
        ? MetaDataForURL.fromJson(jsonDecode(json["metadata"] ?? '{}'))
        : null,
    catmetadata: json['catmetadata'] != null &&
        json['catmetadata'].toString().isNotEmpty
        ? MetaDataForURL.fromJson(jsonDecode(json["catmetadata"] ?? '{}'))
        : null,
    providermetadata: json['providermetadata'] != null &&
        json['providermetadata'].toString().isNotEmpty
        ? MetaDataForHospitalLogo.fromJson(
        jsonDecode(json["providermetadata"] ?? '{}'))
        : null,
    issubscription: json["issubscription"] == null ? null : json["issubscription"],
    ispublic: json["ispublic"],
    html: json["html"] == null ? null : json["html"],
    packageDuration: json["PackageDuration"],
    billingCycle: json["BillingCycle"] == null ? null : json["BillingCycle"],
    ts: DateTime.parse(json["ts"]),
    providerid: json["providerid"],
    providerName: json["provider_name"],
    providerdescription: json["providerdescription"],
    plinkid: json["plinkid"],
    packcatid: json["packcatid"],
    catname: json["catname"],
    catdesc: json["catdesc"],
    catselecttype: json["catselecttype"],
    userpackid: json["userpackid"],
    isSubscribed: json["IsSubscribed"],
    startdate: json["startdate"],
    userpackageduration: json["userpackageduration"],
    enddate: json["enddate"],
    isexpired: json["isexpired"],
    matchcount: json["matchcount"],
  );

  Map<String, dynamic> toJson() => {
    "packageid": packageid,
    "title": title,
    "tags": tags,
    "description": description,
    "docid": docid,
    "price": price,
    "metadata": metadata == null ? null : metadata,
    "issubscription": issubscription == null ? null : issubscription,
    "ispublic": ispublic,
    "html": html == null ? null : html,
    "PackageDuration": packageDuration,
    "BillingCycle": billingCycle == null ? null : billingCycle,
    "ts": ts.toIso8601String(),
    "providerid": providerid,
    "provider_name": providerName,
    "providermetadata": providermetadata,
    "providerdescription": providerdescription,
    "plinkid": plinkid,
    "packcatid": packcatid,
    "catname": catname,
    "catdesc": catdesc,
    "catselecttype": catselecttype,
    "catmetadata": catmetadata == null ? null : catmetadata,
    "userpackid": userpackid,
    "IsSubscribed": isSubscribed,
    "startdate": startdate,
    "userpackageduration": userpackageduration,
    "enddate": enddate,
    "isexpired": isexpired,
    "matchcount": matchcount,
  };
}
