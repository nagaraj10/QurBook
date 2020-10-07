import 'package:myfhb/my_providers/models/User.dart';
import 'UserProfessionalCollection.dart';

class Doctors {
  String id;
  String specialization;
  bool isTelehealthEnabled;
  bool isMciVerified;
  bool isActive;
  String createdOn;
  String lastModifiedBy;
  String lastModifiedOn;
  User user;
  List<DoctorProfessionalDetailCollection> doctorProfessionalDetailCollection;
  bool isDefault;
  String providerPatientMappingId;

  Doctors(
      {this.id,
        this.specialization,
        this.isTelehealthEnabled,
        this.isMciVerified,
        this.isActive,
        this.createdOn,
        this.lastModifiedBy,
        this.lastModifiedOn,
        this.user,
        this.doctorProfessionalDetailCollection,
        this.isDefault,
        this.providerPatientMappingId});

  Doctors.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    specialization = json['specialization'];
    isTelehealthEnabled = json['isTelehealthEnabled'];
    isMciVerified = json['isMciVerified'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedBy = json['lastModifiedBy'];
    lastModifiedOn = json['lastModifiedOn'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['doctorProfessionalDetailCollection'] != null) {
      doctorProfessionalDetailCollection =
      new List<DoctorProfessionalDetailCollection>();
      json['doctorProfessionalDetailCollection'].forEach((v) {
        doctorProfessionalDetailCollection
            .add(new DoctorProfessionalDetailCollection.fromJson(v));
      });
    }
    isDefault = json['isDefault'];
    providerPatientMappingId = json['providerPatientMappingId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['specialization'] = this.specialization;
    data['isTelehealthEnabled'] = this.isTelehealthEnabled;
    data['isMciVerified'] = this.isMciVerified;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedBy'] = this.lastModifiedBy;
    data['lastModifiedOn'] = this.lastModifiedOn;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.doctorProfessionalDetailCollection != null) {
      data['doctorProfessionalDetailCollection'] = this
          .doctorProfessionalDetailCollection
          .map((v) => v.toJson())
          .toList();
    }
    data['isDefault'] = this.isDefault;
    data['providerPatientMappingId'] = this.providerPatientMappingId;
    return data;
  }
}



