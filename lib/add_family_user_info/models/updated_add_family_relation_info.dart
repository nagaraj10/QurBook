import '../../constants/fhb_parameters.dart' as parameters;

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
    final data = <String, dynamic>{};
    data[parameters.strStatus] = status;
    data[parameters.strSuccess] = success;
    data[parameters.strMessage] = message;

    return data;
  }
}
