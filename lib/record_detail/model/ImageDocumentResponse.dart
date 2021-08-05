
class ImageDocumentResponse {
  int status;
  bool success;
  String message;
  Response response;

  ImageDocumentResponse(
      {this.status, this.success, this.message, this.response});

  ImageDocumentResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    message = json['message'];
    response = json['response'] != null
        ? Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['success'] = success;
    data['message'] = message;
    if (response != null) {
      data['response'] = response.toJson();
    }
    return data;
  }
}

class Response {
  int count;
  Data data;

  Response({this.count, this.data});

  Response.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['count'] = count;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String fileContent;
  String fileType;

  Data({this.fileContent, this.fileType});

  Data.fromJson(Map<String, dynamic> json) {
    fileContent = json['fileContent'];
    fileType = json['fileType'];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['fileContent'] = fileContent;
    data['fileType'] = fileType;
    return data;
  }
}

