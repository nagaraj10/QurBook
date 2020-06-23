class UserLinkingResponseList {
  int status;
  bool success;
  String message;

  UserLinkingResponseList({this.status, this.success, this.message});

  UserLinkingResponseList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    message = json['message'];
  }
}
