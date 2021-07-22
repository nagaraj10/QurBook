import '../../../constants/fhb_parameters.dart' as parameters;
import 'MediaData.dart';

class MediaTypesResponse {
  int status;
  bool success;
  String message;
  Response response;

  MediaTypesResponse({this.status, this.success, this.message, this.response});

  MediaTypesResponse.fromJson(Map<String, dynamic> json) {
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
  List<MediaData> data;

  Response({this.count, this.data});

  Response.fromJson(Map<String, dynamic> json) {
    count = json[parameters.strCount];
    if (json[parameters.strData] != null) {
      data = <MediaData>[];
      json[parameters.strData].forEach((v) {
        data.add(MediaData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data[parameters.strCount] = count;
    if (this.data != null) {
      data[parameters.strData] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

