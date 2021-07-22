import '../../constants/fhb_parameters.dart' as parameters;
import 'doctors_data.dart';

class DoctorsListResponse {
  int status;
  bool success;
  String message;
  Response response;

  DoctorsListResponse({this.status, this.success, this.message, this.response});

  DoctorsListResponse.fromJson(Map<String, dynamic> json) {
    status = json[parameters.strStatus];
    success = json[parameters.strSuccess];
    message = json[parameters.strMessage];
    response = json[parameters.strResponse] != null
        ? Response.fromJson(json[parameters.strResponse])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data[parameters.strStatus] = status;
    data[parameters.strSuccess] = success;
    data[parameters.strMessage] = message;
    if (response != null) {
      data[parameters.strResponse] = response.toJson();
    }
    return data;
  }
}

class Response {
  int count;
  List<DoctorsData> data;

  Response({this.count, this.data});

  Response.fromJson(Map<String, dynamic> json) {
      count = json[parameters.strCount];
    if (json[parameters.strData] != null) {
      data = List<DoctorsData>();
      json[parameters.strData].forEach((v) {
        data.add(DoctorsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
     data[parameters.strCount] = count;
    if (this.data != null) {
      data[parameters.strData] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

