import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class UpdateAddFamilyRelationInfo {
  int status;
  bool success;
  String message;

  UpdateAddFamilyRelationInfo({this.status, this.success, this.message});

  UpdateAddFamilyRelationInfo.fromJson(Map<String, dynamic> json) {
    status = json[parameters.strStatus];
    success = json[parameters.strSuccess];
    message = json[parameters.strMessage];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strStatus] = this.status;
    data[parameters.strSuccess] = this.success;
    data[parameters.strMessage] = this.message;

    return data;
  }
}
