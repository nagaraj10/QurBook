class UserHealthResponseList {
  int status;
  bool success;
  String message;
  Response response;

  UserHealthResponseList(
      {this.status, this.success, this.message, this.response});

  UserHealthResponseList.fromJson(Map<String, dynamic> json) {
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
  CompleteData data;

  Response({this.count, this.data});

  Response.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    data =
        json['data'] != null ? new CompleteData.fromJson(json['data']) : null;
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

class CompleteData {
  List<MediaMetaInfo> mediaMetaInfo;

  CompleteData({this.mediaMetaInfo});

  CompleteData.fromJson(Map<String, dynamic> json) {
    if (json['mediaMetaInfo'] != null) {
      mediaMetaInfo = new List<MediaMetaInfo>();
      json['mediaMetaInfo'].forEach((v) {
        mediaMetaInfo.add(new MediaMetaInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mediaMetaInfo != null) {
      data['mediaMetaInfo'] =
          this.mediaMetaInfo.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MediaMetaInfo {
  String id;
  String metaTypeId;
  String userId;
  MetaInfo metaInfo;
  bool isActive;
  String createdBy;
  String createdOn;
  String lastModifiedOn;
  bool isBookmarked;
  bool isDraft;
  String createdByUser;
  List<MediaMasterIds> mediaMasterIds;

  MediaMetaInfo(
      {this.id,
      this.metaTypeId,
      this.userId,
      this.metaInfo,
      this.isActive,
      this.createdBy,
      this.createdOn,
      this.lastModifiedOn,
      this.isBookmarked,
      this.isDraft,
      this.createdByUser,
      this.mediaMasterIds});

  MediaMetaInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    metaTypeId = json['metaTypeId'];
    userId = json['userId'];
    metaInfo = json['metaInfo'] != null
        ? new MetaInfo.fromJson(json['metaInfo'])
        : null;
    isActive = json['isActive'];
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    isBookmarked = json['isBookmarked'];
    isDraft = json['isDraft'];
    createdByUser = json['createdByUser'];
    if (json['mediaMasterIds'] != null) {
      mediaMasterIds = new List<MediaMasterIds>();
      json['mediaMasterIds'].forEach((v) {
        mediaMasterIds.add(new MediaMasterIds.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['metaTypeId'] = this.metaTypeId;
    data['userId'] = this.userId;
    if (this.metaInfo != null) {
      data['metaInfo'] = this.metaInfo.toJson();
    }
    data['isActive'] = this.isActive;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    data['isBookmarked'] = this.isBookmarked;
    data['isDraft'] = this.isDraft;
    data['createdByUser'] = this.createdByUser;
    if (this.mediaMasterIds != null) {
      data['mediaMasterIds'] =
          this.mediaMasterIds.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MetaInfo {
  CategoryInfo categoryInfo;
  String dateOfVisit;
  List<DeviceReadings> deviceReadings;
  Doctor doctor;
  String fileName;
  bool hasVoiceNotes;
  bool isDraft;
  MediaTypeInfo mediaTypeInfo;
  String memoText;
  String memoTextRaw;
  String sourceName;
  Laboratory laboratory;
  Hospital hospital;
  String dateOfExpiry;
  MediaTypeInfo idType;

  MetaInfo(
      {this.categoryInfo,
      this.dateOfVisit,
      this.deviceReadings,
      this.doctor,
      this.fileName,
      this.hasVoiceNotes,
      this.isDraft,
      this.mediaTypeInfo,
      this.memoText,
      this.memoTextRaw,
      this.sourceName,
      this.laboratory,
      this.hospital,
      this.dateOfExpiry,
      this.idType});

  MetaInfo.fromJson(Map<String, dynamic> json) {
    categoryInfo = json['categoryInfo'] != null
        ? new CategoryInfo.fromJson(json['categoryInfo'])
        : null;
    dateOfVisit = json['dateOfVisit'];
    if (json['deviceReadings'] != null) {
      deviceReadings = new List<DeviceReadings>();
      json['deviceReadings'].forEach((v) {
        deviceReadings.add(new DeviceReadings.fromJson(v));
      });
    }
    doctor =
        json['doctor'] != null ? new Doctor.fromJson(json['doctor']) : null;
    fileName = json['fileName'];
    hasVoiceNotes = json['hasVoiceNotes'];
    isDraft = json['isDraft'];
    mediaTypeInfo = json['mediaTypeInfo'] != null
        ? new MediaTypeInfo.fromJson(json['mediaTypeInfo'])
        : null;
    memoText = json['memoText'];
    memoTextRaw = json['memoTextRaw'];
    sourceName = json['sourceName'];
    laboratory = json['laboratory'] != null
        ? new Laboratory.fromJson(json['laboratory'])
        : null;
    hospital = json['hospital'] != null
        ? new Hospital.fromJson(json['hospital'])
        : null;
    dateOfExpiry = json['dateOfExpiry'];
    idType = json['idType'] != null
        ? new MediaTypeInfo.fromJson(json['idType'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categoryInfo != null) {
      data['categoryInfo'] = this.categoryInfo.toJson();
    }
    data['dateOfVisit'] = this.dateOfVisit;
    if (this.deviceReadings != null) {
      data['deviceReadings'] =
          this.deviceReadings.map((v) => v.toJson()).toList();
    }
    if (this.doctor != null) {
      data['doctor'] = this.doctor.toJson();
    }
    data['fileName'] = this.fileName;
    data['hasVoiceNotes'] = this.hasVoiceNotes;
    data['isDraft'] = this.isDraft;
    if (this.mediaTypeInfo != null) {
      data['mediaTypeInfo'] = this.mediaTypeInfo.toJson();
    }
    data['memoText'] = this.memoText;
    data['memoTextRaw'] = this.memoTextRaw;
    data['sourceName'] = this.sourceName;
    if (this.laboratory != null) {
      data['laboratory'] = this.laboratory.toJson();
    }
    if (this.hospital != null) {
      data['hospital'] = this.hospital.toJson();
    }
    data['dateOfExpiry'] = this.dateOfExpiry;
    if (this.idType != null) {
      data['idType'] = this.idType.toJson();
    }
    return data;
  }
}

class CategoryInfo {
  String categoryDescription;
  String categoryName;
  String id;
  bool isCreate;
  bool isDelete;
  bool isDisplay;
  bool isEdit;
  bool isRead;
  String logo;
  String url;
  int localid;

  CategoryInfo(
      {this.categoryDescription,
      this.categoryName,
      this.id,
      this.isCreate,
      this.isDelete,
      this.isDisplay,
      this.isEdit,
      this.isRead,
      this.logo,
      this.url,
      this.localid});

  CategoryInfo.fromJson(Map<String, dynamic> json) {
    categoryDescription = json['categoryDescription'];
    categoryName = json['categoryName'];
    id = json['id'];
    isCreate = json['isCreate'];
    isDelete = json['isDelete'];
    isDisplay = json['isDisplay'];
    isEdit = json['isEdit'];
    isRead = json['isRead'];
    logo = json['logo'];
    url = json['url'];
    localid = json['localid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryDescription'] = this.categoryDescription;
    data['categoryName'] = this.categoryName;
    data['id'] = this.id;
    data['isCreate'] = this.isCreate;
    data['isDelete'] = this.isDelete;
    data['isDisplay'] = this.isDisplay;
    data['isEdit'] = this.isEdit;
    data['isRead'] = this.isRead;
    data['logo'] = this.logo;
    data['url'] = this.url;
    data['localid'] = this.localid;
    return data;
  }
}

class DeviceReadings {
  String parameter;
  String unit;
  String values;

  DeviceReadings({this.parameter, this.unit, this.values});

  DeviceReadings.fromJson(Map<String, dynamic> json) {
    parameter = json['parameter'];
    unit = json['unit'];
    values = json['values'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['parameter'] = this.parameter;
    data['unit'] = this.unit;
    data['values'] = this.values;
    return data;
  }
}

class Doctor {
  int localDoctorId;
  String city;
  String description;
  String email;
  String id;
  bool isUserDefined;
  String name;
  String specialization;
  String state;

  Doctor(
      {this.localDoctorId,
      this.city,
      this.description,
      this.email,
      this.id,
      this.isUserDefined,
      this.name,
      this.specialization,
      this.state});

  Doctor.fromJson(Map<String, dynamic> json) {
    localDoctorId = json['Local_Doctor_Id'];
    city = json['city'];
    description = json['description'];
    email = json['email'];
    id = json['id'];
    isUserDefined = json['isUserDefined'];
    name = json['name'];
    specialization = json['specialization'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Local_Doctor_Id'] = this.localDoctorId;
    data['city'] = this.city;
    data['description'] = this.description;
    data['email'] = this.email;
    data['id'] = this.id;
    data['isUserDefined'] = this.isUserDefined;
    data['name'] = this.name;
    data['specialization'] = this.specialization;
    data['state'] = this.state;
    return data;
  }
}

class MediaTypeInfo {
  String categoryId;
  String createdOn;
  String description;
  String id;
  bool isAITranscription;
  String isActive;
  bool isCreate;
  bool isDelete;
  bool isDisplay;
  bool isEdit;
  bool isManualTranscription;
  bool isRead;
  String lastModifiedOn;
  int localid;
  String logo;
  String name;
  String url;

  MediaTypeInfo(
      {this.categoryId,
      this.createdOn,
      this.description,
      this.id,
      this.isAITranscription,
      this.isActive,
      this.isCreate,
      this.isDelete,
      this.isDisplay,
      this.isEdit,
      this.isManualTranscription,
      this.isRead,
      this.lastModifiedOn,
      this.localid,
      this.logo,
      this.name,
      this.url});

  MediaTypeInfo.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    createdOn = json['createdOn'];
    description = json['description'];
    id = json['id'];
    isAITranscription = json['isAITranscription'];
    isActive = json['isActive'];
    isCreate = json['isCreate'];
    isDelete = json['isDelete'];
    isDisplay = json['isDisplay'];
    isEdit = json['isEdit'];
    isManualTranscription = json['isManualTranscription'];
    isRead = json['isRead'];
    lastModifiedOn = json['lastModifiedOn'];
    localid = json['localid'];
    logo = json['logo'];
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryId'] = this.categoryId;
    data['createdOn'] = this.createdOn;
    data['description'] = this.description;
    data['id'] = this.id;
    data['isAITranscription'] = this.isAITranscription;
    data['isActive'] = this.isActive;
    data['isCreate'] = this.isCreate;
    data['isDelete'] = this.isDelete;
    data['isDisplay'] = this.isDisplay;
    data['isEdit'] = this.isEdit;
    data['isManualTranscription'] = this.isManualTranscription;
    data['isRead'] = this.isRead;
    data['lastModifiedOn'] = this.lastModifiedOn;
    data['localid'] = this.localid;
    data['logo'] = this.logo;
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }
}

class Laboratory {
  int localLabId;
  String addressLine1;
  String addressLine2;
  String branch;
  String city;
  String description;
  String email;
  String id;
  bool isUserDefined;
  int latitude;
  String logoThumbnail;
  int longitude;
  String name;
  String website;
  String zipcode;

  Laboratory(
      {this.localLabId,
      this.addressLine1,
      this.addressLine2,
      this.branch,
      this.city,
      this.description,
      this.email,
      this.id,
      this.isUserDefined,
      this.latitude,
      this.logoThumbnail,
      this.longitude,
      this.name,
      this.website,
      this.zipcode});

  Laboratory.fromJson(Map<String, dynamic> json) {
    localLabId = json['Local_Lab_Id'];
    addressLine1 = json['addressLine1'];
    addressLine2 = json['addressLine2'];
    branch = json['branch'];
    city = json['city'];
    description = json['description'];
    email = json['email'];
    id = json['id'];
    isUserDefined = json['isUserDefined'];
    latitude = json['latitude'];
    logoThumbnail = json['logoThumbnail'];
    longitude = json['longitude'];
    name = json['name'];
    website = json['website'];
    zipcode = json['zipcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Local_Lab_Id'] = this.localLabId;
    data['addressLine1'] = this.addressLine1;
    data['addressLine2'] = this.addressLine2;
    data['branch'] = this.branch;
    data['city'] = this.city;
    data['description'] = this.description;
    data['email'] = this.email;
    data['id'] = this.id;
    data['isUserDefined'] = this.isUserDefined;
    data['latitude'] = this.latitude;
    data['logoThumbnail'] = this.logoThumbnail;
    data['longitude'] = this.longitude;
    data['name'] = this.name;
    data['website'] = this.website;
    data['zipcode'] = this.zipcode;
    return data;
  }
}

class Hospital {
  int localHospitalId;
  String addressLine1;
  String addressLine2;
  String branch;
  String city;
  String description;
  String email;
  String id;
  bool isUserDefined;
  int latitude;
  String logoThumbnail;
  int longitude;
  String name;
  String website;
  String zipcode;

  Hospital(
      {this.localHospitalId,
      this.addressLine1,
      this.addressLine2,
      this.branch,
      this.city,
      this.description,
      this.email,
      this.id,
      this.isUserDefined,
      this.latitude,
      this.logoThumbnail,
      this.longitude,
      this.name,
      this.website,
      this.zipcode});

  Hospital.fromJson(Map<String, dynamic> json) {
    localHospitalId = json['Local_Hospital_Id'];
    addressLine1 = json['addressLine1'];
    addressLine2 = json['addressLine2'];
    branch = json['branch'];
    city = json['city'];
    description = json['description'];
    email = json['email'];
    id = json['id'];
    isUserDefined = json['isUserDefined'];
    latitude = json['latitude'];
    logoThumbnail = json['logoThumbnail'];
    longitude = json['longitude'];
    name = json['name'];
    website = json['website'];
    zipcode = json['zipcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Local_Hospital_Id'] = this.localHospitalId;
    data['addressLine1'] = this.addressLine1;
    data['addressLine2'] = this.addressLine2;
    data['branch'] = this.branch;
    data['city'] = this.city;
    data['description'] = this.description;
    data['email'] = this.email;
    data['id'] = this.id;
    data['isUserDefined'] = this.isUserDefined;
    data['latitude'] = this.latitude;
    data['logoThumbnail'] = this.logoThumbnail;
    data['longitude'] = this.longitude;
    data['name'] = this.name;
    data['website'] = this.website;
    data['zipcode'] = this.zipcode;
    return data;
  }
}

class MediaMasterIds {
  String id;
  String fileType;

  MediaMasterIds({this.id, this.fileType});

  MediaMasterIds.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fileType = json['fileType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fileType'] = this.fileType;
    return data;
  }
}
