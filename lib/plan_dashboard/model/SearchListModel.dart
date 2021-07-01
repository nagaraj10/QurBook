import 'dart:convert';

import 'MetaDataForHospitalLogo.dart';

class SearchListModel {
  bool isSuccess;
  List<SearchListResult> result;

  SearchListModel({this.isSuccess, this.result});

  SearchListModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['result'] != null) {
      result = <SearchListResult>[];
      json['result'].forEach((v) {
        result.add(SearchListResult.fromJson(v));
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

class SearchListResult {
  String providerid;
  String title;
  String description;
  String linkid;
  MetaDataForHospitalLogo metadata;

  SearchListResult({this.providerid, this.title, this.description, this.linkid,this.metadata});

  factory SearchListResult.fromJson(Map<String, dynamic> json) {
    return SearchListResult(providerid : json['providerid'],
        title : json['title'],
        description : json['description'],
        linkid : json['linkid'],
        metadata : json['metadata'] != null && json['metadata'].toString().isNotEmpty
        ? MetaDataForHospitalLogo.fromJson(jsonDecode(json['metadata'] ?? '{}'))
        : null);

  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['providerid'] = providerid;
    data['title'] = title;
    data['description'] = description;
    data['linkid'] = linkid;
    data['metadata'] = metadata;
    return data;
  }
}