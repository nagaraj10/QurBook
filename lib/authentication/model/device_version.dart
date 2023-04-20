import 'dart:io';

class DeviceVersion {
  bool? isSuccess;
  Result? result;

  DeviceVersion({this.isSuccess, this.result});

  DeviceVersion.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSuccess'] = this.isSuccess;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  String? id;
  String? versionName;
  DeviceAdditionalInfo? additionalInfo;
  bool? isActive;
  String? createdOn;

  Result(
      {this.id,
      this.versionName,
      this.additionalInfo,
      this.isActive,
      this.createdOn});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    versionName = json['versionName'];
    additionalInfo = json['additionalInfo'] != null
        ? new DeviceAdditionalInfo.fromJson(json['additionalInfo'])
        : null;
    isActive = json['isActive'];
    createdOn = json['createdOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['versionName'] = this.versionName;
    if (this.additionalInfo != null) {
      data['additionalInfo'] = this.additionalInfo!.toJson();
    }
    data['isActive'] = this.isActive;
    data['createdOn'] = this.createdOn;
    return data;
  }
}

class DeviceAdditionalInfo {
  Qurbook? qurbook;

  DeviceAdditionalInfo({this.qurbook});

  DeviceAdditionalInfo.fromJson(Map<String, dynamic> json) {
    qurbook = Platform.isIOS
        ? json['qurbookios'] != null
            ? new Qurbook.fromJson(json['qurbookios'])
            : null
        : json['qurbookandroid'] != null
            ? new Qurbook.fromJson(json['qurbookandroid'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.qurbook != null) {
      Platform.isIOS
          ? data['qurbookios'] = this.qurbook!.toJson()
          : data['qurbookandroid'] = this.qurbook!.toJson();
    }
    return data;
  }
}

class Qurbook {
  bool? isForceUpdate;

  Qurbook({this.isForceUpdate});

  Qurbook.fromJson(Map<String, dynamic> json) {
    isForceUpdate = json['is_force_update'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_force_update'] = this.isForceUpdate;
    return data;
  }
}
