import 'package:myfhb/telehealth/features/MyProvider/model/ProfilePic.dart';

class TelehealthProviderModel {
  int status;
  bool success;
  String message;
  Response response;

  TelehealthProviderModel(
      {this.status, this.success, this.message, this.response});

  TelehealthProviderModel.fromJson(Map<String, dynamic> json) {
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
  int count;
  MyProvidersData data;

  Response({this.count, this.data});

  Response.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    data = json['data'] != null ? new MyProvidersData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class MyProvidersData {
  MedicalPreferences medicalPreferences;

  MyProvidersData({this.medicalPreferences});

  MyProvidersData.fromJson(Map<String, dynamic> json) {
    medicalPreferences = json['medicalPreferences'] != null
        ? new MedicalPreferences.fromJson(json['medicalPreferences'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.medicalPreferences != null) {
      data['medicalPreferences'] = this.medicalPreferences.toJson();
    }
    return data;
  }
}

class MedicalPreferences {
  Preferences preferences;

  MedicalPreferences({this.preferences});

  MedicalPreferences.fromJson(Map<String, dynamic> json) {
    preferences = json['preferences'] != null
        ? new Preferences.fromJson(json['preferences'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.preferences != null) {
      data['preferences'] = this.preferences.toJson();
    }
    return data;
  }
}

class Preferences {
  List<DoctorIds> doctorIds;
  List<HospitalsIds> hospitalIds;
  List<LaboratoryIds> laboratoryIds;

  Preferences({this.doctorIds, this.hospitalIds, this.laboratoryIds});

  Preferences.fromJson(Map<String, dynamic> json) {
    if (json['doctorIds'] != null) {
      doctorIds = new List<DoctorIds>();
      json['doctorIds'].forEach((v) {
        doctorIds.add(new DoctorIds.fromJson(v));
      });
    }
    if (json['hospitalIds'] != null) {
      hospitalIds = new List<HospitalsIds>();
      json['hospitalIds'].forEach((v) {
        hospitalIds.add(new HospitalsIds.fromJson(v));
      });
    }
    if (json['laboratoryIds'] != null) {
      laboratoryIds = new List<LaboratoryIds>();
      json['laboratoryIds'].forEach((v) {
        laboratoryIds.add(new LaboratoryIds.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.doctorIds != null) {
      data['doctorIds'] = this.doctorIds.map((v) => v.toJson()).toList();
    }
    if (this.hospitalIds != null) {
      data['hospitalIds'] = this.hospitalIds.map((v) => v.toJson()).toList();
    }
    if (this.laboratoryIds != null) {
      data['laboratoryIds'] =
          this.laboratoryIds.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DoctorIds {
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
  String firstName;
  String lastName;
  String genderId;
  String dob;
  String cityId;
  String stateId;
  String pinCode;
  String aboutMe;
  String lastModifiedBy;
  bool isTelehealthEnabled;
  bool isMCIVerified;
  bool isDefault;
  String doctorPatientMappingId;

  DoctorIds(
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
      this.firstName,
      this.lastName,
      this.genderId,
      this.dob,
      this.cityId,
      this.stateId,
      this.pinCode,
      this.aboutMe,
      this.lastModifiedBy,
      this.isTelehealthEnabled,
      this.isMCIVerified,
      this.isDefault,
      this.doctorPatientMappingId});

  DoctorIds.fromJson(Map<String, dynamic> json) {
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
    firstName = json['firstName'];
    lastName = json['lastName'];
    genderId = json['genderId'];
    dob = json['dob'];
    cityId = json['cityId'];
    stateId = json['stateId'];
    pinCode = json['pinCode'];
    aboutMe = json['aboutMe'];
    lastModifiedBy = json['lastModifiedBy'];
    isTelehealthEnabled = json['isTelehealthEnabled'];
    isMCIVerified = json['isMCIVerified'];
    isDefault = json['isDefault'];
    doctorPatientMappingId = json['doctorPatientMappingId'];
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
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['genderId'] = this.genderId;
    data['dob'] = this.dob;
    data['cityId'] = this.cityId;
    data['stateId'] = this.stateId;
    data['pinCode'] = this.pinCode;
    data['aboutMe'] = this.aboutMe;
    data['lastModifiedBy'] = this.lastModifiedBy;
    data['isTelehealthEnabled'] = this.isTelehealthEnabled;
    data['isMCIVerified'] = this.isMCIVerified;
    data['isDefault'] = this.isDefault;
    data['doctorPatientMappingId'] = this.doctorPatientMappingId;
    return data;
  }
}



class HospitalsIds {
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

  HospitalsIds(
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

  HospitalsIds.fromJson(Map<String, dynamic> json) {
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




class LaboratoryIds {
  String id;
  String createdBy;
  String name;
  String logo;
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
  String entityCode;
  String goFhbCode;
  bool isDefault;
  String labPatientMappingId;

  LaboratoryIds(
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
      this.entityCode,
      this.goFhbCode,
      this.isDefault,
      this.labPatientMappingId});

  LaboratoryIds.fromJson(Map<String, dynamic> json) {
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
    entityCode = json['entityCode'];
    goFhbCode = json['goFhbCode'];
    isDefault = json['isDefault'];
    labPatientMappingId = json['labPatientMappingId'];
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
    data['entityCode'] = this.entityCode;
    data['goFhbCode'] = this.goFhbCode;
    data['isDefault'] = this.isDefault;
    data['labPatientMappingId'] = this.labPatientMappingId;
    return data;
  }
}