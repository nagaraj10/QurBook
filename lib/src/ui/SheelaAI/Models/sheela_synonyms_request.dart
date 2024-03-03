import 'dart:convert';

import 'SheelaResponse.dart';

SheelaSynonymsRequestModel sheelaSynonymsRequestModelFromJson(String str) => SheelaSynonymsRequestModel.fromJson(json.decode(str));

String sheelaSynonymsRequestModelToJson(SheelaSynonymsRequestModel data) => json.encode(data.toJson());

class SheelaSynonymsRequestModel {
  Field? field;
  String? message;

  SheelaSynonymsRequestModel({
    this.field,
    this.message,
  });

  factory SheelaSynonymsRequestModel.fromJson(Map<String, dynamic> json) => SheelaSynonymsRequestModel(
    field: json["field"] == null ? null : Field.fromJson(json["field"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "field": field?.toJson(),
    "message": message,
  };
}

class Field {
  String? fdata;
  String? ftype;
  List<Buttons>? fdataA;
  String? description;

  Field({
    this.fdata,
    this.ftype,
    this.fdataA,
    this.description,
  });

  factory Field.fromJson(Map<String, dynamic> json) => Field(
    fdata: json["fdata"],
    ftype: json["ftype"],
    description: json["description"],
    fdataA: json["fdataA"] == null ? [] : List<Buttons>.from(json["fdataA"]!.map((x) => Buttons.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "fdata": fdata,
    "ftype": ftype,
    "description": description,
    "fdataA": fdataA == null ? [] : List<dynamic>.from(fdataA!.map((x) => x.toJson())),
  };
}
