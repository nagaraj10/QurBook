class UserDeLinkingResponseList {
  int status;
  bool success;
  String message;

  UserDeLinkingResponseList({this.status, this.success, this.message});

  UserDeLinkingResponseList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    message = json['message'];
  }
}
