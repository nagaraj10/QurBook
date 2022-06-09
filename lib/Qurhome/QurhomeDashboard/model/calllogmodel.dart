import 'package:myfhb/Qurhome/QurhomeDashboard/model/location_data_model.dart';

class CallLogModel {
  String callerUser;
  String recipientUser;
  String startedTime;
  String endTime;
  String status;
  String patientName;
  String recipientId;
  AdditionalInfo additionalInfo;

  CallLogModel({
    this.callerUser,
    this.recipientUser,
    this.startedTime,
    this.endTime,
    this.status,
    this.patientName,
    this.recipientId,
    this.additionalInfo,
  });

  CallLogModel.fromJson(Map<String, dynamic> json) {
    try {
      callerUser = json['callerUser'];
      recipientUser = json['recipientUser'];
      startedTime = json['startedTime'];
      endTime = json['endTime'];
      status = json['status'];
      patientName = json['patientName'];
      recipientId = json['recipientId'];
      additionalInfo = json["additionalInfo"] != null
          ? new AdditionalInfo.fromJson(json["additionalInfo"])
          : null;
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    try {
      data['callerUser'] = this.callerUser;
      data['recipientUser'] = this.recipientUser;
      data['startedTime'] = this.startedTime;
      data['endTime'] = this.endTime;
      data['status'] = this.status;
      data['patientName'] = this.patientName;
      data['recipientId'] = this.recipientId;
      if (this.additionalInfo != null) {
        data["additionalInfo"] = this.additionalInfo.toJson();
      }
    } catch (e) {
      print(e);
    }

    return data;
  }
}

class CallEndModel {
  String callerUser;
  String recipientUser;
  String startedTime;
  String endTime;
  String status;
  String patientName;
  String recipientId;
  AdditionalInfo additionalInfo;
  String id;

  CallEndModel({
    this.callerUser,
    this.recipientUser,
    this.startedTime,
    this.endTime,
    this.status,
    this.patientName,
    this.recipientId,
    this.additionalInfo,
    this.id,
  });

  CallEndModel.fromJson(Map<String, dynamic> json) {
    try {
      callerUser = json['callerUser'];
      recipientUser = json['recipientUser'];
      startedTime = json['startedTime'];
      endTime = json['endTime'];
      status = json['status'];
      patientName = json['patientName'];
      recipientId = json['recipientId'];
      additionalInfo = json["additionalInfo"] != null
          ? new AdditionalInfo.fromJson(json["additionalInfo"])
          : null;
      id = json['id'];
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    try {
      data['callerUser'] = this.callerUser;
      data['recipientUser'] = this.recipientUser;
      data['startedTime'] = this.startedTime;
      data['endTime'] = this.endTime;
      data['status'] = this.status;
      data['patientName'] = this.patientName;
      data['recipientId'] = this.recipientId;
      if (this.additionalInfo != null) {
        data["additionalInfo"] = this.additionalInfo.toJson();
      }
      data['id'] = this.id;
    } catch (e) {
      print(e);
    }

    return data;
  }
}

class AdditionalInfo {
  Location location;

  AdditionalInfo({this.location});

  AdditionalInfo.fromJson(Map<String, dynamic> json) {
    try {
      location = json["location"] != null
          ? new Location.fromJson(json["location"])
          : null;
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    try {
      if (this.location != null) {
        data["location"] = this.location.toJson();
      }
    } catch (e) {
      print(e);
    }
    return data;
  }
}

class CallLogResponseModel {
  bool isSuccess;
  String message;
  String result;

  CallLogResponseModel(
      {this.isSuccess, this.message, this.result});

  CallLogResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      message = json['message'];
      result = json['result'];
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    try {
      data['isSuccess'] = this.isSuccess;
      data['message'] = this.message;
      data['result'] = this.result;
    } catch (e) {
      print(e);
    }

    return data;
  }
}

class CallRecordModel {
  bool isSuccess;
  Result result;

  CallRecordModel({this.isSuccess, this.result});

  CallRecordModel.fromJson(Map<String, dynamic> json) {
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
  String resourceId;
  String sid;

  Result({this.resourceId, this.sid});

  Result.fromJson(Map<String, dynamic> json) {
    resourceId = json['resourceId'];
    sid = json['sid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['resourceId'] = this.resourceId;
    data['sid'] = this.sid;
    return data;
  }
}

class CallLogErrorResponseModel {
  int status;
  bool isSuccess;
  String message;
  ResponseData response;

  CallLogErrorResponseModel(
      {this.status, this.isSuccess, this.message, this.response});

  CallLogErrorResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    isSuccess = json['isSuccess'];
    message = json['message'];
    response = json['response'] != null
        ? new ResponseData.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.response != null) {
      data['response'] = this.response.toJson();
    }
    return data;
  }
}

class ResponseData {
  int count;
  DataModel data;

  ResponseData({this.count, this.data});

  ResponseData.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    data = json['data'] != null ? new DataModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class DataModel {
  String msg;

  DataModel({this.msg});

  DataModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    return data;
  }
}
