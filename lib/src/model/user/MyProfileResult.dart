import 'package:myfhb/my_family/models/FamilyMembersRes.dart';
import 'package:myfhb/src/model/user/UserAddressCollection.dart';
import 'package:myfhb/src/model/user/userrelationshipcollection.dart';

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
  // String createdBy;
  // String createdOn;
  String lastModifiedBy;
  String lastModifiedOn;
  List<UserAddressCollection3> userAddressCollection3;
  List<UserContactCollection3> userContactCollection3;
  List<UserRoleCollection3> userRoleCollection3;
  List<UserRelationshipCollection> userRelationshipCollection;
  AdditionalInfo additionalInfo;

  MyProfileResult({
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
  });

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
    if (json['userAddressCollection3'] != null) {
      userAddressCollection3 = new List<UserAddressCollection3>();
      json['userAddressCollection3'].forEach((v) {
        userAddressCollection3.add(new UserAddressCollection3.fromJson(v));
      });
    }
    if (json['userContactCollection3'] != null) {
      userContactCollection3 = new List<UserContactCollection3>();
      json['userContactCollection3'].forEach((v) {
        userContactCollection3.add(new UserContactCollection3.fromJson(v));
      });
    }
    if (json['userRoleCollection3'] != null) {
      userRoleCollection3 = new List<UserRoleCollection3>();
      json['userRoleCollection3'].forEach((v) {
        userRoleCollection3.add(new UserRoleCollection3.fromJson(v));
      });
    }
    if (json['userRelationshipCollection'] != null) {
      userRelationshipCollection = new List<UserRelationshipCollection>();
      json['userRelationshipCollection'].forEach((v) {
        userRelationshipCollection
            .add(new UserRelationshipCollection.fromJson(v));
      });
    }

    additionalInfo = json['additionalInfo'] != null
        ? new AdditionalInfo.fromJson(json['additionalInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['userName'] = this.userName;
    data['firstName'] = this.firstName;
    data['middleName'] = this.middleName;
    data['lastName'] = this.lastName;
    data['gender'] = this.gender;
    data['dateOfBirth'] = this.dateOfBirth;
    data['bloodGroup'] = this.bloodGroup;
    data['countryCode'] = this.countryCode;
    data['profilePicThumbnailUrl'] = this.profilePicThumbnailUrl;
    data['isTempUser'] = this.isTempUser;
    data['isVirtualUser'] = this.isVirtualUser;
    data['isMigrated'] = this.isMigrated;
    data['isClaimed'] = this.isClaimed;
    data['isIeUser'] = this.isIeUser;
    data['isEmailVerified'] = this.isEmailVerified;
    data['isCpUser'] = this.isCpUser;
    data['communicationPreferences'] = this.communicationPreferences;
    data['medicalPreferences'] = this.medicalPreferences;
    data['isSignedIn'] = this.isSignedIn;
    data['isActive'] = this.isActive;
    // data['createdBy'] = this.createdBy;
    // data['createdOn'] = this.createdOn;
    data['lastModifiedBy'] = this.lastModifiedBy;
    data['lastModifiedOn'] = this.lastModifiedOn;
    if (this.userAddressCollection3 != null) {
      data['userAddressCollection3'] =
          this.userAddressCollection3.map((v) => v.toJson()).toList();
    }
    if (this.userContactCollection3 != null) {
      data['userContactCollection3'] =
          this.userContactCollection3.map((v) => v.toJson()).toList();
    }
    if (this.userRoleCollection3 != null) {
      data['userRoleCollection3'] =
          this.userRoleCollection3.map((v) => v.toJson()).toList();
    }
    if (this.userRelationshipCollection != null) {
      data['userRelationshipCollection'] =
          this.userRelationshipCollection.map((v) => v.toJson()).toList();
    }
    if (this.additionalInfo != null) {
      data['additionalInfo'] = this.additionalInfo.toJson();
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
    if (json.containsKey('age')) if (json.containsKey('age') is String) {
      age = 0;
    } else {
      age = json['age'];
    }

    height = json['height'];
    weight = json['weight'];
    try {
      if (json.containsKey('language'))
        language = json['language'].cast<String>();
    } catch (e) {}

    if (json.containsKey('mrdNumber')) mrdNumber = json['mrdNumber'];
    if (json.containsKey('uhidNumber')) uhidNumber = json['uhidNumber'];
    if (json.containsKey('visitReason')) visitReason = json['visitReason'];
    if (json.containsKey('patientHistory'))
      patientHistory = json['patientHistory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['age'] = this.age;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['language'] = this.language;
    data['mrdNumber'] = this.mrdNumber;
    data['uhidNumber'] = this.uhidNumber;
    data['visitReason'] = this.visitReason;
    data['patientHistory'] = this.patientHistory;
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
        ? new AddressType.fromJson(json['phoneNumberType'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['phoneNumber'] = this.phoneNumber;
    data['isPrimary'] = this.isPrimary;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    data['email'] = this.email;
    if (this.phoneNumberType != null) {
      data['phoneNumberType'] = this.phoneNumberType.toJson();
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
    role = json['role'] != null ? new Role.fromJson(json['role']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    if (this.role != null) {
      data['role'] = this.role.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    data['roleCode'] = this.roleCode;
    data['description'] = this.description;
    data['isSystemRole'] = this.isSystemRole;
    data['isEnabled'] = this.isEnabled;
    return data;
  }
}
