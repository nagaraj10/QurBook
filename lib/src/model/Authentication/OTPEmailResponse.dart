class OTPEmailResponse {
  String status;
  bool success;
  String message;
  String response;

  OTPEmailResponse({this.status, this.success, this.message, this.response});

  OTPEmailResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    message = json['message'];
    response = json['response'];
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