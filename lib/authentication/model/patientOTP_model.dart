
import '../constants/constants.dart';

class PatientOtpModel {
  String? verificationCode;
  String? source;

  PatientOtpModel(
      {this.verificationCode,
      this.source});

  PatientOtpModel.fromJson(Map<String, dynamic> json) {
    verificationCode = json[strverificationCode];
    source = json[strsource];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data[strverificationCode] = verificationCode;
    data[strsource] = source;
    return data;
  }
}