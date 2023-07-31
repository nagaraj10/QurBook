
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/telehealth/features/appointments/model/cancelAppointments/responseInfoResultRefund.dart';
import 'package:myfhb/telehealth/features/appointments/constants/appointments_parameters.dart'as parameters;

class ResponseInfoResult {
  bool? success;
  ResponseInfoResultRefund? refund;

  ResponseInfoResult({this.success, this.refund});

  ResponseInfoResult.fromJson(Map<String, dynamic> json) {
    try {
      success = json[parameters.strSuccess];
      refund = json[parameters.strRefund] != null
              ? new ResponseInfoResultRefund.fromJson(json[parameters.strRefund])
              : null;
    } catch (e) {
      CommonUtil().appLogs(message: e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strSuccess] = this.success;
    if (this.refund != null) {
      data[parameters.strRefund] = this.refund!.toJson();
    }
    return data;
  }
}
