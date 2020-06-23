class FamilyMembersList {
  int status;
  bool success;
  String message;
  Response response;

  FamilyMembersList({this.status, this.success, this.message, this.response});

  FamilyMembersList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    message = json['message'];
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.response != null) {
      data['response'] = this.response.toJson();
    }
    return data;
  }
}

class Response {
  FamilyData data;

  Response({this.data});

  Response.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new FamilyData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class FamilyData {
  List<Sharedbyme> sharedbyme;
  List<SharedToMe> sharedToMe;
  VirtualUserParent virtualUserParent;

  FamilyData({this.sharedbyme, this.sharedToMe, this.virtualUserParent});

  FamilyData.fromJson(Map<String, dynamic> json) {
    if (json['sharedbyme'] != null) {
      sharedbyme = new List<Sharedbyme>();
      json['sharedbyme'].forEach((v) {
        sharedbyme.add(new Sharedbyme.fromJson(v));
      });
    }
    if (json['sharedToMe'] != null) {
      sharedToMe = new List<SharedToMe>();
      json['sharedToMe'].forEach((v) {
        sharedToMe.add(new SharedToMe.fromJson(v));
      });
    }
    virtualUserParent = json['virtualUserParent'] != null
        ? new VirtualUserParent.fromJson(json['virtualUserParent'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sharedbyme != null) {
      data['sharedbyme'] = this.sharedbyme.map((v) => v.toJson()).toList();
    }
    if (this.sharedToMe != null) {
      data['sharedToMe'] = this.sharedToMe.map((v) => v.toJson()).toList();
    }
    if (this.virtualUserParent != null) {
      data['virtualUserParent'] = this.virtualUserParent.toJson();
    }
    return data;
  }
}

class Sharedbyme {
  ProfileData profileData;
  LinkedData linkedData;

  Sharedbyme({this.profileData, this.linkedData});

  Sharedbyme.fromJson(Map<String, dynamic> json) {
    profileData = json['profileData'] != null
        ? new ProfileData.fromJson(json['profileData'])
        : null;
    linkedData = json['linkedData'] != null
        ? new LinkedData.fromJson(json['linkedData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.profileData != null) {
      data['profileData'] = this.profileData.toJson();
    }
    if (this.linkedData != null) {
      data['linkedData'] = this.linkedData.toJson();
    }
    return data;
  }
}

class SharedToMe {
  ProfileData profileData;
  LinkedData linkedData;

  SharedToMe({this.profileData, this.linkedData});

  SharedToMe.fromJson(Map<String, dynamic> json) {
    profileData = json['profileData'] != null
        ? new ProfileData.fromJson(json['profileData'])
        : null;
    linkedData = json['linkedData'] != null
        ? new LinkedData.fromJson(json['linkedData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.profileData != null) {
      data['profileData'] = this.profileData.toJson();
    }
    if (this.linkedData != null) {
      data['linkedData'] = this.linkedData.toJson();
    }
    return data;
  }
}

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
  QualifiedFullName qualifiedFullName;
  String bloodGroup;
  String dateOfBirth;
  bool isTokenRefresh;
  String countryCode;
  bool isEmailVerified;
  String status;

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
      this.qualifiedFullName,
      this.bloodGroup,
      this.dateOfBirth,
      this.isTokenRefresh,
      this.countryCode,
      this.isEmailVerified,
      this.status});

  ProfileData.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    id = json['id'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    createdOn = json['createdOn'];
    isActive = json['isActive'];
    lastModifiedOn = json['lastModifiedOn'];
    name = json['name'];
    gender = json['gender'];
    isTempUser = json['isTempUser'];
    isVirtualUser = json['isVirtualUser'];
    createdBy = json['createdBy'];
    profilePicThumbnail = json['profilePicThumbnail'] != null
        ? new ProfilePicThumbnail.fromJson(json['profilePicThumbnail'])
        : null;
    qualifiedFullName = json['qualifiedFullName'] != null
        ? new QualifiedFullName.fromJson(json['qualifiedFullName'])
        : null;
    bloodGroup = json['bloodGroup'];
    dateOfBirth = json['dateOfBirth'];
    isTokenRefresh = json['isTokenRefresh'];
    countryCode = json['countryCode'];
    isEmailVerified = json['isEmailVerified'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['id'] = this.id;
    data['phoneNumber'] = this.phoneNumber;
    data['email'] = this.email;
    data['createdOn'] = this.createdOn;
    data['isActive'] = this.isActive;
    data['lastModifiedOn'] = this.lastModifiedOn;
    data['name'] = this.name;
    data['gender'] = this.gender;
    data['isTempUser'] = this.isTempUser;
    data['isVirtualUser'] = this.isVirtualUser;
    data['createdBy'] = this.createdBy;
    if (this.profilePicThumbnail != null) {
      data['profilePicThumbnail'] = this.profilePicThumbnail.toJson();
    }
    data['bloodGroup'] = this.bloodGroup;
    data['dateOfBirth'] = this.dateOfBirth;
    data['isTokenRefresh'] = this.isTokenRefresh;
    data['countryCode'] = this.countryCode;
    data['isEmailVerified'] = this.isEmailVerified;
    data['status'] = this.status;
    if (this.qualifiedFullName != null) {
      data['qualifiedFullName'] = this.qualifiedFullName.toJson();
    }
    return data;
  }
}

class ProfilePicThumbnail {
  String type;
  List<int> data;

  ProfilePicThumbnail({this.type, this.data});

  ProfilePicThumbnail.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    data = json['data'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['data'] = this.data;
    return data;
  }
}

class LinkedData {
  String nickName;
  String customRoleId;
  String roleName;
  Null modeOfShare;

  LinkedData(
      {this.nickName, this.customRoleId, this.roleName, this.modeOfShare});

  LinkedData.fromJson(Map<String, dynamic> json) {
    nickName = json['nickName'];
    customRoleId = json['customRoleId'];
    roleName = json['roleName'];
    modeOfShare = json['modeOfShare'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nickName'] = this.nickName;
    data['customRoleId'] = this.customRoleId;
    data['roleName'] = this.roleName;
    data['modeOfShare'] = this.modeOfShare;
    return data;
  }
}

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
    id = json['id'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    createdOn = json['createdOn'];
    isActive = json['isActive'];
    lastModifiedOn = json['lastModifiedOn'];
    name = json['name'];
    gender = json['gender'];
    isTempUser = json['isTempUser'];
    isVirtualUser = json['isVirtualUser'];
    createdBy = json['createdBy'];
    profilePicThumbnail = json['profilePicThumbnail'] != null
        ? new ProfilePicThumbnail.fromJson(json['profilePicThumbnail'])
        : null;
    bloodGroup = json['bloodGroup'];
    dateOfBirth = json['dateOfBirth'];
    isTokenRefresh = json['isTokenRefresh'];
    countryCode = json['countryCode'];
    isEmailVerified = json['isEmailVerified'];
    status = json['status'];
    qualifiedFullName = json['qualifiedFullName'] != null
        ? new QualifiedFullName.fromJson(json['qualifiedFullName'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['phoneNumber'] = this.phoneNumber;
    data['email'] = this.email;
    data['createdOn'] = this.createdOn;
    data['isActive'] = this.isActive;
    data['lastModifiedOn'] = this.lastModifiedOn;
    data['name'] = this.name;
    data['gender'] = this.gender;
    data['isTempUser'] = this.isTempUser;
    data['isVirtualUser'] = this.isVirtualUser;
    data['createdBy'] = this.createdBy;
    if (this.profilePicThumbnail != null) {
      data['profilePicThumbnail'] = this.profilePicThumbnail.toJson();
    }
    data['bloodGroup'] = this.bloodGroup;
    data['dateOfBirth'] = this.dateOfBirth;
    data['isTokenRefresh'] = this.isTokenRefresh;
    data['countryCode'] = this.countryCode;
    data['isEmailVerified'] = this.isEmailVerified;
    data['status'] = this.status;
    if (this.qualifiedFullName != null) {
      data['qualifiedFullName'] = this.qualifiedFullName.toJson();
    }
    return data;
  }
}

class VirtualUserParent {
  String countryCode;
  String phoneNumber;
  String email;

  VirtualUserParent({this.countryCode, this.phoneNumber, this.email});

  VirtualUserParent.fromJson(Map<String, dynamic> json) {
    countryCode = json['countryCode'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['countryCode'] = this.countryCode;
    data['phoneNumber'] = this.phoneNumber;
    data['email'] = this.email;
    return data;
  }
}

class QualifiedFullName {
  String lastName;
  String firstName;
  String middleName;

  QualifiedFullName({this.lastName, this.firstName, this.middleName});

  QualifiedFullName.fromJson(Map<String, dynamic> json) {
    lastName = json['lastName'];
    firstName = json['firstName'];
    middleName = json['middleName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastName'] = this.lastName;
    data['firstName'] = this.firstName;
    data['middleName'] = this.middleName;
    return data;
  }
}
