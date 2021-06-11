// To parse this JSON data, do
//
//     final regimentModel = regimentModelFromJson(jsonString);

import 'dart:convert';
import 'package:myfhb/regiment/models/regiment_data_model.dart';

List<RegimentDataModel> regimentModelFromJson(String str) =>
    List<RegimentDataModel>.from(
        json.decode(str).map((x) => RegimentDataModel.fromJson(x)));

String regimentModelToJson(List<RegimentDataModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RegimentResponseModel {
  RegimentResponseModel({
    this.isSuccess,
    this.regimentsList,
    this.message,
  });

  final bool isSuccess;
  final List<RegimentDataModel> regimentsList;
  final String message;

  factory RegimentResponseModel.fromJson(Map<String, dynamic> json) =>
      RegimentResponseModel(
        isSuccess: json["isSuccess"],
        regimentsList: List<RegimentDataModel>.from(
            json["result"].map((x) => RegimentDataModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "result":
            List<RegimentDataModel>.from(regimentsList.map((x) => x.toJson())),
      };
}
