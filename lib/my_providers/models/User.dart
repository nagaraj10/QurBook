import 'UserAddressCollection.dart';
import 'UserContactCollection.dart';
import 'UserRoleCollection.dart';

class User {
  String id;
  String name;
  String userName;
  String firstName;
  String middleName;
  String lastName;
  String gender;
  String dateOfBirth;
  String bloodGroup;
  String countryCode;
  String profilePicUrl;
  String profilePicThumbnailUrl;
  bool isTempUser;
  bool isVirtualUser;
  bool isMigrated;
  bool isClaimed;
  bool isIeUser;
  bool isEmailVerified;
  bool isCpUser;
  String communicationPreferences;
  String medicalPreferences;
  bool isSignedIn;
  bool isActive;
  String createdBy;
  String createdOn;
  String lastModifiedBy;
  String lastModifiedOn;
  List<UserContactCollection3> userContactCollection3;
  List<UserRoleCollection3> userRoleCollection3;
  List<UserAddressCollection3> userAddressCollection3;

  User(
      {this.id,
        this.name,
        this.userName,
        this.firstName,
        this.middleName,
        this.lastName,
        this.gender,
        this.dateOfBirth,
        this.bloodGroup,
        this.countryCode,
        this.profilePicUrl,
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
        this.userContactCollection3,
        this.userRoleCollection3,
        this.userAddressCollection3});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    userName = json['userName'];
    firstName = json['firstName'];
    middleName = json['middleName'];
    lastName = json['lastName'];
    gender = json['gender'];
    dateOfBirth = json['dateOfBirth'];
    bloodGroup = json['bloodGroup'];
    countryCode = json['countryCode'];
    profilePicUrl = json['profilePicUrl'];
    profilePicThumbnailUrl = json['profilePicThumbnailUrl'];
    isTempUser = json['isTempUser'];
    isVirtualUser = json['isVirtualUser'];
    isMigrated = json['isMigrated'];
    isClaimed = json['isClaimed'];
    isIeUser = json['isIeUser'];
    isEmailVerified = json['isEmailVerified'];
    isCpUser = json['isCpUser'];
    communicationPreferences = json['communicationPreferences'];
    medicalPreferences = json['medicalPreferences'];
    isSignedIn = json['isSignedIn'];
    isActive = json['isActive'];
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    lastModifiedBy = json['lastModifiedBy'];
    lastModifiedOn = json['lastModifiedOn'];
    if (json['userContactCollection3'] != null) {
      userContactCollection3 = <UserContactCollection3>[];
      json['userContactCollection3'].forEach((v) {
        userContactCollection3.add(UserContactCollection3.fromJson(v));
      });
    }
    if (json['userRoleCollection3'] != null) {
      userRoleCollection3 = <UserRoleCollection3>[];
      json['userRoleCollection3'].forEach((v) {
        userRoleCollection3.add(UserRoleCollection3.fromJson(v));
      });
    }
    if (json['userAddressCollection3'] != null) {
      userAddressCollection3 = <UserAddressCollection3>[];
      json['userAddressCollection3'].forEach((v) {
        userAddressCollection3.add(UserAddressCollection3.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['userName'] = userName;
    data['firstName'] = firstName;
    data['middleName'] = middleName;
    data['lastName'] = lastName;
    data['gender'] = gender;
    data['dateOfBirth'] = dateOfBirth;
    data['bloodGroup'] = bloodGroup;
    data['countryCode'] = countryCode;
    data['profilePicUrl'] = profilePicUrl;
    data['profilePicThumbnailUrl'] = profilePicThumbnailUrl;
    data['isTempUser'] = isTempUser;
    data['isVirtualUser'] = isVirtualUser;
    data['isMigrated'] = isMigrated;
    data['isClaimed'] = isClaimed;
    data['isIeUser'] = isIeUser;
    data['isEmailVerified'] = isEmailVerified;
    data['isCpUser'] = isCpUser;
    data['communicationPreferences'] = communicationPreferences;
    data['medicalPreferences'] = medicalPreferences;
    data['isSignedIn'] = isSignedIn;
    data['isActive'] = isActive;
    data['createdBy'] = createdBy;
    data['createdOn'] = createdOn;
    data['lastModifiedBy'] = lastModifiedBy;
    data['lastModifiedOn'] = lastModifiedOn;
    if (userContactCollection3 != null) {
      data['userContactCollection3'] =
          userContactCollection3.map((v) => v.toJson()).toList();
    }
    if (userRoleCollection3 != null) {
      data['userRoleCollection3'] =
          userRoleCollection3.map((v) => v.toJson()).toList();
    }
    if (userAddressCollection3 != null) {
      data['userAddressCollection3'] =
          userAddressCollection3.map((v) => v.toJson()).toList();
    }
    return data;
  }
}