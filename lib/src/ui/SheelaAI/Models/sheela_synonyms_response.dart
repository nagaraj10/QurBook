// To parse this JSON data, do
//
//     final sheelaSynonymsResponse = sheelaSynonymsResponseFromJson(jsonString);

import 'dart:convert';

SheelaSynonymsResponse sheelaSynonymsResponseFromJson(String str) => SheelaSynonymsResponse.fromJson(json.decode(str));

String sheelaSynonymsResponseToJson(SheelaSynonymsResponse data) => json.encode(data.toJson());

class SheelaSynonymsResponse {
  bool? isSuccess;
  Result? result;

  SheelaSynonymsResponse({
    this.isSuccess,
    this.result,
  });

  factory SheelaSynonymsResponse.fromJson(Map<String, dynamic> json) => SheelaSynonymsResponse(
    isSuccess: json["isSuccess"]??false,
    result: json["result"] == null ? null : Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "result": result?.toJson(),
  };
}

class Result {
  bool? isSuccess;
  String? message;
  String? payload;

  Result({
    this.isSuccess,
    this.message,
    this.payload,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    isSuccess: json["isSuccess"]??false,
    message: json["message"]??"",
    payload: json["payload"]??"",
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "payload": payload,
  };
}
