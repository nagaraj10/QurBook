import 'package:myfhb/src/model/user/ProfilePicThumbnail.dart';
import 'package:myfhb/src/model/user/QualifiedFullName.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class GeneralInfo {
  String name;
  String countryCode;
  String phoneNumber;
  String email;
  String gender;
  String bloodGroup;
  String createdBy;
  bool isEmailVerified;
  bool isVirtualUser;
  bool isTempUser;
  String createdOn;
  String lastModifiedOn;
  String dateOfBirth;
  ProfilePicThumbnailMain profilePicThumbnail;
  QualifiedFullName qualifiedFullName;

  GeneralInfo(
      {this.name,
      this.countryCode,
      this.phoneNumber,
      this.email,
      this.gender,
      this.bloodGroup,
      this.createdBy,
      this.isEmailVerified,
      this.isVirtualUser,
      this.isTempUser,
      this.createdOn,
      this.lastModifiedOn,
      this.dateOfBirth,
      this.profilePicThumbnail});

  GeneralInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    countryCode = json['countryCode'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    gender = json['gender'];
    bloodGroup = json['bloodGroup'];
    createdBy = json['createdBy'];
    isEmailVerified = json['isEmailVerified'];
    isVirtualUser = json['isVirtualUser'];
    isTempUser = json['isTempUser'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    dateOfBirth = json['dateOfBirth'];
    profilePicThumbnail = json['profilePicThumbnail'] != null
        ? new ProfilePicThumbnailMain.fromJson(json['profilePicThumbnail'])
        : null;
         qualifiedFullName = json['qualifiedFullName'] != null
        ? new QualifiedFullName.fromJson(json['qualifiedFullName'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['countryCode'] = this.countryCode;
    data['phoneNumber'] = this.phoneNumber;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['bloodGroup'] = this.bloodGroup;
    data['createdBy'] = this.createdBy;
    data['isEmailVerified'] = this.isEmailVerified;
    data['isVirtualUser'] = this.isVirtualUser;
    data['isTempUser'] = this.isTempUser;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    data['dateOfBirth'] = this.dateOfBirth;
    if (this.profilePicThumbnail != null) {
      data['profilePicThumbnail'] = this.profilePicThumbnail.toJson();
    }
     if (this.qualifiedFullName != null) {
      data['qualifiedFullName'] = this.qualifiedFullName.toJson();
    }
    return data;
  }
}