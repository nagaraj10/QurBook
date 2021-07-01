import '../../constants/fhb_parameters.dart' as parameters;
import 'ProfilePic.dart';

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
  var profilePicThumbnailUrl;

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
        ? ProfilePic.fromJson(json[parameters.strprofilePic])
        : null;
    profilePicThumbnail = json[parameters.strprofilePicThumbnail] != null
        ? ProfilePic.fromJson(json[parameters.strprofilePicThumbnail])
        : null;
    isDefault = json[parameters.strisDefault];
    profilePicThumbnailUrl = json['profilePicThumbnailURL'] != null
        ? json['profilePicThumbnailURL']
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data[parameters.strId] = id;
    data[parameters.strName] = name;
    data[parameters.strAddressLine1] = addressLine1;
    data[parameters.strAddressLine2] = addressLine2;
    data[parameters.strWebsite] = website;
    data[parameters.strGoogleMapUrl] = googleMapUrl;
    data[parameters.strPhoneNumber1] = phoneNumber1;
    data[parameters.strPhoneNumber2] = phoneNumber2;
    data[parameters.strPhoneNumber3] = phoneNumber3;
    data[parameters.strPhoneNumber4] = phoneNumber4;
    data[parameters.strEmail] = email;
    data[parameters.strState] = state;
    data[parameters.strCity] = city;
    data[parameters.strLatitude] = latitude;
    data[parameters.strLongitute] = longitude;
    data[parameters.strIsActive] = isActive;
    data[parameters.strSpecilization] = specialization;
    data[parameters.strIsUserDefined] = isUserDefined;
    data[parameters.strDescription] = description;
    data[parameters.strCreatedBy] = createdBy;
    data[parameters.strLastModifiedOn] = lastModifiedOn;
    if (profilePic != null) {
      data[parameters.strprofilePic] = profilePic.toJson();
    }
    if (profilePicThumbnail != null) {
      data[parameters.strprofilePicThumbnail] =
          profilePicThumbnail.toJson();
    }
    data[parameters.strisDefault] = isDefault;
    data[parameters.strprofilePicThumbnailURL] = profilePicThumbnailUrl;

    return data;
  }
}
