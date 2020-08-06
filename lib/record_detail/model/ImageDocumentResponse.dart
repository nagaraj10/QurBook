
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
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.response != null) {
      data['response'] = this.response.toJson();
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
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  String fileContent;
  String fileType;

  Data({this.fileContent, this.fileType});

  Data.fromJson(Map<String, dynamic> json) {
    fileContent = json['fileContent'];
    fileType = json['fileType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fileContent'] = this.fileContent;
    data['fileType'] = this.fileType;
    return data;
  }
}

