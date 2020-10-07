class HealthOrganizationResult {
  String id;
  String startDate;
  String endDate;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  HealthOrganization healthOrganization;
  List<DoctorFeeCollection> doctorFeeCollection;

  HealthOrganizationResult(
      {this.id,
        this.startDate,
        this.endDate,
        this.isActive,
        this.createdOn,
        this.lastModifiedOn,
        this.healthOrganization,
        this.doctorFeeCollection});

  HealthOrganizationResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    healthOrganization = json['healthOrganization'] != null
        ? new HealthOrganization.fromJson(json['healthOrganization'])
        : null;
    if (json['doctorFeeCollection'] != null) {
      doctorFeeCollection = new List<DoctorFeeCollection>();
      json['doctorFeeCollection'].forEach((v) {
        doctorFeeCollection.add(new DoctorFeeCollection.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    if (this.healthOrganization != null) {
      data['healthOrganization'] = this.healthOrganization.toJson();
    }
    if (this.doctorFeeCollection != null) {
      data['doctorFeeCollection'] =
          this.doctorFeeCollection.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HealthOrganization {
  String id;
  String name;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  List<HealthOrganizationAddressCollection> healthOrganizationAddressCollection;
  List<HealthOrganizationContactCollection> healthOrganizationContactCollection;

  HealthOrganization(
      {this.id,
        this.name,
        this.isActive,
        this.createdOn,
        this.lastModifiedOn,
        this.healthOrganizationAddressCollection,
        this.healthOrganizationContactCollection});

  HealthOrganization.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    if (json['healthOrganizationAddressCollection'] != null) {
      healthOrganizationAddressCollection =
      new List<HealthOrganizationAddressCollection>();
      json['healthOrganizationAddressCollection'].forEach((v) {
        healthOrganizationAddressCollection
            .add(new HealthOrganizationAddressCollection.fromJson(v));
      });
    }
    if (json['healthOrganizationContactCollection'] != null) {
      healthOrganizationContactCollection =
      new List<HealthOrganizationContactCollection>();
      json['healthOrganizationContactCollection'].forEach((v) {
        healthOrganizationContactCollection
            .add(new HealthOrganizationContactCollection.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    if (this.healthOrganizationAddressCollection != null) {
      data['healthOrganizationAddressCollection'] = this
          .healthOrganizationAddressCollection
          .map((v) => v.toJson())
          .toList();
    }
    if (this.healthOrganizationContactCollection != null) {
      data['healthOrganizationContactCollection'] = this
          .healthOrganizationContactCollection
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class HealthOrganizationAddressCollection {
  String id;
  String addressLine1;
  String addressLine2;
  String pincode;
  bool isPrimary;
  bool isActive;
  String createdOn;
  String lastModifiedOn;

  HealthOrganizationAddressCollection(
      {this.id,
        this.addressLine1,
        this.addressLine2,
        this.pincode,
        this.isPrimary,
        this.isActive,
        this.createdOn,
        this.lastModifiedOn});

  HealthOrganizationAddressCollection.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addressLine1 = json['addressLine1'];
    addressLine2 = json['addressLine2'];
    pincode = json['pincode'];
    isPrimary = json['isPrimary'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['addressLine1'] = this.addressLine1;
    data['addressLine2'] = this.addressLine2;
    data['pincode'] = this.pincode;
    data['isPrimary'] = this.isPrimary;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    return data;
  }
}

class HealthOrganizationContactCollection {
  String id;
  String phoneNumber;
  bool isPrimary;
  bool isActive;
  String createdOn;
  String lastModifiedOn;

  HealthOrganizationContactCollection(
      {this.id,
        this.phoneNumber,
        this.isPrimary,
        this.isActive,
        this.createdOn,
        this.lastModifiedOn});

  HealthOrganizationContactCollection.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phoneNumber = json['phoneNumber'];
    isPrimary = json['isPrimary'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['phoneNumber'] = this.phoneNumber;
    data['isPrimary'] = this.isPrimary;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    return data;
  }
}

class DoctorFeeCollection {
  String id;
  String fee;
  int followupValue;
  FollowupIn followupIn;
  String effectiveFromDate;
  String effectiveToDate;
  bool isActive;
  String createdOn;
  String lastModifiedOn;

  DoctorFeeCollection(
      {this.id,
        this.fee,
        this.followupValue,
        this.followupIn,
        this.effectiveFromDate,
        this.effectiveToDate,
        this.isActive,
        this.createdOn,
        this.lastModifiedOn});

  DoctorFeeCollection.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fee = json['fee'];
    followupValue = json['followupValue'];
    followupIn = json['followupIn'] != null
        ? new FollowupIn.fromJson(json['followupIn'])
        : null;
    effectiveFromDate = json['effectiveFromDate'];
    effectiveToDate = json['effectiveToDate'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fee'] = this.fee;
    data['followupValue'] = this.followupValue;
    if (this.followupIn != null) {
      data['followupIn'] = this.followupIn.toJson();
    }
    data['effectiveFromDate'] = this.effectiveFromDate;
    data['effectiveToDate'] = this.effectiveToDate;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    return data;
  }
}

class FollowupIn {
  List<int> days;

  FollowupIn({this.days});

  FollowupIn.fromJson(Map<String, dynamic> json) {
    days = json['days'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['days'] = this.days;
    return data;
  }
}