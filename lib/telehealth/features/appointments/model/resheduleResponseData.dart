
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'resheduleAppointmentInfo.dart';

class ResheduleResponseData {
  ResheduleResponseData({
    this.appointmentInfo,
    this.paymentInfo,
  });

  ResheduleAppointmentInfo appointmentInfo;
  ReshedulePaymentInfo paymentInfo;

  ResheduleResponseData.fromJson(Map<String, dynamic> json) {
    appointmentInfo =
        ResheduleAppointmentInfo.fromJson(json[parameters.strAppointmentInfo]);

    paymentInfo = ReshedulePaymentInfo.fromJson(json[parameters.strPaymentInfo]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data[parameters.strAppointmentInfo] = appointmentInfo.toJson();
    data[parameters.strPaymentInfo] = paymentInfo.toJson();
    return data;
  }
}
