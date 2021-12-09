import 'relationships.dart';
import '../../src/model/user/AddressTypeModel.dart';
import '../../src/model/user/UserAddressCollection.dart';

class FamilyMembers {
  bool isSuccess;
  String message;
  FamilyMemberResult result;

  FamilyMembers({this.isSuccess, this.message, this.result});

  FamilyMembers.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    result = json['result'] != null
        ? FamilyMemberResult.fromJson(json['result'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['isSuccess'] = isSuccess;
    data['message'] = message;
    if (result != null) {
      data['result'] = result.toJson();
    }
    return data;
  }
}

class FamilyMemberResult {
  List<SharedByUsers> sharedByUsers;
  List<SharedToUsers> sharedToUsers;
  VirtualUserParent virtualUserParent;

  FamilyMemberResult(
      {this.sharedByUsers, this.sharedToUsers, this.virtualUserParent});

  FamilyMemberResult.fromJson(Map<String, dynamic> json) {
    if (json['sharedByUsers'] != null) {
      sharedByUsers = List<SharedByUsers>();
      json['sharedByUsers'].forEach((v) {
        sharedByUsers.add(SharedByUsers.fromJson(v));
      });
    }
    if (json['sharedToUsers'] != null) {
      sharedToUsers = List<SharedToUsers>();
      json['sharedToUsers'].forEach((v) {
        sharedToUsers.add(SharedToUsers.fromJson(v));
      });
    }
    try {
      virtualUserParent = json['virtualUserParent'] != null
          ? VirtualUserParent.fromJson(json['virtualUserParent'])
          : null;
    } catch (e) {}
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (sharedByUsers != null) {
      data['sharedByUsers'] =
          sharedByUsers.map((v) => v.toJson()).toList();
    }
    if (sharedToUsers != null) {
      data['sharedToUsers'] =
          sharedToUsers.map((v) => v.toJson()).toList();
    }
    if (virtualUserParent != null) {
      data['virtualUserParent'] = virtualUserParent.toJson();
    }
    return data;
  }
}

class SharedByUsers {
  String id;
  String status;
  String nickName;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  RelationsShipModel relationship;
  Child child;

  SharedByUsers({this.id,
    this.status,
    this.nickName,
    this.isActive,
    this.createdOn,
    this.lastModifiedOn,
    this.relationship,
    this.child});

  SharedByUsers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    nickName = json['nickName'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    relationship = json['relationship'] != null
        ? RelationsShipModel.fromJson(json['relationship'])
        : null;
    child = json['child'] != null ? Child.fromJson(json['child']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['status'] = status;
    data['nickName'] = nickName;
    data['isActive'] = isActive;
    data['createdOn'] = createdOn;
    data['lastModifiedOn'] = lastModifiedOn;
    if (relationship != null) {
      data['relationship'] = relationship.toJson();
    }
    if (child != null) {
      data['child'] = child.toJson();
    }
    return data;
  }
}

/* class Relationship {
  String id;
  String code;
  String name;
  String description;
  String sortOrder;
  bool isActive;
  String createdBy;
  String createdOn;
  String lastModifiedOn;

  Relationship(
      {this.id,
      this.code,
      this.name,
      this.description,
      this.sortOrder,
      this.isActive,
      this.createdBy,
      this.createdOn,
      this.lastModifiedOn});

  Relationship.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    description = json['description'];
    sortOrder = json['sortOrder'];
    isActive = json['isActive'];
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['description'] = this.description;
    data['sortOrder'] = this.sortOrder;
    data['isActive'] = this.isActive;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    return data;
  }
} */

class Child {
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
  String membershipOfferedBy;
  List<UserContactCollectionFamily> userContactCollection3;
  List<UserRoleCollection3> userRoleCollection3;
  List<UserAddressCollection3> userAddressCollection3;
  AdditionalInfo additionalInfo;

  Child({
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
    this.createdBy,
    this.createdOn,
    this.lastModifiedBy,
    this.lastModifiedOn,
    this.userContactCollection3,
    this.userRoleCollection3,
    this.userAddressCollection3,
    this.additionalInfo, this.membershipOfferedBy
  });

  Child.fromJson(Map<String, dynamic> json) {
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
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    lastModifiedBy = json['lastModifiedBy'];
    if (json.containsKey('membershipOfferedBy')) {
      membershipOfferedBy = json['membershipOfferedBy'];
    }
    lastModifiedOn = json['lastModifiedOn'];
    if (json['userContactCollection3'] != null) {
      userContactCollection3 = <UserContactCollectionFamily>[];
      json['userContactCollection3'].forEach((v) {
        userContactCollection3.add(UserContactCollectionFamily.fromJson(v));
      });
    }
    if (json['userRoleCollection3'] != null) {
      userRoleCollection3 = <UserRoleCollection3>[];
      json['userRoleCollection3'].forEach((v) {
        userRoleCollection3.add(UserRoleCollection3.fromJson(v));
      });
    }
    if (json['userAddressCollection3'] != null) {
      userAddressCollection3 = List<UserAddressCollection3>();
      json['userAddressCollection3'].forEach((v) {
        userAddressCollection3.add(UserAddressCollection3.fromJson(v));
      });
    }
    additionalInfo = json['additionalInfo'] != null
        ? AdditionalInfo.fromJson(json['additionalInfo'])
        : null;
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
    data['membershipOfferedBy'] = membershipOfferedBy;
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
    if (additionalInfo != null) {
      data['additionalInfo'] = additionalInfo.toJson();
    }
    return data;
  }
}

class AdditionalInfo {
  String height;
  String weight;

