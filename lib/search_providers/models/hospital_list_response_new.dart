class HospitalsSearchListResponse {
  bool isSuccess;
  List<HospitalsListResult> result;

  HospitalsSearchListResponse({this.isSuccess, this.result});

  HospitalsSearchListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['result'] != null) {
      result = new List<HospitalsListResult>();
      json['result'].forEach((v) {
        result.add(new HospitalsListResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HospitalsListResult {
  String healthOrganizationReferenceId;
  String healthOrganizationName;
  String addressLine1;
  String addressLine2;
  String cityName;
  String stateName;
  String pincode;
  String healthOrganizationId;
  String healthOrganizationTypeId;
  String healthOrganizationTypeName;
  String phoneNumber;
  String phoneNumberTypeId;
  String phoneNumberTypeName;

  HospitalsListResult(
      {this.healthOrganizationReferenceId,
        this.healthOrganizationName,
        this.addressLine1,
        this.addressLine2,
        this.cityName,
        this.stateName,
        this.pincode,
        this.healthOrganizationId,
        this.healthOrganizationTypeId,
        this.healthOrganizationTypeName,
        this.phoneNumber,
        this.phoneNumberTypeId,
        this.phoneNumberTypeName});

  HospitalsListResult.fromJson(Map<String, dynamic> json) {
    healthOrganizationReferenceId = json['healthOrganizationReferenceId'];
    healthOrganizationName = json['healthOrganizationName'];
    addressLine1 = json['addressLine1'];
    addressLine2 = json['addressLine2'];
    cityName = json['cityName'];
    stateName = json['stateName'];
    pincode = json['pincode'];
    healthOrganizationId = json['healthOrganizationId'];
    healthOrganizationTypeId = json['healthOrganizationTypeId'];
    healthOrganizationTypeName = json['healthOrganizationTypeName'];
    phoneNumber = json['phoneNumber'];
    phoneNumberTypeId = json['phoneNumberTypeId'];
    phoneNumberTypeName = json['phoneNumberTypeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['healthOrganizationReferenceId'] = this.healthOrganizationReferenceId;
    data['healthOrganizationName'] = this.healthOrganizationName;
    data['addressLine1'] = this.addressLine1;
    data['addressLine2'] = this.addressLine2;
    data['cityName'] = this.cityName;
    data['stateName'] = this.stateName;
    data['pincode'] = this.pincode;
    data['healthOrganizationId'] = this.healthOrganizationId;
    data['healthOrganizationTypeId'] = this.healthOrganizationTypeId;
    data['healthOrganizationTypeName'] = this.healthOrganizationTypeName;
    data['phoneNumber'] = this.phoneNumber;
    data['phoneNumberTypeId'] = this.phoneNumberTypeId;
    data['phoneNumberTypeName'] = this.phoneNumberTypeName;
    return data;
  }
}
