import '../../../constants/fhb_parameters.dart' as parameters;

class PostImageResponse {
  int status;
  bool success;
  String message;
  Response response;

  PostImageResponse({this.status, this.success, this.message, this.response});

  PostImageResponse.fromJson(Map<String, dynamic> json) {
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
  Data data;

  Response({this.count, this.data});

  Response.fromJson(Map<String, dynamic> json) {
    count = json[parameters.strCount];
    data = json[parameters.strData] != null ? Data.fromJson(json[parameters.strData]) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[parameters.strCount] = count;
    if (this.data != null) {
      data[parameters.strData] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String mediaMasterId;

  Data({this.mediaMasterId});

  Data.fromJson(Map<String, dynamic> json) {
    mediaMasterId = json[parameters.strmediaMasterId];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[parameters.strmediaMasterId] = mediaMasterId;
    return data;
  }
}
