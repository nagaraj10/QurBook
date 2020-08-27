class DoctorImageResponse {
  int status;
  bool success;
  String response;

  DoctorImageResponse({this.status, this.success, this.response});

  DoctorImageResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    response = json['response'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    data['response'] = this.response;
    return data;
  }
}

