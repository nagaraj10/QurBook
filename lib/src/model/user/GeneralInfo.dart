import 'package:myfhb/src/model/user/ProfilePicThumbnail.dart';
import 'package:myfhb/src/model/user/QualifiedFullName.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class GeneralInfo {
  String name;
  String countryCode;
  String phoneNumber;
  String email;
  String gender;
  String bloodGroup;
  String createdBy;
  bool isEmailVerified;
  bool isVirtualUser;
  bool isTempUser;
  String createdOn;
  String lastModifiedOn;
  String dateOfBirth;
  ProfilePicThumbnailMain profilePicThumbnail;
  QualifiedFullName qualifiedFullName;
  String mappedDoctorId;
  String profilePicThumbnailURL;

  GeneralInfo(
      {this.name,
      this.countryCode,
      this.phoneNumber,
      this.email,
      this.gender,
      this.bloodGroup,
      this.createdBy,
      this.isEmailVerified,
      this.isVirtualUser,
      this.isTempUser,
      this.createdOn,
      this.lastModifiedOn,
      this.dateOfBirth,
      this.profilePicThumbnail,
      this.qualifiedFullName,
      this.mappedDoctorId,
      this.profilePicThumbnailURL});

  GeneralInfo.fromJson(Map<String, dynamic> json) {
    name = json[parameters.strName];
    countryCode = json[parameters.strCountryCode];
    phoneNumber = json[parameters.strPhoneNumber];
    email = json[parameters.strEmail];
    gender = json[parameters.strGender];
    bloodGroup = json[parameters.strbloodGroup];
    createdBy = json[parameters.strCreatedBy];
    isEmailVerified = json[parameters.strisEmailVerified];
    isVirtualUser = json[parameters.strisVirtualUser];
    isTempUser = json[parameters.strIstemper];
    createdOn = json[parameters.strCreatedOn];
    lastModifiedOn = json[parameters.strLastModifiedOn];
    dateOfBirth = json[parameters.strdateOfBirth];
    profilePicThumbnail = json[parameters.strprofilePicThumbnail] != null
        ? new ProfilePicThumbnailMain.fromJson(
            json[parameters.strprofilePicThumbnail])
        : null;
    qualifiedFullName = json[parameters.strqualifiedFullName] != null
        ? new QualifiedFullName.fromJson(json[parameters.strqualifiedFullName])
        : null;
    mappedDoctorId = json['mappedDoctorId'];
    profilePicThumbnailURL = json['profilePicThumbnailURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strName] = this.name;
    data[parameters.strCountryCode] = this.countryCode;
    data[parameters.strPhoneNumber] = this.phoneNumber;
    data[parameters.strEmail] = this.email;
    data[parameters.strGender] = this.gender;
    data[parameters.strbloodGroup] = this.bloodGroup;
    data[parameters.strCreatedBy] = this.createdBy;
    data[parameters.strisEmailVerified] = this.isEmailVerified;
    data[parameters.strisVirtualUser] = this.isVirtualUser;
    data[parameters.strIstemper] = this.isTempUser;
    data[parameters.strCreatedOn] = this.createdOn;
    data[parameters.strLastModifiedOn] = this.lastModifiedOn;
    data[parameters.strdateOfBirth] = this.dateOfBirth;
    if (this.profilePicThumbnail != null) {
      data[parameters.strprofilePicThumbnail] =
          this.profilePicThumbnail.toJson();
    }
    if (this.qualifiedFullName != null) {
      data[parameters.strqualifiedFullName] = this.qualifiedFullName.toJson();
    }
    data['mappedDoctorId'] = this.mappedDoctorId;
    data['profilePicThumbnailURL'] = this.profilePicThumbnailURL;
    return data;
  }
}
