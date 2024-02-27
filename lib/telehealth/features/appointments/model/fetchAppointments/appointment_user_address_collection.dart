import 'package:flutter/foundation.dart';
import 'package:myfhb/common/CommonUtil.dart';

import 'city.dart';
import 'package:get/get.dart';

class AppointmentUserAddressCollection3 {
  String? id;
  String? addressLine1;
  String? addressLine2;
  String? pincode;
  bool? isPrimary;
  bool? isActive;
  String? createdOn;
  String? lastModifiedOn;
  City? state;
  City? city;

  AppointmentUserAddressCollection3({
    this.id,
    this.addressLine1,
    this.addressLine2,
    this.pincode,
    this.isPrimary,
    this.isActive,
    this.createdOn,
    this.lastModifiedOn,
    this.state,
    this.city,
  });

  AppointmentUserAddressCollection3.fromJson(
    Map<String, dynamic> json,
  ) {
    try {
      id = json['id'];
      addressLine1 = json['addressLine1'];
      addressLine2 = json['addressLine2'];
      pincode = json['pincode'];
      isPrimary = json['isPrimary'];
      isActive = json['isActive'];
      createdOn = json['createdOn'];
      lastModifiedOn = json['lastModifiedOn'];
      state = json['state'] == null ? null : City.fromJson(json['state']);
      city = json['city'] == null ? null : City.fromJson(json['city']);
    } catch (e, stackTrace) {
      CommonUtil().appLogs(message: e, stackTrace: stackTrace);

      if (kDebugMode) {
        printError(info: e.toString());
      }
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'addressLine1': addressLine1,
        'addressLine2': addressLine2,
        'pincode': pincode,
        'isPrimary': isPrimary,
        'isActive': isActive,
        'createdOn': createdOn,
        'lastModifiedOn': lastModifiedOn,
        'state': state?.toJson(),
        'city': city?.toJson(),
      };
}
