import 'package:myfhb/telehealth/features/appointments/constants/appointments_parameters.dart'as parameters;
import 'package:myfhb/telehealth/features/appointments/model/resheduleAppointments/resheduleResult.dart';

class ResheduleModel {
  bool isSuccess;
  String message;
  ResheduleResult result;

  ResheduleModel({this.isSuccess, this.message, this.result});

  ResheduleModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json[parameters.strIsSuccess];
    message = json[parameters.strMessage];
    result = json[parameters.dataResult] != null
        ? new ResheduleResult.fromJson(json[parameters.dataResult])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strIsSuccess] = this.isSuccess;
    data[parameters.strMessage] = this.message;
    if (this.result != null) {
      data[parameters.dataResult] = this.result.toJson();
    }
    return data;
  }
}
