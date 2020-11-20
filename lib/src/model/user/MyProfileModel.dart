import 'package:myfhb/src/model/user/MyProfileResult.dart';

class MyProfileModel {
  bool isSuccess;
  String message;
  MyProfileResult result;

  MyProfileModel({this.isSuccess, this.message, this.result});

  MyProfileModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    result =
    json['result'] != null ? new MyProfileResult.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

