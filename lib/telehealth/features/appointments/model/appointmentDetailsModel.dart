class AppointmentDetailsModel {
  bool isSuccess;
  Result result;

  AppointmentDetailsModel({this.isSuccess, this.result});

  AppointmentDetailsModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class Result {
  String id;
  String bookingId;
  String doctorSessionId;
  String plannedStartDateTime;
  String plannedEndDateTime;
  String actualStartDateTime;
  String actualEndDateTime;
  int slotNumber;
  bool isHealthRecordShared;
  String plannedFollowupDate;
  bool isRefunded;
  bool isFollowupFee;
  String isFollowup;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  bool isBookedByProvider;
  bool isCallDenied;
  AdditionalInfo additionalInfo;
  BookedFor bookedFor;
  BookedBy bookedBy;
  Status status;
  ServiceCategory serviceCategory;
  Status modeOfService;
  List<String> prescriptionCollection;
  HealthOrganization healthOrganization;
  FeeDetails feeDetails;
  HealthRecord healthRecord;
  int duration;
  String chatListId;

  Result(
      {this.id,
      this.bookingId,
      this.doctorSessionId,
      this.plannedStartDateTime,
      this.plannedEndDateTime,
      this.actualStartDateTime,
      this.actualEndDateTime,
      this.slotNumber,
      this.isHealthRecordShared,
      this.plannedFollowupDate,
      this.isRefunded,
      this.isFollowupFee,
      this.isFollowup,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn,
      this.isBookedByProvider,
      this.isCallDenied,
      this.additionalInfo,
      this.bookedFor,
      this.bookedBy,
      this.status,
      this.serviceCategory,
      this.modeOfService,
      this.prescriptionCollection,
      this.healthOrganization,
      this.feeDetails,
      this.healthRecord,
      this.duration,
      this.chatListId});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['bookingId'];
    doctorSessionId = json['doctorSessionId'];
    plannedStartDateTime = json['plannedStartDateTime'];
    plannedEndDateTime = json['plannedEndDateTime'];
    actualStartDateTime = json['actualStartDateTime'];
    actualEndDateTime = json['actualEndDateTime'];
    slotNumber = json['slotNumber'];
    isHealthRecordShared = json['isHealthRecordShared'];
    plannedFollowupDate = json['plannedFollowupDate'];
    isRefunded = json['isRefunded'];
    isFollowupFee = json['isFollowupFee'];
    isFollowup = json['isFollowup'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    isBookedByProvider = json['isBookedByProvider'];
    isCallDenied = json['isCallDenied'];
    additionalInfo = json['additionalInfo'] != null
        ? new AdditionalInfo.fromJson(json['additionalInfo'])
        : null;
    bookedFor = json['bookedFor'] != null
        ? new BookedFor.fromJson(json['bookedFor'])
        : null;
    bookedBy = json['bookedBy'] != null
        ? new BookedBy.fromJson(json['bookedBy'])
        : null;
    status =
        json['status'] != null ? new Status.fromJson(json['status']) : null;
    serviceCategory = json['serviceCategory'] != null
        ? new ServiceCategory.fromJson(json['serviceCategory'])
        : null;
    modeOfService = json['modeOfService'] != null
        ? new Status.fromJson(json['modeOfService'])
        : null;
    /*if (json['prescriptionCollection'] != null) {
      prescriptionCollection = <Null>[];
      json['prescriptionCollection'].forEach((v) {
        prescriptionCollection!.add(new Null.fromJson(v));
      });
    }*/
    healthOrganization = json['healthOrganization'] != null
        ? new HealthOrganization.fromJson(json['healthOrganization'])
        : null;
    feeDetails = json['feeDetails'] != null
        ? new FeeDetails.fromJson(json['feeDetails'])
        : null;
    healthRecord = json['healthRecord'] != null
        ? new HealthRecord.fromJson(json['healthRecord'])
        : null;
    duration = json['duration'];
    chatListId = json['chatListId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['bookingId'] = this.bookingId;
    data['doctorSessionId'] = this.doctorSessionId;
    data['plannedStartDateTime'] = this.plannedStartDateTime;
    data['plannedEndDateTime'] = this.plannedEndDateTime;
    data['actualStartDateTime'] = this.actualStartDateTime;
    data['actualEndDateTime'] = this.actualEndDateTime;
    data['slotNumber'] = this.slotNumber;
    data['isHealthRecordShared'] = this.isHealthRecordShared;
    data['plannedFollowupDate'] = this.plannedFollowupDate;
    data['isRefunded'] = this.isRefunded;
    data['isFollowupFee'] = this.isFollowupFee;
    data['isFollowup'] = this.isFollowup;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    data['isBookedByProvider'] = this.isBookedByProvider;
    data['isCallDenied'] = this.isCallDenied;
    if (this.additionalInfo != null) {
      data['additionalInfo'] = this.additionalInfo.toJson();
    }
    if (this.bookedFor != null) {
      data['bookedFor'] = this.bookedFor.toJson();
    }
    if (this.bookedBy != null) {
      data['bookedBy'] = this.bookedBy.toJson();
    }
    if (this.status != null) {
      data['status'] = this.status.toJson();
    }
    if (this.serviceCategory != null) {
      data['serviceCategory'] = this.serviceCategory.toJson();
    }
    if (this.modeOfService != null) {
      data['modeOfService'] = this.modeOfService.toJson();
    }
    /*if (this.prescriptionCollection != null) {
      data['prescriptionCollection'] =
          this.prescriptionCollection.map((v) => v.toJson()).toList();
    }*/
    if (this.healthOrganization != null) {
      data['healthOrganization'] = this.healthOrganization.toJson();
    }
    if (this.feeDetails != null) {
      data['feeDetails'] = this.feeDetails.toJson();
    }
    if (this.healthRecord != null) {
      data['healthRecord'] = this.healthRecord.toJson();
    }
    data['duration'] = this.duration;
    data['chatListId'] = this.chatListId;
    return data;
  }
}

class AdditionalInfo {
  int fee;
  String city;
  String notes;
  String state;
  String endTime;
  String labName;
  String pinCode;
  String testName;
  String startTime;
  String cancelReason;
  String preferredLab;
  String addressLine1;
  String addressLine2;
  String preferredDate;
  String modeOfService;

  AdditionalInfo(
      {this.fee,
      this.city,
      this.notes,
      this.state,
      this.endTime,
      this.labName,
      this.pinCode,
      this.testName,
      this.startTime,
      this.cancelReason,
      this.preferredLab,
      this.addressLine1,
      this.addressLine2,
      this.preferredDate,
      this.modeOfService});

  AdditionalInfo.fromJson(Map<String, dynamic> json) {
    fee = json['fee'];
    city = json['city'];
    notes = json['notes'];
    state = json['state'];
    endTime = json['end_time'];
    labName = json['lab_name'];
    pinCode = json['pin_code'];
    testName = json['test_name'];
    startTime = json['start_time'];
    cancelReason = json['cancelReason'];
    preferredLab = json['preferred_lab'];
    addressLine1 = json['address_line_1'];
    addressLine2 = json['address_line_2'];
    preferredDate = json['preferred_date'];
    modeOfService = json['mode_of_service'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fee'] = this.fee;
    data['city'] = this.city;
    data['notes'] = this.notes;
    data['state'] = this.state;
    data['end_time'] = this.endTime;
    data['lab_name'] = this.labName;
    data['pin_code'] = this.pinCode;
    data['test_name'] = this.testName;
    data['start_time'] = this.startTime;
    data['cancelReason'] = this.cancelReason;
    data['preferred_lab'] = this.preferredLab;
    data['address_line_1'] = this.addressLine1;
    data['address_line_2'] = this.addressLine2;
    data['preferred_date'] = this.preferredDate;
    data['mode_of_service'] = this.modeOfService;
    return data;
  }
}

class BookedFor {
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
  String isTempUser;
  String isVirtualUser;
  String isMigrated;
  String isClaimed;
  bool isIeUser;
  String isEmailVerified;
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
  BookedForAdditionalInfo additionalInfo;

  BookedFor(
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
      this.additionalInfo});

  BookedFor.fromJson(Map<String, dynamic> json) {
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
    additionalInfo = json['additionalInfo'] != null
        ? new BookedForAdditionalInfo.fromJson(json['additionalInfo'])
        : null;
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
    if (this.additionalInfo != null) {
      data['additionalInfo'] = this.additionalInfo.toJson();
    }
    return data;
  }
}

class BookedForAdditionalInfo {
  int age;
  String height;
  String offset;
  String weight;
  String language;
  String mrdNumber;
  String uhidNumber;
  String visitReason;
  String heightUnitCode;
  String patientHistory;
  String weightUnitCode;

  BookedForAdditionalInfo(
      {this.age,
      this.height,
      this.offset,
      this.weight,
      this.language,
      this.mrdNumber,
      this.uhidNumber,
      this.visitReason,
      this.heightUnitCode,
      this.patientHistory,
      this.weightUnitCode});

  BookedForAdditionalInfo.fromJson(Map<String, dynamic> json) {
    age = json['age'];
    height = json['height'];
    offset = json['offset'];
    weight = json['weight'];
    language = json['language'];
    mrdNumber = json['mrdNumber'];
    uhidNumber = json['uhidNumber'];
    visitReason = json['visitReason'];
    heightUnitCode = json['heightUnitCode'];
    patientHistory = json['patientHistory'];
    weightUnitCode = json['weightUnitCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['age'] = this.age;
    data['height'] = this.height;
    data['offset'] = this.offset;
    data['weight'] = this.weight;
    data['language'] = this.language;
    data['mrdNumber'] = this.mrdNumber;
    data['uhidNumber'] = this.uhidNumber;
    data['visitReason'] = this.visitReason;
    data['heightUnitCode'] = this.heightUnitCode;
    data['patientHistory'] = this.patientHistory;
    data['weightUnitCode'] = this.weightUnitCode;
    return data;
  }
}

class BookedBy {
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
  String isTempUser;
  String isVirtualUser;
  String isMigrated;
  String isClaimed;
  bool isIeUser;
  String isEmailVerified;
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
  String additionalInfo;

  BookedBy(
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
      this.additionalInfo});

  BookedBy.fromJson(Map<String, dynamic> json) {
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
    additionalInfo = json['additionalInfo'];
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
    data['additionalInfo'] = this.additionalInfo;
    return data;
  }
}

class Status {
  String id;
  String code;
  String name;
  String description;
  int sortOrder;
  bool isActive;
  String additionalInfo;
  String createdBy;
  String parentId;
  String createdOn;
  String lastModifiedOn;

  Status(
      {this.id,
      this.code,
      this.name,
      this.description,
      this.sortOrder,
      this.isActive,
      this.additionalInfo,
      this.createdBy,
      this.parentId,
      this.createdOn,
      this.lastModifiedOn});

  Status.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    description = json['description'];
    sortOrder = json['sortOrder'];
    isActive = json['isActive'];
    additionalInfo = json['additionalInfo'];
    createdBy = json['createdBy'];
    parentId = json['parentId'];
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
    data['additionalInfo'] = this.additionalInfo;
    data['createdBy'] = this.createdBy;
    data['parentId'] = this.parentId;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    return data;
  }
}

class ServiceCategory {
  String id;
  String code;
  String name;
  String description;
  int sortOrder;
  bool isActive;
  ServiceCategoryAdditionalInfo additionalInfo;
  String createdBy;
  String parentId;
  String createdOn;
  String lastModifiedOn;

  ServiceCategory(
      {this.id,
      this.code,
      this.name,
      this.description,
      this.sortOrder,
      this.isActive,
      this.additionalInfo,
      this.createdBy,
      this.parentId,
      this.createdOn,
      this.lastModifiedOn});

  ServiceCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    description = json['description'];
    sortOrder = json['sortOrder'];
    isActive = json['isActive'];
    additionalInfo = json['additionalInfo'] != null
        ? new ServiceCategoryAdditionalInfo.fromJson(json['additionalInfo'])
        : null;
    createdBy = json['createdBy'];
    parentId = json['parentId'];
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
    if (this.additionalInfo != null) {
      data['additionalInfo'] = this.additionalInfo.toJson();
    }
    data['createdBy'] = this.createdBy;
    data['parentId'] = this.parentId;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    return data;
  }
}

