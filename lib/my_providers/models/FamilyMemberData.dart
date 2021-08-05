import 'ProfilePicThumbnail.dart';
import '../../constants/fhb_parameters.dart' as parameters;

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
  ProfilePicThumbnail profilePicThumbnail;
  String bloodGroup;
  String  dateOfBirth;
  bool isTokenRefresh;
  String countryCode;
  bool isEmailVerified;
  String status;

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
      this.status});

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
        ? ProfilePicThumbnail.fromJson(json[parameters.strprofilePicThumbnail])
        : null;
    bloodGroup = json[parameters.strbloodGroup];
    dateOfBirth = json[parameters.strdateOfBirth];
    isTokenRefresh = json[parameters.strisTokenRefresh];
    countryCode = json[parameters.strCountryCode];
    isEmailVerified = json[parameters.strisEmailVerified];
    status = json[parameters.strStatus];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data[parameters.strId] = id;
    data[parameters.strPhoneNumber] = phoneNumber;
    data[parameters.strEmail] = email;
    data[parameters.strCreatedOn] = createdOn;
    data[parameters.strIsActive] = isActive;
    data[parameters.strLastModifiedOn] = lastModifiedOn;
    data[parameters.strName] = name;
    data[parameters.strGender] = gender;
    data[parameters.strIstemper] = isTempUser;
    data[parameters.strisVirtualUser] = isVirtualUser;
    data[parameters.strCreatedBy] = createdBy;
    if (profilePicThumbnail != null) {
      data[parameters.strprofilePicThumbnail] = profilePicThumbnail.toJson();
    }
    data[parameters.strbloodGroup] = bloodGroup;
    data[parameters.strdateOfBirth] = dateOfBirth;
    data[parameters.strisTokenRefresh] = isTokenRefresh;
    data[parameters.strCountryCode] = countryCode;
    data[parameters.strisEmailVerified] = isEmailVerified;
    data[parameters.strStatus] = status;
    return data;
  }
}


