import '../../../constants/fhb_parameters.dart' as parameters;

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
    final data = Map<String, dynamic>();
    data[parameters.strId] = id;
    data[parameters.strName] = name;
    data[parameters.strCountryCode] = countryCode;
    data[parameters.strIsActive] = isActive;
    data[parameters.strCreatedOn] = createdOn;
    data[parameters.strLastModifiedOn] = lastModifiedOn;
    data[parameters.strlastModifiedBy] = lastModifiedBy;
    return data;
  }
}
