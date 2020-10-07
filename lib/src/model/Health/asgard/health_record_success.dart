import 'package:myfhb/src/model/Health/asgard/health_record_collection.dart';

class HealthRecordSuccess {
  bool isSuccess;
  List<Result> result;

  HealthRecordSuccess({this.isSuccess, this.result});

  HealthRecordSuccess.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['result'] != null) {
      result = new List<Result>();
      json['result'].forEach((v) {
        result.add(new Result.fromJson(v));
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

class Result {
  String id;
  String healthRecordTypeId;
  String healthRecordTypeName;
  Metadata metadata;
  String userId;
  bool isBookmarked;
  bool isDraft;
  bool isVisible;
  bool isActive;
  bool isCompleted;
  String doctorId;
  List<HealthRecordCollection> healthRecordCollection;

  Result(
      {this.id,
      this.healthRecordTypeId,
      this.healthRecordTypeName,
      this.metadata,
      this.userId,
      this.isBookmarked,
      this.isDraft,
      this.isVisible,
      this.isActive,
      this.isCompleted,
      this.doctorId,
      this.healthRecordCollection});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    healthRecordTypeId = json['healthRecordTypeId'];
    healthRecordTypeName = json['healthRecordTypeName'];
    metadata = json['metadata'] != null
        ? new Metadata.fromJson(json['metadata'])
        : null;
    userId = json['userId'];
    isBookmarked = json['isBookmarked'];
    isDraft = json['isDraft'];
    isVisible = json['isVisible'];
    isActive = json['isActive'];
    isCompleted = json['isCompleted'];
    doctorId = json['doctorId'];
    if (json['healthRecordCollection'] != null) {
      healthRecordCollection = new List<HealthRecordCollection>();
      json['healthRecordCollection'].forEach((v) {
        healthRecordCollection.add(new HealthRecordCollection.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['healthRecordTypeId'] = this.healthRecordTypeId;
    data['healthRecordTypeName'] = this.healthRecordTypeName;
    if (this.metadata != null) {
      data['metadata'] = this.metadata.toJson();
    }
    data['userId'] = this.userId;
    data['isBookmarked'] = this.isBookmarked;
    data['isDraft'] = this.isDraft;
    data['isVisible'] = this.isVisible;
    data['isActive'] = this.isActive;
    data['isCompleted'] = this.isCompleted;
    data['doctorId'] = this.doctorId;
    if (this.healthRecordCollection != null) {
      data['healthRecordCollection'] =
          this.healthRecordCollection.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Metadata {
  HealthRecordCategory healthRecordCategory;
  HealthRecordType healthRecordType;
  String memoText;
  bool hasVoiceNotes;
  String dateOfVisit;
  bool isDraft;
  String sourceName;
  String memoTextRaw;
  Doctor doctor;
  Hospital hospital;
  String fileName;

  Metadata(
      {this.healthRecordCategory,
      this.healthRecordType,
      this.memoText,
      this.hasVoiceNotes,
      this.dateOfVisit,
      this.isDraft,
      this.sourceName,
      this.memoTextRaw,
      this.doctor,
      this.hospital,
      this.fileName});

  Metadata.fromJson(Map<String, dynamic> json) {
    healthRecordCategory = json['healthRecordCategory'] != null
        ? new HealthRecordCategory.fromJson(json['healthRecordCategory'])
        : null;
    healthRecordType = json['healthRecordType'] != null
        ? new HealthRecordType.fromJson(json['healthRecordType'])
        : null;
    memoText = json['memoText'];
    hasVoiceNotes = json['hasVoiceNotes'];
    dateOfVisit = json['dateOfVisit'];
    isDraft = json['isDraft'];
    sourceName = json['sourceName'];
    memoTextRaw = json['memoTextRaw'];

    fileName = json['fileName'];
    try {
      doctor =
          json['doctor'] != null ? new Doctor.fromJson(json['doctor']) : null;
      hospital = json['hospital'] != null
          ? new Hospital.fromJson(json['hospital'])
          : null;
    } catch (e) {}
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.healthRecordCategory != null) {
      data['healthRecordCategory'] = this.healthRecordCategory.toJson();
    }
    if (this.healthRecordType != null) {
      data['healthRecordType'] = this.healthRecordType.toJson();
    }
    data['memoText'] = this.memoText;
    data['hasVoiceNotes'] = this.hasVoiceNotes;
    data['dateOfVisit'] = this.dateOfVisit;
    data['isDraft'] = this.isDraft;
    data['sourceName'] = this.sourceName;
    data['memoTextRaw'] = this.memoTextRaw;
    if (this.doctor != null) {
      data['doctor'] = this.doctor.toJson();
    }
    if (this.hospital != null) {
      data['hospital'] = this.hospital.toJson();
    }
    data['fileName'] = this.fileName;
    return data;
  }
}

class HealthRecordCategory {
  String id;
  String categoryName;
  String categoryDescription;
  String logo;
  bool isDisplay;
  bool isActive;
  String createdOn;
  Null lastModifiedOn;

  HealthRecordCategory(
      {this.id,
      this.categoryName,
      this.categoryDescription,
      this.logo,
      this.isDisplay,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn});

  HealthRecordCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['categoryName'];
    categoryDescription = json['categoryDescription'];
    logo = json['logo'];
    isDisplay = json['isDisplay'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['categoryName'] = this.categoryName;
    data['categoryDescription'] = this.categoryDescription;
    data['logo'] = this.logo;
    data['isDisplay'] = this.isDisplay;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    return data;
  }
}

class HealthRecordType {
  String id;
  String name;
  String description;
  String logo;
  bool isDisplay;
  bool isAiTranscription;
  bool isActive;
  String createdOn;
  Null lastModifiedOn;

  HealthRecordType(
      {this.id,
      this.name,
      this.description,
      this.logo,
      this.isDisplay,
      this.isAiTranscription,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn});

  HealthRecordType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    logo = json['logo'];
    isDisplay = json['isDisplay'];
    isAiTranscription = json['isAiTranscription'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['logo'] = this.logo;
    data['isDisplay'] = this.isDisplay;
    data['isAiTranscription'] = this.isAiTranscription;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    return data;
  }
}

class Doctor {
  Null doctorId;
  Null userId;
  String name;
  String firstName;
  String lastName;
  Null specialization;
  String doctorReferenceId;
  String addressLine1;
  String addressLine2;
  Null profilePicThumbnailUrl;
  bool isTelehealthEnabled;
  bool isMciVerified;

  Doctor(
      {this.doctorId,
      this.userId,
      this.name,
      this.firstName,
      this.lastName,
      this.specialization,
      this.doctorReferenceId,
      this.addressLine1,
      this.addressLine2,
      this.profilePicThumbnailUrl,
      this.isTelehealthEnabled,
      this.isMciVerified});

  Doctor.fromJson(Map<String, dynamic> json) {
    doctorId = json['doctorId'];
    userId = json['userId'];
    name = json['name'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    specialization = json['specialization'];
    doctorReferenceId = json['doctorReferenceId'];
    addressLine1 = json['addressLine1'];
    addressLine2 = json['addressLine2'];
    profilePicThumbnailUrl = json['profilePicThumbnailUrl'];
    isTelehealthEnabled = json['isTelehealthEnabled'];
    isMciVerified = json['isMciVerified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doctorId'] = this.doctorId;
    data['userId'] = this.userId;
    data['name'] = this.name;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['specialization'] = this.specialization;
    data['doctorReferenceId'] = this.doctorReferenceId;
    data['addressLine1'] = this.addressLine1;
    data['addressLine2'] = this.addressLine2;
    data['profilePicThumbnailUrl'] = this.profilePicThumbnailUrl;
    data['isTelehealthEnabled'] = this.isTelehealthEnabled;
    data['isMciVerified'] = this.isMciVerified;
    return data;
  }
}

class Hospital {
  String id;
  String name;
  String addressLine1;
  Null addressLine2;
  Null city;
  Null state;
  Null pincode;
  bool isReferenced;
  bool isActive;
  String createdOn;
  Null lastModifiedOn;
  HealthOrganizationType healthOrganizationType;
  CreatedBy createdBy;

  Hospital(
      {this.id,
      this.name,
      this.addressLine1,
      this.addressLine2,
      this.city,
      this.state,
      this.pincode,
      this.isReferenced,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn,
      this.healthOrganizationType,
      this.createdBy});

  Hospital.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    addressLine1 = json['addressLine1'];
    addressLine2 = json['addressLine2'];
    city = json['city'];
    state = json['state'];
    pincode = json['pincode'];
    isReferenced = json['isReferenced'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    healthOrganizationType = json['healthOrganizationType'] != null
        ? new HealthOrganizationType.fromJson(json['healthOrganizationType'])
        : null;
    createdBy = json['createdBy'] != null
        ? new CreatedBy.fromJson(json['createdBy'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['addressLine1'] = this.addressLine1;
    data['addressLine2'] = this.addressLine2;
    data['city'] = this.city;
    data['state'] = this.state;
    data['pincode'] = this.pincode;
    data['isReferenced'] = this.isReferenced;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    if (this.healthOrganizationType != null) {
      data['healthOrganizationType'] = this.healthOrganizationType.toJson();
    }
    if (this.createdBy != null) {
      data['createdBy'] = this.createdBy.toJson();
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
  Null lastModifiedOn;

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

class CreatedBy {
  String id;
  String name;
  String userName;
  String firstName;
  Null middleName;
  String lastName;
  Null gender;
  Null dateOfBirth;
  Null bloodGroup;
  Null countryCode;
  Null profilePicUrl;
  Null profilePicThumbnailUrl;
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
  Null isActive;
  Null createdBy;
  String createdOn;
  Null lastModifiedBy;
  Null lastModifiedOn;

  CreatedBy(
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
      this.lastModifiedOn});

  CreatedBy.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
