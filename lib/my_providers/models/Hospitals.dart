class Hospitals {
  String id;
  String name;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  HealthOrganizationTypeNew healthOrganizationType;
  List<HealthOrganizationAddressCollectionNew> healthOrganizationAddressCollection;
  List<HealthOrganizationContactCollectionNew> healthOrganizationContactCollection;
  bool isDefault;
  String providerPatientMappingId;

  Hospitals(
      {this.id,
        this.name,
        this.isActive,
        this.createdOn,
        this.lastModifiedOn,
        this.healthOrganizationType,
        this.healthOrganizationAddressCollection,
        this.healthOrganizationContactCollection,
        this.isDefault,
        this.providerPatientMappingId});

  Hospitals.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    healthOrganizationType = json['healthOrganizationType'] != null
        ? new HealthOrganizationTypeNew.fromJson(json['healthOrganizationType'])
        : null;
    if (json['healthOrganizationAddressCollection'] != null) {
      healthOrganizationAddressCollection =
      new List<HealthOrganizationAddressCollectionNew>();
      json['healthOrganizationAddressCollection'].forEach((v) {
        healthOrganizationAddressCollection
            .add(new HealthOrganizationAddressCollectionNew.fromJson(v));
      });
    }
    if (json['healthOrganizationContactCollection'] != null) {
      healthOrganizationContactCollection =
      new List<HealthOrganizationContactCollectionNew>();
      json['healthOrganizationContactCollection'].forEach((v) {
        healthOrganizationContactCollection
            .add(new HealthOrganizationContactCollectionNew.fromJson(v));
      });
    }
    isDefault = json['isDefault'];
    providerPatientMappingId = json['providerPatientMappingId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    if (this.healthOrganizationType != null) {
      data['healthOrganizationType'] = this.healthOrganizationType.toJson();
    }
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
    data['isDefault'] = this.isDefault;
    data['providerPatientMappingId'] = this.providerPatientMappingId;
    return data;
  }
}

class HealthOrganizationTypeNew {
  String id;
  String code;
  String name;
  String description;
  int sortOrder;
  bool isActive;
  String createdBy;
  String createdOn;
  String lastModifiedOn;

  HealthOrganizationTypeNew(
      {this.id,
        this.code,
        this.name,
        this.description,
        this.sortOrder,
        this.isActive,
        this.createdBy,
        this.createdOn,
        this.lastModifiedOn});

  HealthOrganizationTypeNew.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    description = json['description'];
    sortOrder = json['sortOrder'];
    isActive = json['isActive'];
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['description'] = this.description;
    data['sortOrder'] = this.sortOrder;
    data['isActive'] = this.isActive;
    data['createdBy'] = this.createdBy;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    return data;
  }
}

class HealthOrganizationAddressCollectionNew {
  String id;
  String addressLine1;
  String addressLine2;
  String pincode;
  bool isPrimary;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  CityProviders city;
  StateProviders state;
  HealthOrganizationTypeNew addressType;

  HealthOrganizationAddressCollectionNew(
      {this.id,
        this.addressLine1,
        this.addressLine2,
        this.pincode,
        this.isPrimary,
        this.isActive,
        this.createdOn,
        this.lastModifiedOn,
        this.city,
        this.state,
        this.addressType});

  HealthOrganizationAddressCollectionNew.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addressLine1 = json['addressLine1'];
    addressLine2 = json['addressLine2'];
    pincode = json['pincode'];
    isPrimary = json['isPrimary'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    city = json['city'] != null ? new CityProviders.fromJson(json['city']) : null;
    state = json['state'] != null ? new StateProviders.fromJson(json['state']) : null;
    addressType = json['addressType'] != null
        ? new HealthOrganizationTypeNew.fromJson(json['addressType'])
        : null;
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
    if (this.city != null) {
      data['city'] = this.city.toJson();
    }
    if (this.state != null) {
      data['state'] = this.state.toJson();
    }
    if (this.addressType != null) {
      data['addressType'] = this.addressType.toJson();
    }
    return data;
  }
}

class CityProviders {
  String id;
  String name;
  bool isActive;
  String createdOn;
  String lastModifiedOn;

  CityProviders(
      {this.id, this.name, this.isActive, this.createdOn, this.lastModifiedOn});

  CityProviders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    return data;
  }
}

class StateProviders {
  String id;
  String name;
  String countryCode;
  bool isActive;
  String createdOn;
  String lastModifiedOn;

  StateProviders(
      {this.id,
        this.name,
        this.countryCode,
        this.isActive,
        this.createdOn,
        this.lastModifiedOn});

  StateProviders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    countryCode = json['countryCode'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['countryCode'] = this.countryCode;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    return data;
  }
}

class HealthOrganizationContactCollectionNew {
  String id;
  String phoneNumber;
  bool isPrimary;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  HealthOrganizationTypeNew phoneNumberType;

  HealthOrganizationContactCollectionNew(
      {this.id,
        this.phoneNumber,
        this.isPrimary,
        this.isActive,
        this.createdOn,
        this.lastModifiedOn,
        this.phoneNumberType});

  HealthOrganizationContactCollectionNew.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phoneNumber = json['phoneNumber'];
    isPrimary = json['isPrimary'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    phoneNumberType = json['phoneNumberType'] != null
        ? new HealthOrganizationTypeNew.fromJson(json['phoneNumberType'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['phoneNumber'] = this.phoneNumber;
    data['isPrimary'] = this.isPrimary;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    if (this.phoneNumberType != null) {
      data['phoneNumberType'] = this.phoneNumberType.toJson();
    }
    return data;
  }
}
