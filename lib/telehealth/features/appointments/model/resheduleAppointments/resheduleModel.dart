import 'package:myfhb/telehealth/features/appointments/constants/appointments_parameters.dart'as parameters;
import 'package:myfhb/telehealth/features/appointments/model/resheduleAppointments/resheduleResult.dart';

class ResheduleModel {
  bool isSuccess;
  String message;
  ResheduleResult result;

  ResheduleModel({this.isSuccess, this.message, this.result});

  ResheduleModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    result = json['result'] != null ? new ResheduleResult.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}