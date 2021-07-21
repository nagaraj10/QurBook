import '../../constants/fhb_parameters.dart' as parameters;

class UpdateProvidersId {
  int status;
  bool success;
  String message;

  UpdateProvidersId({this.status, this.success, this.message});

  UpdateProvidersId.fromJson(Map<String, dynamic> json) {
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