  AdditionalInfo({this.height, this.weight});

  AdditionalInfo.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    weight = json['weight'];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['height'] = height;
    data['weight'] = weight;
    return data;
  }
}

/* class UserAddressCollection3 {
  //String id;
  String addressLine1;
  String addressLine2;
  String pincode;
  bool isPrimary;
  bool isActive;
  String createdOn;
  String createdBy;
  String lastModifiedOn;
  AddressType addressType;
  City city;
  State state;

  UserAddressCollection3(
      {
        //this.id,
      this.addressLine1,
      this.addressLine2,
      this.pincode,
      this.isPrimary,
      this.isActive,
      this.createdOn,
      this.createdBy,
      this.lastModifiedOn,
      this.addressType,
      this.city,
      this.state});

  UserAddressCollection3.fromJson(Map<String, dynamic> json) {
    //id = json['id'];
    addressLine1 = json['addressLine1'];
    addressLine2 = json['addressLine2'];
    pincode = json['pincode'];
    isPrimary = json['isPrimary'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    createdBy = json['createdBy'];
    lastModifiedOn = json['lastModifiedOn'];
    addressType = json['addressType'];
    city = json['city'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    //data['id'] = this.id;
    data['addressLine1'] = this.addressLine1;
    data['addressLine2'] = this.addressLine2;
    data['pincode'] = this.pincode;
    data['isPrimary'] = this.isPrimary;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['createdBy'] = this.createdBy;
    data['lastModifiedOn'] = this.lastModifiedOn;
    data['addressType'] = this.addressType;
    data['city'] = this.city;
    data['state'] = this.state;
    return data;
  }
} */

class UserContactCollectionFamily {
  String id;
  String phoneNumber;
  bool isPrimary;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  String email;

  UserContactCollectionFamily({this.id,
    this.phoneNumber,
    this.isPrimary,
    this.isActive,
    this.createdOn,
    this.lastModifiedOn,
    this.email});

  UserContactCollectionFamily.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phoneNumber = json['phoneNumber'];
    isPrimary = json['isPrimary'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    email = json['email'];
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
    return data;
  }
}

class PhoneNumberType {
  String id;
  String code;
  String name;
  String description;
  int sortOrder;
  bool isActive;
  String createdBy;
  String createdOn;
  String lastModifiedOn;

  PhoneNumberType({this.id,
    this.code,
    this.name,
    this.description,
    this.sortOrder,
    this.isActive,
    this.createdBy,
    this.createdOn,
    this.lastModifiedOn});

  PhoneNumberType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    description = json['description'];
    sortOrder = json['sortOrder'];
    isActive = json['isActive'];
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['code'] = code;
    data['name'] = name;
    data['description'] = description;
    data['sortOrder'] = sortOrder;
    data['isActive'] = isActive;
    data['createdBy'] = createdBy;
    data['createdOn'] = createdOn;
    data['lastModifiedOn'] = lastModifiedOn;
    return data;
  }
}

class UserRoleCollection3 {
  String id;
  bool isActive;
  String createdOn;
  String lastModifiedOn;

  UserRoleCollection3(
      {this.id, this.isActive, this.createdOn, this.lastModifiedOn});

  UserRoleCollection3.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['isActive'] = isActive;
    data['createdOn'] = createdOn;
    data['lastModifiedOn'] = lastModifiedOn;
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

  Role({this.id,
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

class SharedToUsers {
  String id;
  String status;
  String nickName;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  RelationsShipModel relationship;
  Parent parent;

  SharedToUsers({this.id,
    this.status,
    this.nickName,
    this.isActive,
    this.createdOn,
    this.lastModifiedOn,
    this.relationship,
    this.parent});

  SharedToUsers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    nickName = json['nickName'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    relationship = json['relationship'] != null
        ? RelationsShipModel.fromJson(json['relationship'])
        : null;
    parent =
    json['parent'] != null ? Parent.fromJson(json['parent']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['status'] = status;
    data['nickName'] = nickName;
    data['isActive'] = isActive;
    data['createdOn'] = createdOn;
    data['lastModifiedOn'] = lastModifiedOn;
    if (relationship != null) {
      data['relationship'] = relationship.toJson();
    }
    if (parent != null) {
      data['parent'] = parent.toJson();
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

  Parent({this.id,
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
    this.lastModifiedOn});

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
    return data;
  }
}

class VirtualUserParent {
  String countryCode;
  String email;
  String phoneNumber;

  VirtualUserParent({this.countryCode, this.email, this.phoneNumber});

  VirtualUserParent.fromJson(Map<String, dynamic> json) {
    countryCode = json['countryCode'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['countryCode'] = countryCode;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    return data;
  }
}
