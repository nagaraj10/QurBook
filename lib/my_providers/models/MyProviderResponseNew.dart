class MyProvidersResponse {
  bool isSuccess;
  String message;
  MyProvidersResponseData result;

  MyProvidersResponse({this.isSuccess, this.message, this.result});

  MyProvidersResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    result = json['result'] != null
        ? new MyProvidersResponseData.fromJson(json['result'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class MyProvidersResponseData {
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
  dynamic communicationPreferences;
  dynamic medicalPreferences;
  bool isSignedIn;
  bool isActive;
  String createdBy;
  String createdOn;
  String lastModifiedBy;
  String lastModifiedOn;
  List<Doctors> doctors;
  List<Hospitals> hospitals;
  List<dynamic> labs;
  List<dynamic> clinics;

  MyProvidersResponseData(
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
      this.doctors,
      this.hospitals,
      this.labs,
      this.clinics});

  MyProvidersResponseData.fromJson(Map<String, dynamic> json) {
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
    if (json['doctors'] != null) {
      doctors = new List<Doctors>();
      json['doctors'].forEach((v) {
        doctors.add(new Doctors.fromJson(v));
      });
    }
    if (json['hospitals'] != null) {
      hospitals = new List<Hospitals>();
      json['hospitals'].forEach((v) {
        hospitals.add(new Hospitals.fromJson(v));
      });
    }
    if (json['labs'] != null) {
      labs = List<dynamic>.from(json['labs'].map((x) => x));
    }
    if (json['clinics'] != null) {
      clinics = List<dynamic>.from(json['labs'].map((x) => x));
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
    if (this.doctors != null) {
      data['doctors'] = this.doctors.map((v) => v.toJson()).toList();
    }
    if (this.hospitals != null) {
      data['hospitals'] = this.hospitals.map((v) => v.toJson()).toList();
    }
    if (this.labs != null) {
      data['labs'] = this.labs.map((v) => v.toJson()).toList();
    }
    if (this.clinics != null) {
      data['clinics'] = this.clinics.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Doctors {
  String id;
  String specialization;
  bool isTelehealthEnabled;
  bool isMciVerified;
  bool isActive;
  String createdOn;
  String lastModifiedBy;
  String lastModifiedOn;
  User user;

  Doctors(
      {this.id,
      this.specialization,
      this.isTelehealthEnabled,
      this.isMciVerified,
      this.isActive,
      this.createdOn,
      this.lastModifiedBy,
      this.lastModifiedOn,
      this.user});

  Doctors.fromJson(Map<String, dynamic> json) {
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
  dynamic communicationPreferences;
  dynamic medicalPreferences;
  bool isSignedIn;
  bool isActive;
  String createdBy;
  String createdOn;
  String lastModifiedBy;
  dynamic lastModifiedOn;

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
      this.lastModifiedOn});

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
    if (json.containsKey('profilePicThumbnailUrl')) {
      profilePicThumbnailUrl = json['profilePicThumbnailUrl'];
    } else {
      profilePicThumbnailUrl = null;
    }
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
    return data;
  }
}

class Hospitals {
  String id;
  String name;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  HealthOrganizationType healthOrganizationType;

  Hospitals(
      {this.id,
      this.name,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn,
      this.healthOrganizationType});

  Hospitals.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    healthOrganizationType = json['healthOrganizationType'] != null
        ? new HealthOrganizationType.fromJson(json['healthOrganizationType'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    if (this.healthOrganizationType != null) {
      data['healthOrganizationType'] = this.healthOrganizationType.toJson();
    }
    return data;
  }
}

class HealthOrganizationType {
  String id;
  String code;
  String name;
  String description;
  int sortOrder;
  bool isActive;
  String createdBy;
  String createdOn;
  dynamic lastModifiedOn;

  HealthOrganizationType(
      {this.id,
      this.code,
      this.name,
      this.description,
      this.sortOrder,
      this.isActive,
      this.createdBy,
      this.createdOn,
      this.lastModifiedOn});

  HealthOrganizationType.fromJson(Map<String, dynamic> json) {
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
