import 'package:myfhb/Prescription/constants/prescription_constants.dart';
import 'package:myfhb/Prescription/constants/prescription_parameters.dart'
    as parameters;

class NewPrescriptionAppointment {
  String id;

  NewPrescriptionAppointment({this.id});
  NewPrescriptionAppointment.fromJson(Map<String, dynamic> json) {
    id = json[parameters.strapId];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strapId] = this.id;
    return data;
  }
}
