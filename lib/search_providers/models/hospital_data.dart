import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/constants/fhb_parameters.dart' as parameters;
class HospitalData {
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

  HospitalData(
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
      this.lastModifiedOn});

  HospitalData.fromJson(Map<String, dynamic> json) {
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
    data[parameters.strLatitude] = this.latitude;
    data[parameters.strLongitute] = this.longitude;
    data[parameters.strLogo] = this.logo;
    data[parameters.strLogothumbnail] = this.logoThumbnail;
    data[parameters.strZipcode] = this.zipCode;
    data[parameters.strWebsite] = this.website;
    data[parameters.strEmail] = this.email;
    data[parameters.strGoogleMapUrl] = this.googleMapUrl;
    data[parameters.strBranch] = this.branch;
    data[parameters.strIsUserDefined] = this.isUserDefined;
    data[parameters.strDescription] = this.description;
    data[parameters.strIsActive] = this.isActive;
    data[parameters.strCreatedOn] = this.createdOn;
    data[parameters.strLastModifiedOn] = this.lastModifiedOn;
    return data;
  }
}