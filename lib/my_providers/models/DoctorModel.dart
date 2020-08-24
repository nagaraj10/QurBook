import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
import 'package:myfhb/my_providers/models/ProfilePic.dart';

class DoctorsModel {
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
  String latitude;
  String longitude;
  bool isActive;
  String specialization;
  bool isUserDefined;
  String description;
  String createdBy;
  String lastModifiedOn;
  ProfilePic profilePic;
  ProfilePic profilePicThumbnail;
  bool isDefault;

  DoctorsModel(
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
      this.latitude,
      this.longitude,
      this.isActive,
      this.specialization,
      this.isUserDefined,
      this.description,
      this.createdBy,
      this.lastModifiedOn,
      this.profilePic,
      this.profilePicThumbnail,
      this.isDefault});

  DoctorsModel.fromJson(Map<String, dynamic> json) {
    id = json[parameters.strId];
    name = json[parameters.strName];
    addressLine1 = json[parameters.strAddressLine1];
    addressLine2 = json[parameters.strAddressLine2];
    website = json[parameters.strWebsite];
    googleMapUrl = json[parameters.strGoogleMapUrl];
    phoneNumber1 = json[parameters.strPhoneNumber1];
    phoneNumber2 = json[parameters.strPhoneNumber2];
    phoneNumber3 = json[parameters.strPhoneNumber3];
    phoneNumber4 = json[parameters.strPhoneNumber4];
    email = json[parameters.strEmail];
    state = json[parameters.strState];
    city = json[parameters.strCity];
    latitude = json[parameters.strLatitude];
    longitude = json[parameters.strLongitute];
    isActive = json[parameters.strIsActive];
    specialization = json[parameters.strSpecilization];
    isUserDefined = json[parameters.strIsUserDefined];
    description = json[parameters.strDescription];
    createdBy = json[parameters.strCreatedBy];
    lastModifiedOn = json[parameters.strLastModifiedOn];
    profilePic = json[parameters.strprofilePic] != null
        ? new ProfilePic.fromJson(json[parameters.strprofilePic])
        : null;
    profilePicThumbnail = json[parameters.strprofilePicThumbnail] != null
        ? new ProfilePic.fromJson(json[parameters.strprofilePicThumbnail])
        : null;
    isDefault = json[parameters.strisDefault];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strId] = this.id;
    data[parameters.strName] = this.name;
    data[parameters.strAddressLine1] = this.addressLine1;
    data[parameters.strAddressLine2] = this.addressLine2;
    data[parameters.strWebsite] = this.website;
    data[parameters.strGoogleMapUrl] = this.googleMapUrl;
    data[parameters.strPhoneNumber1] = this.phoneNumber1;
    data[parameters.strPhoneNumber2] = this.phoneNumber2;
    data[parameters.strPhoneNumber3] = this.phoneNumber3;
    data[parameters.strPhoneNumber4] = this.phoneNumber4;
    data[parameters.strEmail] = this.email;
    data[parameters.strState] = this.state;
    data[parameters.strCity] = this.city;
    data[parameters.strLatitude] = this.latitude;
    data[parameters.strLongitute] = this.longitude;
    data[parameters.strIsActive] = this.isActive;
    data[parameters.strSpecilization] = this.specialization;
    data[parameters.strIsUserDefined] = this.isUserDefined;
    data[parameters.strDescription] = this.description;
    data[parameters.strCreatedBy] = this.createdBy;
    data[parameters.strLastModifiedOn] = this.lastModifiedOn;
    if (this.profilePic != null) {
      data[parameters.strprofilePic] = this.profilePic.toJson();
    }
    if (this.profilePicThumbnail != null) {
      data[parameters.strprofilePicThumbnail] =
          this.profilePicThumbnail.toJson();
    }
    data[parameters.strisDefault] = this.isDefault;
    return data;
  }
}
