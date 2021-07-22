import '../../../constants/fhb_parameters.dart' as parameters;

class Hospital {
  int localHospitalId;
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

  Hospital(
      {this.localHospitalId,
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

  Hospital.fromJson(Map<String, dynamic> json) {
    localHospitalId = json[parameters.strLocal_Hospital_Id] ?? 0;
    addressLine1 = json[parameters.strAddressLine1];
    addressLine2 = json[parameters.strAddressLine2];
    branch = json[parameters.strBranch] ?? '';
    city = json[parameters.strCity];
    description = json[parameters.strDescription];
    email = json[parameters.strEmail] ?? '';
    id = json[parameters.strId];
    isUserDefined = json[parameters.strIsUserDefined] ?? false;
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

    logoThumbnail = json[parameters.strLogothumbnail] ?? '';
    name = json[parameters.strName];
    website = json[parameters.strWebsite];
    if (zipcode is String) {
      zipcode = json[parameters.strZipcode];
    } else {
      zipcode = json[parameters.strZipcode].toString();
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[parameters.strLocal_Hospital_Id] = localHospitalId;
    data[parameters.strAddressLine1] = addressLine1;
    data[parameters.strAddressLine2] = addressLine2;
    data[parameters.strBranch] = branch;
    data[parameters.strCity] = city;
    data[parameters.strDescription] = description;
    data[parameters.strEmail] = email;
    data[parameters.strId] = id;
    data[parameters.strIsUserDefined] = isUserDefined;
    data[parameters.strLatitude] = latitude;
    data[parameters.strLogothumbnail] = logoThumbnail;
    data[parameters.strLongitute] = longitude;
    data[parameters.strName] = name;
    data[parameters.strWebsite] = website;
    data[parameters.strZipcode] = zipcode;
    return data;
  }
}