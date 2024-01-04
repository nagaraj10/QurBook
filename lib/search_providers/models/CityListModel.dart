import 'package:myfhb/common/CommonUtil.dart';

class CityListModel {
  bool? isSuccess;
  List<CityListData>? result;

  CityListModel({this.isSuccess, this.result});

  CityListModel.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      if (json['result'] != null) {
            result = <CityListData>[];
            json['result'].forEach((v) {
              result!.add(CityListData.fromJson(v));
            });
          }
    } catch (e,stackTrace) {
                  CommonUtil().appLogs(message: e,stackTrace:stackTrace);

    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    try {
      data['isSuccess'] = this.isSuccess;
      if (this.result != null) {
            data['result'] = this.result!.map((v) => v.toJson()).toList();
          }
    } catch (e,stackTrace) {
                  CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
    return data;
  }
}

class CityListData {
  String? id;
  String? name;
  bool? isActive;
  String? createdOn;
  String? lastModifiedOn;
  State? state;

  CityListData(
      {this.id,
        this.name,
        this.isActive,
        this.createdOn,
        this.lastModifiedOn,
        this.state});

  CityListData.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      name = json['name'];
      isActive = json['isActive'];
      createdOn = json['createdOn'];
      lastModifiedOn = json['lastModifiedOn'];
      state = json['state'] != null ? State.fromJson(json['state']) : null;
    } catch (e,stackTrace) {
                  CommonUtil().appLogs(message: e,stackTrace:stackTrace);

    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    try {
      data['id'] = this.id;
      data['name'] = this.name;
      data['isActive'] = this.isActive;
      data['createdOn'] = this.createdOn;
      data['lastModifiedOn'] = this.lastModifiedOn;
      if (this.state != null) {
            data['state'] = this.state!.toJson();
          }
    } catch (e,stackTrace) {
                  CommonUtil().appLogs(message: e,stackTrace:stackTrace);

    }
    return data;
  }
}

class State {
  String? id;
  String? name;
  String? countryCode;
  bool? isActive;
  String? createdOn;
  String? lastModifiedOn;

  State(
      {this.id,
        this.name,
        this.countryCode,
        this.isActive,
        this.createdOn,
        this.lastModifiedOn});

  State.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      name = json['name'];
      countryCode = json['countryCode'];
      isActive = json['isActive'];
      createdOn = json['createdOn'];
      lastModifiedOn = json['lastModifiedOn'];
    } catch (e,stackTrace) {
                  CommonUtil().appLogs(message: e,stackTrace:stackTrace);

    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    try {
      data['id'] = this.id;
      data['name'] = this.name;
      data['countryCode'] = this.countryCode;
      data['isActive'] = this.isActive;
      data['createdOn'] = this.createdOn;
      data['lastModifiedOn'] = this.lastModifiedOn;
    } catch (e,stackTrace) {
                  CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
    return data;
  }
}
