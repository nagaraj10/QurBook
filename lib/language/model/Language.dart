
import 'package:myfhb/common/CommonUtil.dart';

class LanguageModel {
  bool? isSuccess;
  List<LanguageResult>? result;

  LanguageModel({this.isSuccess, this.result});

  LanguageModel.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      if (json['result'] != null) {
            result = <LanguageResult>[];
            json['result'].forEach((v) {
              result!.add(LanguageResult.fromJson(v));
            });
          }
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
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

class LanguageResult {
  String? id;
  String? code;
  String? name;
  String? description;
  bool? isActive;
  String? createdBy;
  String? createdOn;
  dynamic lastModifiedOn;
  List<ReferenceValueCollection>? referenceValueCollection;

  LanguageResult(
      {this.id,
      this.code,
      this.name,
      this.description,
      this.isActive,
      this.createdBy,
      this.createdOn,
      this.lastModifiedOn,
      this.referenceValueCollection});

  LanguageResult.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      code = json['code'];
      name = json['name'];
      description = json['description'];
      isActive = json['isActive'];
      createdBy = json['createdBy'];
      createdOn = json['createdOn'];
      lastModifiedOn = json['lastModifiedOn'];
      if (json['referenceValueCollection'] != null) {
            referenceValueCollection = <ReferenceValueCollection>[];
            json['referenceValueCollection'].forEach((v) {
              referenceValueCollection!.add(ReferenceValueCollection.fromJson(v));
            });
          }
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['code'] = code;
    data['name'] = name;
    data['description'] = description;
    data['isActive'] = isActive;
    data['createdBy'] = createdBy;
    data['createdOn'] = createdOn;
    data['lastModifiedOn'] = lastModifiedOn;
    if (referenceValueCollection != null) {
      data['referenceValueCollection'] =
          referenceValueCollection!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReferenceValueCollection {
  String? id;
  String? code;
  String? name;
  String? description;
  int? sortOrder;
  bool? isActive;
  String? createdBy;
  String? createdOn;
  String? lastModifiedOn;

  ReferenceValueCollection(
      {this.id,
      this.code,
      this.name,
      this.description,
      this.sortOrder,
      this.isActive,
      this.createdBy,
      this.createdOn,
      this.lastModifiedOn});

  ReferenceValueCollection.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      code = json['code'];
      name = json['name'];
      description = json['description'];
      sortOrder = json['sortOrder'];
      isActive = json['isActive'];
      createdBy = json['createdBy'];
      createdOn = json['createdOn'];
      lastModifiedOn = json['lastModifiedOn'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['name'] = name;
    data['description'] = description;
    data['sortOrder'] = sortOrder;
    data['isActive'] = isActive;
    data['createdBy'] = createdBy;
    data['createdOn'] = createdOn;
    data['lastModifiedOn'] = lastModifiedOn;
    return data;
  }
}
