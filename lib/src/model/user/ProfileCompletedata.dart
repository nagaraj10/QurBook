import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/src/model/user/DoctorIds.dart';
import 'package:myfhb/src/model/user/HospitalIds.dart';
import 'package:myfhb/src/model/user/LaboratoryIds.dart';
import 'package:myfhb/src/model/user/ProfilePicThumbnail.dart';

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
        ? new Response.fromJson(json[parameters.strResponse])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strStatus] = this.status;
    data[parameters.strSuccess] = this.success;
    data[parameters.strMessage] = this.message;
    if (this.response != null) {
      data[parameters.strResponse] = this.response.toJson();
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
        json[parameters.strData] != null ? new MyProfileData.fromJson(json[parameters.strData]) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strCount] = this.count;
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
      this.countryCode});

  MyProfileData.fromJson(Map<String, dynamic> json) {
    id = json[parameters.strData];
    name = json[parameters.strName];
    phoneNumber = json[parameters.strPhoneNumber];
    email = json[parameters.strEmail];
    gender = json[parameters.strGender];
    //communicationPreferences = json['communicationPreferences'];
    medicalPreferences = json[parameters.strmedicalPreferences] != null
        ? new MedicalPreferences.fromJson(json[parameters.strmedicalPreferences])
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
        ? new ProfilePicThumbnailMain.fromJson(json[parameters.strprofilePicThumbnail])
        : null;
    oid = json[parameters.stroid];
    countryCode = json[parameters.strCountryCode];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strId] = this.id;
    data[parameters.strName] = this.name;
    data[parameters.strPhoneNumber] = this.phoneNumber;
    data[parameters.strEmail] = this.email;
    data[parameters.strGender] = this.gender;
    //data['communicationPreferences'] = this.communicationPreferences;
    if (this.medicalPreferences != null) {
      data[parameters.strmedicalPreferences] = this.medicalPreferences.toJson();
    }
    data[parameters.strIsActive] = this.isActive;
    data[parameters.strIstemper] = this.isTempUser;
    data[parameters.strisVirtualUser] = this.isVirtualUser;
    data[parameters.strCreatedOn] = this.createdOn;
    data[parameters.strCreatedBy] = this.createdBy;
    data[parameters.strLastModifiedOn] = this.lastModifiedOn;
    data[parameters.strdateOfBirth] = this.dateOfBirth;
    data[parameters.strisEmailVerified] = this.isEmailVerified;
    data[parameters.strbloodGroup] = this.bloodGroup;
    if (this.profilePicThumbnail != null) {
      data[parameters.strprofilePicThumbnail] = this.profilePicThumbnail.toJson();
    }
    data[parameters.stroid] = this.oid;
    data[parameters.strCountryCode] = this.countryCode;
    return data;
  }
}

class MedicalPreferences {
  Preferences preferences;

  MedicalPreferences({this.preferences});

  MedicalPreferences.fromJson(Map<String, dynamic> json) {
    preferences = json[parameters.strpreferences] != null
        ? new Preferences.fromJson(json[parameters.strpreferences])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.preferences != null) {
      data[parameters.strpreferences] = this.preferences.toJson();
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
      doctorIds = new List<DoctorIds>();
      json[parameters.strdoctorIds].forEach((v) {
        doctorIds.add(new DoctorIds.fromJson(v));
      });
    }
    if (json[parameters.strhospitalIds] != null) {
      hospitalIds = new List<HospitalIds>();
      json[parameters.strhospitalIds].forEach((v) {
        hospitalIds.add(new HospitalIds.fromJson(v));
      });
    }
    if (json[parameters.strlaboratoryIds] != null) {
      laboratoryIds = new List<LaboratoryIds>();
      json[parameters.strlaboratoryIds].forEach((v) {
        laboratoryIds.add(new LaboratoryIds.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.doctorIds != null) {
      data[parameters.strdoctorIds] = this.doctorIds.map((v) => v.toJson()).toList();
    }
    if (this.hospitalIds != null) {
      data[parameters.strhospitalIds] = this.hospitalIds.map((v) => v.toJson()).toList();
    }
    if (this.laboratoryIds != null) {
      data[parameters.strlaboratoryIds] =
          this.laboratoryIds.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


