import 'MyProfileResult.dart';

class MyProfileModel {
  bool isSuccess;
  String message;
  MyProfileResult result;

  MyProfileModel({this.isSuccess, this.message, this.result});

  MyProfileModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    result =
    json['result'] != null ? MyProfileResult.fromJson(json['result']) : null;
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

