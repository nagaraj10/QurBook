import 'DoctorLanguageCollection.dart';
import 'User.dart';
import 'UserProfessionalCollection.dart';

class GetDoctorsByIdModel {
  bool isSuccess;
  String message;
  DoctorResult result;

  GetDoctorsByIdModel({this.isSuccess, this.message, this.result});

  GetDoctorsByIdModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    result =
        json['result'] != null ? DoctorResult.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['isSuccess'] = isSuccess;
    data['message'] = message;
    if (result != null) {
      data['result'] = result.toJson();
    }
    return data;
  }
}

class DoctorResult {
  String id;
  String specialization;
  bool isTelehealthEnabled;
  bool isMciVerified;
  bool isActive;
  bool isWelcomeMailSent;
  String createdOn;
  String lastModifiedBy;
  String lastModifiedOn;
  bool isResident = false;
  User user;
  List<DoctorProfessionalDetailCollection> doctorProfessionalDetailCollection;
  List<DoctorLanguageCollection> doctorLanguageCollection;

  DoctorResult({
    this.id,
    this.specialization,
    this.isTelehealthEnabled,
    this.isMciVerified,
    this.isActive,
    this.isWelcomeMailSent,
    this.createdOn,
    this.lastModifiedBy,
    this.lastModifiedOn,
    this.user,
    this.doctorProfessionalDetailCollection,
    this.doctorLanguageCollection,
    this.isResident,
  });

  DoctorResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    specialization = json['specialization'];
    isTelehealthEnabled = json['isTelehealthEnabled'];
    isMciVerified = json['isMciVerified'];
    isActive = json['isActive'];
    isWelcomeMailSent = json['isWelcomeMailSent'];
    createdOn = json['createdOn'];
    lastModifiedBy = json['lastModifiedBy'];
    lastModifiedOn = json['lastModifiedOn'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    if (json['doctorProfessionalDetailCollection'] != null) {
      doctorProfessionalDetailCollection =
          <DoctorProfessionalDetailCollection>[];
      json['doctorProfessionalDetailCollection'].forEach((v) {
        doctorProfessionalDetailCollection
            .add(DoctorProfessionalDetailCollection.fromJson(v));
      });
    }
    if (json['doctorLanguageCollection'] != null) {
      doctorLanguageCollection = <DoctorLanguageCollection>[];
      json['doctorLanguageCollection'].forEach((v) {
        doctorLanguageCollection.add(DoctorLanguageCollection.fromJson(v));
      });
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
    data['isWelcomeMailSent'] = isWelcomeMailSent;
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
    data['isResident'] = isResident;
    return data;
  }
}
