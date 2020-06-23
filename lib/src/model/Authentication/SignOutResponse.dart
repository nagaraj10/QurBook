class SignOutResponse {
  int status;
  bool success;
  String message;
  String response;

  SignOutResponse({this.status, this.success, this.message, this.response});

  SignOutResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    message = json['message'];
    response = json['response']==null?'':json['response'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    data['message'] = this.message;
    data['response'] = this.response;
    return data;
  }
}