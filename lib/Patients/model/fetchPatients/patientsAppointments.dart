import 'package:myfhb/Patients/constants/patients_parameters.dart'
    as parameters;
import 'package:myfhb/Patients/model/fetchPatients/pastModel.dart';
import 'package:myfhb/Patients/constants/patients_parameters.dart'
    as parameters;
import 'package:myfhb/Patients/model/fetchPatients/pastModel.dart';

class PatientAppointments {
  PatientAppointments({
    this.upcoming,
    this.past,
  });

  Past upcoming;
  Past past;

  PatientAppointments.fromJson(Map<String, dynamic> json) {
    upcoming = json[parameters.strUpcoming] != null
        ? Past.fromJson(json[parameters.strUpcoming])
        : null;
    past = json[parameters.strPast] != null
        ? Past.fromJson(json[parameters.strPast])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (data[parameters.strUpcoming] != null) {
      data[parameters.strUpcoming] = upcoming.toJson();
    }
    if (data[parameters.strPast] != null) {
      data[parameters.strPast] = past.toJson();
    }
    return data;
  }
}