class ServiceCategoryAdditionalInfo {
  List<Field> field;
  String iconUrl;

  ServiceCategoryAdditionalInfo({this.field, this.iconUrl});

  ServiceCategoryAdditionalInfo.fromJson(Map<String, dynamic> json) {
    if (json['field'] != null) {
      field = <Field>[];
      json['field'].forEach((v) {
        field.add(new Field.fromJson(v));
      });
    }
    iconUrl = json['iconUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.field != null) {
      data['field'] = this.field.map((v) => v.toJson()).toList();
    }
    data['iconUrl'] = this.iconUrl;
    return data;
  }
}

class Field {
  String key;
  List<Data> data;
  String type;
  bool isRequired;
  String displayName;
  String placeholder;
  String isVisible;
  bool isDisable;
  bool isLab;

  Field(
      {this.key,
      this.data,
      this.type,
      this.isRequired,
      this.displayName,
      this.placeholder,
      this.isVisible,
      this.isDisable,
      this.isLab});

  Field.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    type = json['type'];
    isRequired = json['is_required'];
    displayName = json['display_name'];
    placeholder = json['placeholder'];
    isVisible = json['is_visible'];
    isDisable = json['isDisable'];
    isLab = json['isLab'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['type'] = this.type;
    data['is_required'] = this.isRequired;
    data['display_name'] = this.displayName;
    data['placeholder'] = this.placeholder;
    data['is_visible'] = this.isVisible;
    data['isDisable'] = this.isDisable;
    data['isLab'] = this.isLab;
    return data;
  }
}

