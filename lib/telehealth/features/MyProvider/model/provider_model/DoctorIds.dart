import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/Fees.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/Languages.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/ProfessionalDetails.dart';
import 'package:myfhb/telehealth/features/MyProvider/model/provider_model/ProfilePic.dart';

import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class DoctorIds {
  String id;
  String name;
  String addressLine1;
  String addressLine2;
  String website;
  String googleMapUrl;
  String phoneNumber1;
  String phoneNumber2;
  String phoneNumber3;
  String phoneNumber4;
  String email;
  String state;
  String city;
  bool isActive;
  String specialization;
  bool isUserDefined;
  String description;
  String createdBy;
  String lastModifiedOn;
  ProfilePic profilePic;
  ProfilePic profilePicThumbnail;
  String firstName;
  String lastName;
  String genderId;
  String dob;
  String cityId;
  String stateId;
  String pinCode;
  String lastModifiedBy;
  bool isTelehealthEnabled;
  bool isMCIVerified;
  List<Languages> languages;
  List<ProfessionalDetails> professionalDetails;
  Fees fees;
  bool isDefault;
  String doctorPatientMappingId;
  String gender;

  DoctorIds(
      {this.id,
      this.name,
      this.addressLine1,
      this.addressLine2,
      this.website,
      this.googleMapUrl,
      this.phoneNumber1,
      this.phoneNumber2,
      this.phoneNumber3,
      this.phoneNumber4,
      this.email,
      this.state,
      this.city,
      this.isActive,
      this.specialization,
      this.isUserDefined,
      this.description,
      this.createdBy,
      this.lastModifiedOn,
      this.profilePic,
      this.profilePicThumbnail,
      this.firstName,
      this.lastName,
      this.genderId,
      this.dob,
      this.cityId,
      this.stateId,
      this.pinCode,
      this.lastModifiedBy,
      this.isTelehealthEnabled,
      this.isMCIVerified,
      this.languages,
      this.professionalDetails,
      this.fees,
      this.isDefault,
      this.doctorPatientMappingId,
      this.gender});

  DoctorIds.fromJson(Map<String, dynamic> json) {
    id = json[parameters.strId];
    createdBy = json[parameters.strCreatedBy];
    name = json[parameters.strName];
    phoneNumber1 = json[parameters.strPhoneNumber1];
    phoneNumber2 = json[parameters.strPhoneNumber2];
    phoneNumber3 = json[parameters.strPhoneNumber3];
    phoneNumber4 = json[parameters.strPhoneNumber4];
    addressLine1 = json[parameters.strAddressLine1];
    addressLine2 = json[parameters.strAddressLine2];
    city = json[parameters.strCity];
    state = json[parameters.strState];

    website = json[parameters.strWebsite];
    email = json[parameters.strEmail];
    googleMapUrl = json[parameters.strGoogleMapUrl];
    isUserDefined = json[parameters.strIsUserDefined];
    description = json[parameters.strDescription];
    isActive = json[parameters.strIsActive];
    lastModifiedOn = json[parameters.strLastModifiedOn];
    isDefault = json[parameters.strisDefault];
    createdBy = json[parameters.strCreatedBy];

    profilePic = json[parameters.strprofilePic] != null
        ? new ProfilePic.fromJson(json[parameters.strprofilePic])
        : null;
    profilePicThumbnail = json[parameters.strprofilePicThumbnail] != null
        ? new ProfilePic.fromJson(json[parameters.strprofilePicThumbnail])
        : null;
    firstName = json[parameters.strfirstName];
    lastName = json[parameters.strlastName];
    genderId = json[parameters.strGender];
    dob = json[parameters.strdob];
    cityId = json[parameters.strcityId];
    stateId = json[parameters.strstateId];
    pinCode = json[parameters.strpinCode];
    lastModifiedBy = json[parameters.strlastModifiedBy];
    isTelehealthEnabled = json[parameters.strisTelehealthEnabled];
    isMCIVerified = json[parameters.strisMCIVerified];
    if (json[parameters.strlanguages] != null) {
      languages = new List<Languages>();
      json[parameters.strlanguages].forEach((v) {
        languages.add(new Languages.fromJson(v));
      });
    }
    if (json[parameters.strprofessionalDetails] != null) {
      professionalDetails = new List<ProfessionalDetails>();
      json[parameters.strprofessionalDetails].forEach((v) {
        professionalDetails.add(new ProfessionalDetails.fromJson(v));
      });
    }
    fees = json[parameters.strfees] != null ? new Fees.fromJson(json[parameters.strfees]) : null;
    isDefault = json[parameters.strisDefault];
    doctorPatientMappingId = json[parameters.strdoctorPatientMappingId];
    gender = json[parameters.strGender];
    specialization=json[parameters.strSpecilization];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strId] = this.id;
    data[parameters.strCreatedBy] = this.createdBy;
    data[parameters.strName] = this.name;
    data[parameters.strPhoneNumber1] = this.phoneNumber1;
    data[parameters.strPhoneNumber2] = this.phoneNumber2;
    data[parameters.strPhoneNumber3] = this.phoneNumber3;
    data[parameters.strPhoneNumber4] = this.phoneNumber4;
    data[parameters.strAddressLine1] = this.addressLine1;
    data[parameters.strAddressLine2] = this.addressLine2;
    data[parameters.strCity] = this.city;
    data[parameters.strState] = this.state;
    data[parameters.strWebsite] = this.website;
    data[parameters.strEmail] = this.email;
    data[parameters.strGoogleMapUrl] = this.googleMapUrl;
    data[parameters.strIsUserDefined] = this.isUserDefined;
    data[parameters.strDescription] = this.description;
    data[parameters.strIsActive] = this.isActive;
    data[parameters.strCreatedBy] = this.createdBy;
    data[parameters.strLastModifiedOn] = this.lastModifiedOn;
    data[parameters.strisDefault] = this.isDefault;
    data[parameters.strprofilePic] = this.profilePic;
    data[parameters.strprofilePicThumbnail] = this.profilePicThumbnail;
    data[parameters.strfirstName] = this.firstName;
    data[parameters.strlastName] = this.lastName;
    data[parameters.strGenderID] = this.genderId;
    data[parameters.strdob] = this.dob;
    data[parameters.strcityId] = this.cityId;
    data[parameters.strstateId] = this.stateId;
    data[parameters.strpinCode] = this.pinCode;
    data[parameters.strlastModifiedBy] = this.lastModifiedBy;
    data[parameters.strisTelehealthEnabled] = this.isTelehealthEnabled;
    data[parameters.strisMCIVerified] = this.isMCIVerified;
    if (this.languages != null) {
      data[parameters.strlanguages] =
          this.languages.map((v) => v.toJson()).toList();
    }
    if (this.professionalDetails != null) {
      data[parameters.strprofessionalDetails] =
          this.professionalDetails.map((v) => v.toJson()).toList();
    }
    if (this.fees != null) {
      data[parameters.strfees] = this.fees.toJson();
    }
    data[parameters.strisDefault] = this.isDefault;
    data[parameters.strdoctorPatientMappingId] = this.doctorPatientMappingId;
    data[parameters.strGender] = this.gender;
    data[parameters.strSpecilization]=this.specialization;
    return data;
  }
}
