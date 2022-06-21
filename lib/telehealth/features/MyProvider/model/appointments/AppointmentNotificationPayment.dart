import 'package:myfhb/my_providers/models/User.dart';

class AppointmentNotificationPayment {
  bool isSuccess;
  Result result;

  AppointmentNotificationPayment({this.isSuccess, this.result});

  AppointmentNotificationPayment.fromJson(Map<String, dynamic> json) {
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
  Appointment appointment;
  Doctor doctor;
  Payment payment;


  Result({this.appointment, this.doctor});

  Result.fromJson(Map<String, dynamic> json) {
    appointment = json['appointment'] != null
        ? new Appointment.fromJson(json['appointment'])
        : null;
    doctor =
    json['doctor'] != null ? new Doctor.fromJson(json['doctor']) : null;
    if(json.containsKey('payment')) {
      payment =
      json['payment'] != null ? new Payment.fromJson(json['payment']) : null;
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.appointment != null) {
      data['appointment'] = this.appointment.toJson();
    }
    if (this.doctor != null) {
      data['doctor'] = this.doctor.toJson();
    }
    if (this.payment != null) {
      data['payment'] = this.payment.toJson();
    }
    return data;
  }
}

class Appointment {
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
  bool isFollowup;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  bool isBookedByProvider;
  bool isCallDenied;
  AppointmentStatus status;
  BookedFor bookedFor;

  Appointment(
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
        this.status,
        this.bookedFor});

  Appointment.fromJson(Map<String, dynamic> json) {
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
    status =
    json['status'] != null ? new AppointmentStatus.fromJson(json['status']) : null;
    bookedFor = json['bookedFor'] != null
        ? new BookedFor.fromJson(json['bookedFor'])
        : null;
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
    if (this.status != null) {
      data['status'] = this.status.toJson();
    }
    if (this.bookedFor != null) {
      data['bookedFor'] = this.bookedFor.toJson();
    }
    return data;
  }
}

class AppointmentStatus {
  String id;
  String code;
  String name;
  String description;
  int sortOrder;
  bool isActive;
  String createdBy;
  String createdOn;
  String lastModifiedOn;

  AppointmentStatus(
      {this.id,
        this.code,
        this.name,
        this.description,
        this.sortOrder,
        this.isActive,
        this.createdBy,
        this.createdOn,
        this.lastModifiedOn});

  AppointmentStatus.fromJson(Map<String, dynamic> json) {
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
  String providerId;
  AdditionalInfo additionalInfo;

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
    providerId = json['providerId'];
    additionalInfo = json['additionalInfo'] != null
        ? new AdditionalInfo.fromJson(json['additionalInfo'])
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
    data['providerId'] = this.providerId;
    if (this.additionalInfo != null) {
      data['additionalInfo'] = this.additionalInfo.toJson();
    }
    return data;
  }
}

class AdditionalInfo {
  int age;
  String height;
  String offset;
  String weight;
  List<String>  language;
  String mrdNumber;
  String uhidNumber;
  String visitReason;
  String patientHistory;

  AdditionalInfo(
      {this.age,
        this.height,
        this.offset,
        this.weight,
        this.language,
        this.mrdNumber,
        this.uhidNumber,
        this.visitReason,
        this.patientHistory});

  AdditionalInfo.fromJson(Map<String, dynamic> json) {
    age = json['age'];
    height = json['height'];
    offset = json['offset'];
    weight = json['weight'];
    language = json['language'];
    mrdNumber = json['mrdNumber'];
    uhidNumber = json['uhidNumber'];
    visitReason = json['visitReason'];
    patientHistory = json['patientHistory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['age'] = this.age;
    data['height'] = this.height;
    data['offset'] = this.offset;
    data['weight'] = this.weight;
    if (data.containsKey('language')) {
      language = data['language'].cast<String>();
    }    data['mrdNumber'] = this.mrdNumber;
    data['uhidNumber'] = this.uhidNumber;
    data['visitReason'] = this.visitReason;
    data['patientHistory'] = this.patientHistory;
    return data;
  }
}

class Doctor {
  String id;
  String specialization;
  bool isTelehealthEnabled;
  bool isMciVerified;
  bool isActive;
  bool isWelcomeMailSent;
  String createdOn;
  String lastModifiedBy;
  String lastModifiedOn;
  String isResident;
  BusinessDetail businessDetail;
  User user;

  Doctor(
      {this.id,
        this.specialization,
        this.isTelehealthEnabled,
        this.isMciVerified,
        this.isActive,
        this.isWelcomeMailSent,
        this.createdOn,
        this.lastModifiedBy,
        this.lastModifiedOn,
        this.isResident,
        this.businessDetail,
        this.user});

  Doctor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    specialization = json['specialization'];
    isTelehealthEnabled = json['isTelehealthEnabled'];
    isMciVerified = json['isMciVerified'];
    isActive = json['isActive'];
    isWelcomeMailSent = json['isWelcomeMailSent'];
    createdOn = json['createdOn'];
    lastModifiedBy = json['lastModifiedBy'];
    lastModifiedOn = json['lastModifiedOn'];
    isResident = json['isResident'];
    businessDetail = json['businessDetail'] != null
        ? new BusinessDetail.fromJson(json['businessDetail'])
        : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
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
    data['isResident'] = this.isResident;
    if (this.businessDetail != null) {
      data['businessDetail'] = this.businessDetail.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class BusinessDetail {
  int experience;

  BusinessDetail({this.experience});

  BusinessDetail.fromJson(Map<String, dynamic> json) {
    experience = json['experience'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['experience'] = this.experience;
    return data;
  }


}

class Payment {
  String id;
  String longUrl;
  String amount;

  Payment({this.id, this.longUrl, this.amount});

  Payment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    longUrl = json['longUrl'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['longUrl'] = this.longUrl;
    data['amount'] = this.amount;
    return data;
  }
}

