import '../../../constants/fhb_parameters.dart' as parameters;
import 'DoctorIds.dart';
import 'HospitalIds.dart';
import 'LaboratoryIds.dart';
import 'ProfilePicThumbnail.dart';

class ProfileCompleteData {
  int status;
  bool success;
  String message;
  Response response;

  ProfileCompleteData({this.status, this.success, this.message, this.response});

  ProfileCompleteData.fromJson(Map<String, dynamic> json) {
     status = json[parameters.strStatus];
    success = json[parameters.strSuccess];
    message = json[parameters.strMessage];
    response = json[parameters.strResponse] != null
        ? Response.fromJson(json[parameters.strResponse])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[parameters.strStatus] = status;
    data[parameters.strSuccess] = success;
    data[parameters.strMessage] = message;
    if (response != null) {
      data[parameters.strResponse] = response.toJson();
    }
    return data;
  }
}

class Response {
  int count;
  MyProfileData data;

  Response({this.count, this.data});

  Response.fromJson(Map<String, dynamic> json) {
    count = json[parameters.strCount];
    data =
        json[parameters.strData] != null ? MyProfileData.fromJson(json[parameters.strData]) : null;
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data[parameters.strCount] = count;
    if (this.data != null) {
      data[parameters.strData] = this.data.toJson();
    }
    return data;
  }
}

class MyProfileData {
  String id;
  String name;
  String phoneNumber;
  String email;
  String gender;
  //Null communicationPreferences;
  MedicalPreferences medicalPreferences;
  bool isActive;
  bool isTempUser;
  bool isVirtualUser;
  String createdOn;
  String createdBy;
  String lastModifiedOn;
  String dateOfBirth;
  bool isEmailVerified;
  String bloodGroup;
  ProfilePicThumbnailMain profilePicThumbnail;
  int oid;
  String countryCode;
//  QualifiedFullName qualifiedFullName;

  MyProfileData(
      {this.id,
      this.name,
      this.phoneNumber,
      this.email,
      this.gender,
      //this.communicationPreferences,
      this.medicalPreferences,
      this.isActive,
      this.isTempUser,
      this.isVirtualUser,
      this.createdOn,
      this.createdBy,
      this.lastModifiedOn,
      this.dateOfBirth,
      this.isEmailVerified,
      this.bloodGroup,
      this.profilePicThumbnail,
      this.oid,
      this.countryCode,/*this.qualifiedFullName*/});

  MyProfileData.fromJson(Map<String, dynamic> json) {
    id = json[parameters.strData];
    name = json[parameters.strName];
    phoneNumber = json[parameters.strPhoneNumber];
    email = json[parameters.strEmail];
    gender = json[parameters.strGender];
    //communicationPreferences = json['communicationPreferences'];
    medicalPreferences = json[parameters.strmedicalPreferences] != null
        ? MedicalPreferences.fromJson(json[parameters.strmedicalPreferences])
        : null;
    isActive = json[parameters.strIsActive];
    isTempUser = json[parameters.strIstemper];
    isVirtualUser = json[parameters.strisVirtualUser];
    createdOn = json[parameters.strCreatedOn];
    createdBy = json[parameters.strCreatedBy];
    lastModifiedOn = json[parameters.strLastModifiedOn];
    dateOfBirth = json[parameters.strdateOfBirth];
    isEmailVerified = json[parameters.strisEmailVerified];
    bloodGroup = json[parameters.strbloodGroup];
    profilePicThumbnail = json[parameters.strprofilePicThumbnail] != null
        ? ProfilePicThumbnailMain.fromJson(json[parameters.strprofilePicThumbnail])
        : null;
    oid = json[parameters.stroid];
    countryCode = json[parameters.strCountryCode];
    /*qualifiedFullName = json[parameters.strqualifiedFullName] != null
        ? new QualifiedFullName.fromJson(json[parameters.strqualifiedFullName])
        : null;*/
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[parameters.strId] = id;
    data[parameters.strName] = name;
    data[parameters.strPhoneNumber] = phoneNumber;
    data[parameters.strEmail] = email;
    data[parameters.strGender] = gender;
    //data['communicationPreferences'] = this.communicationPreferences;
    if (medicalPreferences != null) {
      data[parameters.strmedicalPreferences] = medicalPreferences.toJson();
    }
    data[parameters.strIsActive] = isActive;
    data[parameters.strIstemper] = isTempUser;
    data[parameters.strisVirtualUser] = isVirtualUser;
    data[parameters.strCreatedOn] = createdOn;
    data[parameters.strCreatedBy] = createdBy;
    data[parameters.strLastModifiedOn] = lastModifiedOn;
    data[parameters.strdateOfBirth] = dateOfBirth;
    data[parameters.strisEmailVerified] = isEmailVerified;
    data[parameters.strbloodGroup] = bloodGroup;
    if (profilePicThumbnail != null) {
      data[parameters.strprofilePicThumbnail] = profilePicThumbnail.toJson();
    }
    data[parameters.stroid] = oid;
    data[parameters.strCountryCode] = countryCode;
    /*if (this.qualifiedFullName != null) {
      data[parameters.strqualifiedFullName] = this.qualifiedFullName.toJson();
    }*/
    return data;
  }
}

class MedicalPreferences {
  Preferences preferences;

  MedicalPreferences({this.preferences});

  MedicalPreferences.fromJson(Map<String, dynamic> json) {
    preferences = json[parameters.strpreferences] != null
        ? Preferences.fromJson(json[parameters.strpreferences])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (preferences != null) {
      data[parameters.strpreferences] = preferences.toJson();
    }
    return data;
  }
}

class Preferences {
  List<DoctorIds> doctorIds;
  List<HospitalIds> hospitalIds;
  List<LaboratoryIds> laboratoryIds;

  Preferences({this.doctorIds, this.hospitalIds, this.laboratoryIds});

  Preferences.fromJson(Map<String, dynamic> json) {
    if (json[parameters.strdoctorIds] != null) {
      doctorIds = <DoctorIds>[];
      json[parameters.strdoctorIds].forEach((v) {
        doctorIds.add(DoctorIds.fromJson(v));
      });
    }
    if (json[parameters.strhospitalIds] != null) {
      hospitalIds = List<HospitalIds>();
      json[parameters.strhospitalIds].forEach((v) {
        hospitalIds.add(HospitalIds.fromJson(v));
      });
    }
    if (json[parameters.strlaboratoryIds] != null) {
      laboratoryIds = List<LaboratoryIds>();
      json[parameters.strlaboratoryIds].forEach((v) {
        laboratoryIds.add(LaboratoryIds.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    if (doctorIds != null) {
      data[parameters.strdoctorIds] = doctorIds.map((v) => v.toJson()).toList();
    }
    if (hospitalIds != null) {
      data[parameters.strhospitalIds] = hospitalIds.map((v) => v.toJson()).toList();
    }
    if (laboratoryIds != null) {
      data[parameters.strlaboratoryIds] =
          laboratoryIds.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


