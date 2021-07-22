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
  List<String> sharedCategories;

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
        this.providerPatientMappingId,this.sharedCategories});

  Hospitals.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    healthOrganizationType = json['healthOrganizationType'] != null
        ? HealthOrganizationTypeNew.fromJson(json['healthOrganizationType'])
        : null;
    if (json['healthOrganizationAddressCollection'] != null) {
      healthOrganizationAddressCollection =
      <HealthOrganizationAddressCollectionNew>[];
      json['healthOrganizationAddressCollection'].forEach((v) {
        healthOrganizationAddressCollection
            .add(HealthOrganizationAddressCollectionNew.fromJson(v));
      });
    }
    if (json['healthOrganizationContactCollection'] != null) {
      healthOrganizationContactCollection =
      <HealthOrganizationContactCollectionNew>[];
      json['healthOrganizationContactCollection'].forEach((v) {
        healthOrganizationContactCollection
            .add(HealthOrganizationContactCollectionNew.fromJson(v));
      });
    }
    isDefault = json['isDefault'];
    providerPatientMappingId = json['providerPatientMappingId'];
    if (json.containsKey('sharedCategories') &&
        json['sharedCategories'] != null) {
      sharedCategories = json['sharedCategories'].cast<String>();
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['isActive'] = isActive;
    data['createdOn'] = createdOn;
    data['lastModifiedOn'] = lastModifiedOn;
    if (healthOrganizationType != null) {
      data['healthOrganizationType'] = healthOrganizationType.toJson();
    }
    if (healthOrganizationAddressCollection != null) {
      data['healthOrganizationAddressCollection'] = healthOrganizationAddressCollection
          .map((v) => v.toJson())
          .toList();
    }
    if (healthOrganizationContactCollection != null) {
      data['healthOrganizationContactCollection'] = healthOrganizationContactCollection
          .map((v) => v.toJson())
          .toList();
    }
    data['isDefault'] = isDefault;
    data['providerPatientMappingId'] = providerPatientMappingId;
    data['sharedCategories'] = sharedCategories;

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
    final data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['name'] = name;
    data['description'] = description;
    data['sortOrder'] = sortOrder;
    data['isActive'] = isActive;
    data['createdBy'] = createdBy;
    data['createdOn'] = createdOn;
    data['lastModifiedOn'] = lastModifiedOn;
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
    city = json['city'] != null ? CityProviders.fromJson(json['city']) : null;
    state = json['state'] != null ? StateProviders.fromJson(json['state']) : null;
    addressType = json['addressType'] != null
        ? HealthOrganizationTypeNew.fromJson(json['addressType'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['addressLine1'] = addressLine1;
    data['addressLine2'] = addressLine2;
    data['pincode'] = pincode;
    data['isPrimary'] = isPrimary;
    data['isActive'] = isActive;
    data['createdOn'] = createdOn;
    data['lastModifiedOn'] = lastModifiedOn;
    if (city != null) {
      data['city'] = city.toJson();
    }
    if (state != null) {
      data['state'] = state.toJson();
    }
    if (addressType != null) {
      data['addressType'] = addressType.toJson();
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
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['isActive'] = isActive;
    data['createdOn'] = createdOn;
    data['lastModifiedOn'] = lastModifiedOn;
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
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['countryCode'] = countryCode;
    data['isActive'] = isActive;
    data['createdOn'] = createdOn;
    data['lastModifiedOn'] = lastModifiedOn;
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
        ? HealthOrganizationTypeNew.fromJson(json['phoneNumberType'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['phoneNumber'] = phoneNumber;
    data['isPrimary'] = isPrimary;
    data['isActive'] = isActive;
    data['createdOn'] = createdOn;
    data['lastModifiedOn'] = lastModifiedOn;
    if (phoneNumberType != null) {
      data['phoneNumberType'] = phoneNumberType.toJson();
    }
    return data;
  }
}
