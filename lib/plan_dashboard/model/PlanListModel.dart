import 'dart:convert';

import 'MetaDataForHospitalLogo.dart';
import 'MetaDataForURL.dart';

class PlanListModel {
  bool isSuccess;
  List<PlanListResult> result;

  PlanListModel({this.isSuccess, this.result});

  PlanListModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['result'] != null) {
      result = new List<PlanListResult>();
      json['result'].forEach((v) {
        result.add(new PlanListResult.fromJson(v));
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

class PlanListResult {
  String packageid;
  String title;
  String description;
  String docid;
  String price;
  String issubscription;
  String ispublic;
  String html;
  String packageDuration;
  String billingCycle;
  String ts;
  String providerid;
  String providerName;
  String providerDesc;
  String plinkid;
  String packcatid;
  String catname;
  String catdesc;
  String catselecttype;
  String userpackid;
  String isSubscribed;
  String startDate;
  MetaDataForURL metadata;
  MetaDataForURL catmetadata;
  MetaDataForHospitalLogo providerMetadata;

  PlanListResult(
      {this.packageid,
      this.title,
      this.description,
      this.docid,
      this.price,
      this.issubscription,
      this.ispublic,
      this.html,
      this.packageDuration,
      this.billingCycle,
      this.ts,
      this.providerid,
      this.providerName,
      this.plinkid,
      this.packcatid,
      this.catname,
      this.catdesc,
      this.catselecttype,
      this.userpackid,
      this.isSubscribed,
      this.startDate,
      this.metadata,
      this.catmetadata,
      this.providerMetadata,this.providerDesc});

  factory PlanListResult.fromJson(Map<String, dynamic> json) {
    return PlanListResult(
        packageid: json['packageid'],
        title: json['title'],
        description: json['description'],
        docid: json['docid'],
        price: json['price'],
        issubscription: json['issubscription'],
        ispublic: json['ispublic'],
        html: json['html'],
        packageDuration: json['PackageDuration'],
        billingCycle: json['BillingCycle'],
        ts: json['ts'],
        providerid: json['providerid'],
        providerName: json['provider_name'],
        providerDesc: json['providerdescription'],
        plinkid: json['plinkid'],
        packcatid: json['packcatid'],
        catname: json['catname'],
        catdesc: json['catdesc'],
        catselecttype: json['catselecttype'],
        userpackid: json['userpackid'],
        isSubscribed: json['IsSubscribed'],
        startDate: json['startdate'],
        metadata:
            json['metadata'] != null && json['metadata'].toString().isNotEmpty
                ? MetaDataForURL.fromJson(jsonDecode(json["metadata"] ?? '{}'))
                : null,
        catmetadata: json['catmetadata'] != null &&
                json['catmetadata'].toString().isNotEmpty
            ? MetaDataForURL.fromJson(jsonDecode(json["catmetadata"] ?? '{}'))
            : null,
        providerMetadata: json['providermetadata'] != null &&
                json['providermetadata'].toString().isNotEmpty
            ? MetaDataForHospitalLogo.fromJson(
                jsonDecode(json["providermetadata"] ?? '{}'))
            : null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['packageid'] = this.packageid;
    data['title'] = this.title;
    data['description'] = this.description;
    data['docid'] = this.docid;
    data['price'] = this.price;
    data['issubscription'] = this.issubscription;
    data['ispublic'] = this.ispublic;
    data['html'] = this.html;
    data['PackageDuration'] = this.packageDuration;
    data['BillingCycle'] = this.billingCycle;
    data['ts'] = this.ts;
    data['providerid'] = this.providerid;
    data['provider_name'] = this.providerName;
    data['providerdescription'] = this.providerDesc;
    data['plinkid'] = this.plinkid;
    data['packcatid'] = this.packcatid;
    data['catname'] = this.catname;
    data['catdesc'] = this.catdesc;
    data['catselecttype'] = this.catselecttype;
    data['userpackid'] = this.userpackid;
    data['IsSubscribed'] = this.isSubscribed;
    data['startdate'] = this.startDate;
    data['metadata'] = this.metadata;
    data['catmetadata'] = this.catmetadata;
    data['providermetadata'] = this.providerMetadata;
    return data;
  }
}
