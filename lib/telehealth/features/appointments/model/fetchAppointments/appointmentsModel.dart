
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/telehealth/features/appointments/constants/appointments_parameters.dart'as parameters;
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/appointmentsData.dart';

class AppointmentsModel {
  AppointmentsModel({
    this.isSuccess,
    this.result,
  });

  bool? isSuccess;
  AppointmentsData? result;

  AppointmentsModel.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json[parameters.strIsSuccess];

      result = json[parameters.dataResult] == null
              ? null
              : AppointmentsData.fromJson(json[parameters.dataResult]);
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strIsSuccess] = isSuccess;

    data[parameters.dataResult] = result!.toJson();
    return data;
  }
}
