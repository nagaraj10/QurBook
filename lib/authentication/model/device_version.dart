import 'dart:io';

import 'package:myfhb/common/CommonUtil.dart';

class DeviceVersion {
  bool? isSuccess;
  Result? result;

  DeviceVersion({this.isSuccess, this.result});

  DeviceVersion.fromJson(Map<String, dynamic> json) {
    try {
      isSuccess = json['isSuccess'];
      result =
              json['result'] != null ? Result.fromJson(json['result']) : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
    try {
      id = json['id'];
      versionName = json['versionName'];
      additionalInfo = json['additionalInfo'] != null
              ? DeviceAdditionalInfo.fromJson(json['additionalInfo'])
              : null;
      isActive = json['isActive'];
      createdOn = json['createdOn'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
    try {
      qurbook = Platform.isIOS
              ? json['qurbookios'] != null
                  ? Qurbook.fromJson(json['qurbookios'])
                  : null
              : json['qurbookandroid'] != null
                  ? Qurbook.fromJson(json['qurbookandroid'])
                  : null;
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
    try {
      isForceUpdate = json['is_force_update'];
    } catch (e,stackTrace) {
      CommonUtil().appLogs(message: e,stackTrace:stackTrace);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['is_force_update'] = this.isForceUpdate;
    return data;
  }
}
