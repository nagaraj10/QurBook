import 'package:myfhb/telehealth/features/appointments/constants/appointments_parameters.dart'as parameters;
import 'package:myfhb/telehealth/features/appointments/model/cancelAppointments/cancelResult.dart';

class CancelAppointmentModel {
  bool isSuccess;
  List<CancelResult> result;

  CancelAppointmentModel({this.isSuccess, this.result});

  CancelAppointmentModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json[parameters.strIsSuccess];
    if (json[parameters.dataResult] != null) {
      result = new List<CancelResult>();
      json[parameters.dataResult].forEach((v) {
        result.add(new CancelResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strIsSuccess] = this.isSuccess;
    if (this.result != null) {
      data[parameters.dataResult] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

