import 'package:myfhb/telehealth/features/appointments/model/resheduleAppointments/resheduleAppointmentInfo.dart';
import 'package:myfhb/telehealth/features/appointments/model/resheduleAppointments/reshedulePaymentInfo.dart';
import 'package:myfhb/telehealth/features/appointments/constants/appointments_parameters.dart'
    as parameters;

class ResheduleResult {
  ResheduleAppointmentInfo appointmentInfo;
  var paymentInfo;

  ResheduleResult({this.appointmentInfo, this.paymentInfo});

  ResheduleResult.fromJson(Map<String, dynamic> json) {
    appointmentInfo = json['appointmentInfo'] != null
        ? new ResheduleAppointmentInfo.fromJson(json['appointmentInfo'])
        : null;
    paymentInfo = json['paymentInfo'] != null
        ?  (json['paymentInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.appointmentInfo != null) {
      data['appointmentInfo'] = this.appointmentInfo.toJson();
    }
    if (this.paymentInfo != null) {
      data['paymentInfo'] = this.paymentInfo.toJson();
    }
    return data;
  }
}
