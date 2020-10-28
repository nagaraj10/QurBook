import 'package:myfhb/my_providers/models/UserProfessionalCollection.dart';
import 'package:myfhb/telehealth/features/appointments/constants/appointments_parameters.dart'
    as parameters;
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/booked.dart';

class Doctor {
  Doctor(
      {this.id,
      this.specialization,
      this.isTelehealthEnabled,
      this.isMciVerified,
      this.isActive,
      this.createdOn,
      this.lastModifiedBy,
      this.lastModifiedOn,
      this.user,
      this.doctorProfessionalDetailCollection});

  String id;
  String specialization;
  bool isTelehealthEnabled;
  bool isMciVerified;
  bool isActive;
  DateTime createdOn;
  dynamic lastModifiedBy;
  dynamic lastModifiedOn;
  Booked user;
  List<DoctorProfessionalDetailCollection> doctorProfessionalDetailCollection;

  Doctor.fromJson(Map<String, dynamic> json) {
    id = json[parameters.strId];
    specialization = json[parameters.strSpecilization];
    isTelehealthEnabled = json[parameters.strisTelehealthEnabled];
    isMciVerified = json[parameters.strIsMciVerified];
    isActive = json[parameters.strIsActive];
    createdOn = DateTime.parse(json[parameters.strCreatedOn]);
    lastModifiedBy = json[parameters.strlastModifiedBy];
    lastModifiedOn = json[parameters.strLastModifiedOn];
    user = json[parameters.strUser] == null
        ? null
        : Booked.fromJson(json[parameters.strUser]);
    if (json['doctorProfessionalDetailCollection'] != null) {
      doctorProfessionalDetailCollection =
          new List<DoctorProfessionalDetailCollection>();
      json['doctorProfessionalDetailCollection'].forEach((v) {
        doctorProfessionalDetailCollection
            .add(new DoctorProfessionalDetailCollection.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strId] = id;
    data[parameters.strSpecilization] = specialization;
    data[parameters.strisTelehealthEnabled] = isTelehealthEnabled;
    data[parameters.strIsMciVerified] = isMciVerified;
    data[parameters.strIsActive] = isActive;
    data[parameters.strCreatedOn] = createdOn.toIso8601String();
    data[parameters.strlastModifiedBy] = lastModifiedBy;
    data[parameters.strLastModifiedOn] = lastModifiedOn;
    data[parameters.strUser] = user.toJson();
    if (this.doctorProfessionalDetailCollection != null) {
      data['doctorProfessionalDetailCollection'] = this
          .doctorProfessionalDetailCollection
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}
