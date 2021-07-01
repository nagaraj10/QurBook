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
      result = List<PlanListResult>();
      json['result'].forEach((v) {
        result.add(PlanListResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['isSuccess'] = isSuccess;
    if (result != null) {
      data['result'] = result.map((v) => v.toJson()).toList();
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
                ? MetaDataForURL.fromJson(jsonDecode(json['metadata'] ?? '{}'))
                : null,
        catmetadata: json['catmetadata'] != null &&
                json['catmetadata'].toString().isNotEmpty
            ? MetaDataForURL.fromJson(jsonDecode(json['catmetadata'] ?? '{}'))
            : null,
        providerMetadata: json['providermetadata'] != null &&
                json['providermetadata'].toString().isNotEmpty
            ? MetaDataForHospitalLogo.fromJson(
                jsonDecode(json['providermetadata'] ?? '{}'))
            : null);
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['packageid'] = packageid;
    data['title'] = title;
    data['description'] = description;
    data['docid'] = docid;
    data['price'] = price;
    data['issubscription'] = issubscription;
    data['ispublic'] = ispublic;
    data['html'] = html;
    data['PackageDuration'] = packageDuration;
    data['BillingCycle'] = billingCycle;
    data['ts'] = ts;
    data['providerid'] = providerid;
    data['provider_name'] = providerName;
    data['providerdescription'] = providerDesc;
    data['plinkid'] = plinkid;
    data['packcatid'] = packcatid;
    data['catname'] = catname;
    data['catdesc'] = catdesc;
    data['catselecttype'] = catselecttype;
    data['userpackid'] = userpackid;
    data['IsSubscribed'] = isSubscribed;
    data['startdate'] = startDate;
    data['metadata'] = metadata;
    data['catmetadata'] = catmetadata;
    data['providermetadata'] = providerMetadata;
    return data;
  }
}
