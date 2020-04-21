class VerifyEmailResponse {
  int status;
  bool success;
  String message;
  Response response;

  VerifyEmailResponse({this.status, this.success, this.message, this.response});

  VerifyEmailResponse.fromJson(Map<String, dynamic> json) {
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
  String creationTime;
  String expirationTime;

  Response({this.creationTime, this.expirationTime});

  Response.fromJson(Map<String, dynamic> json) {
    creationTime = json['creationTime'];
    expirationTime = json['expirationTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['creationTime'] = this.creationTime;
    data['expirationTime'] = this.expirationTime;
    return data;
  }
}