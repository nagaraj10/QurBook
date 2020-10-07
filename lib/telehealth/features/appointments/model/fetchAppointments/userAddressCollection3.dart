import 'package:myfhb/telehealth/features/appointments/constants/appointments_parameters.dart'as parameters;
import 'package:myfhb/telehealth/features/appointments/model/fetchAppointments/city.dart';

class UserAddressCollection3 {
  UserAddressCollection3({
    this.id,
    this.addressLine1,
    this.addressLine2,
    this.pincode,
    this.isPrimary,
    this.isActive,
    this.createdOn,
    this.lastModifiedOn,
    this.city,
    this.state,
  });

  String id;
  String addressLine1;
  String addressLine2;
  String pincode;
  bool isPrimary;
  bool isActive;
  DateTime createdOn;
  dynamic lastModifiedOn;
  City city;
  City state;

  UserAddressCollection3.fromJson(Map<String, dynamic> json) {
    id = json[parameters.strId];
    addressLine1 = json[parameters.strAddressLine1];
    addressLine2 = json[parameters.strAddressLine2];
    pincode = json[parameters.strPincode];
    isPrimary = json[parameters.strIsPrimary];
    isActive = json[parameters.strIsActive];
    createdOn = DateTime.parse(json[parameters.strCreatedOn]);
    lastModifiedOn = json[parameters.strLastModifiedOn];
    city = json[parameters.strCity] == null
        ? null
        : City.fromJson(json[parameters.strCity]);
    state = json[parameters.strState] == null
        ? null
        : City.fromJson(json[parameters.strState]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strId] = id;
    data[parameters.strAddressLine1] = addressLine1;
    data[parameters.strAddressLine2] = addressLine2;
    data[parameters.strPincode] = pincode;
    data[parameters.strIsPrimary] = isPrimary;
    data[parameters.strIsActive] = isActive;
    data[parameters.strCreatedOn] = createdOn.toIso8601String();
    data[parameters.strLastModifiedOn] = lastModifiedOn;
    data[parameters.strCity] = city.toJson();
    data[parameters.strState] = state.toJson();
    return data;
  }
}