class Data {
  String id;
  String name;

  Data({this.id, this.name});

  Data.fromJson(Map<String, dynamic> json) {
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

class HealthOrganization {
  String id;
  String name;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  BusinessDetail businessDetail;
  String domainUrl;
  bool isDisabled;
  String communicationEmails;
  String emailDomain;
  String specialty;
  bool isHealthPlansActivated;
  bool isOptCaregiveService;
  String revenuePercentage;
  String telehealthRevenue;
  String additionalInfo;
  List<HealthOrganizationAddressCollection> healthOrganizationAddressCollection;

  HealthOrganization(
      {this.id,
      this.name,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn,
      this.businessDetail,
      this.domainUrl,
      this.isDisabled,
      this.communicationEmails,
      this.emailDomain,
      this.specialty,
      this.isHealthPlansActivated,
      this.isOptCaregiveService,
      this.revenuePercentage,
      this.telehealthRevenue,
      this.additionalInfo,
      this.healthOrganizationAddressCollection});

  HealthOrganization.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    businessDetail = json['businessDetail'] != null
        ? new BusinessDetail.fromJson(json['businessDetail'])
        : null;
    domainUrl = json['domainUrl'];
    isDisabled = json['isDisabled'];
    communicationEmails = json['communicationEmails'];
    emailDomain = json['emailDomain'];
    specialty = json['specialty'];
    isHealthPlansActivated = json['isHealthPlansActivated'];
    isOptCaregiveService = json['isOptCaregiveService'];
    revenuePercentage = json['revenuePercentage'];
    telehealthRevenue = json['telehealthRevenue'];
    additionalInfo = json['additionalInfo'];
    if (json['healthOrganizationAddressCollection'] != null) {
      healthOrganizationAddressCollection =
          <HealthOrganizationAddressCollection>[];
      json['healthOrganizationAddressCollection'].forEach((v) {
        healthOrganizationAddressCollection
            .add(new HealthOrganizationAddressCollection.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    if (this.businessDetail != null) {
      data['businessDetail'] = this.businessDetail.toJson();
    }
    data['domainUrl'] = this.domainUrl;
    data['isDisabled'] = this.isDisabled;
    data['communicationEmails'] = this.communicationEmails;
    data['emailDomain'] = this.emailDomain;
    data['specialty'] = this.specialty;
    data['isHealthPlansActivated'] = this.isHealthPlansActivated;
    data['isOptCaregiveService'] = this.isOptCaregiveService;
    data['revenuePercentage'] = this.revenuePercentage;
    data['telehealthRevenue'] = this.telehealthRevenue;
    data['additionalInfo'] = this.additionalInfo;
    if (this.healthOrganizationAddressCollection != null) {
      data['healthOrganizationAddressCollection'] = this
          .healthOrganizationAddressCollection
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class BusinessDetail {
  List<String> documents;
  String gstNumber;

  BusinessDetail({this.documents, this.gstNumber});

  BusinessDetail.fromJson(Map<String, dynamic> json) {
    /*if (json['documents'] != null) {
      documents = <Null>[];
      json['documents'].forEach((v) {
        documents.add(new Null.fromJson(v));
      });
    }
    gstNumber = json['gstNumber'];*/
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    /*if (this.documents != null) {
      data['documents'] = this.documents!.map((v) => v.toJson()).toList();
    }
    data['gstNumber'] = this.gstNumber;*/
    return data;
  }
}

class HealthOrganizationAddressCollection {
  String id;
  String addressLine1;
  String addressLine2;
  String pincode;
  bool isPrimary;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  State state;
  City city;

  HealthOrganizationAddressCollection(
      {this.id,
      this.addressLine1,
      this.addressLine2,
      this.pincode,
      this.isPrimary,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn,
      this.state,
      this.city});

  HealthOrganizationAddressCollection.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addressLine1 = json['addressLine1'];
    addressLine2 = json['addressLine2'];
    pincode = json['pincode'];
    isPrimary = json['isPrimary'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    state = json['state'] != null ? new State.fromJson(json['state']) : null;
    city = json['city'] != null ? new City.fromJson(json['city']) : null;
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
    if (this.state != null) {
      data['state'] = this.state.toJson();
    }
    if (this.city != null) {
      data['city'] = this.city.toJson();
    }
    return data;
  }
}

class State {
  String id;
  String name;
  String countryCode;
  bool isActive;
  String createdOn;
  String lastModifiedOn;

  State(
      {this.id,
      this.name,
      this.countryCode,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn});

  State.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    countryCode = json['countryCode'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['countryCode'] = this.countryCode;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    return data;
  }
}

class City {
  String id;
  String name;
  bool isActive;
  String createdOn;
  String lastModifiedOn;

  City(
      {this.id, this.name, this.isActive, this.createdOn, this.lastModifiedOn});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    return data;
  }
}

class FeeDetails {
  int paidAmount;
  int doctorCancellationCharge;
  int finalRefundAmount;
  String paymentMode;

  FeeDetails(
      {this.paidAmount,
      this.doctorCancellationCharge,
      this.finalRefundAmount,
      this.paymentMode});

  FeeDetails.fromJson(Map<String, dynamic> json) {
    paidAmount = json['paidAmount'];
    doctorCancellationCharge = json['doctorCancellationCharge'];
    finalRefundAmount = json['finalRefundAmount'];
    paymentMode = json['paymentMode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paidAmount'] = this.paidAmount;
    data['doctorCancellationCharge'] = this.doctorCancellationCharge;
    data['finalRefundAmount'] = this.finalRefundAmount;
    data['paymentMode'] = this.paymentMode;
    return data;
  }
}

class HealthRecord {
  String notes;
  String voice;
  List<String> associatedRecords;
  List<String> bills;
  List<String> others;
  List<String> prescription;

  HealthRecord(
      {this.notes,
      this.voice,
      this.associatedRecords,
      this.bills,
      this.others,
      this.prescription});

  HealthRecord.fromJson(Map<String, dynamic> json) {
    /*notes = json['notes'];
    voice = json['voice'];
    if (json['associatedRecords'] != null) {
      associatedRecords = <Null>[];
      json['associatedRecords'].forEach((v) {
        associatedRecords!.add(new Null.fromJson(v));
      });
    }
    if (json['bills'] != null) {
      bills = <Null>[];
      json['bills'].forEach((v) {
        bills!.add(new Null.fromJson(v));
      });
    }
    if (json['others'] != null) {
      others = <Null>[];
      json['others'].forEach((v) {
        others!.add(new Null.fromJson(v));
      });
    }
    if (json['prescription'] != null) {
      prescription = <Null>[];
      json['prescription'].forEach((v) {
        prescription!.add(new Null.fromJson(v));
      });
    }*/
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    /*data['notes'] = this.notes;
    data['voice'] = this.voice;
    if (this.associatedRecords != null) {
      data['associatedRecords'] =
          this.associatedRecords!.map((v) => v.toJson()).toList();
    }
    if (this.bills != null) {
      data['bills'] = this.bills!.map((v) => v.toJson()).toList();
    }
    if (this.others != null) {
      data['others'] = this.others!.map((v) => v.toJson()).toList();
    }
    if (this.prescription != null) {
      data['prescription'] = this.prescription!.map((v) => v.toJson()).toList();
    }*/
    return data;
  }
}
