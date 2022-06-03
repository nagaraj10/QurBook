import 'package:myfhb/Patients/constants/patients_parameters.dart'
    as parameters;

class Defaults {
  Defaults({
    this.doctorId,
    this.hospitalId,
    this.laboratoryId,
  });

  String doctorId;
  dynamic hospitalId;
  dynamic laboratoryId;

  Defaults.fromJson(Map<String, dynamic> json) {
    doctorId = json[parameters.strDoctorId];
    hospitalId = json[parameters.strHospitalId];
    laboratoryId = json[parameters.strLaboratoryId];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strDoctorId] = doctorId;
    data[parameters.strHospitalId] = hospitalId;
    data[parameters.strLaboratoryId] = laboratoryId;
    return data;
  }
}
