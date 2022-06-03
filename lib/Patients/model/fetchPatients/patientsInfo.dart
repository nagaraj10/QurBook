import 'package:myfhb/Patients/constants/patients_parameters.dart'
    as parameters;
import 'package:myfhb/Patients/model/fetchPatients/additionalInfo.dart';

class PatientInfo {
  PatientInfo(
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
      this.createdBy,
      this.createdOn,
      this.lastModifiedBy,
      this.lastModifiedOn,
      this.additionalInfo,
      this.userContactCollection3,
      this.userRelationshipCollection});

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
  String createdBy;
  String createdOn;
  String lastModifiedBy;
  String lastModifiedOn;
  AdditionalInfo additionalInfo;
  List<UserContactCollection3> userContactCollection3;
  List<UserRelationshipCollection> userRelationshipCollection;

  PatientInfo.fromJson(Map<String, dynamic> json) {
    id = json[parameters.strId];
    name = json[parameters.strName];
    userName = json[parameters.strUserName];
    firstName = json[parameters.strFirstName];
    middleName = json[parameters.strMiddleName];
    lastName = json[parameters.strLastName];
    gender = json[parameters.strGender];
    dateOfBirth = json[parameters.strDateOfBirth];
    bloodGroup = json[parameters.strBloodGroup];
    countryCode = json[parameters.strCountryCode];
    profilePicThumbnailUrl = json[parameters.strProfilePicThumbnailUrl];
    isTempUser = json[parameters.strIsTempUser];
    isVirtualUser = json[parameters.strIsVirtualUser];
    isMigrated = json[parameters.strIsMigrated];
    isClaimed = json[parameters.strIsClaimed];
    isIeUser = json[parameters.strIsIeUser];
    isEmailVerified = json[parameters.strIsEmailVerified];
    isCpUser = json[parameters.strIsCpUser];
    communicationPreferences = json[parameters.strCommunicationPreferences];
    medicalPreferences = json[parameters.strMedicalPreferences];
    isSignedIn = json[parameters.strIsSignedIn];
    isActive = json[parameters.strIsActive];
    createdBy = json[parameters.strCreatedBy];
    createdOn = json[parameters.strCreatedOn];
    lastModifiedBy = json[parameters.strLastModifiedBy];
    lastModifiedOn = json[parameters.strLastModifiedOn];
    additionalInfo = json['additionalInfo'] != null
        ? new AdditionalInfo.fromJson(json['additionalInfo'])
        : null;
    if (json['userContactCollection3'] != null) {
      userContactCollection3 = new List<UserContactCollection3>();
      json['userContactCollection3'].forEach((v) {
        userContactCollection3.add(new UserContactCollection3.fromJson(v));
      });
    }
    if (json['userRelationshipCollection'] != null) {
      userRelationshipCollection = new List<UserRelationshipCollection>();
      json['userRelationshipCollection'].forEach((v) {
        userRelationshipCollection
            .add(new UserRelationshipCollection.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strId] = id;
    data[parameters.strName] = name;
    data[parameters.strUserName] = userName;
    data[parameters.strFirstName] = firstName;
    data[parameters.strMiddleName] = middleName;
    data[parameters.strLastName] = lastName;
    data[parameters.strGender] = gender;
    data[parameters.strDateOfBirth] = dateOfBirth;
    data[parameters.strBloodGroup] = bloodGroup;
    data[parameters.strCountryCode] = countryCode;
    data[parameters.strProfilePicThumbnailURL] = profilePicThumbnailUrl;
    data[parameters.strIsTempUser] = isTempUser;
    data[parameters.strIsVirtualUser] = isVirtualUser;
    data[parameters.strIsMigrated] = isMigrated;
    data[parameters.strIsClaimed] = isClaimed;
    data[parameters.strIsIeUser] = isIeUser;
    data[parameters.strIsEmailVerified] = isEmailVerified;
    data[parameters.strIsCpUser] = isCpUser;
    data[parameters.strCommunicationPreferences] = communicationPreferences;
    data[parameters.strMedicalPreferences] = medicalPreferences;
    data[parameters.strIsSignedIn] = isSignedIn;
    data[parameters.strIsActive] = isActive;
    data[parameters.strCreatedBy] = createdBy;
    data[parameters.strCreatedOn] = createdOn;
    data[parameters.strLastModifiedBy] = lastModifiedBy;
    data[parameters.strLastModifiedOn] = lastModifiedOn;
    if (this.additionalInfo != null) {
      data['additionalInfo'] = this.additionalInfo.toJson();
    }
    if (this.userContactCollection3 != null) {
      data['userContactCollection3'] =
          this.userContactCollection3.map((v) => v.toJson()).toList();
    }
    if (this.userRelationshipCollection != null) {
      data['userRelationshipCollection'] =
          this.userRelationshipCollection.map((v) => v.toJson()).toList();
    }
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

  UserContactCollection3(
      {this.id,
      this.phoneNumber,
      this.isPrimary,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn,
      this.email});

  UserContactCollection3.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phoneNumber = json['phoneNumber'];
    isPrimary = json['isPrimary'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    email = json['email'];
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
    return data;
  }
}

class UserRelationshipCollection {
  String id;
  String status;
  String nickName;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  Parent parent;

  UserRelationshipCollection(
      {this.id,
      this.status,
      this.nickName,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn,
      this.parent});

  UserRelationshipCollection.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    nickName = json['nickName'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    parent =
        json['parent'] != null ? new Parent.fromJson(json['parent']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['nickName'] = this.nickName;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    if (this.parent != null) {
      data['parent'] = this.parent.toJson();
    }
    return data;
  }
}

class Parent {
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
  String providerId;
  AdditionalInfo additionalInfo;
  List<UserContactCollection3> userContactCollection3;

  Parent(
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
      this.providerId,
      this.additionalInfo,
      this.userContactCollection3});

  Parent.fromJson(Map<String, dynamic> json) {
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
    providerId = json['providerId'];
    additionalInfo = json['additionalInfo'] != null
        ? new AdditionalInfo.fromJson(json['additionalInfo'])
        : null;
    if (json['userContactCollection3'] != null) {
      userContactCollection3 = new List<UserContactCollection3>();
      json['userContactCollection3'].forEach((v) {
        userContactCollection3.add(new UserContactCollection3.fromJson(v));
      });
    }
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
    data['profilePicUrl'] = this.profilePicUrl;
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
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['lastModifiedBy'] = this.lastModifiedBy;
    data['lastModifiedOn'] = this.lastModifiedOn;
    data['providerId'] = this.providerId;
    if (this.additionalInfo != null) {
      data['additionalInfo'] = this.additionalInfo.toJson();
    }
    if (this.userContactCollection3 != null) {
      data['userContactCollection3'] =
          this.userContactCollection3.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
