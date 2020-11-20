import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/appointments/CreateAppointmentResult.dart';

class CreateAppointmentModel {
  bool isSuccess;
  String message;
  CreateAppointmentResult result;

  CreateAppointmentModel({this.isSuccess, this.message, this.result});

  CreateAppointmentModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json[strIsSuccess];
    message = json[strMessage];
    result =
    json[strResult] != null
        ? new CreateAppointmentResult.fromJson(json[strResult])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[strIsSuccess] = this.isSuccess;
    data[strMessage] = this.message;
    if (this.result != null) {
      data[strResult] = this.result.toJson();
    }
    return data;
  }
}

