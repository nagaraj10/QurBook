class NewHospitalResponse {
  bool isSuccess;
  Result result;

  NewHospitalResponse({this.isSuccess, this.result});

  NewHospitalResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    return data;
  }
}

class Result {
  String name;
  HealthOrganizationType healthOrganizationType;
  HealthOrganizationType createdBy;
  String createdOn;
  bool isActive;
  String addressLine1;
  String addressLine2;
  String city;
  String state;
  String pincode;
  String isReferenced;
  String lastModifiedOn;
  String id;

  Result(
      {this.name,
        this.healthOrganizationType,
        this.createdBy,
        this.createdOn,
        this.isActive,
        this.addressLine1,
        this.addressLine2,
        this.city,
        this.state,
        this.pincode,
        this.isReferenced,
        this.lastModifiedOn,
        this.id});

  Result.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    healthOrganizationType = json['healthOrganizationType'] != null
        ? new HealthOrganizationType.fromJson(json['healthOrganizationType'])
        : null;
    createdBy = json['createdBy'] != null
        ? new HealthOrganizationType.fromJson(json['createdBy'])
        : null;
    createdOn = json['createdOn'];
    isActive = json['isActive'];
    addressLine1 = json['addressLine1'];
    addressLine2 = json['addressLine2'];
    city = json['city'];
    state = json['state'];
    pincode = json['pincode'];
    isReferenced = json['isReferenced'];
    lastModifiedOn = json['lastModifiedOn'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.healthOrganizationType != null) {
      data['healthOrganizationType'] = this.healthOrganizationType.toJson();
    }
    if (this.createdBy != null) {
      data['createdBy'] = this.createdBy.toJson();
    }
    data['createdOn'] = this.createdOn;
    data['isActive'] = this.isActive;
    data['addressLine1'] = this.addressLine1;
    data['addressLine2'] = this.addressLine2;
    data['city'] = this.city;
    data['state'] = this.state;
    data['pincode'] = this.pincode;
    data['isReferenced'] = this.isReferenced;
    data['lastModifiedOn'] = this.lastModifiedOn;
    data['id'] = this.id;
    return data;
  }
}

class HealthOrganizationType {
  String id;

  HealthOrganizationType({this.id});

  HealthOrganizationType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}