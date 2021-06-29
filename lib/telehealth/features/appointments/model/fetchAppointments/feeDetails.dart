import 'package:myfhb/telehealth/features/appointments/constants/appointments_parameters.dart'
as parameters;

class FeeDetails {
  int paidAmount;
  int doctorCancellationCharge;
  int finalRefundAmount;
  String paymentMode;

  FeeDetails(
      {this.paidAmount, this.doctorCancellationCharge, this.finalRefundAmount,this.paymentMode});

  FeeDetails.fromJson(Map<String, dynamic> json) {
    paidAmount = json[parameters.strPaidAmount];
    doctorCancellationCharge = json[parameters.strDoctorCancellationCharges];
    finalRefundAmount = json[parameters.strFinalRefundAmount];
    paymentMode = json[parameters.strPaymentMode];
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