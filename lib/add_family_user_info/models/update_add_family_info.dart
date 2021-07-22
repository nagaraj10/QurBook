import '../../constants/fhb_parameters.dart' as parameters;

class UpdateAddFamilyInfo {
  int status;
  bool success;
  String message;

  UpdateAddFamilyInfo({this.status, this.success, this.message});

  UpdateAddFamilyInfo.fromJson(Map<String, dynamic> json) {
    status = json[parameters.strStatus];
    success = json[parameters.strSuccess];
    message = json[parameters.strMessage];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data[parameters.strStatus] = status;
    data[parameters.strSuccess] = success;
    data[parameters.strMessage] = message;

    return data;
  }
}
