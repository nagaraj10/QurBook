class ErrorModelResponse {
  int status;
  bool success;
  String message;

  ErrorModelResponse({this.status, this.success, this.message});

  ErrorModelResponse.fromJson(Map<String, dynamic> json) {
    if (json.containsKey("isSuccess")) {
      success = json['isSuccess'];
    } else {
      success = json['success'];
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (data.containsKey("isSuccess")) {
      data['isSuccess'] = this.success;
    } else {
      data['success'] = this.success;
    }
    data['status'] = this.status;
    data['message'] = this.message;

    return data;
  }
}
