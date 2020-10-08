class LabsSearchListResponse {
  bool isSuccess;
  List<LabListResult> result;

  LabsSearchListResponse({this.isSuccess, this.result});

  LabsSearchListResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['result'] != null) {
      result = new List<LabListResult>();
      json['result'].forEach((v) {
        result.add(new LabListResult.fromJson(v));
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

class LabListResult {
  String healthOrganizationId;
  String healthOrganizationName;
  String healthOrganizationTypeId;
  String healthOrganizationTypeName;
  String addressLine1;
  String addressLine2;
  String pincode;
  String cityName;
  String stateName;
  String phoneNumber;
  String phoneNumberTypeId;
  String phoneNumberTypeName;
  Null healthOrganizationReferenceId;

  LabListResult(
      {this.healthOrganizationId,
        this.healthOrganizationName,
        this.healthOrganizationTypeId,
        this.healthOrganizationTypeName,
        this.addressLine1,
        this.addressLine2,
        this.pincode,
        this.cityName,
        this.stateName,
        this.phoneNumber,
        this.phoneNumberTypeId,
        this.phoneNumberTypeName,
        this.healthOrganizationReferenceId});

  LabListResult.fromJson(Map<String, dynamic> json) {
    healthOrganizationId = json['healthOrganizationId'];
    healthOrganizationName = json['healthOrganizationName'];
    healthOrganizationTypeId = json['healthOrganizationTypeId'];
    healthOrganizationTypeName = json['healthOrganizationTypeName'];
    addressLine1 = json['addressLine1'];
    addressLine2 = json['addressLine2'];
    pincode = json['pincode'];
    cityName = json['cityName'];
    stateName = json['stateName'];
    phoneNumber = json['phoneNumber'];
    phoneNumberTypeId = json['phoneNumberTypeId'];
    phoneNumberTypeName = json['phoneNumberTypeName'];
    healthOrganizationReferenceId = json['healthOrganizationReferenceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['healthOrganizationId'] = this.healthOrganizationId;
    data['healthOrganizationName'] = this.healthOrganizationName;
    data['healthOrganizationTypeId'] = this.healthOrganizationTypeId;
    data['healthOrganizationTypeName'] = this.healthOrganizationTypeName;
    data['addressLine1'] = this.addressLine1;
    data['addressLine2'] = this.addressLine2;
    data['pincode'] = this.pincode;
    data['cityName'] = this.cityName;
    data['stateName'] = this.stateName;
    data['phoneNumber'] = this.phoneNumber;
    data['phoneNumberTypeId'] = this.phoneNumberTypeId;
    data['phoneNumberTypeName'] = this.phoneNumberTypeName;
    data['healthOrganizationReferenceId'] = this.healthOrganizationReferenceId;
    return data;
  }
}