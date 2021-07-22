import '../../../../common/CommonUtil.dart';
import 'health_record_collection.dart';

class HealthRecordList {
  bool isSuccess;
  List<HealthResult> result;

  HealthRecordList({this.isSuccess, this.result});

  HealthRecordList.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['result'] != null) {
      result = <HealthResult>[];
      json['result'].forEach((v) {
        result.add(HealthResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['isSuccess'] = isSuccess;
    if (result != null) {
      data['result'] = result.map((v) => v.toJson()).toList();
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
  String createdOn;
  DateTime dateTimeValue;

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
      this.isSelected,
      this.createdOn,
      this.dateTimeValue});

  HealthResult.fromJson(Map<String, dynamic> json) {
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
    createdOn = json['createdOn'];
    if (metadata != null) {
      if (metadata.startDateTime != null && metadata.startDateTime != '') {
        dateTimeValue = DateTime.parse(metadata.startDateTime);
      } else {
        dateTimeValue = DateTime.parse(createdOn);
      }
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
    data['createdOn'] = createdOn;
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
  String startDateTime;
  String endDateTime;
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
    if (json.containsKey('startDateTime')) {
      startDateTime = json['startDateTime'];
    }
    if (json.containsKey('endDateTime')) {
      endDateTime = json['endDateTime'];
    }
    fileName = json['fileName'];
    try {
      if (json.containsKey('deviceReadings')) {
        if (json['deviceReadings'] != null) {
          deviceReadings = <DeviceReadings>[];
          json['deviceReadings'].forEach((v) {
            deviceReadings.add(DeviceReadings.fromJson(v));
          });
        }
      }
      if (json.containsKey('doctor')) {
        doctor =
            json['doctor'] != null ? Doctor.fromJson(json['doctor']) : null;
      }
      if (json.containsKey('hospital')) {
        hospital = json['hospital'] != null
            ? Hospital.fromJson(json['hospital'])
            : null;
      }
      if (json.containsKey('laboratory')) {
        laboratory = json['laboratory'] != null
            ? Laboratory.fromJson(json['laboratory'])
            : null;
      }
    } catch (e) {
      print(e);
    }
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
    data['startDateTime'] = startDateTime;
    data['endDateTime'] = endDateTime;

    if (doctor != null) {
      data['doctor'] = doctor.toJson();
    }
    if (hospital != null) {
      data['hospital'] = hospital.toJson();
    }
    data['fileName'] = fileName;
    if (laboratory != null) {
      data['laboratory'] = laboratory.toJson();
    }
    if (deviceReadings != null) {
      data['deviceReadings'] =
          deviceReadings.map((v) => v.toJson()).toList();
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
    final data = <String, dynamic>{};
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
    final data = Map<String, dynamic>();
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
    final data = Map<String, dynamic>();
    data['healthOrganizationReferenceId'] = healthOrganizationReferenceId;
    data['healthOrganizationName'] = healthOrganizationName;
    data['addressLine1'] = addressLine1;
    data['addressLine2'] = addressLine2;
    data['cityName'] = cityName;
    data['stateName'] = stateName;
    data['pincode'] = pincode;
    data['healthOrganizationId'] = healthOrganizationId;
    data['healthOrganizationTypeId'] = healthOrganizationTypeId;
    data['healthOrganizationTypeName'] = healthOrganizationTypeName;
    data['phoneNumber'] = phoneNumber;
    data['phoneNumberTypeId'] = phoneNumberTypeId;
    data['phoneNumberTypeName'] = phoneNumberTypeName;
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
    final data = <String, dynamic>{};
    data['healthOrganizationId'] = healthOrganizationId;
    data['healthOrganizationName'] = healthOrganizationName;
    data['healthOrganizationTypeId'] = healthOrganizationTypeId;
    data['healthOrganizationTypeName'] = healthOrganizationTypeName;
    data['addressLine1'] = addressLine1;
    data['addressLine2'] = addressLine2;
    data['pincode'] = pincode;
    data['cityName'] = cityName;
    data['stateName'] = stateName;
    data['phoneNumber'] = phoneNumber;
    data['phoneNumberTypeId'] = phoneNumberTypeId;
    data['phoneNumberTypeName'] = phoneNumberTypeName;
    data['healthOrganizationReferenceId'] = healthOrganizationReferenceId;
    return data;
  }
}

class DeviceReadings {
  String parameter;
  dynamic value;
  dynamic unit;

  DeviceReadings({this.parameter, this.value, this.unit});

  DeviceReadings.fromJson(Map<String, dynamic> json) {
    parameter = json['parameter'];
    value = json['value'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['parameter'] = parameter;
    data['value'] = value;
    data['unit'] = unit;
    return data;
  }
}
