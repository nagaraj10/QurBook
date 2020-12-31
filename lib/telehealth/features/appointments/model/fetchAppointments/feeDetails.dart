import 'package:myfhb/telehealth/features/appointments/constants/appointments_parameters.dart'
as parameters;

class FeeDetails {
  int paidAmount;
  int doctorCancellationCharge;
  int finalRefundAmount;

  FeeDetails(
      {this.paidAmount, this.doctorCancellationCharge, this.finalRefundAmount});

  FeeDetails.fromJson(Map<String, dynamic> json) {
    paidAmount = json[parameters.strPaidAmount];
    doctorCancellationCharge = json[parameters.strDoctorCancellationCharges];
    finalRefundAmount = json[parameters.strFinalRefundAmount];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strPaidAmount] = this.paidAmount;
    data[parameters.strDoctorCancellationCharges] = this.doctorCancellationCharge;
    data[parameters.strFinalRefundAmount] = this.finalRefundAmount;
    return data;
  }
}
