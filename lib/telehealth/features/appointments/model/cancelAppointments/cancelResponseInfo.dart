import 'package:myfhb/telehealth/features/appointments/model/cancelAppointments/responseInfoResult.dart';
import 'package:myfhb/telehealth/features/appointments/constants/appointments_parameters.dart'as parameters;

class CancelResponseInfo {
  ResponseInfoResult result;
  bool isSuccess;

  CancelResponseInfo({this.result, this.isSuccess});

  CancelResponseInfo.fromJson(Map<String, dynamic> json) {
    result =
    json[parameters.dataResult] != null ? new ResponseInfoResult.fromJson(json[parameters.dataResult]) : null;
    isSuccess = json[parameters.strIsSuccess];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data[parameters.dataResult] = this.result.toJson();
    }
    data[parameters.strIsSuccess] = this.isSuccess;
    return data;
  }
}