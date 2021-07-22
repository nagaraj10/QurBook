import '../../constants/fhb_parameters.dart' as parameters;

class LaboratoryModel {
  String id;
  String createdBy;
  String name;
  String logo;
  String latitude;
  String longitude;
  String logoThumbnail;
  int zipCode;
  String website;
  String city;
  String googleMapUrl;
  String branch;
  String addressLine1;
  String addressLine2;
  String state;
  String email;
  String description;
  String phoneNumber1;
  String phoneNumber2;
  String phoneNumber3;
  String phoneNumber4;
  bool isUserDefined;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  bool isDefault;

  LaboratoryModel(
      {this.id,
      this.createdBy,
      this.name,
      this.logo,
      this.latitude,
      this.longitude,
      this.logoThumbnail,
      this.zipCode,
      this.website,
      this.city,
      this.googleMapUrl,
      this.branch,
      this.addressLine1,
      this.addressLine2,
      this.state,
      this.email,
      this.description,
      this.phoneNumber1,
      this.phoneNumber2,
      this.phoneNumber3,
      this.phoneNumber4,
      this.isUserDefined,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn,
      this.isDefault});

  LaboratoryModel.fromJson(Map<String, dynamic> json) {
    id = json[parameters.strId];
    createdBy = json[parameters.strCreatedBy];
    name = json[parameters.strName];
    logo = json[parameters.strLogo];
    latitude = json[parameters.strLatitude];
    longitude = json[parameters.strLongitute];
    logoThumbnail = json[parameters.strLogothumbnail];
    zipCode = json[parameters.strZipcode];
    website = json[parameters.strWebsite];
    city = json[parameters.strCity];
    googleMapUrl = json[parameters.strGoogleMapUrl];
    branch = json[parameters.strBranch];
    addressLine1 = json[parameters.strAddressLine1];
    addressLine2 = json[parameters.strAddressLine2];
    state = json[parameters.strState];
    email = json[parameters.strEmail];
    description = json[parameters.strDescription];
    phoneNumber1 = json[parameters.strPhoneNumber1];
    phoneNumber2 = json[parameters.strPhoneNumber2];
    phoneNumber3 = json[parameters.strPhoneNumber3];
    phoneNumber4 = json[parameters.strPhoneNumber4];
    isUserDefined = json[parameters.strIsUserDefined];
    isActive = json[parameters.strIsActive];
    createdOn = json[parameters.strCreatedOn];
    lastModifiedOn = json[parameters.strLastModifiedOn];
    isDefault = json[parameters.strisDefault];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data[parameters.strId] = id;
    data[parameters.strCreatedBy] = createdBy;
    data[parameters.strName] = name;
    data[parameters.strLogo] = logo;
    data[parameters.strLatitude] = latitude;
    data[parameters.strLongitute] = longitude;
    data[parameters.strLogothumbnail] = logoThumbnail;
    data[parameters.strZipcode] = zipCode;
    data[parameters.strWebsite]=website;
    data[parameters.strCity] = city;
    data[parameters.strGoogleMapUrl] = googleMapUrl;
    data[parameters.strBranch] = branch;
    data[parameters.strAddressLine1] = addressLine1;
    data[parameters.strAddressLine2] = addressLine2;
    data[parameters.strState] = state;
    data[parameters.strEmail] = email;
    data[parameters.strDescription] = description;
    data[parameters.strPhoneNumber1] = phoneNumber1;
    data[parameters.strPhoneNumber2] = phoneNumber2;
    data[parameters.strPhoneNumber3] = phoneNumber3;
    data[parameters.strPhoneNumber4] = phoneNumber4;
    data[parameters.strIsUserDefined] = isUserDefined;
    data[parameters.strIsActive] = isActive;
    data[parameters.strCreatedOn] = createdOn;
    data[parameters.strLastModifiedOn] = lastModifiedOn;
    data[parameters.strisDefault] = isDefault;
    return data;
  }
}
