import 'package:myfhb/telehealth/features/appointments/model/resheduleAppointments/resheduleAppointmentInfo.dart';
import 'package:myfhb/telehealth/features/appointments/model/resheduleAppointments/reshedulePaymentInfo.dart';
import 'package:myfhb/telehealth/features/appointments/constants/appointments_parameters.dart'as parameters;

class ResheduleResult {
  ResheduleAppointmentInfo appointmentInfo;
  ReshedulePaymentInfo paymentInfo;

  ResheduleResult({this.appointmentInfo, this.paymentInfo});

  ResheduleResult.fromJson(Map<String, dynamic> json) {
    appointmentInfo = json[parameters.strAppointmentInfo] != null
        ? new ResheduleAppointmentInfo.fromJson(json[parameters.strAppointmentInfo])
        : null;
    paymentInfo = json[parameters.strPaymentInfo] != null
        ? new ReshedulePaymentInfo.fromJson(json[parameters.strPaymentInfo])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.appointmentInfo != null) {
      data[parameters.strAppointmentInfo] = this.appointmentInfo.toJson();
    }
    if (this.paymentInfo != null) {
      data[parameters.strPaymentInfo] = this.paymentInfo.toJson();
    }
    return data;
  }
}