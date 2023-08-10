
// To parse this JSON data, do
//
//     final ticketTypesModel = ticketTypesModelFromJson(jsonString);

import 'dart:convert';

import 'package:myfhb/common/CommonUtil.dart';

TicketTypesModel ticketTypesModelFromJson(String str) =>
    TicketTypesModel.fromJson(json.decode(str));

String ticketTypesModelToJson(TicketTypesModel data) =>
    json.encode(data.toJson());

class TicketTypesModel {
  TicketTypesModel({
    this.isSuccess,
    this.message,
    this.ticketTypeResults,
  });

  bool? isSuccess;
  String? message;
  List<TicketTypesResult>? ticketTypeResults;

  factory TicketTypesModel.fromJson(Map<String, dynamic> json) =>
      TicketTypesModel(
        isSuccess: json["isSuccess"],
        message: json["message"],
        ticketTypeResults: List<TicketTypesResult>.from(
            json["result"].map((x) => TicketTypesResult.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "message": message,
        "result": List<dynamic>.from(ticketTypeResults!.map((x) => x.toJson())),
      };
}

class TicketTypesResult {
  TicketTypesResult({
    this.priorities,
    this.id,
    this.name,
    this.iconUrl,
    this.v,
    this.additionalInfo,
  });

  List<Priority>? priorities;
  String? id;
  String? name;
  String? iconUrl;
  int? v;
  AdditionalInfo? additionalInfo;

  factory TicketTypesResult.fromJson(Map<String, dynamic> json) =>
      TicketTypesResult(
        priorities: List<Priority>.from(
            json["priorities"].map((x) => Priority.fromJson(x))),
        id: json["_id"],
        name: json["name"],
        iconUrl: json["iconUrl"] ?? null,
        v: json["__v"],
        additionalInfo: json['additionalInfo'] != null
            ? new AdditionalInfo.fromJson(json['additionalInfo'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "priorities": List<dynamic>.from(priorities!.map((x) => x.toJson())),
        "_id": id,
        "name": name,
        "iconUrl": iconUrl,
        "__v": v,
        "additionalInfo": additionalInfo!.toJson()
      };
}

class Priority {
  Priority({
    this.overdueIn,
    this.htmlColor,
    this.id,
    this.name,
    this.migrationNum,
    this.priorityDefault,
    this.v,
    this.durationFormatted,
    this.priorityId,
  });

  int? overdueIn;
  String? htmlColor;
  String? id;
  String? name;
  int? migrationNum;
  bool? priorityDefault;
  int? v;
  String? durationFormatted;
  String? priorityId;

  factory Priority.fromJson(Map<String, dynamic> json) => Priority(
        overdueIn: json["overdueIn"],
        htmlColor: json["htmlColor"],
        id: json["_id"],
        name: json["name"],
        migrationNum: json["migrationNum"],
        priorityDefault: json["default"],
        v: json["__v"],
        durationFormatted: json["durationFormatted"],
        priorityId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "overdueIn": overdueIn,
        "htmlColor": htmlColor,
        "_id": id,
        "name": name,
        "migrationNum": migrationNum,
        "default": priorityDefault,
        "__v": v,
        "durationFormatted": durationFormatted,
        "id": priorityId,
      };
}

class AdditionalInfo {
  List<Field>? field;
  String? healthOrgTypeId;

  AdditionalInfo({this.field,this.healthOrgTypeId});

  AdditionalInfo.fromJson(Map<String, dynamic> json) {
    try {
      if (json['field'] != null) {
            field = <Field>[];
            json['field'].forEach((v) {
              field!.add(new Field.fromJson(v));
            });
          }
      healthOrgTypeId = json['healthOrgTypeId'];
    } catch (e,stackTrace) {
      //print(e);
            CommonUtil().appLogs(message: e,stackTrace:stackTrace);

    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    try {
      if (this.field != null) {
            data['field'] = this.field!.map((v) => v.toJson()).toList();
          }
      data['healthOrgTypeId'] = this.healthOrgTypeId;
    } catch (e,stackTrace) {
      //print(e);
            CommonUtil().appLogs(message: e,stackTrace:stackTrace);

    }
    return data;
  }
}

class Field {
  String? name;
  String? type;
  String? field;
  bool? isDoctor;
  bool? isHospital;
  bool? isCategory;
  bool? isLab;
  bool? isRequired;
  List<FieldData>? fieldData;
  String? displayName;
  String? placeholder;
  FieldData? selValueDD;
  String? isVisible;
  bool? isProvider;
  List<String>? providerType;
  bool? isDisable;

  Field(
      {this.name,
      this.type,
      this.field,
      this.isDoctor = false,
      this.isHospital = false,
      this.isCategory = false,
      this.isLab = false,
      this.isRequired = false,
      this.fieldData,this.displayName, this.placeholder,this.selValueDD=null,this.isVisible,this.isProvider, this.providerType, this.isDisable});

  setFieldData(data){
    this.fieldData=data;
  }

  Field.fromJson(Map<String, dynamic> json) {
    try {
      name = json['name'];
      type = json['type'];
      field = json['field'];
      isDoctor = json['isDoctor'] ?? false;
      isHospital = json['isHospital'] ?? false;
      isCategory = json['isCategory'] ?? false;
      isLab = json['isLab'] ?? false;
      isRequired = json['is_required']?? false;
      if (json['data'] != null) {
        fieldData = <FieldData>[];
        json['data'].forEach((v) {
          fieldData!.add(new FieldData.fromJson(v));
        });
      }
      displayName = json['display_name'];
      placeholder = json['placeholder'];
      selValueDD = null;
      isVisible = json['is_visible'];
      isProvider = json['isProvider']!=null?json['isProvider']:false;
      if (json['provider_type'] != null) {
        providerType = <String>[];
        json['provider_type'].forEach((v) {
          providerType!.add(v);
        });
      }
      isDisable = json['isDisable']!=null?json['isDisable']:false;
    } catch (e,stackTrace) {
      //print(e);
            CommonUtil().appLogs(message: e,stackTrace:stackTrace);

    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    try {
      data['name'] = this.name;
      data['type'] = this.type;
      data['field'] = this.field;
      data['isDoctor'] = this.isDoctor;
      data['isHospital'] = this.isHospital;
      data['isCategory'] = this.isCategory;
      data['isLab'] = this.isLab;
      data['is_required'] = this.isRequired;
      if (this.fieldData != null) {
            data['data'] = this.fieldData!.map((v) => v.toJson()).toList();
          }
      data['display_name'] = this.displayName;
      data['placeholder'] = this.placeholder;
      data['is_visible'] = this.isVisible;
      data['isProvider'] = this.isProvider;
      data['provider_type'] = this.providerType;
      data['isDisable'] = this.isDisable;
    } catch (e,stackTrace) {
      //print(e);
            CommonUtil().appLogs(message: e,stackTrace:stackTrace);

    }

    return data;
  }
}

class FieldData {
  String? id;
  String? name;
  String? fieldName;

  FieldData({this.id, this.name,this.fieldName=null});

  FieldData.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      name = json['name'];
      fieldName = null;
    } catch (e,stackTrace) {
      //print(e);
            CommonUtil().appLogs(message: e,stackTrace:stackTrace);

    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    try {
      data['id'] = this.id;
      data['name'] = this.name;
    } catch (e,stackTrace) {
      //print(e);
            CommonUtil().appLogs(message: e,stackTrace:stackTrace);

    }
    return data;
  }
}
