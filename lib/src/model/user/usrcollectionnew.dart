
import 'package:myfhb/common/CommonUtil.dart';

import 'State.dart';

import 'AddressTypeModel.dart';

class UserAddressCollection3 {
  String? id;
  String? addressLine1;
  String? addressLine2;
  String? pincode;
  bool? isPrimary;
  bool? isActive;
  String? createdOn;
  String? lastModifiedOn;
  String? createdBy;
  AddressType? addressType;
  City? city;
  State? state;

  UserAddressCollection3(
      {this.id,
      this.addressLine1,
      this.addressLine2,
      this.pincode,
      this.isPrimary,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn,
      this.createdBy,
      this.addressType,
      this.city,
      this.state});

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
      createdBy = json['createdBy'];
      addressType = json['addressType'] != null
              ? AddressType.fromJson(json['addressType'])
              : null;
      city = json['city'] != null ? City.fromJson(json['city']) : null;
      state = json['state'] != null ? State.fromJson(json['state']) : null;
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
    data['createdBy'] = createdBy;
    data['lastModifiedOn'] = lastModifiedOn;
    if (addressType != null) {
      data['addressType'] = addressType!.toJson();
    }
    if (city != null) {
      data['city'] = city!.toJson();
    }
    if (state != null) {
      data['state'] = state!.toJson();
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
