import 'package:myfhb/telehealth/features/appointments/constants/appointments_parameters.dart'as parameters;

class City {
  City({
    this.id,
    this.name,
    this.isActive,
    this.createdOn,
    this.lastModifiedOn,
    this.countryCode,
    this.healthOrganizationAddressCollection,
  });

  String id;
  String name;
  bool isActive;
  DateTime createdOn;
  dynamic lastModifiedOn;
  String countryCode;
  List<HealthOrganizationAddressCollection> healthOrganizationAddressCollection;

  City.fromJson(Map<String, dynamic> json) {
    try {
      id = json[parameters.strId];
      name = json[parameters.strName];
      isActive = json[parameters.strIsActive];
      createdOn = DateTime.parse(json[parameters.strCreatedOn]);
      lastModifiedOn = json[parameters.strLastModifiedOn];
      countryCode = json[parameters.strCountryCode] == null
              ? null
              : json[parameters.strCountryCode];
      if (json['healthOrganizationAddressCollection'] != null) {
            healthOrganizationAddressCollection = <HealthOrganizationAddressCollection>[];
            json['healthOrganizationAddressCollection'].forEach((v) { healthOrganizationAddressCollection.add(new HealthOrganizationAddressCollection.fromJson(v)); });
          }
    } catch (e) {
      //print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    try {
      data[parameters.strId] = id;
      data[parameters.strName] = name;
      data[parameters.strIsActive] = isActive;
      data[parameters.strCreatedOn] = createdOn.toIso8601String();
      data[parameters.strLastModifiedOn] = lastModifiedOn;
      data[parameters.strCountryCode] = countryCode == null ? null : countryCode;
      if (this.healthOrganizationAddressCollection != null) {
            data['healthOrganizationAddressCollection'] = this.healthOrganizationAddressCollection.map((v) => v.toJson()).toList();
          }
    } catch (e) {
      //print(e);
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
  StateDetails state;
  CityDetails city;

  HealthOrganizationAddressCollection({this.id, this.addressLine1, this.addressLine2, this.pincode, this.isPrimary, this.isActive, this.createdOn, this.lastModifiedOn, this.state, this.city});

  HealthOrganizationAddressCollection.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      addressLine1 = json['addressLine1'];
      addressLine2 = json['addressLine2'];
      pincode = json['pincode'];
      isPrimary = json['isPrimary'];
      isActive = json['isActive'];
      createdOn = json['createdOn'];
      lastModifiedOn = json['lastModifiedOn'];
      state = json['state'] != null
          ? new StateDetails.fromJson(json['state'])
          : null;
      city =
          json['city'] != null ? new CityDetails.fromJson(json['city']) : null;
    } catch (e) {
      //print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    try {
      data['id'] = this.id;
      data['addressLine1'] = this.addressLine1;
      data['addressLine2'] = this.addressLine2;
      data['pincode'] = this.pincode;
      data['isPrimary'] = this.isPrimary;
      data['isActive'] = this.isActive;
      data['createdOn'] = this.createdOn;
      data['lastModifiedOn'] = this.lastModifiedOn;
      if (this.state != null) {
        data['state'] = this.state.toJson();
      }
      if (this.city != null) {
        data['city'] = this.city.toJson();
      }
    } catch (e) {
      //print(e);
    }
    return data;
  }
}


class StateDetails {
  String id;
  String name;
  String countryCode;
  bool isActive;
  String createdOn;
  String lastModifiedOn;

  StateDetails({this.id, this.name, this.countryCode, this.isActive, this.createdOn, this.lastModifiedOn});

  StateDetails.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      name = json['name'];
      countryCode = json['countryCode'];
      isActive = json['isActive'];
      createdOn = json['createdOn'];
      lastModifiedOn = json['lastModifiedOn'];
    } catch (e) {
      //print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    try {
      data['id'] = this.id;
      data['name'] = this.name;
      data['countryCode'] = this.countryCode;
      data['isActive'] = this.isActive;
      data['createdOn'] = this.createdOn;
      data['lastModifiedOn'] = this.lastModifiedOn;
    } catch (e) {
      //print(e);
    }
    return data;
  }
}

class CityDetails {
  String id;
  String name;
  bool isActive;
  String createdOn;
  String lastModifiedOn;

  CityDetails({this.id, this.name, this.isActive, this.createdOn, this.lastModifiedOn});

  CityDetails.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      name = json['name'];
      isActive = json['isActive'];
      createdOn = json['createdOn'];
      lastModifiedOn = json['lastModifiedOn'];
    } catch (e) {
      //print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    try {
      data['id'] = this.id;
      data['name'] = this.name;
      data['isActive'] = this.isActive;
      data['createdOn'] = this.createdOn;
      data['lastModifiedOn'] = this.lastModifiedOn;
    } catch (e) {
      //print(e);
    }
    return data;
  }
}
