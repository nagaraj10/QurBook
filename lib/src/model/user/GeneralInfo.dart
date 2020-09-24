import 'package:myfhb/src/model/user/City.dart';
import 'package:myfhb/src/model/user/ProfilePicThumbnail.dart';
import 'package:myfhb/src/model/user/QualifiedFullName.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/src/model/user/State.dart';

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
  String mappedDoctorId;
  String profilePicThumbnailURL;
  String addressLine1;
  String addressLine2;
  String pincode;
  City city;
  State state;

  GeneralInfo({
    this.name,
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
    this.profilePicThumbnail,
    this.qualifiedFullName,
    this.mappedDoctorId,
    this.profilePicThumbnailURL,
    this.addressLine1,
    this.addressLine2,
    this.pincode,
    this.city,
    this.state,
  });

  GeneralInfo.fromJson(Map<String, dynamic> json) {
    name = json[parameters.strName];
    countryCode = json[parameters.strCountryCode];
    phoneNumber = json[parameters.strPhoneNumber];
    email = json[parameters.strEmail];
    gender = json[parameters.strGender];
    bloodGroup = json[parameters.strbloodGroup];
    createdBy = json[parameters.strCreatedBy];
    isEmailVerified = json[parameters.strisEmailVerified];
    isVirtualUser = json[parameters.strisVirtualUser];
    isTempUser = json[parameters.strIstemper];
    createdOn = json[parameters.strCreatedOn];
    lastModifiedOn = json[parameters.strLastModifiedOn];
    dateOfBirth = json[parameters.strdateOfBirth];
    profilePicThumbnail = json[parameters.strprofilePicThumbnail] != null
        ? new ProfilePicThumbnailMain.fromJson(
            json[parameters.strprofilePicThumbnail])
        : null;
    qualifiedFullName = json[parameters.strqualifiedFullName] != null
        ? new QualifiedFullName.fromJson(json[parameters.strqualifiedFullName])
        : null;
    mappedDoctorId = json[parameters.strMappedDoctorId];
    profilePicThumbnailURL = json[parameters.strProfilePicThumbnailURL];
    addressLine1 = json[parameters.strAddressLine1];
    addressLine2 = json[parameters.strAddressLine2];
    pincode = json[parameters.strpincode];
    city = json[parameters.strCity] != null
        ? new City.fromJson(json[parameters.strCity])
        : null;
    state = json[parameters.strState] != null
        ? new State.fromJson(json[parameters.strState])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strName] = this.name;
    data[parameters.strCountryCode] = this.countryCode;
    data[parameters.strPhoneNumber] = this.phoneNumber;
    data[parameters.strEmail] = this.email;
    data[parameters.strGender] = this.gender;
    data[parameters.strbloodGroup] = this.bloodGroup;
    data[parameters.strCreatedBy] = this.createdBy;
    data[parameters.strisEmailVerified] = this.isEmailVerified;
    data[parameters.strisVirtualUser] = this.isVirtualUser;
    data[parameters.strIstemper] = this.isTempUser;
    data[parameters.strCreatedOn] = this.createdOn;
    data[parameters.strLastModifiedOn] = this.lastModifiedOn;
    data[parameters.strdateOfBirth] = this.dateOfBirth;
    if (this.profilePicThumbnail != null) {
      data[parameters.strprofilePicThumbnail] =
          this.profilePicThumbnail.toJson();
    }
    if (this.qualifiedFullName != null) {
      data[parameters.strqualifiedFullName] = this.qualifiedFullName.toJson();
    }
    data[parameters.strMappedDoctorId] = this.mappedDoctorId;
    data[parameters.strProfilePicThumbnailURL] = this.profilePicThumbnailURL;
    data[parameters.strAddressLine1] = this.addressLine1;
    data[parameters.strAddressLine2] = this.addressLine2;
    data[parameters.strpincode] = this.pincode;
    if (this.city != null) {
      data[parameters.strCity] = this.city.toJson();
    }
    if (this.state != null) {
      data[parameters.strState] = this.state.toJson();
    }
    return data;
  }
}
