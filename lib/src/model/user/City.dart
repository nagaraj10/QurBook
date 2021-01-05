import 'package:myfhb/src/model/user/State.dart' as stateObj;

import 'package:myfhb/constants/fhb_parameters.dart' as parameters;

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[parameters.strId] = this.id;
    data[parameters.strName] = this.name;
    //data[parameters.strstateId] = this.stateId;
    data[parameters.strIsActive] = this.isActive;
    data[parameters.strCreatedOn] = this.createdOn;
    if (this.state != null) {
      data[parameters.strState] = this.state.toJson();
    }
    data[parameters.strLastModifiedOn] = this.lastModifiedOn;
    data[parameters.strlastModifiedBy] = this.lastModifiedBy;
    return data;
  }
}
