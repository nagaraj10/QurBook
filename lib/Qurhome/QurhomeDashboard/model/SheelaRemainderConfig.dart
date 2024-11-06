class SheelaRemainderConfig {
  bool? isSuccess;
  List<Result>? result;

  SheelaRemainderConfig({this.isSuccess, this.result});

  SheelaRemainderConfig.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String? id;
  String? code;
  String? name;
  List<ConfigurationData>? configurationData;
  bool? isActive;
  String? createdOn;
  Null? lastModifiedOn;

  Result(
      {this.id,
      this.code,
      this.name,
      this.configurationData,
      this.isActive,
      this.createdOn,
      this.lastModifiedOn});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    if (json['configurationData'] != null) {
      configurationData = <ConfigurationData>[];
      json['configurationData'].forEach((v) {
        configurationData!.add(ConfigurationData.fromJson(v));
      });
    }
    isActive = json['isActive'];
    createdOn = json['createdOn'];
    lastModifiedOn = json['lastModifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    if (this.configurationData != null) {
      data['configurationData'] =
          this.configurationData!.map((v) => v.toJson()).toList();
    }
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    data['lastModifiedOn'] = this.lastModifiedOn;
    return data;
  }
}

class ConfigurationData {
  String? name;
  String? value;

  ConfigurationData({this.name, this.value});

  ConfigurationData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }
}
