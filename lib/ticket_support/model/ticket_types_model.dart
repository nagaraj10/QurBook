// To parse this JSON data, do
//
//     final ticketTypesModel = ticketTypesModelFromJson(jsonString);

import 'dart:convert';

TicketTypesModel ticketTypesModelFromJson(String str) => TicketTypesModel.fromJson(json.decode(str));

String ticketTypesModelToJson(TicketTypesModel data) => json.encode(data.toJson());

class TicketTypesModel {
  TicketTypesModel({
    this.isSuccess,
    this.message,
    this.ticketTypeResults,
  });

  bool isSuccess;
  String message;
  List<TicketTypesResult> ticketTypeResults;

  factory TicketTypesModel.fromJson(Map<String, dynamic> json) => TicketTypesModel(
    isSuccess: json["isSuccess"],
    message: json["message"],
    ticketTypeResults: List<TicketTypesResult>.from(json["result"].map((x) => TicketTypesResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "result": List<dynamic>.from(ticketTypeResults.map((x) => x.toJson())),
  };
}

class TicketTypesResult {
  TicketTypesResult({
    this.priorities,
    this.id,
    this.name,
    this.v,
  });

  List<Priority> priorities;
  String id;
  String name;
  int v;

  factory TicketTypesResult.fromJson(Map<String, dynamic> json) => TicketTypesResult(
    priorities: List<Priority>.from(json["priorities"].map((x) => Priority.fromJson(x))),
    id: json["_id"],
    name: json["name"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "priorities": List<dynamic>.from(priorities.map((x) => x.toJson())),
    "_id": id,
    "name": name,
    "__v": v,
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

  int overdueIn;
  String htmlColor;
  String id;
  String name;
  int migrationNum;
  bool priorityDefault;
  int v;
  String durationFormatted;
  String priorityId;

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