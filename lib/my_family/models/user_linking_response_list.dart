
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
class UserLinkingResponseList {
  int status;
  bool success;
  String message;

  UserLinkingResponseList({this.status, this.success, this.message});

  UserLinkingResponseList.fromJson(Map<String, dynamic> json) {
    status = json[parameters.strStatus];
    success = json[parameters.strSuccess];
    message = json[parameters.strMessage];
  }
}
