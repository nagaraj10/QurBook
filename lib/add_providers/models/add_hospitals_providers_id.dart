class AddHospitalsProvidersId {
  int status;
  bool success;
  String message;
  Response response;

  AddHospitalsProvidersId(
      {this.status, this.success, this.message, this.response});

  AddHospitalsProvidersId.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    message = json['message'];
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }
}

class Response {
  int count;
  AddHospitalData data;

  Response({this.count, this.data});

  Response.fromJson(Map<String, dynamic> json) {
    count = json['count'];

    Map<String, dynamic> dic;
    if (json['data'] != null) {
      dic = json['data'];
      data = AddHospitalData.fromJson(dic);
    } else {
      print('No data found');
      print(json['data']);
    }
  }
}

class AddHospitalData {
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

  AddHospitalData(
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

  AddHospitalData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    addressLine1 = json['addressLine1'] != null ? json['addressLine1'] : '';
    addressLine2 = json['addressLine2'] != null ? json['addressLine2'] : '';
    website = json['website'] != null ? json['website'] : '';
    googleMapUrl = json['googleMapUrl'] != null ? json['googleMapUrl'] : '';
    phoneNumber1 = json['phoneNumber1'] != null ? json['phoneNumber1'] : '';
    phoneNumber2 = json['phoneNumber2'] != null ? json['phoneNumber2'] : '';
    phoneNumber3 = json['phoneNumber3'] != null ? json['phoneNumber3'] : '';
    phoneNumber4 = json['phoneNumber4'] != null ? json['phoneNumber4'] : '';
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
