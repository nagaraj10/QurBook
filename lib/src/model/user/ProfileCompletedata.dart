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
    count = json['count'];
    data =
        json['data'] != null ? new MyProfileData.fromJson(json['data']) : null;
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
    id = json['id'];
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    gender = json['gender'];
    //communicationPreferences = json['communicationPreferences'];
    medicalPreferences = json['medicalPreferences'] != null
        ? new MedicalPreferences.fromJson(json['medicalPreferences'])
        : null;
    isActive = json['isActive'];
    isTempUser = json['isTempUser'];
    isVirtualUser = json['isVirtualUser'];
    createdOn = json['createdOn'];
    createdBy = json['createdBy'];
    lastModifiedOn = json['lastModifiedOn'];
    dateOfBirth = json['dateOfBirth'];
    isEmailVerified = json['isEmailVerified'];
    bloodGroup = json['bloodGroup'];
    profilePicThumbnail = json['profilePicThumbnail'] != null
        ? new ProfilePicThumbnailMain.fromJson(json['profilePicThumbnail'])
        : null;
    oid = json['oid'];
    countryCode = json['countryCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phoneNumber'] = this.phoneNumber;
    data['email'] = this.email;
    data['gender'] = this.gender;
    //data['communicationPreferences'] = this.communicationPreferences;
    if (this.medicalPreferences != null) {
      data['medicalPreferences'] = this.medicalPreferences.toJson();
    }
    data['isActive'] = this.isActive;
    data['isTempUser'] = this.isTempUser;
    data['isVirtualUser'] = this.isVirtualUser;
    data['createdOn'] = this.createdOn;
    data['createdBy'] = this.createdBy;
    data['lastModifiedOn'] = this.lastModifiedOn;
    data['dateOfBirth'] = this.dateOfBirth;
    data['isEmailVerified'] = this.isEmailVerified;
    data['bloodGroup'] = this.bloodGroup;
    if (this.profilePicThumbnail != null) {
      data['profilePicThumbnail'] = this.profilePicThumbnail.toJson();
    }
    data['oid'] = this.oid;
    data['countryCode'] = this.countryCode;
    return data;
  }
}

class MedicalPreferences {
  Preferences preferences;

  MedicalPreferences({this.preferences});

  MedicalPreferences.fromJson(Map<String, dynamic> json) {
    preferences = json['preferences'] != null
        ? new Preferences.fromJson(json['preferences'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.preferences != null) {
      data['preferences'] = this.preferences.toJson();
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
    if (json['doctorIds'] != null) {
      doctorIds = new List<DoctorIds>();
      json['doctorIds'].forEach((v) {
        doctorIds.add(new DoctorIds.fromJson(v));
      });
    }
    if (json['hospitalIds'] != null) {
      hospitalIds = new List<HospitalIds>();
      json['hospitalIds'].forEach((v) {
        hospitalIds.add(new HospitalIds.fromJson(v));
      });
    }
    if (json['laboratoryIds'] != null) {
      laboratoryIds = new List<LaboratoryIds>();
      json['laboratoryIds'].forEach((v) {
        laboratoryIds.add(new LaboratoryIds.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.doctorIds != null) {
      data['doctorIds'] = this.doctorIds.map((v) => v.toJson()).toList();
    }
    if (this.hospitalIds != null) {
      data['hospitalIds'] = this.hospitalIds.map((v) => v.toJson()).toList();
    }
    if (this.laboratoryIds != null) {
      data['laboratoryIds'] =
          this.laboratoryIds.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


