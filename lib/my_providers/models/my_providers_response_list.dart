class MyProvidersResponseList {
  int status;
  bool success;
  String message;
  Response response;

  MyProvidersResponseList(
      {this.status, this.success, this.message, this.response});

  MyProvidersResponseList.fromJson(Map<String, dynamic> json) {
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
  MyProvidersData data;

  Response({this.data});

  Response.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null
        ? new MyProvidersData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class MyProvidersData {
  List<DoctorsModel> doctorsModel;
  List<LaboratoryModel> laboratoryModel;
  List<HospitalsModel> hospitalsModel;

  MyProvidersData(
      {this.doctorsModel, this.laboratoryModel, this.hospitalsModel});

  MyProvidersData.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> medicalJson = json['medicalPreferences'];

    if (medicalJson != null) {
      Map<String, dynamic> preferencesJson = medicalJson['preferences'];

      if (preferencesJson != null) {
        if (preferencesJson['doctorIds'] != null) {
          doctorsModel = new List<DoctorsModel>();
          preferencesJson['doctorIds'].forEach((v) {
            doctorsModel.add(new DoctorsModel.fromJson(v));
          });
        }
        if (preferencesJson['laboratoryIds'] != null) {
          laboratoryModel = new List<LaboratoryModel>();
          preferencesJson['laboratoryIds'].forEach((v) {
            laboratoryModel.add(new LaboratoryModel.fromJson(v));
          });
        }
        if (preferencesJson['hospitalIds'] != null) {
          hospitalsModel = new List<HospitalsModel>();
          preferencesJson['hospitalIds'].forEach((v) {
            hospitalsModel.add(new HospitalsModel.fromJson(v));
          });
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.doctorsModel != null) {
      data['doctorIds'] = this.doctorsModel.map((v) => v.toJson()).toList();
    }
    if (this.laboratoryModel != null) {
      data['laboratoryIds'] =
          this.laboratoryModel.map((v) => v.toJson()).toList();
    }
    if (this.hospitalsModel != null) {
      data['hospitalIds'] = this.hospitalsModel.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DoctorsModel {
  String id;
  String name;
  String addressLine1;
  String addressLine2;
  String website;
  String googleMapUrl;
  String phoneNumber1;
  String phoneNumber2;
  String phoneNumber3;
  String phoneNumber4;
  String email;
  String state;
  String city;
  bool isActive;
  String specialization;
  bool isUserDefined;
  String description;
  String createdBy;
  String lastModifiedOn;
  ProfilePic profilePic;
  ProfilePic profilePicThumbnail;
  bool isDefault;

  DoctorsModel(
      {this.id,
      this.name,
      this.addressLine1,
      this.addressLine2,
      this.website,
      this.googleMapUrl,
      this.phoneNumber1,
      this.phoneNumber2,
      this.phoneNumber3,
      this.phoneNumber4,
      this.email,
      this.state,
      this.city,
      this.isActive,
      this.specialization,
      this.isUserDefined,
      this.description,
      this.createdBy,
      this.lastModifiedOn,
      this.profilePic,
      this.profilePicThumbnail,
      this.isDefault});

  DoctorsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    addressLine1 = json['addressLine1'];
    addressLine2 = json['addressLine2'];
    website = json['website'];
    googleMapUrl = json['googleMapUrl'];
    phoneNumber1 = json['phoneNumber1'];
    phoneNumber2 = json['phoneNumber2'];
    phoneNumber3 = json['phoneNumber3'];
    phoneNumber4 = json['phoneNumber4'];
    email = json['email'];
    state = json['state'];
    city = json['city'];
    isActive = json['isActive'];
    specialization = json['specialization'];
    isUserDefined = json['isUserDefined'];
    description = json['description'];
    createdBy = json['createdBy'];
    lastModifiedOn = json['lastModifiedOn'];
    profilePic = json['profilePic'] != null
        ? new ProfilePic.fromJson(json['profilePic'])
        : null;
    profilePicThumbnail = json['profilePicThumbnail'] != null
        ? new ProfilePic.fromJson(json['profilePicThumbnail'])
        : null;
    isDefault = json['isDefault'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['addressLine1'] = this.addressLine1;
    data['addressLine2'] = this.addressLine2;
    data['website'] = this.website;
    data['googleMapUrl'] = this.googleMapUrl;
    data['phoneNumber1'] = this.phoneNumber1;
    data['phoneNumber2'] = this.phoneNumber2;
    data['phoneNumber3'] = this.phoneNumber3;
    data['phoneNumber4'] = this.phoneNumber4;
    data['email'] = this.email;
    data['state'] = this.state;
    data['city'] = this.city;
    data['isActive'] = this.isActive;
    data['specialization'] = this.specialization;
    data['isUserDefined'] = this.isUserDefined;
    data['description'] = this.description;
    data['createdBy'] = this.createdBy;
    data['lastModifiedOn'] = this.lastModifiedOn;
    if (this.profilePic != null) {
      data['profilePic'] = this.profilePic.toJson();
    }
    if (this.profilePicThumbnail != null) {
      data['profilePicThumbnail'] = this.profilePicThumbnail.toJson();
    }
    data['isDefault'] = this.isDefault;
    return data;
  }
}

class LaboratoryModel {
  String id;
  String createdBy;
  String name;
  Null logo;
  String latitude;
  String longitude;
  String logoThumbnail;
  int zipCode;
  String website;
  String city;
  String googleMapUrl;
  String branch;
  String addressLine1;
  String addressLine2;
  String state;
  String email;
  String description;
  String phoneNumber1;
  String phoneNumber2;
  String phoneNumber3;
  String phoneNumber4;
  bool isUserDefined;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  bool isDefault;

  LaboratoryModel(
      {this.id,
      this.createdBy,
      this.name,
      this.logo,
      this.latitude,
      this.longitude,
      this.logoThumbnail,
      this.zipCode,
      this.website,
      this.city,
      this.googleMapUrl,
      this.branch,
      this.addressLine1,
      this.addressLine2,
      this.state,
      this.email,
      this.description,
      this.phoneNumber1,
      this.phoneNumber2,
      this.phoneNumber3,
      this.phoneNumber4,
      this.isUserDefined,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn,
      this.isDefault});

  LaboratoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['createdBy'];
    name = json['name'];
    logo = json['logo'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    logoThumbnail = json['logoThumbnail'];
    zipCode = json['zipCode'];
    website = json['website'];
    city = json['city'];
    googleMapUrl = json['googleMapUrl'];
    branch = json['branch'];
    addressLine1 = json['addressLine1'];
    addressLine2 = json['addressLine2'];
    state = json['state'];
    email = json['email'];
    description = json['description'];
    phoneNumber1 = json['phoneNumber1'];
    phoneNumber2 = json['phoneNumber2'];
    phoneNumber3 = json['phoneNumber3'];
    phoneNumber4 = json['phoneNumber4'];
    isUserDefined = json['isUserDefined'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    isDefault = json['isDefault'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdBy'] = this.createdBy;
    data['name'] = this.name;
    data['logo'] = this.logo;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['logoThumbnail'] = this.logoThumbnail;
    data['zipCode'] = this.zipCode;
    data['website'] = this.website;
    data['city'] = this.city;
    data['googleMapUrl'] = this.googleMapUrl;
    data['branch'] = this.branch;
    data['addressLine1'] = this.addressLine1;
    data['addressLine2'] = this.addressLine2;
    data['state'] = this.state;
    data['email'] = this.email;
    data['description'] = this.description;
    data['phoneNumber1'] = this.phoneNumber1;
    data['phoneNumber2'] = this.phoneNumber2;
    data['phoneNumber3'] = this.phoneNumber3;
    data['phoneNumber4'] = this.phoneNumber4;
    data['isUserDefined'] = this.isUserDefined;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    data['isDefault'] = this.isDefault;
    return data;
  }
}

class HospitalsModel {
  String id;
  String createdBy;
  String name;
  String phoneNumber1;
  String phoneNumber2;
  String phoneNumber3;
  String phoneNumber4;
  String addressLine1;
  String addressLine2;
  String city;
  String state;
  String latitude;
  String longitude;
  String logo;
  String logoThumbnail;
  int zipCode;
  String website;
  String email;
  String googleMapUrl;
  String branch;
  bool isUserDefined;
  String description;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  bool isDefault;

  HospitalsModel(
      {this.id,
      this.createdBy,
      this.name,
      this.phoneNumber1,
      this.phoneNumber2,
      this.phoneNumber3,
      this.phoneNumber4,
      this.addressLine1,
      this.addressLine2,
      this.city,
      this.state,
      this.latitude,
      this.longitude,
      this.logo,
      this.logoThumbnail,
      this.zipCode,
      this.website,
      this.email,
      this.googleMapUrl,
      this.branch,
      this.isUserDefined,
      this.description,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn,
      this.isDefault});

  HospitalsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['createdBy'];
    name = json['name'];
    phoneNumber1 = json['phoneNumber1'];
    phoneNumber2 = json['phoneNumber2'];
    phoneNumber3 = json['phoneNumber3'];
    phoneNumber4 = json['phoneNumber4'];
    addressLine1 = json['addressLine1'];
    addressLine2 = json['addressLine2'];
    city = json['city'];
    state = json['state'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    logo = json['logo'];
    logoThumbnail = json['logoThumbnail'];
    zipCode = json['zipCode'];
    website = json['website'];
    email = json['email'];
    googleMapUrl = json['googleMapUrl'];
    branch = json['branch'];
    isUserDefined = json['isUserDefined'];
    description = json['description'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    isDefault = json['isDefault'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdBy'] = this.createdBy;
    data['name'] = this.name;
    data['phoneNumber1'] = this.phoneNumber1;
    data['phoneNumber2'] = this.phoneNumber2;
    data['phoneNumber3'] = this.phoneNumber3;
    data['phoneNumber4'] = this.phoneNumber4;
    data['addressLine1'] = this.addressLine1;
    data['addressLine2'] = this.addressLine2;
    data['city'] = this.city;
    data['state'] = this.state;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['logo'] = this.logo;
    data['logoThumbnail'] = this.logoThumbnail;
    data['zipCode'] = this.zipCode;
    data['website'] = this.website;
    data['email'] = this.email;
    data['googleMapUrl'] = this.googleMapUrl;
    data['branch'] = this.branch;
    data['isUserDefined'] = this.isUserDefined;
    data['description'] = this.description;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    data['isDefault'] = this.isDefault;
    return data;
  }
}

class ProfilePic {
  String type;
  List<int> data;

  ProfilePic({this.type, this.data});

  ProfilePic.fromJson(Map<String, dynamic> json) {
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
  Null bloodGroup;
  Null dateOfBirth;
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
