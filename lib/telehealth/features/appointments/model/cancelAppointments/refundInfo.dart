
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/telehealth/features/appointments/model/cancelAppointments/payload.dart';
import 'package:myfhb/telehealth/features/appointments/constants/appointments_parameters.dart'as parameters;

class RefundInfo {
  bool? isSuccess;
  Payload? payload;

  RefundInfo({this.isSuccess, this.payload});

  RefundInfo.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json[parameters.strIsSuccess];
      payload = json[parameters.strPayload] != null
              ? new Payload.fromJson(json[parameters.strPayload])
              : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strIsSuccess] = this.isSuccess;
    if (this.payload != null) {
      data[parameters.strPayload] = this.payload!.toJson();
    }
    return data;
  }
}
