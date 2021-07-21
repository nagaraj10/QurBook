import 'ProfilePicThumbnail.dart';
import '../../../constants/fhb_parameters.dart' as parameters;

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
        ? ProfilePicThumbnailMain.fromJson(json[parameters.strprofilePic])
        : null;
    profilePicThumbnail = json[parameters.strprofilePicThumbnail] != null
        ? ProfilePicThumbnailMain.fromJson(
            json[parameters.strprofilePicThumbnail])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data[parameters.strId] = id;
    data[parameters.strCreatedBy] = createdBy;
    data[parameters.strName] = name;
    data[parameters.strPhoneNumber1] = phoneNumber1;
    data[parameters.strPhoneNumber2] = phoneNumber2;
    data[parameters.strPhoneNumber3] = phoneNumber3;
    data[parameters.strPhoneNumber4] = phoneNumber4;
    data[parameters.strAddressLine1] = addressLine1;
    data[parameters.strAddressLine2] = addressLine2;
    data[parameters.strCity] = city;
    data[parameters.strState] = state;
    data[parameters.strWebsite] = website;
    data[parameters.strEmail] = email;
    data[parameters.strGoogleMapUrl] = googleMapUrl;
    data[parameters.strIsUserDefined] = isUserDefined;
    data[parameters.strDescription] = description;
    data[parameters.strIsActive] = isActive;
    data[parameters.strCreatedBy] = createdBy;
    data[parameters.strLastModifiedOn] = lastModifiedOn;
    data[parameters.strisDefault] = isDefault;
    data[parameters.strprofilePic] = profilePic;
    data[parameters.strprofilePicThumbnail] = profilePicThumbnail;

    return data;
  }
}
