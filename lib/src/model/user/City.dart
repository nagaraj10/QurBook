import 'State.dart' as stateObj;

import '../../../constants/fhb_parameters.dart' as parameters;

class City {
  String id;
  String name;
  String stateId;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  String lastModifiedBy;
  stateObj.State state;

  City(
      {this.id,
      this.name,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn,
      this.lastModifiedBy});

  City.fromJson(Map<String, dynamic> json) {
    id = json[parameters.strId];
    name = json[parameters.strName];
    //stateId = jso[parameters.strstateId];
    isActive = json[parameters.strIsActive];
    createdOn = json[parameters.strCreatedOn];
    state = json[parameters.strState] != null
        ? stateObj.State.fromJson(json[parameters.strState])
        : null;
    lastModifiedOn = json[parameters.strLastModifiedOn];
    lastModifiedBy = json[parameters.strlastModifiedBy];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[parameters.strId] = id;
    data[parameters.strName] = name;
    //data[parameters.strstateId] = this.stateId;
    data[parameters.strIsActive] = isActive;
    data[parameters.strCreatedOn] = createdOn;
    if (state != null) {
      data[parameters.strState] = state.toJson();
    }
    data[parameters.strLastModifiedOn] = lastModifiedOn;
    data[parameters.strlastModifiedBy] = lastModifiedBy;
    return data;
  }
}
