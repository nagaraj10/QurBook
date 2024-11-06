
import 'package:myfhb/common/CommonUtil.dart';

class HealthOrganizationResult {
  String? id;
  String? startDate;
  String? endDate;
  bool? isActive;
  String? createdOn;
  String? lastModifiedOn;
  HealthOrganization? healthOrganization;
  List<DoctorFeeCollection>? doctorFeeCollection;

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
    try {
      id = json['id'];
      startDate = json['startDate'];
      endDate = json['endDate'];
      isActive = json['isActive'];
      createdOn = json['createdOn'];
      lastModifiedOn = json['lastModifiedOn'];
      healthOrganization = json['healthOrganization'] != null
              ? HealthOrganization.fromJson(json['healthOrganization'])
              : null;
      if (json['doctorFeeCollection'] != null) {
            doctorFeeCollection = <DoctorFeeCollection>[];
            json['doctorFeeCollection'].forEach((v) {
              doctorFeeCollection!.add(DoctorFeeCollection.fromJson(v));
            });
          }
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    if (this.healthOrganization != null) {
      data['healthOrganization'] = this.healthOrganization!.toJson();
    }
    if (this.doctorFeeCollection != null) {
      data['doctorFeeCollection'] =
          this.doctorFeeCollection!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HealthOrganization {
  String? id;
  String? name;
  bool? isActive;
  String? createdOn;
  String? lastModifiedOn;
  List<HealthOrganizationAddressCollection>? healthOrganizationAddressCollection;
  List<HealthOrganizationContactCollection>? healthOrganizationContactCollection;

  HealthOrganization(
      {this.id,
        this.name,
        this.isActive,
        this.createdOn,
        this.lastModifiedOn,
        this.healthOrganizationAddressCollection,
        this.healthOrganizationContactCollection});

  HealthOrganization.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      name = json['name'];
      isActive = json['isActive'];
      createdOn = json['createdOn'];
      lastModifiedOn = json['lastModifiedOn'];
      if (json['healthOrganizationAddressCollection'] != null) {
            healthOrganizationAddressCollection =
            <HealthOrganizationAddressCollection>[];
            json['healthOrganizationAddressCollection'].forEach((v) {
              healthOrganizationAddressCollection!
                  .add(HealthOrganizationAddressCollection.fromJson(v));
            });
          }
      if (json['healthOrganizationContactCollection'] != null) {
            healthOrganizationContactCollection =
            <HealthOrganizationContactCollection>[];
            json['healthOrganizationContactCollection'].forEach((v) {
              healthOrganizationContactCollection!
                  .add(HealthOrganizationContactCollection.fromJson(v));
            });
          }
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    if (this.healthOrganizationAddressCollection != null) {
      data['healthOrganizationAddressCollection'] = this
          .healthOrganizationAddressCollection!
          .map((v) => v.toJson())
          .toList();
    }
    if (this.healthOrganizationContactCollection != null) {
      data['healthOrganizationContactCollection'] = this
          .healthOrganizationContactCollection!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class HealthOrganizationAddressCollection {
  String? id;
  String? addressLine1;
  String? addressLine2;
  String? pincode;
  bool? isPrimary;
  bool? isActive;
  String? createdOn;
  String? lastModifiedOn;
  AddressTypeNew? addressType;
  CityNew? city;
  StateNew? state;

  HealthOrganizationAddressCollection(
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
      addressType = json['addressType'] != null
              ? AddressTypeNew.fromJson(json['addressType'])
              : null;
      city = json['city'] != null ? CityNew.fromJson(json['city']) : null;
      state = json['state'] != null ? StateNew.fromJson(json['state']) : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['addressLine1'] = this.addressLine1;
    data['addressLine2'] = this.addressLine2;
    data['pincode'] = this.pincode;
    data['isPrimary'] = this.isPrimary;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    if (this.addressType != null) {
      data['addressType'] = this.addressType!.toJson();
    }
    if (this.city != null) {
      data['city'] = this.city!.toJson();
    }
    if (this.state != null) {
      data['state'] = this.state!.toJson();
    }
    return data;
  }
}

class AddressTypeNew {
  String? id;
  String? code;
  String? name;
  String? description;
  int? sortOrder;
  bool? isActive;
  String? createdBy;
  String? createdOn;
  String? lastModifiedOn;

  AddressTypeNew(
      {this.id,
        this.code,
        this.name,
        this.description,
        this.sortOrder,
        this.isActive,
        this.createdBy,
        this.createdOn,
        this.lastModifiedOn});

  AddressTypeNew.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      code = json['code'];
      name = json['name'];
      description = json['description'];
      sortOrder = json['sortOrder'];
      isActive = json['isActive'];
      createdBy = json['createdBy'];
      createdOn = json['createdOn'];
      lastModifiedOn = json['lastModifiedOn'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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

class CityNew {
  String? id;
  String? name;
  bool? isActive;
  String? createdOn;
  String? lastModifiedOn;

  CityNew(
      {this.id, this.name, this.isActive, this.createdOn, this.lastModifiedOn});

  CityNew.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    return data;
  }
}

class StateNew {
  String? id;
  String? name;
  String? countryCode;
  bool? isActive;
  String? createdOn;
  String? lastModifiedOn;

  StateNew(
      {this.id,
        this.name,
        this.countryCode,
        this.isActive,
        this.createdOn,
        this.lastModifiedOn});

  StateNew.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['countryCode'] = this.countryCode;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    return data;
  }
}


class HealthOrganizationContactCollection {
  String? id;
  String? phoneNumber;
  bool? isPrimary;
  bool? isActive;
  String? createdOn;
  String? lastModifiedOn;

  HealthOrganizationContactCollection(
      {this.id,
        this.phoneNumber,
        this.isPrimary,
        this.isActive,
        this.createdOn,
        this.lastModifiedOn});

  HealthOrganizationContactCollection.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      phoneNumber = json['phoneNumber'];
      isPrimary = json['isPrimary'];
      isActive = json['isActive'];
      createdOn = json['createdOn'];
      lastModifiedOn = json['lastModifiedOn'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
  String? id;
  String? fee;
  int? followupValue;
  FollowupIn? followupIn;
  String? effectiveFromDate;
  String? effectiveToDate;
  bool? isActive;
  String? createdOn;
  String? lastModifiedOn;
  FeeType? feeType;
  FeeType? followupType;

  DoctorFeeCollection(
      {this.id,
        this.fee,
        this.followupValue,
        this.followupIn,
        this.effectiveFromDate,
        this.effectiveToDate,
        this.isActive,
        this.createdOn,
        this.lastModifiedOn,
        this.feeType,
        this.followupType});

  DoctorFeeCollection.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      fee = json['fee'];
      followupValue = json['followupValue'];
      followupIn = json['followupIn'] != null
              ? FollowupIn.fromJson(json['followupIn'])
              : null;
      effectiveFromDate = json['effectiveFromDate'];
      effectiveToDate = json['effectiveToDate'];
      isActive = json['isActive'];
      createdOn = json['createdOn'];
      lastModifiedOn = json['lastModifiedOn'];
      feeType =
          json['feeType'] != null ? FeeType.fromJson(json['feeType']) : null;
      followupType = json['followupType'] != null
              ? FeeType.fromJson(json['followupType'])
              : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['fee'] = this.fee;
    data['followupValue'] = this.followupValue;
    if (this.followupIn != null) {
      data['followupIn'] = this.followupIn!.toJson();
    }
    data['effectiveFromDate'] = this.effectiveFromDate;
    data['effectiveToDate'] = this.effectiveToDate;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    if (this.feeType != null) {
      data['feeType'] = this.feeType!.toJson();
    }
    if (this.followupType != null) {
      data['followupType'] = this.followupType!.toJson();
    }
    return data;
  }
}

class FollowupIn {
  List<int>? days;

  FollowupIn({this.days});

  FollowupIn.fromJson(Map<String, dynamic> json) {
    try {
      if(json.containsKey('days'))
            if (json['days'] != null) {
              days = json['days'].cast<int>();
            }
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['days'] = this.days;
    return data;
  }
}

class FeeType {
  String? id;
  String? code;
  String? name;
  String? description;
  int? sortOrder;
  bool? isActive;
  String? createdBy;
  String? createdOn;
  String? lastModifiedOn;

  FeeType(
      {this.id,
        this.code,
        this.name,
        this.description,
        this.sortOrder,
        this.isActive,
        this.createdBy,
        this.createdOn,
        this.lastModifiedOn});

  FeeType.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      code = json['code'];
      name = json['name'];
      description = json['description'];
      sortOrder = json['sortOrder'];
      isActive = json['isActive'];
      createdBy = json['createdBy'];
      createdOn = json['createdOn'];
      lastModifiedOn = json['lastModifiedOn'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
