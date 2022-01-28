import 'dart:convert';

FeedbackCategoryType feedbackCategoryTypeFromJson(String str) =>
    FeedbackCategoryType.fromJson(json.decode(str));

String feedbackCategoryTypeToJson(FeedbackCategoryType data) =>
    json.encode(data.toJson());

class FeedbackCategoryType {
  FeedbackCategoryType({
    this.isSuccess,
    this.result,
  });

  bool isSuccess;
  List<FeedbackCategoryModel> result;

  factory FeedbackCategoryType.fromJson(Map<String, dynamic> json) =>
      FeedbackCategoryType(
        isSuccess: json["isSuccess"] == null ? null : json["isSuccess"],
        result: json["result"] == null
            ? null
            : List<FeedbackCategoryModel>.from(
                json["result"].map((x) => FeedbackCategoryModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess == null ? null : isSuccess,
        "result": result == null
            ? null
            : List<dynamic>.from(result.map((x) => x.toJson())),
      };
}

class FeedbackCategoryModel {
  FeedbackCategoryModel({
    this.id,
    this.code,
    this.name,
  });

  String id;
  String code;
  String name;

  factory FeedbackCategoryModel.fromJson(Map<String, dynamic> json) =>
      FeedbackCategoryModel(
        id: json["id"] == null ? null : json["id"],
        code: json["code"] == null ? null : json["code"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "code": code == null ? null : code,
        "name": name == null ? null : name,
      };
}
