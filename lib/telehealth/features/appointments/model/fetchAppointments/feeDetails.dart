
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/telehealth/features/appointments/constants/appointments_parameters.dart'
as parameters;

class FeeDetails {
  var paidAmount;
  int? doctorCancellationCharge;
  var finalRefundAmount;
  String? paymentMode;

  FeeDetails(
      {this.paidAmount, this.doctorCancellationCharge, this.finalRefundAmount,this.paymentMode});

  FeeDetails.fromJson(Map<String, dynamic> json) {
    try {
      paidAmount = json[parameters.strPaidAmount];
      doctorCancellationCharge = json[parameters.strDoctorCancellationCharges];
      finalRefundAmount = json[parameters.strFinalRefundAmount];
      paymentMode = json[parameters.strPaymentMode];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strPaidAmount] = this.paidAmount;
    data[parameters.strDoctorCancellationCharges] = this.doctorCancellationCharge;
    data[parameters.strFinalRefundAmount] = this.finalRefundAmount;
    data[parameters.strPaymentMode] = this.paymentMode;
    return data;
  }
}