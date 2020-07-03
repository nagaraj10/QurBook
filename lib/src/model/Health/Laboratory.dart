import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class Laboratory {
  int localLabId;
  String addressLine1;
  String addressLine2;
  String branch;
  String city;
  String description;
  String email;
  String id;
  bool isUserDefined;
  String latitude;
  String logoThumbnail;
  String longitude;
  String name;
  String website;
  String zipcode;

  Laboratory(
      {this.localLabId,
      this.addressLine1,
      this.addressLine2,
      this.branch,
      this.city,
      this.description,
      this.email,
      this.id,
      this.isUserDefined,
      this.latitude,
      this.logoThumbnail,
      this.longitude,
      this.name,
      this.website,
      this.zipcode});

  Laboratory.fromJson(Map<String, dynamic> json) {
    localLabId = json[parameters.strLocal_Lab_Id]==null?0:json[parameters.strLocal_Lab_Id];
    addressLine1 = json[parameters.strAddressLine1];
    addressLine2 = json[parameters.strAddressLine2];
    branch = json[parameters.strBranch];
    city = json[parameters.strCity];
    description = json[parameters.strDescription];
    email = json[parameters.strEmail];
    id = json[parameters.strId];
    isUserDefined = json[parameters.strIsUserDefined];
    if (json[parameters.strLatitude] is String) {
      latitude = json[parameters.strLatitude];
    } else {
      latitude = json[parameters.strLatitude].toString();
    }
    if (json[parameters.strLongitute] is String) {
      longitude = json[parameters.strLongitute];
    } else {
      longitude = json[parameters.strLongitute].toString();
    }
    //latitude = json['latitude'];
    logoThumbnail = json[parameters.strLogothumbnail];
    //longitude = json['longitude'];
    name = json[parameters.strName];
    website = json[parameters.strWebsite];
    if (zipcode is String) {
      zipcode = json[parameters.strZipcode];
    } else {
      zipcode = json[parameters.strZipcode].toString();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strLocal_Lab_Id] = this.localLabId;
    data[parameters.strAddressLine1] = this.addressLine1;
    data[parameters.strAddressLine2] = this.addressLine2;
    data[parameters.strBranch] = this.branch;
    data[parameters.strCity] = this.city;
    data[parameters.strDescription] = this.description;
    data[parameters.strEmail] = this.email;
    data[parameters.strId] = this.id;
    data[parameters.strIsUserDefined] = this.isUserDefined;
    data[parameters.strLatitude] = this.latitude;
    data[parameters.strLogothumbnail] = this.logoThumbnail;
    data[parameters.strLongitute] = this.longitude;
    data[parameters.strName] = this.name;
    data[parameters.strWebsite] = this.website;
    data[parameters.strZipcode] = this.zipcode;
    return data;
  }
}




