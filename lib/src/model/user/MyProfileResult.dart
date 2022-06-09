import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart';

import '../../../my_family/models/FamilyMembersRes.dart';
import '../GetDeviceSelectionModel.dart';
import 'UserAddressCollection.dart';
import 'userrelationshipcollection.dart';

import 'AddressTypeModel.dart';

class MyProfileResult {
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
  bool isCaregiver;
  // String createdBy;
  // String createdOn;
  String lastModifiedBy;
  String lastModifiedOn;
  String membershipOfferedBy;
  List<UserAddressCollection3> userAddressCollection3;
  List<UserContactCollection3> userContactCollection3;
  List<UserRoleCollection3> userRoleCollection3;
  List<UserRelationshipCollection> userRelationshipCollection;
  AdditionalInfo additionalInfo;
  List<UserProfileSettingCollection3> userProfileSettingCollection3;

  MyProfileResult(
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
      // this.createdBy,
      // this.createdOn,
      this.lastModifiedBy,
      this.lastModifiedOn,
      this.userAddressCollection3,
      this.userContactCollection3,
      this.userRoleCollection3,
      this.userRelationshipCollection,
      this.additionalInfo,
      this.userProfileSettingCollection3,
      this.membershipOfferedBy,
      this.isCaregiver});

  MyProfileResult.fromJson(Map<String, dynamic> json) {
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
    // createdBy = json['createdBy'];
    // createdOn = json['createdOn'];
    lastModifiedBy = json['lastModifiedBy'];
    lastModifiedOn = json['lastModifiedOn'];
    if (json.containsKey('membershipOfferedBy'))
      membershipOfferedBy = json['membershipOfferedBy'];
    if (json['userAddressCollection3'] != null) {
      userAddressCollection3 = List<UserAddressCollection3>();
      json['userAddressCollection3'].forEach((v) {
        userAddressCollection3.add(UserAddressCollection3.fromJson(v));
      });
    }
    if (json['userContactCollection3'] != null) {
      userContactCollection3 = List<UserContactCollection3>();
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
    if (json['userRelationshipCollection'] != null) {
      userRelationshipCollection = <UserRelationshipCollection>[];
      json['userRelationshipCollection'].forEach((v) {
        userRelationshipCollection.add(UserRelationshipCollection.fromJson(v));
      });
    }
    if (json['userProfileSettingCollection3'] != null) {
      userProfileSettingCollection3 = List<UserProfileSettingCollection3>();
      json['userProfileSettingCollection3'].forEach((v) {
        userProfileSettingCollection3
            .add(UserProfileSettingCollection3.fromJson(v));
      });
    }

    additionalInfo = json['additionalInfo'] != null
        ? AdditionalInfo.fromJson(json['additionalInfo'])
        : null;

    if (json.containsKey("isCaregiver")) {
      isCaregiver = json['isCaregiver'];
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
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
    // data['createdBy'] = this.createdBy;
    // data['createdOn'] = this.createdOn;
    data['lastModifiedBy'] = lastModifiedBy;
    data['lastModifiedOn'] = lastModifiedOn;
    data['membershipOfferedBy'] = membershipOfferedBy;
    data['isCaregiver'] = isCaregiver;
    if (userAddressCollection3 != null) {
      data['userAddressCollection3'] =
          userAddressCollection3.map((v) => v.toJson()).toList();
    }
    if (userContactCollection3 != null) {
      data['userContactCollection3'] =
          userContactCollection3.map((v) => v.toJson()).toList();
    }
    if (userRoleCollection3 != null) {
      data['userRoleCollection3'] =
          userRoleCollection3.map((v) => v.toJson()).toList();
    }
    if (userRelationshipCollection != null) {
      data['userRelationshipCollection'] =
          userRelationshipCollection.map((v) => v.toJson()).toList();
    }
    if (additionalInfo != null) {
      data['additionalInfo'] = additionalInfo.toJson();
    }
    if (userProfileSettingCollection3 != null) {
      data['userProfileSettingCollection3'] =
          userProfileSettingCollection3.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AdditionalInfo {
  int age;
  String height;
  String weight;
  List<String> language;
  String mrdNumber;
  String uhidNumber;
  String visitReason;
  String patientHistory;
  HeightObj heightObj;
  String offSet = CommonUtil().setTimeZone();

  AdditionalInfo(
      {this.age,
      this.height,
      this.weight,
      this.language,
      this.mrdNumber,
      this.uhidNumber,
      this.visitReason,
      this.patientHistory});

  AdditionalInfo.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('age')) {
      if (json.containsKey('age') is String) {
        age = 0;
      } else {
        age = json['age'];
      }
    }

    try {
      if (json['height'].runtimeType == String) {
        height = json['height'];
      } else {
        heightObj =
            json['height'] != null ? HeightObj.fromJson(json['height']) : null;
      }
          weight = json['weight']?.toString();

    } catch (e) {}


    try {
      if (json.containsKey('language')) {
        language = json['language'].cast<String>();
      }
    } catch (e) {}
    if (json.containsKey('mrdNumber')) mrdNumber = json['mrdNumber'];
    if (json.containsKey('uhidNumber')) uhidNumber = json['uhidNumber'];
    if (json.containsKey('visitReason')) visitReason = json['visitReason'];
    if (json.containsKey('patientHistory')) {
      patientHistory = json['patientHistory'];
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['age'] = age;
    data['height'] = height;
    data['weight'] = weight;
    data['language'] = language;
    data['mrdNumber'] = mrdNumber;
    data['uhidNumber'] = uhidNumber;
    data['visitReason'] = visitReason;
    data['patientHistory'] = patientHistory;
    if (this.heightObj != null) {
      data['height'] = this.heightObj.toJson();
    }
    data[KEY_OffSet] = CommonUtil().setTimeZone();
    return data;
  }
}

class UserContactCollection3 {
  String id;
  String phoneNumber;
  bool isPrimary;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  String email;
  AddressType phoneNumberType;

  UserContactCollection3(
      {this.id,
      this.phoneNumber,
      this.isPrimary,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn,
      this.email,
      this.phoneNumberType});

  UserContactCollection3.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phoneNumber = json['phoneNumber'];
    isPrimary = json['isPrimary'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    email = json['email'];
    phoneNumberType = json['phoneNumberType'] != null
        ? AddressType.fromJson(json['phoneNumberType'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['phoneNumber'] = phoneNumber;
    data['isPrimary'] = isPrimary;
    data['isActive'] = isActive;
    data['createdOn'] = createdOn;
    data['lastModifiedOn'] = lastModifiedOn;
    data['email'] = email;
    if (phoneNumberType != null) {
      data['phoneNumberType'] = phoneNumberType.toJson();
    }
    return data;
  }
}

class UserRoleCollection3 {
  String id;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  Role role;

  UserRoleCollection3(
      {this.id, this.isActive, this.createdOn, this.lastModifiedOn, this.role});

  UserRoleCollection3.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    role = json['role'] != null ? Role.fromJson(json['role']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['isActive'] = isActive;
    data['createdOn'] = createdOn;
    data['lastModifiedOn'] = lastModifiedOn;
    if (role != null) {
      data['role'] = role.toJson();
    }
    return data;
  }
}

class Role {
  String id;
  String name;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  String roleCode;
  String description;
  bool isSystemRole;
  bool isEnabled;

  Role(
      {this.id,
      this.name,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn,
      this.roleCode,
      this.description,
      this.isSystemRole,
      this.isEnabled});

  Role.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    roleCode = json['roleCode'];
    description = json['description'];
    isSystemRole = json['isSystemRole'];
    isEnabled = json['isEnabled'];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['isActive'] = isActive;
    data['createdOn'] = createdOn;
    data['lastModifiedOn'] = lastModifiedOn;
    data['roleCode'] = roleCode;
    data['description'] = description;
    data['isSystemRole'] = isSystemRole;
    data['isEnabled'] = isEnabled;
    return data;
  }
}

class UserProfileSettingCollection3 {
  String id;
  String userId;
  ProfileSetting profileSetting;
  bool isActive;
  String createdOn;
  String lastModifiedOn;

  UserProfileSettingCollection3(
      {this.id,
      this.userId,
      this.profileSetting,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn});

  UserProfileSettingCollection3.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    profileSetting = json['profileSetting'] != null
        ? ProfileSetting.fromJson(json['profileSetting'])
        : null;
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    if (profileSetting != null) {
      data['profileSetting'] = profileSetting.toJson();
    }
    data['isActive'] = isActive;
    data['createdOn'] = createdOn;
    data['lastModifiedOn'] = lastModifiedOn;
    return data;
  }
}

class HeightObj {
  String valueFeet;
  String valueInches;

  HeightObj({this.valueFeet, this.valueInches});

  HeightObj.fromJson(Map<String, dynamic> json) {
    valueFeet = json['valueFeet'];
    valueInches = json['valueInches'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['valueFeet'] = this.valueFeet;
    data['valueInches'] = this.valueInches;
    return data;
  }
}
