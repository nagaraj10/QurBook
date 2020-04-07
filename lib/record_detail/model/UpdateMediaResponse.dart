class UpdateMediaResponse {
  int status;
  bool success;
  String message;
  Response response;

  UpdateMediaResponse({this.status, this.success, this.message, this.response});

  UpdateMediaResponse.fromJson(Map<String, dynamic> json) {
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
  Data data;

  Response({this.count, this.data});

  Response.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  MediaMetaInfo mediaMetaInfo;

  Data({this.mediaMetaInfo});

  Data.fromJson(Map<String, dynamic> json) {
    mediaMetaInfo = json['mediaMetaInfo'] != null
        ? new MediaMetaInfo.fromJson(json['mediaMetaInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mediaMetaInfo != null) {
      data['mediaMetaInfo'] = this.mediaMetaInfo.toJson();
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
  Null isVisible;
  String createdBy;
  String createdOn;
  String lastModifiedOn;
  bool isBookmarked;
  bool isDraft;
  String lastModifiedBy;

  MediaMetaInfo(
      {this.id,
      this.metaTypeId,
      this.userId,
      this.metaInfo,
      this.isActive,
      this.isVisible,
      this.createdBy,
      this.createdOn,
      this.lastModifiedOn,
      this.isBookmarked,
      this.isDraft,
      this.lastModifiedBy});

  MediaMetaInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    metaTypeId = json['metaTypeId'];
    userId = json['userId'];
    metaInfo = json['metaInfo'] != null
        ? new MetaInfo.fromJson(json['metaInfo'])
        : null;
    isActive = json['isActive'];
    isVisible = json['isVisible'];
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    isBookmarked = json['isBookmarked'];
    isDraft = json['isDraft'];
    lastModifiedBy = json['lastModifiedBy'];
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
    data['isVisible'] = this.isVisible;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    data['isBookmarked'] = this.isBookmarked;
    data['isDraft'] = this.isDraft;
    data['lastModifiedBy'] = this.lastModifiedBy;
    return data;
  }
}

class MetaInfo {
  CategoryInfo categoryInfo;
  MediaTypeInfo mediaTypeInfo;
  String dateOfVisit;
  String memoText;
  bool hasVoiceNote;
  bool isDraft;
  String sourceName;
  String memoTextRaw;
  Doctor doctor;
  Hospital hospital;
  String fileName;

  MetaInfo(
      {this.categoryInfo,
      this.mediaTypeInfo,
      this.dateOfVisit,
      this.memoText,
      this.hasVoiceNote,
      this.isDraft,
      this.sourceName,
      this.memoTextRaw,
      this.doctor,
      this.hospital,
      this.fileName});

  MetaInfo.fromJson(Map<String, dynamic> json) {
    categoryInfo = json['categoryInfo'] != null
        ? new CategoryInfo.fromJson(json['categoryInfo'])
        : null;
    mediaTypeInfo = json['mediaTypeInfo'] != null
        ? new MediaTypeInfo.fromJson(json['mediaTypeInfo'])
        : null;
    dateOfVisit = json['dateOfVisit'];
    memoText = json['memoText'];
    hasVoiceNote = json['hasVoiceNote'];
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
    if (this.categoryInfo != null) {
      data['categoryInfo'] = this.categoryInfo.toJson();
    }
    if (this.mediaTypeInfo != null) {
      data['mediaTypeInfo'] = this.mediaTypeInfo.toJson();
    }
    data['dateOfVisit'] = this.dateOfVisit;
    data['memoText'] = this.memoText;
    data['hasVoiceNote'] = this.hasVoiceNote;
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

class CategoryInfo {
  String id;
  String categoryName;
  String categoryDescription;
  String logo;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  bool isDisplay;
  bool isCreate;
  bool isRead;
  bool isEdit;
  bool isDelete;

  CategoryInfo(
      {this.id,
      this.categoryName,
      this.categoryDescription,
      this.logo,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn,
      this.isDisplay,
      this.isCreate,
      this.isRead,
      this.isEdit,
      this.isDelete});

  CategoryInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['categoryName'];
    categoryDescription = json['categoryDescription'];
    logo = json['logo'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    isDisplay = json['isDisplay'];
    isCreate = json['isCreate'];
    isRead = json['isRead'];
    isEdit = json['isEdit'];
    isDelete = json['isDelete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['categoryName'] = this.categoryName;
    data['categoryDescription'] = this.categoryDescription;
    data['logo'] = this.logo;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    data['isDisplay'] = this.isDisplay;
    data['isCreate'] = this.isCreate;
    data['isRead'] = this.isRead;
    data['isEdit'] = this.isEdit;
    data['isDelete'] = this.isDelete;
    return data;
  }
}

class MediaTypeInfo {
  String id;
  String name;
  String description;
  String logo;
  String categoryId;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  bool isDisplay;
  bool isCreate;
  bool isRead;
  bool isEdit;
  bool isDelete;
  bool isManualTranscription;
  bool isAITranscription;

  MediaTypeInfo(
      {this.id,
      this.name,
      this.description,
      this.logo,
      this.categoryId,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn,
      this.isDisplay,
      this.isCreate,
      this.isRead,
      this.isEdit,
      this.isDelete,
      this.isManualTranscription,
      this.isAITranscription});

  MediaTypeInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    logo = json['logo'];
    categoryId = json['categoryId'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    isDisplay = json['isDisplay'];
    isCreate = json['isCreate'];
    isRead = json['isRead'];
    isEdit = json['isEdit'];
    isDelete = json['isDelete'];
    isManualTranscription = json['isManualTranscription'];
    isAITranscription = json['isAITranscription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['logo'] = this.logo;
    data['categoryId'] = this.categoryId;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    data['isDisplay'] = this.isDisplay;
    data['isCreate'] = this.isCreate;
    data['isRead'] = this.isRead;
    data['isEdit'] = this.isEdit;
    data['isDelete'] = this.isDelete;
    data['isManualTranscription'] = this.isManualTranscription;
    data['isAITranscription'] = this.isAITranscription;
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
  Null logo;
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