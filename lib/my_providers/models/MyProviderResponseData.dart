import 'Doctors.dart';
import 'Hospitals.dart';

class MyProvidersResponseData {
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
  List<Doctors> doctors;
  List<Hospitals> hospitals;
  List<Hospitals> labs;
  List<Hospitals> clinics;

  MyProvidersResponseData(
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
        this.doctors,
        this.hospitals,
        this.labs,
        this.clinics});

  MyProvidersResponseData.fromJson(Map<String, dynamic> json) {
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
    if (json['doctors'] != null) {
      doctors = List<Doctors>();
      json['doctors'].forEach((v) {
        doctors.add(Doctors.fromJson(v));
      });
    }
    if (json['hospitals'] != null) {
      hospitals = List<Hospitals>();
      json['hospitals'].forEach((v) {
        hospitals.add(Hospitals.fromJson(v));
      });
    }
    if (json['labs'] != null) {
      labs = <Hospitals>[];
      json['labs'].forEach((v) {
        labs.add(Hospitals.fromJson(v));
      });
    }
    if (json['clinics'] != null) {
      clinics = <Hospitals>[];
      json['clinics'].forEach((v) {
        clinics.add(Hospitals.fromJson(v));
      });
    }
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
    if (doctors != null) {
      data['doctors'] = doctors.map((v) => v.toJson()).toList();
    }
    if (hospitals != null) {
      data['hospitals'] = hospitals.map((v) => v.toJson()).toList();
    }
    if (labs != null) {
      data['labs'] = labs.map((v) => v.toJson()).toList();
    }
    if (clinics != null) {
      data['clinics'] = clinics.map((v) => v.toJson()).toList();
    }
    return data;
  }
}