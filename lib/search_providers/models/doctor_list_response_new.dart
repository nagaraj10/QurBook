class DoctorsSearchListResponse {
  bool isSuccess;
  String message;
  List<DoctorsListResult> result;

  DoctorsSearchListResponse({this.isSuccess, this.message, this.result});

  DoctorsSearchListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    if (json['result'] != null) {
      result = new List<DoctorsListResult>();
      json['result'].forEach((v) {
        result.add(new DoctorsListResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DoctorsListResult {
  String id;
  String specialization;
  bool isTelehealthEnabled;
  bool isMciVerified;
  bool isActive;
  String createdOn;
  Null lastModifiedBy;
  Null lastModifiedOn;
  User user;

  DoctorsListResult(
      {this.id,
      this.specialization,
      this.isTelehealthEnabled,
      this.isMciVerified,
      this.isActive,
      this.createdOn,
      this.lastModifiedBy,
      this.lastModifiedOn,
      this.user});

  DoctorsListResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    specialization = json['specialization'];
    isTelehealthEnabled = json['isTelehealthEnabled'];
    isMciVerified = json['isMciVerified'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedBy = json['lastModifiedBy'];
    lastModifiedOn = json['lastModifiedOn'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['specialization'] = this.specialization;
    data['isTelehealthEnabled'] = this.isTelehealthEnabled;
    data['isMciVerified'] = this.isMciVerified;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedBy'] = this.lastModifiedBy;
    data['lastModifiedOn'] = this.lastModifiedOn;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class User {
  String id;
  String name;
  Null userName;
  String firstName;
  Null middleName;
  String lastName;
  String gender;
  Null dateOfBirth;
  Null bloodGroup;
  Null countryCode;
  String profilePicThumbnailUrl;
  Null isTempUser;
  Null isVirtualUser;
  Null isMigrated;
  Null isClaimed;
  bool isIeUser;
  Null isEmailVerified;
  bool isCpUser;
  Null communicationPreferences;
  Null medicalPreferences;
  bool isSignedIn;
  bool isActive;
  String createdBy;
  String createdOn;
  Null lastModifiedBy;
  Null lastModifiedOn;
  List<UserContactCollection3> userContactCollection3;
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
      userContactCollection3 = new List<UserContactCollection3>();
      json['userContactCollection3'].forEach((v) {
        userContactCollection3.add(new UserContactCollection3.fromJson(v));
      });
    }
    if (json['userAddressCollection3'] != null) {
      userAddressCollection3 = new List<UserAddressCollection3>();
      json['userAddressCollection3'].forEach((v) {
        userAddressCollection3.add(new UserAddressCollection3.fromJson(v));
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
    if (this.userContactCollection3 != null) {
      data['userContactCollection3'] =
          this.userContactCollection3.map((v) => v.toJson()).toList();
    }
    if (this.userAddressCollection3 != null) {
      data['userAddressCollection3'] =
          this.userAddressCollection3.map((v) => v.toJson()).toList();
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
  Null lastModifiedOn;
  String email;
  PhoneNumberType phoneNumberType;

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
        ? new PhoneNumberType.fromJson(json['phoneNumberType'])
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

class PhoneNumberType {
  String id;
  String code;
  String name;
  String description;
  int sortOrder;
  bool isActive;
  String createdBy;
  String createdOn;
  Null lastModifiedOn;

  PhoneNumberType(
      {this.id,
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
}

class UserAddressCollection3 {
  String id;
  String addressLine1;
  String addressLine2;
  String pincode;
  bool isPrimary;
  bool isActive;
  String createdOn;
  Null lastModifiedOn;
  DoctorsState state;
  City city;

  UserAddressCollection3(
      {this.id,
      this.addressLine1,
      this.addressLine2,
      this.pincode,
      this.isPrimary,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn,
      this.state,
      this.city});

  UserAddressCollection3.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addressLine1 = json['addressLine1'];
    addressLine2 = json['addressLine2'];
    pincode = json['pincode'];
    isPrimary = json['isPrimary'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    state =
        json['state'] != null ? new DoctorsState.fromJson(json['state']) : null;
    city = json['city'] != null ? new City.fromJson(json['city']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['addressLine1'] = this.addressLine1;
    data['addressLine2'] = this.addressLine2;
    data['pincode'] = this.pincode;
    data['isPrimary'] = this.isPrimary;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    if (this.state != null) {
      data['state'] = this.state.toJson();
    }
    if (this.city != null) {
      data['city'] = this.city.toJson();
    }
    return data;
  }
}

class DoctorsState {
  String id;
  String name;
  String countryCode;
  bool isActive;
  String createdOn;
  Null lastModifiedOn;

  DoctorsState(
      {this.id,
      this.name,
      this.countryCode,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn});

  DoctorsState.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    countryCode = json['countryCode'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['countryCode'] = this.countryCode;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    return data;
  }
}

class City {
  String id;
  String name;
  bool isActive;
  String createdOn;
  Null lastModifiedOn;

  City(
      {this.id, this.name, this.isActive, this.createdOn, this.lastModifiedOn});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    return data;
  }
}
