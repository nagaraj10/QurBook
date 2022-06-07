import 'dart:core';

import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/healthRecord.dart';

class CareCoordinatorData {
  bool isSuccess;
  List<Result> result;

  CareCoordinatorData({this.isSuccess, this.result});

  CareCoordinatorData.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      if (json['result'] != null) {
        result = <Result>[];
        json['result'].forEach((v) {
          result.add(new Result.fromJson(v));
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    try {
      data['isSuccess'] = this.isSuccess;
      if (this.result != null) {
        data['result'] = this.result.map((v) => v.toJson()).toList();
      }
    } catch (e) {
      print(e);
    }

    return data;
  }
}

class Result {
  String patientId;
  String userId;
  String userType;

  Result({this.patientId, this.userId, this.userType});

  Result.fromJson(Map<String, dynamic> json) {
    try {
      patientId = json['patientId'];
      userId = json['userId'];
      userType = json['userType'];
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    try {
      data['patientId'] = this.patientId;
      data['userId'] = this.userId;
      data['userType'] = this.userType;
    } catch (e) {
      print(e);
    }
    return data;
  }
}

class CallMessagingErrorResponse {
  bool isSuccess;
  String message;
  Diagnostics diagnostics;

  CallMessagingErrorResponse({this.isSuccess, this.message, this.diagnostics});

  CallMessagingErrorResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    diagnostics = json['diagnostics'] != null
        ? new Diagnostics.fromJson(json['diagnostics'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.diagnostics != null) {
      data['diagnostics'] = this.diagnostics.toJson();
    }
    return data;
  }
}

class Diagnostics {
  String message;
  ErrorData errorData;
  bool includeErrorDataInResponse;

  Diagnostics({this.message, this.errorData, this.includeErrorDataInResponse});

  Diagnostics.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    errorData = json['errorData'] != null
        ? new ErrorData.fromJson(json['errorData'])
        : null;
    includeErrorDataInResponse = json['includeErrorDataInResponse'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.errorData != null) {
      data['errorData'] = this.errorData.toJson();
    }
    data['includeErrorDataInResponse'] = this.includeErrorDataInResponse;
    return data;
  }
}

class ErrorData {
  String code;
  String message;

  ErrorData({this.code, this.message});

  ErrorData.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    return data;
  }
}

