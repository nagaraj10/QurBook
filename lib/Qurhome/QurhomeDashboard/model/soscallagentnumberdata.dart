import 'dart:core';


class SOSCallAgentNumberData {
  bool isSuccess;
  Result result;

  SOSCallAgentNumberData({this.isSuccess, this.result});

  SOSCallAgentNumberData.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      result =
      json['result'] != null ? new Result.fromJson(json['result']) : null;
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    try {
      data['isSuccess'] = this.isSuccess;
      if (this.result != null) {
        data['result'] = this.result.toJson();
      }
    } catch (e) {
      print(e);
    }

    return data;
  }
}

class Result {
  String exoPhoneNumber;
  String verificationPin;

  Result({this.exoPhoneNumber, this.verificationPin});

  Result.fromJson(Map<String, dynamic> json) {
    try {
      exoPhoneNumber = json['exoPhoneNumber'];
      verificationPin = json['verificationPin'];
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    try {
      data['exoPhoneNumber'] = this.exoPhoneNumber;
      data['verificationPin'] = this.verificationPin;
    } catch (e) {
      print(e);
    }
    return data;
  }
}



