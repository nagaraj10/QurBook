import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/appointments/AppointmentInfoModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/appointments/PayloadModel.dart';

class CreateAppointmentResult {
  AppointmentInfoModel appointmentInfo;
  PaymentInfo paymentInfo;

  CreateAppointmentResult({this.appointmentInfo, this.paymentInfo});

  CreateAppointmentResult.fromJson(Map<String, dynamic> json) {
    appointmentInfo = json[strAppointmentInfo] != null
        ? new AppointmentInfoModel.fromJson(json[strAppointmentInfo])
        : null;
    paymentInfo = json[strPaymentInfo] != null
        ? new PaymentInfo.fromJson(json[strPaymentInfo])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.appointmentInfo != null) {
      data[strAppointmentInfo] = this.appointmentInfo.toJson();
    }
    if (this.paymentInfo != null) {
      data[strPaymentInfo] = this.paymentInfo.toJson();
    }
    return data;
  }
}

class PaymentInfo {
  bool isSuccess;
  PayloadModel payload;

  PaymentInfo({this.isSuccess, this.payload});

  PaymentInfo.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    payload =
    json['payload'] != null ? new PayloadModel.fromJson(json['payload']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.payload != null) {
      data['payload'] = this.payload.toJson();
    }
    return data;
  }
}