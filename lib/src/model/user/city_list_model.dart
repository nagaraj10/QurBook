import 'City.dart';
import 'State.dart';

class CityModel {
  bool isSuccess;
  List<City> result;

  CityModel({this.isSuccess, this.result});

  CityModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['result'] != null) {
      result = <City>[];
      json['result'].forEach((v) {
        result.add(City.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['isSuccess'] = isSuccess;
    if (result != null) {
      data['result'] = result.map((v) => v.toJson()).toList();
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
    state = json['state'] != null ? State.fromJson(json['state']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['isActive'] = isActive;
    data['createdOn'] = createdOn;
    data['lastModifiedOn'] = lastModifiedOn;
    if (state != null) {
      data['state'] = state.toJson();
    }
    return data;
  }
}
