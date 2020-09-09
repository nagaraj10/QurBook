import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/telehealth/features/appointments/model/resheduleResponseData.dart';

class Reshedule {
  Reshedule({
    this.status,
    this.success,
    this.message,
    this.response,
  });

  int status;
  bool success;
  String message;
  Response response;

  Reshedule.fromJson(Map<String, dynamic> json) {
    status = json[parameters.strStatus];
    success = json[parameters.strSuccess];
    message = json[parameters.strMessage];
    response =
        json[parameters.strResponse] == null ? null : Response.fromJson(json[parameters.strResponse]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strStatus] = status;
    data[parameters.strSuccess] = success;
    data[parameters.strMessage] = message;
    data[parameters.strResponse] = response.toJson();
    return data;
  }
}

class Response {
  Response({
    this.count,
    this.data,
  });

  int count;
  ResheduleResponseData data;

  Response.fromJson(Map<String, dynamic> json) {
    count = json[parameters.strCount];
    data = ResheduleResponseData.fromJson(json[parameters.strData]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strCount] = count;
    data[parameters.strData] = this.data.toJson();
    return data;
  }
}
