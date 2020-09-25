import 'package:myfhb/src/model/Category/CategoryData.dart';
import 'package:myfhb/src/model/Category/catergory_result.dart';
import 'package:myfhb/src/model/Health/asgard/health_record_collection.dart';
import 'package:myfhb/src/model/Media/media_result.dart';

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
  String healthRecordType;
  Metadata metadata;
  String userId;
  bool isBookmarked;
  bool isDraft;
  bool isVisible;
  bool isActive;
  bool isCompleted;
  List<HealthRecordCollection> healthRecordCollection;
  bool isSelected = false;

  HealthResult(
      {this.id,
      this.healthRecordType,
      this.metadata,
      this.userId,
      this.isBookmarked,
      this.isDraft,
      this.isVisible,
      this.isActive,
      this.isCompleted,
      this.healthRecordCollection,
      this.isSelected});

  HealthResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    healthRecordType = json['healthRecordType'];
    metadata = json['metadata'] != null
        ? new Metadata.fromJson(json['metadata'])
        : null;
    userId = json['userId'];
    isBookmarked = json['isBookmarked'];
    isDraft = json['isDraft'];
    isVisible = json['isVisible'];
    isActive = json['isActive'];
    isCompleted = json['isCompleted'];
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
    data['healthRecordType'] = this.healthRecordType;
    if (this.metadata != null) {
      data['metadata'] = this.metadata.toJson();
    }
    data['userId'] = this.userId;
    data['isBookmarked'] = this.isBookmarked;
    data['isDraft'] = this.isDraft;
    data['isVisible'] = this.isVisible;
    data['isActive'] = this.isActive;
    data['isCompleted'] = this.isCompleted;
    if (this.healthRecordCollection != null) {
      data['healthRecordCollection'] =
          this.healthRecordCollection.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Metadata {
  CategoryResult healthRecordCategory;
  MediaResult healthRecordType;
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
        ? new CategoryResult.fromJson(json['healthRecordCategory'])
        : null;
    healthRecordType = json['healthRecordType'] != null
        ? new MediaResult.fromJson(json['healthRecordType'])
        : null;
    memoText = json['memoText'];
    hasVoiceNotes = json['hasVoiceNotes'];
    dateOfVisit = json['dateOfVisit'];
    isDraft = json['isDraft'];
    sourceName = json['sourceName'];
    memoTextRaw = json['memoTextRaw'];
    doctor =
        json['doctor'] != null ? new Doctor.fromJson(json['doctor']) : null;
    hospital = json['hospital'] != null
        ? new Hospital.fromJson(json['hospital'])
        : null;
    fileName = json['fileName'];
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

class Doctor {
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

  Doctor(
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
      this.lastModifiedOn});

  Doctor.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}

class Hospital {
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

  Hospital(
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
      this.lastModifiedOn});

  Hospital.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
