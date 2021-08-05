class UpdateAddFamilyInfo {
  bool isSuccess;
  String message;
  Result result;

  UpdateAddFamilyInfo({this.isSuccess, this.message, this.result});

  UpdateAddFamilyInfo.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    result =
        json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['isSuccess'] = isSuccess;
    data['message'] = message;
    if (result != null) {
      data['result'] = result.toJson();
    }
    return data;
  }
}

class Result {
  String id;

  Result({this.id});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    return data;
  }
}
