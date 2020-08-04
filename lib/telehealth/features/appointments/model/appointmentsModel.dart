


import 'doctorsData.dart';

class AppointmentsModel {
  AppointmentsModel({
    this.status,
    this.success,
    this.message,
    this.response,
  });

  int status;
  bool success;
  String message;
  Response response;

  AppointmentsModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    success = json["success"];
    message = json["message"];
    response =
    json['response'] != null ? Response.fromJson(json["response"]) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["status"] = this.status;
    data["success"] = this.success;
    data["message"] = this.message;
    if (this.response != null) {
      data["response"] = this.response.toJson();
    }
    return data;
  }
}

class Response {
  Response({
    this.count,
    this.data,
  });

  int count;
  DoctorsData data;

  Response.fromJson(Map<String, dynamic> json) {
    count = json["count"];
    data = DoctorsData.fromJson(json["data"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["count"] = this.count;
    if (this.data != null) {
      data["data"] = this.data.toJson();
    }
    return data;
  }
}





