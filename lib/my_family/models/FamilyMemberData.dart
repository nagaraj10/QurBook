import 'package:myfhb/src/model/user/ProfilePicThumbnail.dart';
import 'package:myfhb/src/model/user/QualifiedFullName.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;


class FamilyMemberData {
  String id;
  String phoneNumber;
  String email;
  String createdOn;
  bool isActive;
  String lastModifiedOn;
  String name;
  String gender;
  bool isTempUser;
  bool isVirtualUser;
  String createdBy;
  ProfilePicThumbnailMain profilePicThumbnail;
  String bloodGroup;
  String dateOfBirth;
  bool isTokenRefresh;
  String countryCode;
  bool isEmailVerified;
  String status;
  QualifiedFullName qualifiedFullName;

  FamilyMemberData(
      {this.id,
      this.phoneNumber,
      this.email,
      this.createdOn,
      this.isActive,
      this.lastModifiedOn,
      this.name,
      this.gender,
      this.isTempUser,
      this.isVirtualUser,
      this.createdBy,
      this.profilePicThumbnail,
      this.bloodGroup,
      this.dateOfBirth,
      this.isTokenRefresh,
      this.countryCode,
      this.isEmailVerified,
      this.status,
      this.qualifiedFullName});

  FamilyMemberData.fromJson(Map<String, dynamic> json) {
    id = json[parameters.strId];
    phoneNumber = json[parameters.strPhoneNumber];
    email = json[parameters.strEmail];
    createdOn = json[parameters.strCreatedOn];
    isActive = json[parameters.strIsActive];
    lastModifiedOn = json[parameters.strLastModifiedOn];
    name = json[parameters.strName];
    gender = json[parameters.strGender];
    isTempUser = json[parameters.strIstemper];
    isVirtualUser = json[parameters.strisVirtualUser];
    createdBy = json[parameters.strCreatedBy];
    profilePicThumbnail = json[parameters.strprofilePicThumbnail] != null
        ? new ProfilePicThumbnailMain.fromJson(json[parameters.strprofilePicThumbnail])
        : null;
    bloodGroup = json[parameters.strbloodGroup];
    dateOfBirth = json[parameters.strdateOfBirth];
    isTokenRefresh = json[parameters.strisTokenRefresh];
    countryCode = json[parameters.strCountryCode];
    isEmailVerified = json[parameters.strisEmailVerified];
    status = json[parameters.strStatus];
    qualifiedFullName = json[parameters.strqualifiedFullName] != null
        ? new QualifiedFullName.fromJson(json[parameters.strqualifiedFullName])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strId] = this.id;
    data[parameters.strPhoneNumber] = this.phoneNumber;
    data[parameters.strEmail] = this.email;
    data[parameters.strCreatedOn] = this.createdOn;
    data[parameters.strIsActive] = this.isActive;
    data[parameters.strLastModifiedOn] = this.lastModifiedOn;
    data[parameters.strName] = this.name;
    data[parameters.strGender] = this.gender;
    data[parameters.strIstemper] = this.isTempUser;
    data[parameters.strisVirtualUser] = this.isVirtualUser;
    data[parameters.strCreatedBy] = this.createdBy;
    if (this.profilePicThumbnail != null) {
      data[parameters.strprofilePicThumbnail] = this.profilePicThumbnail.toJson();
    }
    data[parameters.strbloodGroup] = this.bloodGroup;
    data[parameters.strdateOfBirth] = this.dateOfBirth;
    data[parameters.strisTokenRefresh] = this.isTokenRefresh;
    data[parameters.strCountryCode] = this.countryCode;
    data[parameters.strisEmailVerified] = this.isEmailVerified;
    data[parameters.strStatus] = this.status;
    if (this.qualifiedFullName != null) {
      data[parameters.strqualifiedFullName] = this.qualifiedFullName.toJson();
    }
    return data;
  }
}



