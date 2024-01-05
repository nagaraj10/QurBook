
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/telehealth/features/appointments/model/cancelAppointments/refundInfo.dart';
import 'package:myfhb/telehealth/features/appointments/constants/appointments_parameters.dart'as parameters;

class CancelResult {
  String? bookingId;
  RefundInfo? refundInfo;
  bool? status;

  CancelResult({this.bookingId, this.refundInfo, this.status});

  CancelResult.fromJson(Map<String, dynamic> json) {
    try {
      bookingId = json[parameters.strBookingId];
      refundInfo = json[parameters.strRefundInfo] != null
              ? RefundInfo.fromJson(json[parameters.strRefundInfo])
              : null;
      status = json[parameters.strStatus];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data[parameters.strBookingId] = this.bookingId;
    if (this.refundInfo != null) {
      data[parameters.strRefundInfo] = this.refundInfo!.toJson();
    }
    data[parameters.strStatus] = this.status;
    return data;
  }
}
