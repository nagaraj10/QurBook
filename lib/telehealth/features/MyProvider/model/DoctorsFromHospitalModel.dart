import 'package:myfhb/my_providers/models/UserAddressCollection.dart';

class DoctorListFromHospitalModel {
  bool isSuccess;
  List<ResultFromHospital> result;

  DoctorListFromHospitalModel({this.isSuccess, this.result});

  DoctorListFromHospitalModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['result'] != null) {
      result = new List<ResultFromHospital>();
      json['result'].forEach((v) {
        result.add(new ResultFromHospital.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ResultFromHospital {
  String id;
  String startDate;
  String endDate;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  DoctorFromHos doctor;
  List<DoctorFeeCollection> doctorFeeCollection;
  HealthOrganization healthOrganization;
  //List<Null> doctorSessionCollection;

  ResultFromHospital(
      {this.id,
        this.startDate,
        this.endDate,
        this.isActive,
        this.createdOn,
        this.lastModifiedOn,
        this.doctor,
        this.doctorFeeCollection,
        this.healthOrganization,});

  ResultFromHospital.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    doctor =
    json['doctor'] != null ? new DoctorFromHos.fromJson(json['doctor']) : null;
    if (json['doctorFeeCollection'] != null) {
      doctorFeeCollection = new List<DoctorFeeCollection>();
      json['doctorFeeCollection'].forEach((v) {
        doctorFeeCollection.add(new DoctorFeeCollection.fromJson(v));
      });
    }
    healthOrganization = json['healthOrganization'] != null
        ? new HealthOrganization.fromJson(json['healthOrganization'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    if (this.doctor != null) {
      data['doctor'] = this.doctor.toJson();
    }
    if (this.doctorFeeCollection != null) {
      data['doctorFeeCollection'] =
          this.doctorFeeCollection.map((v) => v.toJson()).toList();
    }
    if (this.healthOrganization != null) {
      data['healthOrganization'] = this.healthOrganization.toJson();
    }
    return data;
  }
}

class DoctorFromHos {
  String id;
  String specialization;
  bool isTelehealthEnabled;
  bool isMciVerified;
  bool isActive;
  bool isWelcomeMailSent;
  String createdOn;
  String lastModifiedBy;
  String lastModifiedOn;
  UserResponse user;
  List<DoctorLanguageCollection> doctorLanguageCollection;
  List<DoctorProfessionalDetailCollection> doctorProfessionalDetailCollection;

  DoctorFromHos(
      {this.id,
        this.specialization,
        this.isTelehealthEnabled,
        this.isMciVerified,
        this.isActive,
        this.isWelcomeMailSent,
        this.createdOn,
        this.lastModifiedBy,
        this.lastModifiedOn,
        this.user,
        this.doctorLanguageCollection,
        this.doctorProfessionalDetailCollection});

  DoctorFromHos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    specialization = json['specialization'];
    isTelehealthEnabled = json['isTelehealthEnabled'];
    isMciVerified = json['isMciVerified'];
    isActive = json['isActive'];
    isWelcomeMailSent = json['isWelcomeMailSent'];
    createdOn = json['createdOn'];
    lastModifiedBy = json['lastModifiedBy'];
    lastModifiedOn = json['lastModifiedOn'];
    user = json['user'] != null ? new UserResponse.fromJson(json['user']) : null;
    if (json['doctorLanguageCollection'] != null) {
      doctorLanguageCollection = new List<DoctorLanguageCollection>();
      json['doctorLanguageCollection'].forEach((v) {
        doctorLanguageCollection.add(new DoctorLanguageCollection.fromJson(v));
      });
    }
    if (json['doctorProfessionalDetailCollection'] != null) {
      doctorProfessionalDetailCollection =
      new List<DoctorProfessionalDetailCollection>();
      json['doctorProfessionalDetailCollection'].forEach((v) {
        doctorProfessionalDetailCollection
            .add(new DoctorProfessionalDetailCollection.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['specialization'] = this.specialization;
    data['isTelehealthEnabled'] = this.isTelehealthEnabled;
    data['isMciVerified'] = this.isMciVerified;
    data['isActive'] = this.isActive;
    data['isWelcomeMailSent'] = this.isWelcomeMailSent;
    data['createdOn'] = this.createdOn;
    data['lastModifiedBy'] = this.lastModifiedBy;
    data['lastModifiedOn'] = this.lastModifiedOn;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.doctorLanguageCollection != null) {
      data['doctorLanguageCollection'] =
          this.doctorLanguageCollection.map((v) => v.toJson()).toList();
    }
    if (this.doctorProfessionalDetailCollection != null) {
      data['doctorProfessionalDetailCollection'] = this
          .doctorProfessionalDetailCollection
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class UserResponse {
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
  String providerId;
  List<UserAddressCollection3> userAddressCollection3;
  List<UserContactCollection3> userContactCollection3;

  UserResponse(
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
        this.providerId,
        this.userAddressCollection3,
        this.userContactCollection3});

  UserResponse.fromJson(Map<String, dynamic> json) {
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
    providerId = json['providerId'];
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
    data['providerId'] = this.providerId;
    if (this.userAddressCollection3 != null) {
      data['userAddressCollection3'] =
          this.userAddressCollection3.map((v) => v.toJson()).toList();
    }
    if (this.userContactCollection3 != null) {
      data['userContactCollection3'] =
          this.userContactCollection3.map((v) => v.toJson()).toList();
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

class DoctorLanguageCollection {
  String id;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  Language language;

  DoctorLanguageCollection(
      {this.id,
        this.isActive,
        this.createdOn,
        this.lastModifiedOn,
        this.language});

  DoctorLanguageCollection.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    language = json['language'] != null
        ? new Language.fromJson(json['language'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    if (this.language != null) {
      data['language'] = this.language.toJson();
    }
    return data;
  }
}

class Language {
  String id;
  String code;
  String name;
  String description;
  int sortOrder;
  bool isActive;
  String createdBy;
  String createdOn;
  String lastModifiedOn;

  Language(
      {this.id,
        this.code,
        this.name,
        this.description,
        this.sortOrder,
        this.isActive,
        this.createdBy,
        this.createdOn,
        this.lastModifiedOn});

  Language.fromJson(Map<String, dynamic> json) {
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

class DoctorProfessionalDetailCollection {
  String id;
  QualificationInfo qualificationInfo;
  MedicalCouncilInfo medicalCouncilInfo;
  Degree specialty;
  List<ClinicName> clinicName;
  String aboutMe;
  bool isActive;
  String createdOn;
  String lastModifiedOn;

  DoctorProfessionalDetailCollection(
      {this.id,
        this.qualificationInfo,
        this.medicalCouncilInfo,
        this.specialty,
        this.clinicName,
        this.aboutMe,
        this.isActive,
        this.createdOn,
        this.lastModifiedOn});

  DoctorProfessionalDetailCollection.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    qualificationInfo = json['qualificationInfo'] != null
        ? new QualificationInfo.fromJson(json['qualificationInfo'])
        : null;
    medicalCouncilInfo = json['medicalCouncilInfo'] != null
        ? new MedicalCouncilInfo.fromJson(json['medicalCouncilInfo'])
        : null;
    specialty = json['specialty'] != null
        ? new Degree.fromJson(json['specialty'])
        : null;
    if (json['clinicName'] != null) {
      clinicName = new List<ClinicName>();
      json['clinicName'].forEach((v) {
        clinicName.add(new ClinicName.fromJson(v));
      });
    }
    aboutMe = json['aboutMe'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.qualificationInfo != null) {
      data['qualificationInfo'] = this.qualificationInfo.toJson();
    }
    if (this.medicalCouncilInfo != null) {
      data['medicalCouncilInfo'] = this.medicalCouncilInfo.toJson();
    }
    if (this.specialty != null) {
      data['specialty'] = this.specialty.toJson();
    }
    if (this.clinicName != null) {
      data['clinicName'] = this.clinicName.map((v) => v.toJson()).toList();
    }
    data['aboutMe'] = this.aboutMe;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    return data;
  }
}

class QualificationInfo {
  List<Degree> degree;
  List<Degree> university;

  QualificationInfo({this.degree, this.university});

  QualificationInfo.fromJson(Map<String, dynamic> json) {
    if (json['degree'] != null) {
      degree = new List<Degree>();
      json['degree'].forEach((v) {
        degree.add(new Degree.fromJson(v));
      });
    }
    if (json['university'] != null) {
      university = new List<Degree>();
      json['university'].forEach((v) {
        university.add(new Degree.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.degree != null) {
      data['degree'] = this.degree.map((v) => v.toJson()).toList();
    }
    if (this.university != null) {
      data['university'] = this.university.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Degree {
  String id;
  String name;

  Degree({this.id, this.name});

  Degree.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class MedicalCouncilInfo {
  String id;
  String mciNumber;

  MedicalCouncilInfo({this.id, this.mciNumber});

  MedicalCouncilInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mciNumber = json['mciNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mciNumber'] = this.mciNumber;
    return data;
  }
}

class ClinicName {
  String id;
  String name;

  ClinicName({this.id, this.name});

  ClinicName.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class DoctorFeeCollection {
  String id;
  String fee;
  String followupValue;
  String followupIn;
  String effectiveFromDate;
  String effectiveToDate;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  FeeType feeType;

  DoctorFeeCollection(
      {this.id,
        this.fee,
        this.followupValue,
        this.followupIn,
        this.effectiveFromDate,
        this.effectiveToDate,
        this.isActive,
        this.createdOn,
        this.lastModifiedOn,
        this.feeType});

  DoctorFeeCollection.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fee = json['fee'];
    followupValue = json['followupValue'];
    followupIn = json['followupIn'];
    effectiveFromDate = json['effectiveFromDate'];
    effectiveToDate = json['effectiveToDate'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    feeType =
    json['feeType'] != null ? new FeeType.fromJson(json['feeType']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fee'] = this.fee;
    data['followupValue'] = this.followupValue;
    data['followupIn'] = this.followupIn;
    data['effectiveFromDate'] = this.effectiveFromDate;
    data['effectiveToDate'] = this.effectiveToDate;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    if (this.feeType != null) {
      data['feeType'] = this.feeType.toJson();
    }
    return data;
  }
}

class FeeType {
  String id;
  String code;
  String name;
  String description;
  int sortOrder;
  bool isActive;
  String createdBy;
  String createdOn;
  String lastModifiedOn;

  FeeType(
      {this.id,
        this.code,
        this.name,
        this.description,
        this.sortOrder,
        this.isActive,
        this.createdBy,
        this.createdOn,
        this.lastModifiedOn});

  FeeType.fromJson(Map<String, dynamic> json) {
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

class HealthOrganization {
  String id;
  String name;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  String domainUrl;

  HealthOrganization(
      {this.id,
        this.name,
        this.isActive,
        this.createdOn,
        this.lastModifiedOn,
        this.domainUrl});

  HealthOrganization.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    domainUrl = json['domainUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    data['domainUrl'] = this.domainUrl;
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
  String lastModifiedOn;
  City city;
  State state;

  UserAddressCollection3({this.id, this.addressLine1, this.addressLine2, this.pincode, this.isPrimary, this.isActive, this.createdOn, this.lastModifiedOn, this.city, this.state});

  UserAddressCollection3.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addressLine1 = json['addressLine1'];
    addressLine2 = json['addressLine2'];
    pincode = json['pincode'];
    isPrimary = json['isPrimary'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    city = json['city'] != null ? new City.fromJson(json['city']) : null;
    state = json['state'] != null ? new State.fromJson(json['state']) : null;
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
    if (this.city != null) {
      data['city'] = this.city.toJson();
    }
    if (this.state != null) {
      data['state'] = this.state.toJson();
    }
    return data;
  }
}