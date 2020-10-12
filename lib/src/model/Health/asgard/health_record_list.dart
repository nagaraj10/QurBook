import 'package:myfhb/src/model/Health/asgard/health_record_collection.dart';

class HealthRecordList {
  bool isSuccess;
  List<HealthResult> result;

  HealthRecordList({this.isSuccess, this.result});

  HealthRecordList.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['result'] != null) {
      result = new List<HealthResult>();
      json['result'].forEach((v) {
        result.add(new HealthResult.fromJson(v));
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

class HealthResult {
  String id;
  String healthRecordTypeId;
  String healthRecordTypeName;
  Metadata metadata;
  String userId;
  bool isBookmarked;
  bool isDraft;
  bool isVisible;
  bool isActive;
  String isCompleted;
  String doctorId;
  List<HealthRecordCollection> healthRecordCollection;
  bool isSelected = false;

  HealthResult(
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
      this.healthRecordCollection,
      this.isSelected});

  HealthResult.fromJson(Map<String, dynamic> json) {
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
  Laboratory laboratory;
  List<DeviceReadings> deviceReadings;

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
      this.fileName,
      this.laboratory,
      this.deviceReadings});

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
      if (json.containsKey('deviceReadings')) {
        if (json['deviceReadings'] != null) {
          deviceReadings = new List<DeviceReadings>();
          json['deviceReadings'].forEach((v) {
            deviceReadings.add(new DeviceReadings.fromJson(v));
          });
        }
      }
      if (json.containsKey('doctor')) {
        doctor =
            json['doctor'] != null ? new Doctor.fromJson(json['doctor']) : null;
      }
      if (json.containsKey('hospital')) {
        hospital = json['hospital'] != null
            ? new Hospital.fromJson(json['hospital'])
            : null;
      }
      if (json.containsKey('laboratory')) {
        laboratory = json['laboratory'] != null
            ? new Laboratory.fromJson(json['laboratory'])
            : null;
      }
    } catch (e) {
      print(e);
    }
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
    if (this.laboratory != null) {
      data['laboratory'] = this.laboratory.toJson();
    }
    if (this.deviceReadings != null) {
      data['deviceReadings'] =
          this.deviceReadings.map((v) => v.toJson()).toList();
    }
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
  String healthOrganizationReferenceId;
  String healthOrganizationName;
  String addressLine1;
  String addressLine2;
  String cityName;
  String stateName;
  String pincode;
  String healthOrganizationId;
  String healthOrganizationTypeId;
  String healthOrganizationTypeName;
  String phoneNumber;
  String phoneNumberTypeId;
  String phoneNumberTypeName;

  Hospital(
      {this.healthOrganizationReferenceId,
      this.healthOrganizationName,
      this.addressLine1,
      this.addressLine2,
      this.cityName,
      this.stateName,
      this.pincode,
      this.healthOrganizationId,
      this.healthOrganizationTypeId,
      this.healthOrganizationTypeName,
      this.phoneNumber,
      this.phoneNumberTypeId,
      this.phoneNumberTypeName});

  Hospital.fromJson(Map<String, dynamic> json) {
    healthOrganizationReferenceId = json['healthOrganizationReferenceId'];
    healthOrganizationName = json['healthOrganizationName'];
    addressLine1 = json['addressLine1'];
    addressLine2 = json['addressLine2'];
    cityName = json['cityName'];
    stateName = json['stateName'];
    pincode = json['pincode'];
    healthOrganizationId = json['healthOrganizationId'];
    healthOrganizationTypeId = json['healthOrganizationTypeId'];
    healthOrganizationTypeName = json['healthOrganizationTypeName'];
    phoneNumber = json['phoneNumber'];
    phoneNumberTypeId = json['phoneNumberTypeId'];
    phoneNumberTypeName = json['phoneNumberTypeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['healthOrganizationReferenceId'] = this.healthOrganizationReferenceId;
    data['healthOrganizationName'] = this.healthOrganizationName;
    data['addressLine1'] = this.addressLine1;
    data['addressLine2'] = this.addressLine2;
    data['cityName'] = this.cityName;
    data['stateName'] = this.stateName;
    data['pincode'] = this.pincode;
    data['healthOrganizationId'] = this.healthOrganizationId;
    data['healthOrganizationTypeId'] = this.healthOrganizationTypeId;
    data['healthOrganizationTypeName'] = this.healthOrganizationTypeName;
    data['phoneNumber'] = this.phoneNumber;
    data['phoneNumberTypeId'] = this.phoneNumberTypeId;
    data['phoneNumberTypeName'] = this.phoneNumberTypeName;
    return data;
  }
}

class Laboratory {
  String healthOrganizationId;
  String healthOrganizationName;
  String healthOrganizationTypeId;
  String healthOrganizationTypeName;
  String addressLine1;
  String addressLine2;
  String pincode;
  String cityName;
  String stateName;
  String phoneNumber;
  String phoneNumberTypeId;
  String phoneNumberTypeName;
  String healthOrganizationReferenceId;

  Laboratory(
      {this.healthOrganizationId,
      this.healthOrganizationName,
      this.healthOrganizationTypeId,
      this.healthOrganizationTypeName,
      this.addressLine1,
      this.addressLine2,
      this.pincode,
      this.cityName,
      this.stateName,
      this.phoneNumber,
      this.phoneNumberTypeId,
      this.phoneNumberTypeName,
      this.healthOrganizationReferenceId});

  Laboratory.fromJson(Map<String, dynamic> json) {
    healthOrganizationId = json['healthOrganizationId'];
    healthOrganizationName = json['healthOrganizationName'];
    healthOrganizationTypeId = json['healthOrganizationTypeId'];
    healthOrganizationTypeName = json['healthOrganizationTypeName'];
    addressLine1 = json['addressLine1'];
    addressLine2 = json['addressLine2'];
    pincode = json['pincode'];
    cityName = json['cityName'];
    stateName = json['stateName'];
    phoneNumber = json['phoneNumber'];
    phoneNumberTypeId = json['phoneNumberTypeId'];
    phoneNumberTypeName = json['phoneNumberTypeName'];
    healthOrganizationReferenceId = json['healthOrganizationReferenceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['healthOrganizationId'] = this.healthOrganizationId;
    data['healthOrganizationName'] = this.healthOrganizationName;
    data['healthOrganizationTypeId'] = this.healthOrganizationTypeId;
    data['healthOrganizationTypeName'] = this.healthOrganizationTypeName;
    data['addressLine1'] = this.addressLine1;
    data['addressLine2'] = this.addressLine2;
    data['pincode'] = this.pincode;
    data['cityName'] = this.cityName;
    data['stateName'] = this.stateName;
    data['phoneNumber'] = this.phoneNumber;
    data['phoneNumberTypeId'] = this.phoneNumberTypeId;
    data['phoneNumberTypeName'] = this.phoneNumberTypeName;
    data['healthOrganizationReferenceId'] = this.healthOrganizationReferenceId;
    return data;
  }
}

class DeviceReadings {
  String parameter;
  String value;
  String unit;

  DeviceReadings({this.parameter, this.value, this.unit});

  DeviceReadings.fromJson(Map<String, dynamic> json) {
    parameter = json['parameter'];
    value = json['value'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['parameter'] = this.parameter;
    data['value'] = this.value;
    data['unit'] = this.unit;
    return data;
  }
}
