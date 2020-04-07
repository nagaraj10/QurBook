class DoctorsListResponse {
  int status;
  bool success;
  String message;
  Response response;

  DoctorsListResponse({this.status, this.success, this.message, this.response});

  DoctorsListResponse.fromJson(Map<String, dynamic> json) {
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
  List<DoctorsData> data;

  Response({this.count, this.data});

  Response.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['data'] != null) {
      data = new List<DoctorsData>();
      json['data'].forEach((v) {
        data.add(new DoctorsData.fromJson(v));
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

class DoctorsData {
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

  DoctorsData(
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
      this.lastModifiedOn});

  DoctorsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    addressLine1 = json['addressLine1'];
    addressLine2 = json['addressLine2'];
    website = json['website'];
    googleMapUrl = json['googleMapUrl'];
    phoneNumber1 = json['phoneNumber1'];
    phoneNumber2 = json['phoneNumber2'];
    phoneNumber3 = json['phoneNumber3'];
    phoneNumber4 = json['phoneNumber4'];
    email = json['email'];
    state = json['state'];
    city = json['city'];
    isActive = json['isActive'];
    specialization = json['specialization'];
    isUserDefined = json['isUserDefined'];
    description = json['description'];
    createdBy = json['createdBy'];
    lastModifiedOn = json['lastModifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['addressLine1'] = this.addressLine1;
    data['addressLine2'] = this.addressLine2;
    data['website'] = this.website;
    data['googleMapUrl'] = this.googleMapUrl;
    data['phoneNumber1'] = this.phoneNumber1;
    data['phoneNumber2'] = this.phoneNumber2;
    data['phoneNumber3'] = this.phoneNumber3;
    data['phoneNumber4'] = this.phoneNumber4;
    data['email'] = this.email;
    data['state'] = this.state;
    data['city'] = this.city;
    data['isActive'] = this.isActive;
    data['specialization'] = this.specialization;
    data['isUserDefined'] = this.isUserDefined;
    data['description'] = this.description;
    data['createdBy'] = this.createdBy;
    data['lastModifiedOn'] = this.lastModifiedOn;
    return data;
  }
}
