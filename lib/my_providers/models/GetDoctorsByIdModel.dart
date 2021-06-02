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
    json['result'] != null ? new DoctorResult.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result.toJson();
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
  User user;
  List<DoctorProfessionalDetailCollection> doctorProfessionalDetailCollection;
  List<DoctorLanguageCollection> doctorLanguageCollection;

  DoctorResult(
      {this.id,
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
        this.doctorLanguageCollection});

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
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['doctorProfessionalDetailCollection'] != null) {
      doctorProfessionalDetailCollection =
      new List<DoctorProfessionalDetailCollection>();
      json['doctorProfessionalDetailCollection'].forEach((v) {
        doctorProfessionalDetailCollection
            .add(new DoctorProfessionalDetailCollection.fromJson(v));
      });
    }
    if (json['doctorLanguageCollection'] != null) {
      doctorLanguageCollection = new List<DoctorLanguageCollection>();
      json['doctorLanguageCollection'].forEach((v) {
        doctorLanguageCollection.add(new DoctorLanguageCollection.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['specialization'] = this.specialization;
    data['isTelehealthEnabled'] = this.isTelehealthEnabled;
    data['isMciVerified'] = this.isMciVerified;
    data['isActive'] = this.isActive;
    data['isWelcomeMailSent'] = this.isWelcomeMailSent;
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
    if (this.doctorLanguageCollection != null) {
      data['doctorLanguageCollection'] =
          this.doctorLanguageCollection.map((v) => v.toJson()).toList();
    }
    return data;
  }
}