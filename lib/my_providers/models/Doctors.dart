import 'DoctorLanguageCollection.dart';
import 'User.dart';
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
  List<DoctorLanguageCollection> doctorLanguageCollection;
  bool isDefault;
  String providerPatientMappingId;
  List<String> sharedCategories;
  bool isResident = false;
  bool isPatientAssociatedRequest = false;
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
      this.doctorLanguageCollection,
      this.isDefault,
      this.providerPatientMappingId,
      this.sharedCategories,
      this.isResident,
      this.isPatientAssociatedRequest});

  Doctors.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    specialization = json['specialization'];
    isTelehealthEnabled = json['isTelehealthEnabled'];
    isMciVerified = json['isMciVerified'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedBy = json['lastModifiedBy'];
    lastModifiedOn = json['lastModifiedOn'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    if (json['doctorProfessionalDetailCollection'] != null) {
      doctorProfessionalDetailCollection =
          List<DoctorProfessionalDetailCollection>();
      json['doctorProfessionalDetailCollection'].forEach((v) {
        doctorProfessionalDetailCollection
            .add(DoctorProfessionalDetailCollection.fromJson(v));
      });
    }
    if (json['doctorLanguageCollection'] != null) {
      doctorLanguageCollection = List<DoctorLanguageCollection>();
      json['doctorLanguageCollection'].forEach((v) {
        doctorLanguageCollection.add(DoctorLanguageCollection.fromJson(v));
      });
    }
    isDefault = json['isDefault'];
    providerPatientMappingId = json['providerPatientMappingId'];
    if (json.containsKey('sharedCategories') &&
        json['sharedCategories'] != null) {
      sharedCategories = json['sharedCategories'].cast<String>();
    }
    isResident = json['isResident'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['specialization'] = specialization;
    data['isTelehealthEnabled'] = isTelehealthEnabled;
    data['isMciVerified'] = isMciVerified;
    data['isActive'] = isActive;
    data['createdOn'] = createdOn;
    data['lastModifiedBy'] = lastModifiedBy;
    data['lastModifiedOn'] = lastModifiedOn;
    if (user != null) {
      data['user'] = user.toJson();
    }
    if (doctorProfessionalDetailCollection != null) {
      data['doctorProfessionalDetailCollection'] =
          doctorProfessionalDetailCollection.map((v) => v.toJson()).toList();
    }
    if (doctorLanguageCollection != null) {
      data['doctorLanguageCollection'] =
          doctorLanguageCollection.map((v) => v.toJson()).toList();
    }
    data['isDefault'] = isDefault;
    data['providerPatientMappingId'] = providerPatientMappingId;
    data['sharedCategories'] = sharedCategories;
    data['isResident'] = isResident;
    return data;
  }
}
