class ErrorModelResponse {
  int status;
  bool success;
  String message;

  ErrorModelResponse({this.status, this.success, this.message});

  ErrorModelResponse.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('isSuccess')) {
      success = json['isSuccess'];
    } else {
      success = json['success'];
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (data.containsKey('isSuccess')) {
      data['isSuccess'] = success;
    } else {
      data['success'] = success;
    }
    data['status'] = status;
    data['message'] = message;

    return data;
  }
}
