class HospitalListResponse {
  int status;
  bool success;
  String message;
  Response response;

  HospitalListResponse(
      {this.status, this.success, this.message, this.response});

  HospitalListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    message = json['message'];
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.response != null) {
      data['response'] = this.response.toJson();
    }
    return data;
  }
}

class Response {
  int count;
  List<HospitalData> data;

  Response({this.count, this.data});

  Response.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['data'] != null) {
      data = new List<HospitalData>();
      json['data'].forEach((v) {
        data.add(new HospitalData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

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
    id = json['id'];
    createdBy = json['createdBy'];
    name = json['name'];
    phoneNumber1 = json['phoneNumber1'];
    phoneNumber2 = json['phoneNumber2'];
    phoneNumber3 = json['phoneNumber3'];
    phoneNumber4 = json['phoneNumber4'];
    addressLine1 = json['addressLine1'];
    addressLine2 = json['addressLine2'];
    city = json['city'];
    state = json['state'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    logo = json['logo'];
    logoThumbnail = json['logoThumbnail'];
    zipCode = json['zipCode'];
    website = json['website'];
    email = json['email'];
    googleMapUrl = json['googleMapUrl'];
    branch = json['branch'];
    isUserDefined = json['isUserDefined'];
    description = json['description'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdBy'] = this.createdBy;
    data['name'] = this.name;
    data['phoneNumber1'] = this.phoneNumber1;
    data['phoneNumber2'] = this.phoneNumber2;
    data['phoneNumber3'] = this.phoneNumber3;
    data['phoneNumber4'] = this.phoneNumber4;
    data['addressLine1'] = this.addressLine1;
    data['addressLine2'] = this.addressLine2;
    data['city'] = this.city;
    data['state'] = this.state;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['logo'] = this.logo;
    data['logoThumbnail'] = this.logoThumbnail;
    data['zipCode'] = this.zipCode;
    data['website'] = this.website;
    data['email'] = this.email;
    data['googleMapUrl'] = this.googleMapUrl;
    data['branch'] = this.branch;
    data['isUserDefined'] = this.isUserDefined;
    data['description'] = this.description;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    return data;
  }
}
