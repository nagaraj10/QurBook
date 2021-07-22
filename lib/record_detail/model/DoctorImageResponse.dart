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
    final data = Map<String, dynamic>();
    data['status'] = status;
    data['success'] = success;
    data['response'] = response;
    return data;
  }
}

