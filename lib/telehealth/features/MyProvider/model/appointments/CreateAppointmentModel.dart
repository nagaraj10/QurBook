import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/appointments/CreateAppointmentResult.dart';

class CreateAppointmentModel {
  bool isSuccess;
  String message;
  CreateAppointmentResult result;

  CreateAppointmentModel({this.isSuccess, this.message, this.result});

  CreateAppointmentModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json[IS_SUCCESS];
    message = json[MESSAGE];
    result =
    json[RESULT] != null
        ? new CreateAppointmentResult.fromJson(json[RESULT])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[IS_SUCCESS] = this.isSuccess;
    data[MESSAGE] = this.message;
    if (this.result != null) {
      data[RESULT] = this.result.toJson();
    }
    return data;
  }
}

