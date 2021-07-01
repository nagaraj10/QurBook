import '../../../constants/fhb_parameters.dart' as parameters;

class HospitalIds {
  String id;
  String createdBy;
  String name;
  String phoneNumber1;
  String phoneNumber2;
  String phoneNumber3;
  String phoneNumber4;
  String addressLine1;
  String addressLine2;
  String city;
  String state;
  String latitude;
  String longitude;
  String logo;
  String logoThumbnail;
  int zipCode;
  String website;
  String email;
  String googleMapUrl;
  String branch;
  bool isUserDefined;
  String description;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  bool isDefault;

  HospitalIds(
      {this.id,
      this.createdBy,
      this.name,
      this.phoneNumber1,
      this.phoneNumber2,
      this.phoneNumber3,
      this.phoneNumber4,
      this.addressLine1,
      this.addressLine2,
      this.city,
      this.state,
      this.latitude,
      this.longitude,
      this.logo,
      this.logoThumbnail,
      this.zipCode,
      this.website,
      this.email,
      this.googleMapUrl,
      this.branch,
      this.isUserDefined,
      this.description,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn,
      this.isDefault});

  HospitalIds.fromJson(Map<String, dynamic> json) {
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
    latitude = json[parameters.strLatitude];
    longitude = json[parameters.strLongitute];
    logo = json[parameters.strLogo];
    logoThumbnail = json[parameters.strLogothumbnail];
    zipCode = json[parameters.strZipcode];
    website = json[parameters.strWebsite];
    email = json[parameters.strEmail];
    googleMapUrl = json[parameters.strGoogleMapUrl];
    branch = json[parameters.strBranch];
    isUserDefined = json[parameters.strIsUserDefined];
    description = json[parameters.strDescription];
    isActive = json[parameters.strIsActive];
    createdOn = json[parameters.strCreatedOn];
    lastModifiedOn = json[parameters.strLastModifiedOn];
    isDefault = json[parameters.strisDefault];
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
    data[parameters.strLatitude] = latitude;
    data[parameters.strLongitute] = longitude;
    data[parameters.strLogo] = logo;
    data[parameters.strLogothumbnail] = logoThumbnail;
    data[parameters.strZipcode] = zipCode;
    data[parameters.strWebsite] = website;
    data[parameters.strEmail] = email;
    data[parameters.strGoogleMapUrl] = googleMapUrl;
    data[parameters.strBranch] = branch;
    data[parameters.strIsUserDefined] = isUserDefined;
    data[parameters.strDescription] = description;
    data[parameters.strIsActive] = isActive;
    data[parameters.strCreatedOn] = createdOn;
    data[parameters.strLastModifiedOn] = lastModifiedOn;
    data[parameters.strisDefault] = isDefault;
    return data;
  }
}
