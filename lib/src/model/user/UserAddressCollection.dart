import 'package:myfhb/src/model/user/State.dart';

import 'AddressTypeModel.dart';

class UserAddressCollection3 {
  String id;
  String addressLine1;
  String addressLine2;
  String pincode;
  bool isPrimary;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  AddressType addressType;
  City city;
  State state;

  UserAddressCollection3(
      {this.id,
      this.addressLine1,
      this.addressLine2,
      this.pincode,
      this.isPrimary,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn,
      this.addressType,
      this.city,
      this.state});

  UserAddressCollection3.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addressLine1 = json['addressLine1'];
    addressLine2 = json['addressLine2'];
    pincode = json['pincode'];
    isPrimary = json['isPrimary'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    addressType = json['addressType'] != null
        ? new AddressType.fromJson(json['addressType'])
        : null;
    city = json['city'] != null ? new City.fromJson(json['city']) : null;
    state = json['state'] != null ? new State.fromJson(json['state']) : null;
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
    if (this.addressType != null) {
      data['addressType'] = this.addressType.toJson();
    }
    if (this.city != null) {
      data['city'] = this.city.toJson();
    }
    if (this.state != null) {
      data['state'] = this.state.toJson();
    }
    return data;
  }
}

class City {
  String id;
  String name;
  bool isActive;
  String createdOn;
  String lastModifiedOn;

  City(
      {this.id, this.name, this.isActive, this.createdOn, this.lastModifiedOn});

  City.fromJson(Map<String, dynamic> json) {
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
