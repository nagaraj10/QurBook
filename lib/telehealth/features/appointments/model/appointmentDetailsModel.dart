import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:myfhb/common/CommonUtil.dart';

class AppointmentDetailsModel {
  bool? isSuccess;
  Result? result;

  AppointmentDetailsModel({this.isSuccess, this.result});

  AppointmentDetailsModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  String? plannedStartDateTime;
  String? plannedEndDateTime;
  int? slotNumber;
  AdditionalInfo? additionalInfo;
  ServiceCategory? serviceCategory;
  Status? modeOfService;
  HealthOrganization? healthOrganization;
  Doctor? doctor;
  Result(
      {this.plannedStartDateTime,
      this.plannedEndDateTime,
      this.slotNumber,
      this.additionalInfo,
      this.serviceCategory,
      this.modeOfService,
      this.healthOrganization,
      this.doctor});

  Result.fromJson(Map<String, dynamic> json) {
    try {
      plannedStartDateTime = json['plannedStartDateTime'];
      plannedEndDateTime = json['plannedEndDateTime'];
      slotNumber = json['slotNumber'];
      additionalInfo = json['additionalInfo'] != null
          ? new AdditionalInfo.fromJson(json['additionalInfo'])
          : AdditionalInfo();
      serviceCategory = json['serviceCategory'] != null
          ? new ServiceCategory.fromJson(json['serviceCategory'])
          : null;
      modeOfService = json['modeOfService'] != null
          ? new Status.fromJson(json['modeOfService'])
          : null;
      healthOrganization = json['healthOrganization'] != null
          ? new HealthOrganization.fromJson(json['healthOrganization'])
          : null;
      doctor =
          json['doctor'] != null ? new Doctor.fromJson(json['doctor']) : null;

    } catch (e) {
                  CommonUtil().appLogs(message: e.toString());

      if (kDebugMode) {
        printError(info: e.toString());
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['plannedStartDateTime'] = this.plannedStartDateTime;
    data['plannedEndDateTime'] = this.plannedEndDateTime;
    data['slotNumber'] = this.slotNumber;
    if (this.additionalInfo != null) {
      data['additionalInfo'] = this.additionalInfo!.toJson();
    }
    if (this.serviceCategory != null) {
      data['serviceCategory'] = this.serviceCategory!.toJson();
    }
    if (this.modeOfService != null) {
      data['modeOfService'] = this.modeOfService!.toJson();
    }
    if (this.healthOrganization != null) {
      data['healthOrganization'] = this.healthOrganization!.toJson();
    }
    if (this.doctor != null) {
      data['doctor'] = this.doctor!.toJson();
    }
    return data;
  }
}

class PickupRequestInfo{
  String? requestTime;
  bool? isAccepted;
  String? requestFrom;
  PickupRequestInfo.fromJson(Map<String, dynamic> json) {
    requestTime=json['requestTime']!=null?json['requestTime']:null;
    requestFrom=json['requestFrom']!=null?json['requestFrom']:null;
    isAccepted=json['isAccepted']!=null?json['isAccepted']:null;
  }
}

class AdditionalInfo {
  String? to;
  String? from;
  String? city;
  String? cityName;
  String? description;
  String? notesDisplay;
  String? state;
  String? title;
  String? labName;
  String? pinCode;
  String? testName;
  String? addressLine1;
  String? addressLine2;
  String? locationUrl;
  Status? modeOfService;
  String? providerName;
  bool? isEndTimeOptional;
  List<PickupRequestInfo>? pickupRequestInfo;

  AdditionalInfo(
      {this.to,
      this.from,
      this.city,
      this.cityName,
      this.description,
      this.notesDisplay,
      this.state,
      this.title,
      this.labName,
      this.pinCode,
      this.testName,
      this.addressLine1,
      this.addressLine2,
      this.locationUrl,
      this.modeOfService,
      this.isEndTimeOptional,
      this.providerName,
      this.pickupRequestInfo});

  AdditionalInfo.fromJson(Map<String, dynamic> json) {
    try {
      if(json['pickupRequestInfo']!=null){
        pickupRequestInfo = [];
        json['pickupRequestInfo'].forEach((v) {
          pickupRequestInfo?.add(PickupRequestInfo.fromJson(v));
        });
      }
      to = json['to'] != null
          ? json['to']
          : json['To'] != null
              ? json['To']
              : "";
      from = json['from'] != null
          ? json['from']
          : json['From'] != null
              ? json['From']
              : "";
      city = json['city'];
      cityName = json['cityName'];
      if(cityName!=null){
        city = cityName;
      }
      description = json['description'] != null
          ? json['description']
          : "";
      notesDisplay = json['notes'] != null ? json['notes'] : '';
      state = json['state'];
      title = json['title'];
      labName = json['lab_name'];
      pinCode = json['pin_code'];
      isEndTimeOptional = json['isEndTimeOptional'];

      if (json['test_name'] != null && json['test_name'] is String) {
        testName = json['test_name'];
      } else {
        Data? testNameObject = json['test_name'] != null
            ? new Data.fromJson(json['test_name'])
            : null;
        testName = testNameObject?.id ?? "";
      }

      addressLine1 = json['address_line_1'];
      addressLine2 = json['address_line_2'];
      locationUrl = json['location_url'] != null ? json['location_url'] : "";
      providerName = json['provider_name'];
      modeOfService = json['mode_of_service'] != null
          ? new Status.fromJson(json['mode_of_service'])
          : null;


    } catch (e) {
                  CommonUtil().appLogs(message: e.toString());

      if (kDebugMode) {
        printError(info: e.toString());
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['to'] = this.to;
    data['from'] = this.from;
    data['city'] = this.city;
    data['description'] = this.description;
    data['notes'] = this.notesDisplay;
    data['state'] = this.state;
    data['title'] = this.title;
    data['lab_name'] = this.labName;
    data['pin_code'] = this.pinCode;
    data['test_name'] = this.testName;
    data['address_line_1'] = this.addressLine1;
    data['address_line_2'] = this.addressLine2;
    data['location_url'] = this.locationUrl;
    data['mode_of_service'] = this.modeOfService;
    data['provider_name'] = this.providerName;
    return data;
  }
}

class Status {
  String? name;

  Status({this.name});

  Status.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}

class ServiceCategory {
  String? name;
  String? code;
  ServiceCategoryAdditionalInfo? additionalInfo;

  ServiceCategory({this.name, this.additionalInfo});

  ServiceCategory.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    additionalInfo = json['additionalInfo'] != null
        ? new ServiceCategoryAdditionalInfo.fromJson(json['additionalInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.additionalInfo != null) {
      data['additionalInfo'] = this.additionalInfo!.toJson();
    }
    return data;
  }
}

class ServiceCategoryAdditionalInfo {
  List<Field>? field;
  String? iconUrl;

  ServiceCategoryAdditionalInfo({this.field, this.iconUrl});

  ServiceCategoryAdditionalInfo.fromJson(Map<String, dynamic> json) {
    if (json['field'] != null) {
      field = <Field>[];
      json['field'].forEach((v) {
        field!.add(new Field.fromJson(v));
      });
    }
    iconUrl = json['iconUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.field != null) {
      data['field'] = this.field!.map((v) => v.toJson()).toList();
    }
    data['iconUrl'] = this.iconUrl;
    return data;
  }
}

class Field {
  String? key;
  List<Data>? data;

  Field({this.key, this.data});

  Field.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? name;

  Data({this.id, this.name});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class HealthOrganization {
  String? name;
  List<HealthOrganizationAddressCollection>? healthOrganizationAddressCollection;

  HealthOrganization({this.name, this.healthOrganizationAddressCollection});

  HealthOrganization.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['healthOrganizationAddressCollection'] != null) {
      healthOrganizationAddressCollection =
          <HealthOrganizationAddressCollection>[];
      json['healthOrganizationAddressCollection'].forEach((v) {
        healthOrganizationAddressCollection!
            .add(new HealthOrganizationAddressCollection.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.healthOrganizationAddressCollection != null) {
      data['healthOrganizationAddressCollection'] = this
          .healthOrganizationAddressCollection!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class HealthOrganizationAddressCollection {
  String? addressLine1;
  String? addressLine2;
  String? pincode;
  State? state;
  City? city;

  HealthOrganizationAddressCollection(
      {this.addressLine1,
      this.addressLine2,
      this.pincode,
      this.state,
      this.city});

  HealthOrganizationAddressCollection.fromJson(Map<String, dynamic> json) {
    addressLine1 = json['addressLine1'];
    addressLine2 = json['addressLine2'];
    pincode = json['pincode'];
    state = json['state'] != null ? new State.fromJson(json['state']) : null;
    city = json['city'] != null ? new City.fromJson(json['city']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['addressLine1'] = this.addressLine1;
    data['addressLine2'] = this.addressLine2;
    data['pincode'] = this.pincode;
    if (this.state != null) {
      data['state'] = this.state!.toJson();
    }
    if (this.city != null) {
      data['city'] = this.city!.toJson();
    }
    return data;
  }
}

class State {
  String? name;

  State({this.name});

  State.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}

class City {
  String? name;

  City({this.name});

  City.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}

class Doctor {
  User? user;

  Doctor({
    this.user,
  });

  Doctor.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  String? firstName;
  String? lastName;

  User({this.firstName, this.lastName});

  User.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    return data;
  }
}
