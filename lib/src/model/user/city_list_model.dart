import 'package:myfhb/src/model/user/City.dart';
import 'package:myfhb/src/model/user/State.dart';

class CityModel {
  bool isSuccess;
  List<City> result;

  CityModel({this.isSuccess, this.result});

  CityModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['result'] != null) {
      result = new List<City>();
      json['result'].forEach((v) {
        result.add(new City.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CityResult {
  String id;
  String name;
  bool isActive;
  String createdOn;
  String lastModifiedOn;
  State state;

  CityResult(
      {this.id,
      this.name,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn,
      this.state});

  CityResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
    state = json['state'] != null ? new State.fromJson(json['state']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    if (this.state != null) {
      data['state'] = this.state.toJson();
    }
    return data;
  }
}
