import 'package:myfhb/telehealth/features/appointments/model/cancelAppointments/refundInfo.dart';
import 'package:myfhb/telehealth/features/appointments/constants/appointments_parameters.dart'as parameters;

class CancelResult {
  String bookingId;
  RefundInfo refundInfo;
  bool status;

  CancelResult({this.bookingId, this.refundInfo, this.status});

  CancelResult.fromJson(Map<String, dynamic> json) {
    bookingId = json[parameters.strBookingId];
    refundInfo = json[parameters.strRefundInfo] != null
        ? new RefundInfo.fromJson(json[parameters.strRefundInfo])
        : null;
    status = json[parameters.strStatus];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strBookingId] = this.bookingId;
    if (this.refundInfo != null) {
      data[parameters.strRefundInfo] = this.refundInfo.toJson();
    }
    data[parameters.strStatus] = this.status;
    return data;
  }
}
