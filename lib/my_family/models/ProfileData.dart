import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/my_providers/models/ProfilePicThumbnail.dart';

class ProfileData {
  String userId;
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
  ProfilePicThumbnail profilePicThumbnail;
  /*QualifiedFullName qualifiedFullName;*/
  String bloodGroup;
  String dateOfBirth;
  bool isTokenRefresh;
  String countryCode;
  bool isEmailVerified;
  String status;
  String profilePicThumbnailURL;

  ProfileData(
      {this.userId,
      this.id,
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
      /*this.qualifiedFullName,*/
      this.bloodGroup,
      this.dateOfBirth,
      this.isTokenRefresh,
      this.countryCode,
      this.isEmailVerified,
      this.status,
      this.profilePicThumbnailURL});

  ProfileData.fromJson(Map<String, dynamic> json) {
    userId = json[parameters.struserId];
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
    try {
      profilePicThumbnail = json['profilePicThumbnail'] != null
          ? new ProfilePicThumbnail.fromJson(json['profilePicThumbnail'])
          : null;
    } catch (e) {}
    /*qualifiedFullName = json[parameters.strqualifiedFullName] != null
        ? new QualifiedFullName.fromJson(json[parameters.strqualifiedFullName])
        : null;*/
    bloodGroup = json[parameters.strbloodGroup];
    dateOfBirth = json[parameters.strdateOfBirth];
    isTokenRefresh = json[parameters.strisTokenRefresh];
    countryCode = json[parameters.strCountryCode];
    isEmailVerified = json[parameters.strisEmailVerified];
    status = json[parameters.strStatus];
    profilePicThumbnailURL = json[parameters.strprofilePicThumbnailURL];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.struserId] = this.userId;
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
      data[parameters.strprofilePicThumbnail] =
          this.profilePicThumbnail.toJson();
    }
    data[parameters.strbloodGroup] = this.bloodGroup;
    data[parameters.strdateOfBirth] = this.dateOfBirth;
    data[parameters.strisTokenRefresh] = this.isTokenRefresh;
    data[parameters.strCountryCode] = this.countryCode;
    data[parameters.strIsEmailVerified] = this.isEmailVerified;
    data[parameters.strStatus] = this.status;
    /*if (this.qualifiedFullName != null) {
      data[parameters.strqualifiedFullName] = this.qualifiedFullName.toJson();
    }*/
    data[parameters.strprofilePicThumbnailURL] = this.profilePicThumbnailURL;
    return data;
  }
}
