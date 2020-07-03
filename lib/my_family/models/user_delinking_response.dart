import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class UserDeLinkingResponseList {
  int status;
  bool success;
  String message;

  UserDeLinkingResponseList({this.status, this.success, this.message});

  UserDeLinkingResponseList.fromJson(Map<String, dynamic> json) {
    status = json[parameters.strStatus];
    success = json[parameters.strSuccess];
    message = json[parameters.strMessage];
  }
}
