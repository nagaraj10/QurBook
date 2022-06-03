import 'package:myfhb/Patients/constants/patients_parameters.dart'
    as parameters;
import 'package:myfhb/Patients/model/addNewPatient/addNewPatientResult.dart';

class AddNewPatient {
  AddNewPatient({
    this.isSuccess,
    this.message,
    this.result,
  });

  bool isSuccess;
  String message;
  AddNewPatientResult result;

  AddNewPatient.fromJson(Map<String, dynamic> json) {
    isSuccess = json[parameters.strIsSuccess];
    message = json[parameters.strMessage];
    result = json[parameters.strResult] != null
        ? AddNewPatientResult.fromJson(json[parameters.strResult])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strIsSuccess] = isSuccess;
    data[parameters.strMessage] = message;
    data[parameters.strResult] = result.toJson();
    return data;
  }
}
