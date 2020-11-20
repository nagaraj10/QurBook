import 'package:myfhb/src/model/user/ProfilePicThumbnail.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class DoctorIds {
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
  ProfilePicThumbnailMain profilePic;
  ProfilePicThumbnailMain profilePicThumbnail;
  bool isDefault;

  DoctorIds(
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
      this.lastModifiedOn,
      this.profilePic,
      this.profilePicThumbnail,
      this.isDefault});

  DoctorIds.fromJson(Map<String, dynamic> json) {
    id = json[parameters.strId];
    createdBy = json[parameters.strCreatedBy];
    name = json[parameters.strName];
    phoneNumber1 = json[parameters.strPhoneNumber1];
    phoneNumber2 = json[parameters.strPhoneNumber2];
    phoneNumber3 = json[parameters.strPhoneNumber3];
    phoneNumber4 = json[parameters.strPhoneNumber4];
    addressLine1 = json[parameters.strAddressLine1];
    addressLine2 = json[parameters.strAddressLine2];
    city = json[parameters.strCity];
    state = json[parameters.strState];

    website = json[parameters.strWebsite];
    email = json[parameters.strEmail];
    googleMapUrl = json[parameters.strGoogleMapUrl];
    isUserDefined = json[parameters.strIsUserDefined];
    description = json[parameters.strDescription];
    isActive = json[parameters.strIsActive];
    lastModifiedOn = json[parameters.strLastModifiedOn];
    isDefault = json[parameters.strisDefault];
    createdBy = json[parameters.strCreatedBy];

    profilePic = json[parameters.strprofilePic] != null
        ? new ProfilePicThumbnailMain.fromJson(json[parameters.strprofilePic])
        : null;
    profilePicThumbnail = json[parameters.strprofilePicThumbnail] != null
        ? new ProfilePicThumbnailMain.fromJson(
            json[parameters.strprofilePicThumbnail])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data[parameters.strId] = this.id;
    data[parameters.strCreatedBy] = this.createdBy;
    data[parameters.strName] = this.name;
    data[parameters.strPhoneNumber1] = this.phoneNumber1;
    data[parameters.strPhoneNumber2] = this.phoneNumber2;
    data[parameters.strPhoneNumber3] = this.phoneNumber3;
    data[parameters.strPhoneNumber4] = this.phoneNumber4;
    data[parameters.strAddressLine1] = this.addressLine1;
    data[parameters.strAddressLine2] = this.addressLine2;
    data[parameters.strCity] = this.city;
    data[parameters.strState] = this.state;
    data[parameters.strWebsite] = this.website;
    data[parameters.strEmail] = this.email;
    data[parameters.strGoogleMapUrl] = this.googleMapUrl;
    data[parameters.strIsUserDefined] = this.isUserDefined;
    data[parameters.strDescription] = this.description;
    data[parameters.strIsActive] = this.isActive;
    data[parameters.strCreatedBy] = this.createdBy;
    data[parameters.strLastModifiedOn] = this.lastModifiedOn;
    data[parameters.strisDefault] = this.isDefault;
    data[parameters.strprofilePic] = this.profilePic;
    data[parameters.strprofilePicThumbnail] = this.profilePicThumbnail;

    return data;
  }
}
