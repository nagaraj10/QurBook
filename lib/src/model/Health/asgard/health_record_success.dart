import 'health_record_collection.dart';

class HealthRecordSuccess {
  bool isSuccess;
  List<Result> result;

  HealthRecordSuccess({this.isSuccess, this.result});

  HealthRecordSuccess.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['result'] != null) {
      result = List<Result>();
      json['result'].forEach((v) {
        result.add(Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['isSuccess'] = isSuccess;
    if (result != null) {
      data['result'] = result.map((v) => v.toJson()).toList();
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
        ? Metadata.fromJson(json['metadata'])
        : null;
    userId = json['userId'];
    isBookmarked = json['isBookmarked'];
    isDraft = json['isDraft'];
    isVisible = json['isVisible'];
    isActive = json['isActive'];
    isCompleted = json['isCompleted'];
    doctorId = json['doctorId'];
    if (json['healthRecordCollection'] != null) {
      healthRecordCollection = <HealthRecordCollection>[];
      json['healthRecordCollection'].forEach((v) {
        healthRecordCollection.add(HealthRecordCollection.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['healthRecordTypeId'] = healthRecordTypeId;
    data['healthRecordTypeName'] = healthRecordTypeName;
    if (metadata != null) {
      data['metadata'] = metadata.toJson();
    }
    data['userId'] = userId;
    data['isBookmarked'] = isBookmarked;
    data['isDraft'] = isDraft;
    data['isVisible'] = isVisible;
    data['isActive'] = isActive;
    data['isCompleted'] = isCompleted;
    data['doctorId'] = doctorId;
    if (healthRecordCollection != null) {
      data['healthRecordCollection'] =
          healthRecordCollection.map((v) => v.toJson()).toList();
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
        ? HealthRecordCategory.fromJson(json['healthRecordCategory'])
        : null;
    healthRecordType = json['healthRecordType'] != null
        ? HealthRecordType.fromJson(json['healthRecordType'])
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
          json['doctor'] != null ? Doctor.fromJson(json['doctor']) : null;
      hospital = json['hospital'] != null
          ? Hospital.fromJson(json['hospital'])
          : null;
    } catch (e) {}
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    if (healthRecordCategory != null) {
      data['healthRecordCategory'] = healthRecordCategory.toJson();
    }
    if (healthRecordType != null) {
      data['healthRecordType'] = healthRecordType.toJson();
    }
    data['memoText'] = memoText;
    data['hasVoiceNotes'] = hasVoiceNotes;
    data['dateOfVisit'] = dateOfVisit;
    data['isDraft'] = isDraft;
    data['sourceName'] = sourceName;
    data['memoTextRaw'] = memoTextRaw;
    if (doctor != null) {
      data['doctor'] = doctor.toJson();
    }
    if (hospital != null) {
      data['hospital'] = hospital.toJson();
    }
    data['fileName'] = fileName;
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
  String lastModifiedOn;

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
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['categoryName'] = categoryName;
    data['categoryDescription'] = categoryDescription;
    data['logo'] = logo;
    data['isDisplay'] = isDisplay;
    data['isActive'] = isActive;
    data['createdOn'] = createdOn;
    data['lastModifiedOn'] = lastModifiedOn;
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
  String lastModifiedOn;

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
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['logo'] = logo;
    data['isDisplay'] = isDisplay;
    data['isAiTranscription'] = isAiTranscription;
    data['isActive'] = isActive;
    data['createdOn'] = createdOn;
    data['lastModifiedOn'] = lastModifiedOn;
    return data;
  }
}

class Doctor {
  String doctorId;
  String userId;
  String name;
  String firstName;
  String lastName;
  String specialization;
  String doctorReferenceId;
  String addressLine1;
  String addressLine2;
  String profilePicThumbnailUrl;
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
    final data = <String, dynamic>{};
    data['doctorId'] = doctorId;
    data['userId'] = userId;
    data['name'] = name;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['specialization'] = specialization;
    data['doctorReferenceId'] = doctorReferenceId;
    data['addressLine1'] = addressLine1;
    data['addressLine2'] = addressLine2;
    data['profilePicThumbnailUrl'] = profilePicThumbnailUrl;
    data['isTelehealthEnabled'] = isTelehealthEnabled;
    data['isMciVerified'] = isMciVerified;
    return data;
  }
}

class Hospital {
  String id;
  String name;
  String addressLine1;
  String addressLine2;
  String city;
  String state;
  String pincode;
  bool isReferenced;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
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
        ? HealthOrganizationType.fromJson(json['healthOrganizationType'])
        : null;
    createdBy = json['createdBy'] != null
        ? CreatedBy.fromJson(json['createdBy'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['addressLine1'] = addressLine1;
    data['addressLine2'] = addressLine2;
    data['city'] = city;
    data['state'] = state;
    data['pincode'] = pincode;
    data['isReferenced'] = isReferenced;
    data['isActive'] = isActive;
    data['createdOn'] = createdOn;
    data['lastModifiedOn'] = lastModifiedOn;
    if (healthOrganizationType != null) {
      data['healthOrganizationType'] = healthOrganizationType.toJson();
    }
    if (createdBy != null) {
      data['createdBy'] = createdBy.toJson();
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
  String lastModifiedOn;

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

class CreatedBy {
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
