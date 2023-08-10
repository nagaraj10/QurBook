
import 'package:myfhb/common/CommonUtil.dart';

import 'PhoneNumberType.dart';

class UserAddressCollection3 {
  String? id;
  String? addressLine1;
  String? addressLine2;
  String? pincode;
  bool? isPrimary;
  bool? isActive;
  String? createdOn;
  String? lastModifiedOn;
  City? city;
  State? state;
  PhoneNumberType? addressType;

  UserAddressCollection3(
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

  UserAddressCollection3.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      addressLine1 = json['addressLine1'];
      addressLine2 = json['addressLine2'];
      pincode = json['pincode'];
      isPrimary = json['isPrimary'];
      isActive = json['isActive'];
      createdOn = json['createdOn'];
      lastModifiedOn = json['lastModifiedOn'];
      city = json['city'] != null ? City.fromJson(json['city']) : null;
      state = json['state'] != null ? State.fromJson(json['state']) : null;
      addressType = json['addressType'] != null
              ? PhoneNumberType.fromJson(json['addressType'])
              : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['addressLine1'] = addressLine1;
    data['addressLine2'] = addressLine2;
    data['pincode'] = pincode;
    data['isPrimary'] = isPrimary;
    data['isActive'] = isActive;
    data['createdOn'] = createdOn;
    data['lastModifiedOn'] = lastModifiedOn;
    if (city != null) {
      data['city'] = city!.toJson();
    }
    if (state != null) {
      data['state'] = state!.toJson();
    }
    if (addressType != null) {
      data['addressType'] = addressType!.toJson();
    }
    return data;
  }
}

class City {
  String? id;
  String? name;
  bool? isActive;
  String? createdOn;
  String? lastModifiedOn;

  City(
      {this.id, this.name, this.isActive, this.createdOn, this.lastModifiedOn});

  City.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      name = json['name'];
      isActive = json['isActive'];
      createdOn = json['createdOn'];
      lastModifiedOn = json['lastModifiedOn'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['isActive'] = isActive;
    data['createdOn'] = createdOn;
    data['lastModifiedOn'] = lastModifiedOn;
    return data;
  }
}

class State {
  String? id;
  String? name;
  String? countryCode;
  bool? isActive;
  String? createdOn;
  String? lastModifiedOn;

  State(
      {this.id,
        this.name,
        this.countryCode,
        this.isActive,
        this.createdOn,
        this.lastModifiedOn});

  State.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      name = json['name'];
      countryCode = json['countryCode'];
      isActive = json['isActive'];
      createdOn = json['createdOn'];
      lastModifiedOn = json['lastModifiedOn'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['countryCode'] = countryCode;
    data['isActive'] = isActive;
    data['createdOn'] = createdOn;
    data['lastModifiedOn'] = lastModifiedOn;
    return data;
  }
}

