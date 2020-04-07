class GlobalSearch {
  int status;
  bool success;
  String message;
  Response response;

  GlobalSearch({this.status, this.success, this.message, this.response});

  GlobalSearch.fromJson(Map<String, dynamic> json) {
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
  List<Data> data;

  Response({this.count, this.data});

  Response.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
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

  Data(
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

  Data.fromJson(Map<String, dynamic> json) {
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
  MediaTypeInfo mediaTypeInfo;
  String memoText;
  bool hasVoiceNote;
  String dateOfVisit;
  bool isDraft;
  String sourceName;
  String memoTextRaw;
  Doctor doctor;
  Hospital hospital;
  String fileName;
  List<DeviceReadings> deviceReadings;
  Laboratory laboratory;

  MetaInfo({
    this.categoryInfo,
    this.mediaTypeInfo,
    this.memoText,
    this.hasVoiceNote,
    this.dateOfVisit,
    this.isDraft,
    this.sourceName,
    this.memoTextRaw,
    this.doctor,
    this.hospital,
    this.fileName,
    this.deviceReadings,
    this.laboratory,
  });

  MetaInfo.fromJson(Map<String, dynamic> json) {
    categoryInfo = json['categoryInfo'] != null
        ? new CategoryInfo.fromJson(json['categoryInfo'])
        : null;
    mediaTypeInfo = json['mediaTypeInfo'] != null
        ? new MediaTypeInfo.fromJson(json['mediaTypeInfo'])
        : null;
    memoText = json['memoText'];
    hasVoiceNote = json['hasVoiceNote'];
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

    if (json['deviceReadings'] != null) {
      deviceReadings = new List<DeviceReadings>();
      json['deviceReadings'].forEach((v) {
        deviceReadings.add(new DeviceReadings.fromJson(v));
      });
    }
    laboratory = json['laboratory'] != null
        ? new Laboratory.fromJson(json['laboratory'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categoryInfo != null) {
      data['categoryInfo'] = this.categoryInfo.toJson();
    }
    if (this.mediaTypeInfo != null) {
      data['mediaTypeInfo'] = this.mediaTypeInfo.toJson();
    }
    data['memoText'] = this.memoText;
    data['hasVoiceNote'] = this.hasVoiceNote;
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
    if (this.deviceReadings != null) {
      data['deviceReadings'] =
          this.deviceReadings.map((v) => v.toJson()).toList();
    }

    if (this.laboratory != null) {
      data['laboratory'] = this.laboratory.toJson();
    }
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
  String latitude;
  String logoThumbnail;
  String longitude;
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
    if (json['latitude'] is String) {
      latitude = json['latitude'];
    } else {
      latitude = json['latitude'].toString();
    }
    if (json['longitude'] is String) {
      longitude = json['longitude'];
    } else {
      longitude = json['longitude'].toString();
    }
    //latitude = json['latitude'];
    logoThumbnail = json['logoThumbnail'];
    //longitude = json['longitude'];
    name = json['name'];
    website = json['website'];
    if (zipcode is String) {
      zipcode = json['zipcode'];
    } else {
      zipcode = json['zipcode'].toString();
    }
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

class DeviceReadings {
  String parameter;
  String unit;
  String value;

  DeviceReadings({this.parameter, this.unit, this.value});

  DeviceReadings.fromJson(Map<String, dynamic> json) {
    parameter = json['parameter'];
    if (json['value'] is int) {
      value = json['value'].toString();
    } else {
      value = json['value'];
    }
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['parameter'] = this.parameter;
    data['unit'] = this.unit;
    data['values'] = this.value;
    return data;
  }
}

class CategoryInfo {
  String id;
  String categoryName;
  String categoryDescription;
  String logo;
  String lastModifiedOn;
  bool isDisplay;
  bool isCreate;
  bool isRead;
  bool isEdit;
  bool isDelete;
    bool isActive;


  CategoryInfo(
      {this.id,
      this.categoryName,
      this.categoryDescription,
      this.logo,
   
      this.lastModifiedOn,
      this.isDisplay,
      this.isCreate,
      this.isRead,
      this.isEdit,
      this.isDelete, this.isActive});

  CategoryInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['categoryName'];
    categoryDescription = json['categoryDescription'];
    logo = json['logo'];
   
    lastModifiedOn = json['lastModifiedOn'];
    isDisplay = json['isDisplay'];
    isCreate = json['isCreate'];
    isRead = json['isRead'];
    isEdit = json['isEdit'];
    isDelete = json['isDelete'];
        isActive = json['isActive'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['categoryName'] = this.categoryName;
    data['categoryDescription'] = this.categoryDescription;
    data['logo'] = this.logo;
  
    data['lastModifiedOn'] = this.lastModifiedOn;
    data['isDisplay'] = this.isDisplay;
    data['isCreate'] = this.isCreate;
    data['isRead'] = this.isRead;
    data['isEdit'] = this.isEdit;
    data['isDelete'] = this.isDelete;
        data['isActive'] = this.isActive;

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
