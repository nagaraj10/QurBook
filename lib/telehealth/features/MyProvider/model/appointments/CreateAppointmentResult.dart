
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_parameters.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/appointments/AppointmentInfoModel.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/appointments/PayloadModel.dart';

class CreateAppointmentResult {
  AppointmentInfoModel? appointmentInfo;
  PaymentInfo? paymentInfo;

  CreateAppointmentResult({this.appointmentInfo, this.paymentInfo});

  CreateAppointmentResult.fromJson(Map<String, dynamic> json) {
    try {
      appointmentInfo = json[strAppointmentInfo] != null
              ? AppointmentInfoModel.fromJson(json[strAppointmentInfo])
              : null;
      paymentInfo = json[strPaymentInfo] != null
              ? PaymentInfo.fromJson(json[strPaymentInfo])
              : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.appointmentInfo != null) {
      data[strAppointmentInfo] = this.appointmentInfo!.toJson();
    }
    if (this.paymentInfo != null) {
      data[strPaymentInfo] = this.paymentInfo!.toJson();
    }
    return data;
  }
}

class PaymentInfo {
  bool? isSuccess;
  PayloadModel? payload;

  PaymentInfo({this.isSuccess, this.payload});

  PaymentInfo.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      payload =
          json['payload'] != null ? PayloadModel.fromJson(json['payload']) : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.payload != null) {
      data['payload'] = this.payload!.toJson();
    }
    return data;
  }
}