import 'package:myfhb/src/model/user/UserAddressCollection.dart';
import 'package:myfhb/telehealth/features/appointments/constants/appointments_parameters.dart'as parameters;

class Booked {
  Booked({
    this.id,
    this.name,
    this.userName,
    this.firstName,
    this.middleName,
    this.lastName,
    this.gender,
    this.dateOfBirth,
    this.bloodGroup,
    this.countryCode,
//    this.profilePicUrl,
    this.profilePicThumbnailUrl,
    this.isTempUser,
    this.isVirtualUser,
    this.isMigrated,
    this.isClaimed,
    this.isIeUser,
    this.isEmailVerified,
    this.isCpUser,
    this.communicationPreferences,
    this.medicalPreferences,
    this.isSignedIn,
    this.isActive,
    this.createdBy,
    this.createdOn,
    this.lastModifiedBy,
    this.lastModifiedOn,
    this.userAddressCollection3,
  });

  String id;
  String name;
  dynamic userName;
  String firstName;
  dynamic middleName;
  String lastName;
  String gender;
  String dateOfBirth;
  dynamic bloodGroup;
  dynamic countryCode;

//  String profilePicUrl;
  String profilePicThumbnailUrl;
  dynamic isTempUser;
  dynamic isVirtualUser;
  dynamic isMigrated;
  dynamic isClaimed;
  bool isIeUser;
  dynamic isEmailVerified;
  bool isCpUser;
  dynamic communicationPreferences;
  dynamic medicalPreferences;
  bool isSignedIn;
  bool isActive;
  String createdBy;
  String createdOn;
  String lastModifiedBy;
  String lastModifiedOn;
  List<UserAddressCollection3> userAddressCollection3;

  Booked.fromJson(Map<String, dynamic> json) {
    id = json[parameters.strId];
    name = json[parameters.strName];
    userName = json[parameters.strUserName];
    firstName = json[parameters.strFirstName];
    middleName = json[parameters.strmiddleName];
    lastName = json[parameters.strLastName];
    gender = json[parameters.strGender];
    dateOfBirth = json[parameters.strdateOfBirth];
    bloodGroup = json[parameters.strbloodGroup];
    countryCode = json[parameters.strCountryCode];
//    profilePicUrl = json[parameters.strProfilePicUrl];
    profilePicThumbnailUrl = json[parameters.strProfilePicThumbnailUrl];
    isTempUser = json[parameters.strIstemper];
    isVirtualUser = json[parameters.strisVirtualUser];
    isMigrated = json[parameters.strIsMigrated];
    isClaimed = json[parameters.strIsClaimed];
    isIeUser = json[parameters.strIsIeUser];
    isEmailVerified = json[parameters.strIsEmailVerified];
    isCpUser = json[parameters.strIsCpUser];
    communicationPreferences = json[parameters.strCommunicationPreferences];
    medicalPreferences = json[parameters.strmedicalPreferences];
    isSignedIn = json[parameters.strIsSignedIn];
    isActive = json[parameters.strIsActive];
    createdBy = json[parameters.strCreatedBy];
    createdOn = json[parameters.strCreatedOn];
    lastModifiedBy = json[parameters.strlastModifiedBy];
    lastModifiedOn = json[parameters.strLastModifiedOn];
    userAddressCollection3 = json[parameters.strUserAddressCollection3] == null
        ? null
        : List<UserAddressCollection3>.from(json[parameters.strUserAddressCollection3]
            .map((x) => UserAddressCollection3.fromJson(x)));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strId] = id;
    data[parameters.strName] = name;
    data[parameters.strUserName] = userName;
    data[parameters.strFirstName] = firstName;
    data[parameters.strmiddleName] = middleName;
    data[parameters.strLastName] = lastName;
    data[parameters.strGender] = gender;
    data[parameters.strdateOfBirth] = dateOfBirth;
    data[parameters.strbloodGroup] = bloodGroup;
    data[parameters.strCountryCode] = countryCode;
//    data[parameters.strProfilePicUrl] = profilePicUrl;
    data[parameters.strProfilePicThumbnailUrl] = profilePicThumbnailUrl;
    data[parameters.strIstemper] = isTempUser;
    data[parameters.strisVirtualUser] = isVirtualUser;
    data[parameters.strIsMigrated] = isMigrated;
    data[parameters.strIsClaimed] = isClaimed;
    data[parameters.strIsIeUser] = isIeUser;
    data[parameters.strIsEmailVerified] = isEmailVerified;
    data[parameters.strIsCpUser] = isCpUser;
    data[parameters.strCommunicationPreferences] = communicationPreferences;
    data[parameters.strmedicalPreferences] = medicalPreferences;
    data[parameters.strIsSignedIn] = isSignedIn;
    data[parameters.strIsActive] = isActive;
    data[parameters.strCreatedBy] = createdBy;
    data[parameters.strCreatedOn] = createdOn;
    data[parameters.strlastModifiedBy] = lastModifiedBy;
    data[parameters.strLastModifiedOn] = lastModifiedOn;
    return data;
  }
}
