import 'package:myfhb/Prescription/constants/prescription_constants.dart';
import 'package:myfhb/Prescription/constants/prescription_parameters.dart'
    as parameters;

class NewPrescriptionDataResponse {
  bool isSuccess;
  String message;
  String result;

  NewPrescriptionDataResponse({this.isSuccess, this.message, this.result});

  NewPrescriptionDataResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json[parameters.strapResponseisSuccess];
    message = json[parameters.strapResponseMessage];
    result = json[parameters.strapResponseResult];
  }
}
