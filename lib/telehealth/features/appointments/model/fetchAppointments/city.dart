import 'package:myfhb/telehealth/features/appointments/constants/appointments_parameters.dart'as parameters;

class City {
  City({
    this.id,
    this.name,
    this.isActive,
    this.createdOn,
    this.lastModifiedOn,
    this.countryCode,
  });

  String id;
  String name;
  bool isActive;
  DateTime createdOn;
  dynamic lastModifiedOn;
  String countryCode;

  City.fromJson(Map<String, dynamic> json) {
    id = json[parameters.strId];
    name = json[parameters.strName];
    isActive = json[parameters.strIsActive];
    createdOn = DateTime.parse(json[parameters.strCreatedOn]);
    lastModifiedOn = json[parameters.strLastModifiedOn];
    countryCode = json[parameters.strCountryCode] == null
        ? null
        : json[parameters.strCountryCode];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strId] = id;
    data[parameters.strName] = name;
    data[parameters.strIsActive] = isActive;
    data[parameters.strCreatedOn] = createdOn.toIso8601String();
    data[parameters.strLastModifiedOn] = lastModifiedOn;
    data[parameters.strCountryCode] = countryCode == null ? null : countryCode;
    return data;
  }
}
