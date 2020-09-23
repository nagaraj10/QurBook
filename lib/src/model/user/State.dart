import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

class State {
  String id;
  String name;
  String countryCode;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  String lastModifiedBy;

  State(
      {this.id,
      this.name,
      this.countryCode,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn,
      this.lastModifiedBy});

  State.fromJson(Map<String, dynamic> json) {
    id = json[parameters.strId];
    name = json[parameters.strName];
    countryCode = json[parameters.strCountryCode];
    isActive = json[parameters.strIsActive];
    createdOn = json[parameters.strCreatedOn];
    lastModifiedOn = json[parameters.strLastModifiedOn];
    lastModifiedBy = json[parameters.strlastModifiedBy];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strId] = this.id;
    data[parameters.strName] = this.name;
    data[parameters.strCountryCode] = this.countryCode;
    data[parameters.strIsActive] = this.isActive;
    data[parameters.strCreatedOn] = this.createdOn;
    data[parameters.strLastModifiedOn] = this.lastModifiedOn;
    data[parameters.strlastModifiedBy] = this.lastModifiedBy;
    return data;
  }
}
