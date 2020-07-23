import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/MedicalCouncilInfo.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/QualificationInfo.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/Specialty.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class ProfessionalDetails {
  String id;
  String doctorId;
  String aboutMe;
  QualificationInfo qualificationInfo;
  MedicalCouncilInfo medicalCouncilInfo;
  Specialty specialty;
  Specialty clinicName;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  String lastModifiedBy;

  ProfessionalDetails(
      {this.id,
      this.doctorId,
      this.aboutMe,
      this.qualificationInfo,
      this.medicalCouncilInfo,
      this.specialty,
      this.clinicName,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn,
      this.lastModifiedBy});

  ProfessionalDetails.fromJson(Map<String, dynamic> json) {
    id = json[parameters.strId];
    doctorId = json[parameters.strDoctorId];
    aboutMe = json[parameters.straboutMe];
    qualificationInfo = json[parameters.strqualificationInfo] != null
        ? new QualificationInfo.fromJson(json[parameters.strqualificationInfo])
        : null;
    medicalCouncilInfo = json[parameters.strmedicalCouncilInfo] != null
        ? new MedicalCouncilInfo.fromJson(json[parameters.strmedicalCouncilInfo])
        : null;
    specialty = json[parameters.strspecialty] != null
        ? new Specialty.fromJson(json[parameters.strspecialty])
        : null;
    clinicName = json[parameters.strclinicName] != null
        ? new Specialty.fromJson(json[parameters.strclinicName])
        : null;
    isActive = json[parameters.strIsActive];
    createdOn = json[parameters.strCreatedOn];
    lastModifiedOn = json[parameters.strLastModifiedOn];
    lastModifiedBy = json[parameters.strlastModifiedBy];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strId] = this.id;
    data[parameters.strDoctorId] = this.doctorId;
    data[parameters.straboutMe] = this.aboutMe;
    if (this.qualificationInfo != null) {
      data[parameters.strqualificationInfo] = this.qualificationInfo.toJson();
    }
    if (this.medicalCouncilInfo != null) {
      data[parameters.strmedicalCouncilInfo] = this.medicalCouncilInfo.toJson();
    }
    if (this.specialty != null) {
      data[parameters.strspecialty] = this.specialty.toJson();
    }
    if (this.clinicName != null) {
      data[parameters.strclinicName] = this.clinicName.toJson();
    }
    data[parameters.strIsActive] = this.isActive;
    data[parameters.strCreatedOn] = this.createdOn;
    data[parameters.strLastModifiedOn] = this.lastModifiedOn;
    data[parameters.strlastModifiedBy] = this.lastModifiedBy;
    return data;
  }
}